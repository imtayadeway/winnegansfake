require "bundler/setup"
require "dotenv"

Dotenv.load(".env.test")

require "winnegansfake"
require "database_cleaner/sequel"
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
