class Link
  attr_accessor :file, :target

  def initialize(file, target)
    @file = file
    @target = target
  end

  def installed
    type = File.exists?(@target) && File.ftype(@target)
    type == "link" && File.readlink(@target) == @file
  end

  def install(overwrite: false, backup: false)
    if overwrite
      FileUtils.rm_rf(@target)
    end

    if backup
      FileUtils.mv(@target, "#{@target}.backup")
    end

    FileUtils.ln_s(@file, @target, force: true)
  end

  def uninstall
    if File.symlink?(@target) && File.readlink(@target) == @file
      FileUtils.rm(@target)
    end
  end
end
