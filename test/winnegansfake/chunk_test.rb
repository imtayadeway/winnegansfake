require "test_helper"
require "winnegansfake/chunk"

class ChunkTest < Minitest::Test
  def test_text
    file = StringIO.new("The quick brown fox jumps over the lazy dog")
    cursor = Struct.new(:get).new(0)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 19)

    chunk = chunker.text

    assert_equal "The quick brown fox", chunk
  end

  def test_reads_from_cursor
    file = StringIO.new("The quick brown fox jumps over the lazy dog")
    cursor = Struct.new(:get).new(4)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 15)

    chunk = chunker.text

    assert_equal "quick brown fox", chunk
  end

  def test_strip
    file = StringIO.new("The quick brown fox jumps over the lazy dog")
    cursor = Struct.new(:get).new(0)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 20)

    chunk = chunker.text

    assert_equal "The quick brown fox", chunk
  end

  def test_next_pos
    file = StringIO.new("The quick brown fox jumps over the lazy dog")
    cursor = Struct.new(:get).new(0)
    chunk = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 19)

    assert_equal "The quick brown fox", chunk.text

    next_cursor = Struct.new(:get).new(chunk.next_pos)
    next_chunk = WinnegansFake::Chunk.new(file: file, cursor: next_cursor, size: 24)

    assert_equal "jumps over the lazy dog", next_chunk.text
  end

  def test_next_pos_weirdness
    file = StringIO.new("\n\nThe quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.")
    cursor = Struct.new(:get).new(0)
    chunk = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 55)

    assert_equal "The quick brown fox jumps over the lazy dog.", chunk.text

    next_cursor = Struct.new(:get).new(chunk.next_pos)
    next_chunk = WinnegansFake::Chunk.new(file: file, cursor: next_cursor, size: 22)

    assert_equal "The quick brown fox", next_chunk.text
  end

  def test_next_pos_wraparound
    file = StringIO.new("the quick brown fox jumps over the lazy dog")
    cursor = Struct.new(:get).new(0)
    chunk = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 49)

    assert_equal "the quick brown fox jumps over the lazy dog the", chunk.text
    assert_equal chunk.next_pos, 3
  end

  def test_wraps_around
    file = StringIO.new("the quick brown fox jumps over the lazy dog\n")
    cursor = Struct.new(:get).new(30)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 33)

    chunk = chunker.text

    assert_equal "the lazy dog the quick brown fox", chunk
  end

  def test_whole_words
    file = StringIO.new("The quick brown fox jumps over the lazy dog")
    cursor = Struct.new(:get).new(0)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 22)

    chunk = chunker.text

    assert_equal "The quick brown fox", chunk
  end

  def test_newline
    file = StringIO.new("The quick brown fox\njumps over the lazy dog")
    cursor = Struct.new(:get).new(0)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 26)

    chunk = chunker.text

    assert_equal "The quick brown fox", chunk
  end

  def test_punctuation
    file = StringIO.new("The quick brown fox jumps over the lazy dog. The quick brown fox...")
    cursor = Struct.new(:get).new(0)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 58)

    chunk = chunker.text

    assert_equal "The quick brown fox jumps over the lazy dog.", chunk
  end

  def test_can_advance_over_lines
    file = StringIO.new("The quick brown fox\njumps over the lazy dog")
    cursor = Struct.new(:get).new(0)
    chunk = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 19)

    assert_equal "The quick brown fox", chunk.text

    next_cursor = Struct.new(:get).new(chunk.next_pos)
    next_chunk = WinnegansFake::Chunk.new(file: file, cursor: next_cursor, size: 24)

    assert_equal "jumps over the lazy dog", next_chunk.text
  end

  def test_next_pos_inside_word_boundaries
    file = StringIO.new("The quick brown fox jumps over the lazy dog")
    cursor = Struct.new(:get).new(0)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 22)

    pos = chunker.next_pos

    assert_equal 20, pos
  end

  def test_integration
    cursor = Class.new do
      def get
        @n || 0
      end

      def set(n)
        @n = n
      end
    end.new
    file = File.new("finneganswake.txt", "r")

    6300.times do
      chunk = WinnegansFake::Chunk.new(file: file, cursor: cursor)
      cursor.set(chunk.next_pos)
      puts "#" * 90
      puts chunk.text
      puts "#" * 90
    end
  end
end
