require "ncurses"
require "./dir_window"
require "./file_window"
require "./window_manager"

module Crf
  VERSION = "0.1.0"
  class QuitWindow < Exception ; end
  STATUS_H = 3

  class Crf
    def initialize
      @mng = WindowManager.new
    end

    def start
      NCurses.start
      NCurses.cbreak
      NCurses.no_echo
    end

    def create_parent
      parent = Window.new(0, 0, 1, 1)
      @mng.add_parent(parent)
    end

    def create_right
      right = FileWindow.new(
        ((NCurses.width - 1) * 0.3).to_i32 - 1,
        0,
        ((NCurses.width - 1) * 0.7).to_i32 + 2,
        NCurses.height - STATUS_H
      )
      right.border = Border::Single
      right.draw_border
      @mng.add(right)
    end

    def create_left
      left = DirWindow.new(
        0,
        0,
        ((NCurses.width - 1) * 0.3).to_i32,
        NCurses.height - STATUS_H
      )
      left.border = Border::Double
      left.draw_border
      @mng.add(left)
    end

    def create_status
      status = Window.new(
        0,
        NCurses.height - STATUS_H,
        NCurses.width - 1,
        STATUS_H
      )
      status.border = Border::Single
      status.draw_border
      @mng.add_status(status)
      status.refresh
    end

    def show_help
      
    end

    def main_loop
      begin
        loop do
          @mng.parent.get_char do |ch|
            case ch
            when 'l'
              @mng.forcus_next
              #@mng.echo_status "l"
            when 'h'
              @mng.forcus_prev
              #@mng.echo_status "h"
            when '?'
              show_help
            when 'q'
              raise QuitWindow.new
            end
          end
        end
      rescue QuitWindow
        # exit
      end
    end

    def terminate
      NCurses.end
    end

    def main
      start
      create_parent
      create_left
      create_right
      create_status
      @mng.update
      main_loop
      terminate
    end
  end
end


if File.basename(PROGRAM_NAME) == File.basename(__FILE__, ".cr")
  Crf::Crf.new.main
end
