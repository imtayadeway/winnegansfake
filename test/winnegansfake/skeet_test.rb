require "test_helper"
require "winnegansfake/skeet"

class SkeetTest < Minitest::Test
  def test_sets_cursor
    skip "do this elsewhere"
    file = StringIO.new("The quick brown fox jumps over the lazy dog")
    cursor = Class.new do
      def get
        @cursor || 0
      end

      def set(n)
        @cursor = n
      end
    end.new
    chunker = WinnegansFake::Chunk.new(file: file, cursor: cursor, size: 20)
    chunker.next

    chunk = chunker.next

    assert_equal "jumps over the lazy", chunk
  end
end
