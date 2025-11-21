require "bundler/setup"
require "winnegansfake"
require "database_cleaner/sequel"
require "dotenv/load"
require "timecop"
require "minitest/autorun"

DatabaseCleaner.strategy = :truncation

module WinnegansFake
  class Test < Minitest::Test
    def teardown
      DatabaseCleaner.clean
    end
  end
end

if WinnegansFake::DB.table_exists?(:cursor)
  WinnegansFake::DB.drop_table :cursor
end
WinnegansFake::DB.create_table :cursor do
  primary_key :id
  Integer :value, null: false
end

if WinnegansFake::DB.table_exists?(:timestamp)
  WinnegansFake::DB.drop_table :timestamp
end
WinnegansFake::DB.create_table :timestamp do
  primary_key :id
  DateTime :value, null: false
end
