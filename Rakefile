require 'erb'
require 'rake'
require 'pathname'
require 'pry'
require 'require_all'
require 'sudo'

require_all 'lib'

desc "Hook our dotfiles into system-standard positions."

DOTFILES_DIR = File.absolute_path(File.dirname(__FILE__))
DOTFILES_PRIVATE_DIR = File.join(File.dirname(DOTFILES_DIR), "dotfiles-private")

RAKEFILES = Dir.glob("#{DOTFILES_DIR}/*/Rakefile") + Dir.glob("#{DOTFILES_PRIVATE_DIR}/Rakefile")
RAKEFILES.each do |rakefile|
  import rakefile
end

TEMPLATES = Dir.glob('*/**{.template}')
LINKABLES = Dir.glob('*/**{.symlink}') + Dir.glob('.gen/**{.symlink}')
DOT_CONFIGS = Dir.glob('*/**{.config}')
PROGRESS = Progress.new(total: [TEMPLATES, LINKABLES, DOT_CONFIGS].map(&:size).reduce(:+))
PROMPT = Prompt.new(PROGRESS)
STYLES = Styles.new

def relpath_from(path, relative_from)
  path = Pathname.new(File.absolute_path(path)).relative_path_from(relative_from)
  "#{path}"
end

def pretty_target(target)
  pretty_path = if target.to_s.start_with?(ENV["HOME"])
    "~/" + relpath_from(target, ENV["HOME"])
  else
    target
  end

  STYLES.target(pretty_path)
end

def pretty_dotfile(file)
  STYLES.relpath(relpath_from(file, DOTFILES_DIR))
end

def prompt_install_link(file, target, use_sudo: false)
  PROMPT.install_link(file, target, use_sudo: use_sudo)
end

def uninstall_link(file, target)
  Link.new(file, target).uninstall
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

    PROGRESS.log("generating #{pretty_target(relpath_from(template, DOTFILES_DIR))}")
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
  root = "#{ENV["PWD"]}"
  PROGRESS.iterate(LINKABLES) do |linkable|
    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"
    prompt_install_link("#{root}/#{linkable}", target)
  end

  PROGRESS.iterate(DOT_CONFIGS) do |dot_config|
    file = dot_config.split('/').last.split('.config').last
    target = "#{ENV["HOME"]}/.config/#{file}"
    prompt_install_link("#{root}/#{dot_config}", target)
  end

  PROGRESS.log("Finished." + (PROMPT.skipped > 0 ? " Skipped #{PROMPT.skipped} symlink(s)." : ""))
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
