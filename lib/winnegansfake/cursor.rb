module WinnegansFake
  class Cursor
    def get
      (DB[:cursor].first || { value: 0 })[:value]
    end

    def set(value)
      DB.transaction do
        DB[:cursor].truncate
        DB[:cursor].insert(value: value)
      end
    end
  end
end
