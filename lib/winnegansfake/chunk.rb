module WinnegansFake
  class Chunk
    DEFAULT_SIZE = 300.freeze
    TRAILING_WORD_PARTIALS_REGEX = /[^\s]+\z/.freeze
    TRAILING_NEW_PARAGRAPHS_REGEX = /\n.*\z/.freeze
    TRAILING_SENTENCE_FRAGMENTS_REGEX = /[^,\.]+\z/.freeze
    PUNCTUATION_REGEX = /[,\.:;!\?]/.freeze
    UNACCEPTABLE_SENTENCE_FRAGMENTS_BOUNDARY = 0.75

    attr_reader :file, :cursor, :size
    attr_accessor :text

    def initialize(file:, cursor:, size: DEFAULT_SIZE)
      @file = file
      @cursor = cursor
      @size = size
      generate_text
    end

    def next_pos
      # TODO: handle wraparound
      cursor.get + text.size + 1
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
