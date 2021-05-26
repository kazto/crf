require "ncurses"
require "./window"
require "./window_manager"

module Crf
  VERSION = "0.1.0"
  class QuitWindow < Exception ; end
  STATUS_H = 3

  class Crf
    def initialize
      @mng = WindowManager.new
    end

    def main
      NCurses.start
      NCurses.cbreak
      NCurses.no_echo

      parent = Window.new(
        0,
        0,
        1, #NCurses.width,
        1  #NCurses.height
      )
      @mng.add(parent)

      right = Window.new(
        ((NCurses.width - 1) * 0.3).to_i32 - 1,
        0,
        ((NCurses.width - 1) * 0.7).to_i32 + 2,
        NCurses.height - STATUS_H
      )
      right.border = Border::Single
      right.draw_border

      left = Window.new(
        0,
        0,
        ((NCurses.width - 1) * 0.3).to_i32,
        NCurses.height - STATUS_H
      )
      left.border = Border::Double
      left.draw_border

      status = Window.new(
        0,
        NCurses.height - 3,
        NCurses.width - 1,
        STATUS_H
      )
      status.border = Border::Single
      status.draw_border

      @mng.add(left)
      @mng.add(right)
      @mng.add_status(status)

      parent.refresh
      status.refresh
      right.refresh
      left.refresh
 
      begin
        loop do
          parent.get_char do |ch|
            case ch
            when 'l'
              @mng.forcus_next
              #@mng.echo_status "l"
            when 'h'
              @mng.forcus_prev
              #@mng.echo_status "h"
            when 'q'
              raise QuitWindow.new
            end
          end
        end
      rescue QuitWindow
        # exit
      end
      
      NCurses.end
    end

    def forcus_next

    end
  end
end

Crf::Crf.new.main
