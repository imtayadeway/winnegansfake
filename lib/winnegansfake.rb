require "bundler/setup"
require "minisky"
require "sequel"

Sequel.default_timezone = :utc

module WinnegansFake
  require "winnegansfake/bsky_adapter"
  require "winnegansfake/chunk"
  require "winnegansfake/config"
  require "winnegansfake/cursor"
  require "winnegansfake/skeet"
  require "winnegansfake/timestamp"

  DB = Sequel.postgres

  def self.post
    file = File.new("finneganswake.txt", "r")
    chonk = Chunk.new(file: file)
    Skeet.new.make(chonk: chonk)
  end

  def self.post?
    WinnegansFake::Timestamp.new.post?
  end
end
