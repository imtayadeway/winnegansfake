module WinnegansFake
  class Chunk
    DEFAULT_SIZE = 300.freeze
    TRAILING_WORD_PARTIALS_REGEX = /[^\s]+\z/.freeze
    TRAILING_NEW_PARAGRAPHS_REGEX = /(\n.*)+\z/.freeze
    TRAILING_SENTENCE_FRAGMENTS_REGEX = /[^,\.:;!\?]+\z/.freeze
    PUNCTUATION_REGEX = /[,\.:;!\?]/.freeze
    UNACCEPTABLE_SENTENCE_FRAGMENTS_BOUNDARY = 0.66

    attr_reader :file, :cursor, :size
    attr_accessor :text, :raw_text, :wraparound_text

    def initialize(file:, cursor: Cursor.new, size: DEFAULT_SIZE)
      @file = file
      @cursor = cursor
      @size = size
      generate_text
    end

    def next_pos
      if wraparound_text?
        (0..wraparound_text.size).detect do |n|
          text.end_with?(wraparound_text[0..n])
        end + 1
      else
        cursor.get + text.size + leading_whitespace_chars + 1
      end
    end

    private

    def wraparound_text?
      !!wraparound_text
    end

    def leading_whitespace_chars
      (raw_text.slice(/\A\s+/) || "").size
    end

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
      self.raw_text = file.readpartial(size)
      self.text = raw_text.dup
    end

    def handle_wraparound
      if file.eof?
        file.rewind
        self.wraparound_text = file.readpartial(size - text.size)
        text.chomp!
        text.concat(" " + wraparound_text)
      end
    end

    def ensure_whole_words
      unless file.pread(1, file.pos).match?(/\s/)
        text.sub!(TRAILING_WORD_PARTIALS_REGEX, "")
      end
    end

    def ensure_single_line
      if text.match?(/\n/)
        text.sub!(TRAILING_NEW_PARAGRAPHS_REGEX, "")
      end
    end

    def trim_to_punctuation
      if unacceptable_trailing_sentence_fragments?
        text.sub!(TRAILING_SENTENCE_FRAGMENTS_REGEX, "")
      end
    end

    def unacceptable_trailing_sentence_fragments?
      unacceptable_sentence_fragments_zone&.match?(PUNCTUATION_REGEX)
    end

    def unacceptable_sentence_fragments_zone
      text[(size * UNACCEPTABLE_SENTENCE_FRAGMENTS_BOUNDARY).floor..-1]
    end

    def strip_whitespace
      text.strip!
    end
  end
end
