require "test_helper"
require "winnegansfake/skeet"

class SkeetTest < Minitest::Test
  def test_posts_to_bsky
    text = "The quick brown fox jumps over the lazy dog"
    chunk = Struct.new(:text, :next_pos).new(text, 42)
    bsky_adapter = Minitest::Mock.new

    bsky_adapter.expect :post, true, [], text: text

    WinnegansFake::Skeet.new(adapter: bsky_adapter).make(chunk: chunk)
  end

  def test_sets_cursor_if_success
    text = "The quick brown fox jumps over the lazy dog"
    chunk = Struct.new(:text, :next_pos).new(text, 42)
    cursor = Minitest::Mock.new
    bsky_adapter = Class.new do
      def post(text:)
        true
      end
    end.new

    cursor.expect :set, nil, [42]

    WinnegansFake::Skeet.new(adapter: bsky_adapter, cursor: cursor).make(chunk: chunk)
  end

  def test_touches_timestamp_if_success
    text = "The quick brown fox jumps over the lazy dog"
    chunk = Struct.new(:text, :next_pos).new(text, 42)
    timestamp = Minitest::Mock.new
    bsky_adapter = Class.new do
      def post(text:)
        true
      end
    end.new

    timestamp.expect :touch, nil

    WinnegansFake::Skeet.new(adapter: bsky_adapter, timestamp: timestamp).make(chunk: chunk)
  end

  def test_does_not_set_cursor_if_fail
    text = "The quick brown fox jumps over the lazy dog"
    chunk = Struct.new(:text, :next_pos).new(text, 42)
    cursor = Minitest::Mock.new
    bsky_adapter = Class.new do
      def post(text:)
        false
      end
    end.new

    WinnegansFake::Skeet.new(adapter: bsky_adapter, cursor: cursor).make(chunk: chunk)
  end

  def test_does_not_touch_timestamp_if_fail
    text = "The quick brown fox jumps over the lazy dog"
    chunk = Struct.new(:text, :next_pos).new(text, 42)
    timestamp = Minitest::Mock.new
    bsky_adapter = Class.new do
      def post(text:)
        false
      end
    end.new

    WinnegansFake::Skeet.new(adapter: bsky_adapter, timestamp: timestamp).make(chunk: chunk)
  end
end
