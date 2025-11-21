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
      @text ||=
        begin
          file.pos = cursor.get
          t = file.readpartial(size)
          if file.eof?
            file.rewind
            t.concat(" " + file.readpartial(size - t.size))
          end

          unless t.end_with?(" ")
            t.sub!(/[^ ]+\z/, "")
          end

          if t.match?(/\n/)
            t.sub!(/\n.*\z/, "")
          end

          if t[(size * 0.75).floor..-1].match?(/[,\.]/)
            t.sub!(/[^,\.]+\z/, "")
          end

          t.strip.chomp
        end
    end

    def next_pos
      text
      file.pos
    end
  end
end
