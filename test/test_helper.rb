require "bundler/setup"
require "winnegansfake"
require "database_cleaner/sequel"
require "minitest/autorun"

DatabaseCleaner.strategy = :truncation

module WinnegansFake
  class Test < Minitest::Test
    def teardown
      DatabaseCleaner.clean
    end
  end
end

unless WinnegansFake::DB.table_exists?(:cursor)
  WinnegansFake::DB.create_table :cursor do
    primary_key :id
    Integer :value, null: false
  end
end
