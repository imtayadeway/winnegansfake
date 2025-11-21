module WinnegansFake
  class Skeet
    def make(chonk:, cursor:)
      post_chonk(chonk)

      if success?
        cursor.set(chonk.next_pos)
      end
    end
  end
end
