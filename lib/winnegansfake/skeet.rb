module WinnegansFake
  class Skeet
    attr_reader :adapter, :cursor, :timestamp

    def initialize(adapter: BskyAdapter.new, cursor: Cursor.new, timestamp: Timestamp.new)
      @adapter = adapter
      @cursor = cursor
      @timestamp = timestamp
    end

    def make(chunk:)
      success = post(chunk.text)

      if success
        cursor.set(chunk.next_pos)
        timestamp.touch
      end
    end

    private

    def post(text)
      adapter.post(text: text)
    end
  end
end
