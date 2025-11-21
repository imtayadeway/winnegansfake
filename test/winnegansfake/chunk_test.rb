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
end
