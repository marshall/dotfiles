require 'pastel'
require 'tty-cursor'

require_relative 'styles'

CHOICES = ['skip', 'Skip All', 'overwrite', 'Overwrite all', 'backup', 'Backup all']
DOTFILES_DIR = File.absolute_path(File.join(File.dirname(__FILE__), '/..'))

class Prompt
  attr_accessor :backup, :backup_all, :skip, :skip_all, :overwrite, :overwrite_all, :progress, :styles

  def initialize(progress)
    @skip_all = false
    @overwrite_all = false
    @backup_all = false
    @styles = Styles.new
    @progress = progress
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

    relpath = Pathname.new(file).relative_path_from(DOTFILES_DIR)
    progress.pause

    err = !File.symlink?(target) ?
        "a file already exists there" :
        "a link already exists there to #{styles.exists(File.readlink(target))}'"

    msg =
      styles.err("Tried to link ") +
      styles.target(target) +
      styles.err(" to ") +
      styles.relpath(relpath) +
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
end
