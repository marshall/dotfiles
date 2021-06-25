require 'pastel'
require 'tty-cursor'

require_relative 'link'
require_relative 'styles'

CHOICES = ['skip', 'Skip All', 'overwrite', 'Overwrite all', 'backup', 'Backup all']

class Prompt
  attr_accessor :backup, :backup_all, :skip, :skip_all, :overwrite, :overwrite_all, :progress,
                :skipped, :styles

  def initialize(progress)
    @skip_all = false
    @overwrite_all = false
    @backup_all = false
    @styles = Styles.new
    @progress = progress
    @skipped = 0
  end

  def prompt_choices
    choices = CHOICES.map { |c| styles.key(c[0]) + styles.txt(c[1..]) }
    choices[-1].prepend('or ')

    keys = CHOICES.map { |c| styles.key(c[0]) }
    choices.join(', ') + ' ' +
      styles.txt('[') +
      keys.join() +
      styles.txt(']>') +
      styles.txt(' ')
  end

  def prompt(file, target)
    @overwrite = false
    @backup = false
    @skip = false

    if skip_all
      return :skip
    elsif overwrite_all
      return :overwrite
    elsif backup_all
      return :backup
    end

    progress.pause

    err = !File.symlink?(target) ?
        "a file already exists there" :
        "a link already exists there to #{styles.exists(File.readlink(target))}'"

    msg =
      styles.err("Tried to link ") +
      styles.target(target) +
      styles.err(" to ") +
      styles.relpath(relpath_from(file, DOTFILES_DIR)) +
      styles.err(", but #{err}. What do you want to do?")
    choices = prompt_choices

    align = choices.size - styles.strip(choices).size + styles.strip(msg).size
    print("\n" + msg + "\n" + prompt_choices)

    case STDIN.gets.chomp
      when 'o'
        @overwrite = true
      when 'b'
        @backup = true
      when 'O'
        @overwrite_all = true
      when 'B'
        @backup_all = true
      when 'S'
        @skip_all = true
      when 's'
        @skip = true
    end

    print TTY::Cursor.clear_lines(4)
    progress.resume

    if skip || skip_all
      :skip
    elsif overwrite || overwrite_all
      :overwrite
    elsif backup || backup_all
      :backup
    end
  end

  def install_link(file, target, use_sudo: false)
    link = Link.new(file, target)
    if link.installed
      progress.log("installed #{pretty_target(target)}")
      return
    end

    action = File.exists?(target) && prompt(file, target)
    overwrite = false
    backup = false
    case action
      when :skip
        @skipped += 1
        progress.log("skipped #{pretty_target(target)}")
        return
      when :overwrite
        progress.log("remove #{pretty_target(target)}")
        overwrite = true
      when :backup
        progress.log("backup #{pretty_target(target)}")
        backup = true
    end

    progress.log("symlink #{pretty_target(target)} to #{pretty_dotfile(file)} ")
    if use_sudo
      progress.log("sudo required for #{pretty_target(target)}")
      Sudo::Wrapper.run(ruby_opts: "-r#{ENV['PWD']}/lib/link.rb") do |su|
        su[link].install(overwrite: overwrite, backup: backup)
      end
    else
      link.install(overwrite: overwrite, backup: backup)
    end
  end

end
