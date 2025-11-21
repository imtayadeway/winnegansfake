module WinnegansFake
  class Skeet
    def make(chonk:, cursor:, timestamp: Timestamp.new)
      post_chonk(chonk)

      if success?
        cursor.set(chonk.next_pos)
        timestamp.touch
      end
    end
  end
end
