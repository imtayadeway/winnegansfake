require "bundler/setup"
require "minisky"

module WinnegansFake
  require "winnegansfake/chunk"
  require "winnegansfake/cursor"
  require "winnegansfake/skeet"
  require "winnegansfake/timestamp"

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
