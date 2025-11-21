require "test_helper"

class TimestampTest < WinnegansFake::Test
  def test_post_true
    Timecop.freeze do
      WinnegansFake::DB[:timestamp].insert(value: Time.now.utc - WinnegansFake::Timestamp::CADENCE - 1)

      assert WinnegansFake::Timestamp.new.post?
    end
  end

  def test_post_false
    Timecop.freeze do
      WinnegansFake::DB[:timestamp].insert(value: Time.now.utc - WinnegansFake::Timestamp::CADENCE + 1)

      refute WinnegansFake::Timestamp.new.post?
    end
  end

  def test_touch
    Timecop.freeze do
      WinnegansFake::DB[:timestamp].insert(value: Time.now.utc - WinnegansFake::Timestamp::CADENCE - 1)

      WinnegansFake::Timestamp.new.touch

      refute WinnegansFake::Timestamp.new.post?
    end
  end
end
