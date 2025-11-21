require "test_helper"

class CursorTest < WinnegansFake::Test
  def test_get
    WinnegansFake::DB[:cursor].insert(value: 42)

    value = WinnegansFake::Cursor.new.get

    assert_equal 42, value
  end

  def test_set
    WinnegansFake::DB[:cursor].insert(value: 42)
    WinnegansFake::Cursor.new.set(43)

    value = WinnegansFake::Cursor.new.get

    assert_equal 43, value
  end
end
