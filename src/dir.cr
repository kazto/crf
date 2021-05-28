require "dir"
require "file"

module Crf
  class Dir
    def initialize(path : String)
      @path = path
    end

    def glob
      ::Dir.glob(@path) #.select { |v| File.directory?(v) }
    end
  end
end
