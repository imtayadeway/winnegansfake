module WinnegansFake
  class Timestamp
    CADENCE = 3 * 60 * 60

    def touch
    end

    def post?
      Time.current > thing + CADENCE
    end
  end
end
