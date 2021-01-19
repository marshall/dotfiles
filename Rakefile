require 'erb'
require 'rake'
require 'pathname'

desc "Hook our dotfiles into system-standard positions."

DOTFILES_DIR = File.dirname(__FILE__)

task :bootstrap do
  system('bootstrap/bootstrap.sh')
end

task :generate do
  templates = Dir.glob('*/**{.template}')
  gen_dir = '_gen'

  templates.each do |template|
    if not File.exists?(gen_dir)
      Dir.mkdir(gen_dir)
    end

    filename = template.split('/').last.split('.template').last
    target = File.join(gen_dir, filename)
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
  $skip_all = false
  $overwrite_all = false
  $backup_all = false

  def make_link(file, target)
    relpath = Pathname.new(file).relative_path_from(DOTFILES_DIR)
    print "link #{relpath.to_s} => #{target}"
    status = "created"
    if File.symlink?(target) && File.readlink(target) == file
      status = "already linked"
    else
      if File.exists?(target) || File.symlink?(target)
        overwrite = false
        backup = false
        skip = false
        unless $skip_all || $overwrite_all || $backup_all
          puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
          case STDIN.gets.chomp
          when 'o'
            overwrite = true
          when 'b'
            backup = true
          when 'O'
            $overwrite_all = true
          when 'B'
            $backup_all = true
          when 'S'
            $skip_all = true
          when 's'
            skip = true
          end
        end
        if !skip && !$skip_all
          if overwrite || $overwrite_all
            FileUtils.rm_rf(target)
            status = "overwrite"
          end
          if backup || $backup_all
            `mv "#{target}" "#{target}.backup"`
            status = "backup"
          end
        end
      end

      if !skip && !$skip_all
        `ln -s "#{file}" "#{target}"`
      else
        status = "skipped"
      end
    end

    puts " [#{status}]"
  end

  linkables = Dir.glob('*/**{.symlink}')
  root = "#{ENV["PWD"]}"
  linkables.each do |linkable|
    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"
    make_link("#{root}/#{linkable}", target)
  end

  dot_configs = Dir.glob('*/**{.config}')
  dot_configs.each do |dot_config|
    file = dot_config.split('/').last.split('.config').last
    target = "#{ENV["HOME"]}/.config/#{file}"
    make_link("#{root}/#{dot_config}", target)
  end

end

task :uninstall do

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end
    
    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"` 
    end

  end
end

task :default => 'install'
