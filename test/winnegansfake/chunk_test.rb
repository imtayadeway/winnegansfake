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

  def test_wraps_around
    file = StringIO.new("the quick brown fox jumps over the lazy dog")
    cursor = Struct.new(:get).new(30)
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 31)

    chunk = chunker.text

    assert_equal "the lazy dog the quick brown fox", chunk
  end
end
