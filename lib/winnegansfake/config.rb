module WinnegansFake
  module Config
    def self.bsky_id
      ENV.fetch("BSKY_ID")
    end

    def self.bsky_pass
      ENV.fetch("BSKY_PASS")
    end

    def self.cadence
      ENV.fetch("CADENCE", 10800).to_i
    end

    def self.database_url
      ENV.fetch("DATABASE_URL")
    end
  end
end
