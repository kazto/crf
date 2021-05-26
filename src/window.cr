require "ncurses"

module Crf
  enum Border 
    None
    Single
    Double
  end

  class Window
    def initialize(x : Int32, y : Int32, w : Int32, h : Int32)
      @x = x
      @y = y
      @w = w
      @h = h
      @wnd = NCurses::Window.new(@h, @w, @y, @x)
      @border = Border::None
    end

    def draw_lines(corner, horizon, vertical)
        # top
        @wnd.move(0, 0)
        @wnd.draw_hline corner, 1
        @wnd.move(0, 1)
        @wnd.draw_hline horizon, @w - 2
        @wnd.move(0, (@w - 1))
        @wnd.draw_hline corner, 1

        # left
        @wnd.move(1, 0)
        @wnd.draw_vline vertical, @h - 2

        # right
        @wnd.move(1, @w - 1)
        @wnd.draw_vline vertical, @h - 2

        # bottom
        @wnd.move @h - 1, 0
        @wnd.draw_hline corner, 1
        @wnd.move @h - 1, 1
        @wnd.draw_hline horizon, @w - 2
        @wnd.move (@h - 1), (@w - 1)
        @wnd.draw_hline corner, 1
    end

    def draw_border
      case @border 
      when Border::Single
        draw_lines '+', '-', '|'
      when Border::Double
        draw_lines '#', '=', '#'
      end
    end

    def border=(b : Border)
      @border = b
    end

    def refresh
      @wnd.refresh
    end
    def get_char(&block)
      yield @wnd.get_char
    end
    def width
      @w
    end
    def height
      @h
    end
    def move(y, x)
      @wnd.move(y, x)
    end
    def print(v)
      @wnd.print(v)
    end

    def update_forcus
      @border = Border::Double
      draw_border
      refresh
    end

    def update_unforcus
      @border = Border::Single
      draw_border
      refresh
    end
  end
end