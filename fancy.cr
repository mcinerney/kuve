# vim: set ts=2 sw=2 noet fileencoding=utf-8:

require "colorize"

class ProgressIndicator
  GLYPHS = "|/-\\"
  COLORS = [:light_yellow, :light_blue, :blue, :white]

  def initialize(@msg : String)
    @running = true
    @g_step = 0 # glyph step
    @c_step = 0 # color step
    @channel = Channel(Nil).new
    spawn run_loop
  end

  def run_loop
    printf "  %s\r", @msg.colorize(:light_yellow)

    while @running
      @g_step = (@g_step + 1) % GLYPHS.size
      @c_step = (@c_step + 1) % COLORS.size

      print GLYPHS[@g_step].colorize(COLORS[@c_step])
      sleep 0.05
      print "\b"
    end

    print "\033[2K" # erase line

    @channel.send nil # signal stop that we're done
  end

  def stop
    @running = false
    @channel.receive # wait for the run loop to exit
  end
end
