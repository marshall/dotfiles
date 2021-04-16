require 'erb'
require 'rake'
require 'pathname'
require 'pry'
require 'sudo'

require_relative 'lib/link'
require_relative 'lib/prompt'
require_relative 'lib/progress'

desc "Hook our dotfiles into system-standard positions."

TEMPLATES = Dir.glob('*/**{.template}')
LINKABLES = Dir.glob('*/**{.symlink}') + Dir.glob('.gen/**{.symlink}')
DOT_CONFIGS = Dir.glob('*/**{.config}')
PROGRESS = Progress.new(total: [TEMPLATES, LINKABLES, DOT_CONFIGS].map(&:size).reduce(:+))
STYLES = Styles.new

# PROGRESS.start

def relpath(path, relative_from)
  path = Pathname.new(File.absolute_path(path)).relative_path_from(relative_from)
  "#{path}"
end

def pretty_target(target)
  pretty_path = if target.to_s.start_with?(ENV["HOME"])
    "~/" + relpath(target, ENV["HOME"])
  else
    target
  end

  STYLES.target(pretty_path)
end

def pretty_dotfile(file)
  STYLES.relpath(relpath(file, DOTFILES_DIR))
end

task :bootstrap do
  system('bootstrap/bootstrap.sh')
end

task :generate do
  gen_dir = '.gen'

  PROGRESS.iterate(TEMPLATES) do |template|
    if not File.exists?(gen_dir)
      Dir.mkdir(gen_dir)
    end

    filename = template.split('/').last.split('.template').last
    target = File.join(gen_dir, filename)
    target_rel = Pathname.new(File.absolute_path(template)).relative_path_from(DOTFILES_DIR)

    PROGRESS.log("generating #{pretty_target(target_rel)}")
    File.open(template, 'r') do |template_file|
      erb = ERB.new(template_file.read())
      erb.filename = template
      File.open(target, 'w+') do |out|
        out.write(erb.result)
      end
    end
  end
end

task :install => [:generate] do
  $prompt = Prompt.new(PROGRESS)
  $skipped = 0

  def make_link(file, target, use_sudo: false)
    link = Link.new(file, target)
    if link.installed
      PROGRESS.log("installed #{pretty_target(target)}")
      return
    end

    action = File.exists?(target) && $prompt.prompt(file, target)
    overwrite = false
    backup = false
    case action
      when :skip
        $skipped += 1
        PROGRESS.log("skipped #{pretty_target(target)}")
        return
      when :overwrite
        PROGRESS.log("remove #{pretty_target(target)}")
        overwrite = true
      when :backup
        PROGRESS.log("backup #{pretty_target(target)}")
        backup = true
    end

    PROGRESS.log("symlink #{pretty_target(target)} to #{pretty_dotfile(file)} ")
    if use_sudo
      PROGRESS.log("sudo required for #{pretty_target(target)}")
      Sudo::Wrapper.run(ruby_opts: "-r#{ENV['PWD']}/lib/link.rb") do |su|
        su[link].link(overwrite: overwrite, backup: backup)
      end
    else
      link.link(overwrite: overwrite, backup: backup)
    end
  end

  root = "#{ENV["PWD"]}"
  PROGRESS.iterate(LINKABLES) do |linkable|
    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"
    make_link("#{root}/#{linkable}", target)
  end

  PROGRESS.iterate(DOT_CONFIGS) do |dot_config|
    file = dot_config.split('/').last.split('.config').last
    target = "#{ENV["HOME"]}/.config/#{file}"
    make_link("#{root}/#{dot_config}", target)
  end

  # copy udev rules for QMK in Linux
  rules_dir = "/etc/udev/rules.d"
  if Dir.exists?(rules_dir)
    Dir.glob('**/*.udev.rules').each do |linkable|
      target_name = linkable.split('/').last.sub('.udev', '')
      target = File.join(rules_dir, target_name)

      make_link(File.absolute_path(File.join(ENV['PWD'], linkable)), target, use_sudo: true)
    end
  end

  PROGRESS.log("Finished." + ($skipped > 0 ? " Skipped #{$skipped} symlink(s)." : ""))
end

task :install_linux do

end

task :uninstall do
  Dir.glob('**/*.symlink').each do |linkable|
    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target) && File.readlink(target) == file
      FileUtils.rm(target)
    end

    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"` 
    end

  end
end

task :default => 'install'
