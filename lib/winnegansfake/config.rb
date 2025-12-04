module WinnegansFake
  module Config
    def self.cadence
      ENV.fetch("CADENCE").to_i
    end

    def self.database_url
      ENV.fetch("DATABASE_URL")
    end
  end
end
