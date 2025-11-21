module WinnegansFake
  class Chunk
    DEFAULT_SIZE = 300.freeze

    attr_reader :file, :cursor, :size
    attr_accessor :text

    def initialize(file:, cursor:, size: DEFAULT_SIZE)
      @file = file
      @cursor = cursor
      @size = size
      generate_text
    end

    def next_pos
      text
      file.pos
    end

    private

    def generate_text
      read_raw_sample
      handle_wraparound
      ensure_whole_words
      strip_whitespace
      ensure_single_line
      trim_to_punctuation
    end

    def read_raw_sample
      file.pos = cursor.get
      self.text = file.readpartial(size)
    end

    def handle_wraparound
      if file.eof?
        file.rewind
        text.concat(" " + file.readpartial(size - text.size))
      end
    end

    def ensure_whole_words
      unless file.pread(1, file.pos).match?(/\s/)
        text.sub!(/[^\s]+\z/, "")
      end
    end

    def ensure_single_line
      if text.match?(/\n/)
        text.sub!(/\n.*\z/, "")
      end
    end

    def trim_to_punctuation
      if text[(size * 0.75).floor..-1].match?(/[,\.]/)
        text.sub!(/[^,\.]+\z/, "")
      end
    end

    def strip_whitespace
      text.strip!
    end
  end
end
