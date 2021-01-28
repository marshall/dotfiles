require 'pastel'

class Styles
  attr_accessor :pastel, :styles

  def initialize(**styles)
    @pastel = Pastel.new
    @styles = {
      key: pastel.blue.detach,
      txt: pastel.white.dim.detach,
      target: pastel.cyan.detach,
      relpath: pastel.yellow.detach,
      err: pastel.red.detach,
      exists: pastel.white.bold.detach,
      title: pastel.white.detach,
      bar: pastel.green.detach,
      percent: pastel.yellow.detach,
      log: pastel.reset.detach,
    }.merge(styles)

    @styles.each do |name, style|
      self.class.send(:define_method, name) do |arg|
        @styles[name].(arg)
      end
    end
  end

  def strip(s)
    @pastel.strip(s)
  end
end
