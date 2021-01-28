require 'tty-progressbar'

require_relative 'styles'

class Progress < TTY::ProgressBar
  attr_accessor :progress, :styles

  def initialize(**options)
    @need_cleanup = true
    @styles = Styles.new
    @options = {
      bar_format: :track,
      width: 20
    }

    @_title = "dotfiles"
    @_format = styles.title(@_title) + ": " +
      styles.log(":log") + " | " +
      styles.bar(":bar") + " " +
      styles.percent(":percent")
    @log = ''

    super(@_format,
          log: @msg,
          **@options.merge(options))

    @static_cols = TTY::ProgressBar.display_columns(
      @_format.gsub(/:bar/, ' ' * @options[:width])
                  .gsub(/:percent/, '100%')
                  .gsub(/:log/, ''))
  end

  def advance(progress = 1, tokens = {})
    super(progress, { log: @log }.merge(tokens))
  end

  def log(msg)
    if complete?
      if @need_cleanup
        print TTY::Cursor.clear_lines(2)
        @need_cleanup = false
      end

      puts styles.title(@_title) + ": " + styles.log(msg)
      return
    end

    max = 80 - @static_cols - 3
    @log = msg.size > max ? "#{msg[0...max]}..." : msg.ljust(max)
  end
end
