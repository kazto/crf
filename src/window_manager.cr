require "ncurses"
require "./window"

module Crf
  class WindowManager
    def initialize
      @wnds = [] of Window
      @parent = uninitialized Window 
      @modal = uninitialized Window
      @status = uninitialized Window
      @cursor = 0
    end

    def add(wnd)
      @wnds << wnd
    end

    def add_parent(wnd)
      @parent = wnd
    end

    def add_modal(wnd)
      @modal = wnd
    end

    def add_status(wnd)
      @status = wnd
    end

    def parent
      @parent
    end

    def update
      echo_status @cursor.to_s
      (0...@wnds.size).each do |n|
        next if n == @cursor
        @wnds[n].update_unforcus
      end
      @wnds[@cursor].update_forcus
    end

    def forcus_next
      if @cursor == @wnds.size - 1
        @cursor = 0
      else
        @cursor += 1
      end
      update
    end

    def forcus_prev
      if @cursor == 0
        @cursor = @wnds.size - 1
      else
        @cursor -= 1
      end
      update
    end

    def echo_status(str)
      @status.move(1, 1)
      @status.print(str)
      @status.refresh
    end
  end
end