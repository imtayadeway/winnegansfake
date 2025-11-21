require "bundler/setup"
require "minisky"
require "sequel"

module WinnegansFake
  require "winnegansfake/chunk"
  require "winnegansfake/cursor"
  require "winnegansfake/skeet"
  require "winnegansfake/timestamp"

  DB = Sequel.postgres

  def self.post
    cursor = Cursor.new
    file = File.new("finneganswake.txt", "r")
    chonk = Chunk.new(file: file, cursor: cursor)
    Skeet.new.make(chonk: chonk, cursor: cursor)
  end

  def self.post?
    WinnegansFake::Timestamp.new.post?
  end
end
