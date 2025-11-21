module WinnegansFake
  class Timestamp
    CADENCE = 3 * 60 * 60

    def touch
      DB.transaction do
        DB[:timestamp].truncate
        DB[:timestamp].insert(value: Time.now.utc)
      end
    end

    def post?
      return true unless DB[:timestamp].first
      value = DB[:timestamp].first[:value].utc
      Time.now.utc > value + CADENCE
    end
  end
end
