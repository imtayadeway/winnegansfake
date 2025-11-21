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
      @text ||= get_text
    end

    def next_pos
      text
      file.pos
    end

    private

    def get_text
      file.pos = cursor.get
      t = file.readpartial(size)

      # wraparound
      if file.eof?
        file.rewind
        t.concat(" " + file.readpartial(size - t.size))
      end

      # end on whole word
      unless file.pread(1, file.pos).match?(/\s/)
        t.sub!(/[^\s]+\z/, "")
      end

      # linebreaks
      if t.match?(/\n/)
        t.sub!(/\n.*\z/, "")
      end

      # end near punctuation
      if t[(size * 0.75).floor..-1].match?(/[,\.]/)
        t.sub!(/[^,\.]+\z/, "")
      end

      t.strip.chomp
    end
  end
end
