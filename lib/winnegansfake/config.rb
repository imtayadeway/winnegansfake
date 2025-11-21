module WinnegansFake
  module Config
    def self.cadence
      ENV.fetch("CADENCE").to_i
    end
  end
end
