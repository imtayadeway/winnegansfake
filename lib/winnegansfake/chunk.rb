module WinnegansFake
  class Chunk
    DEFAULT_SIZE = 300.freeze

    attr_reader :file, :cursor, :size

    def initialize(file:, cursor:, size: DEFAULT_SIZE)
      @file = file
      @cursor = cursor
      @size = size
    end

    def text
      file.pos = cursor.get
      file.readpartial(size).strip
    end

    def next_pos

    end
  end
end
