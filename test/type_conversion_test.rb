require "test_helper"

class TypeConversionTest < Minitest::Test
  def test_integer_converter
    converter = RangeComponentAttributes::IntegerConverter.new
    assert_equal 42, converter.("42")
    assert_equal Float::INFINITY, converter.(Float::INFINITY)
    refute converter.(nil)
    refute converter.("")
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("asdf") }
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("0.1") }

    converter = RangeComponentAttributes::IntegerConverter.new blank_value: Float::INFINITY
    assert_equal Float::INFINITY, converter.(nil)
    assert_equal Float::INFINITY, converter.("")
  end

  def test_float_converter
    converter = RangeComponentAttributes::FloatConverter.new
    assert_equal 42.0, converter.("42")
    assert_equal 42.5, converter.("42.5")
    assert_equal Float::INFINITY, converter.(Float::INFINITY)
    refute converter.(nil)
    refute converter.("")
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("asdf") }

    converter = RangeComponentAttributes::FloatConverter.new blank_value: Float::INFINITY
    assert_equal Float::INFINITY, converter.(nil)
    assert_equal Float::INFINITY, converter.("")
  end

  def test_decimal_converter
    converter = RangeComponentAttributes::DecimalConverter.new
    assert_equal BigDecimal("42"), converter.("42")
    assert_equal BigDecimal("42.5"), converter.("42.5")
    assert_equal BigDecimal("42"), converter.(42.0)
    assert_equal BigDecimal("42"), converter.(42)
    assert_equal Float::INFINITY, converter.(Float::INFINITY)
    refute converter.(nil)
    refute converter.("")
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("asdf") }

    converter = RangeComponentAttributes::DecimalConverter.new blank_value: Float::INFINITY
    assert_equal Float::INFINITY, converter.(nil)
    assert_equal Float::INFINITY, converter.("")
  end

  def test_date_converter
    converter = RangeComponentAttributes::DateConverter.new
    assert_equal Date.new(2000,1,1), converter.("01/01/2000")
    assert_equal Date.new(2000,1,1), converter.("1/1/2000")
    assert_equal Date.new(2000,1,1), converter.("2000-01-01")
    assert_equal Date.new(2000,1,1), converter.(Date.new(2000,1,1))
    assert_equal Float::INFINITY, converter.(Float::INFINITY)
    refute converter.(nil)
    refute converter.("")
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("asdf") }
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("3/50/1290") }

    converter = RangeComponentAttributes::DateConverter.new blank_value: Float::INFINITY
    assert_equal Float::INFINITY, converter.(nil)
    assert_equal Float::INFINITY, converter.("")
  end

  def test_time_converter
    Time.zone = "America/New_York"
    converter = RangeComponentAttributes::TimeConverter.new
    assert_equal Time.zone.local(2000,1,1), converter.("01/01/2000")
    assert_equal Time.zone.local(2000,1,1), converter.("1/1/2000")
    assert_equal Time.zone.local(2000,1,1), converter.("2000-01-01")
    assert_equal Time.zone.local(2000,1,1), converter.(Date.new(2000,1,1))
    assert_equal Time.zone.local(2000,1,1), converter.(Time.zone.local(2000,1,1))
    assert_equal Time.zone.local(2000,1,1, 8, 23, 58), converter.("2000-01-01 08:23:58")
    assert_equal Float::INFINITY, converter.(Float::INFINITY)
    refute converter.(nil)
    refute converter.("")
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("asdf") }
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("3/50/1290") }

    converter = RangeComponentAttributes::TimeConverter.new blank_value: Float::INFINITY
    assert_equal Float::INFINITY, converter.(nil)
    assert_equal Float::INFINITY, converter.("")
  end
end
