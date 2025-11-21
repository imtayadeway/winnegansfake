module WinnegansFake
  class Timestamp
    def touch
      DB.transaction do
        DB[:timestamp].truncate
        DB[:timestamp].insert(value: Time.now.utc)
      end
    end

    def post?
      return true unless DB[:timestamp].first
      value = DB[:timestamp].first[:value].utc
      Time.now.utc > value + Config.cadence
    end
  end
end
