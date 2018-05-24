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
  end

  def test_float_converter
    converter = RangeComponentAttributes::FloatConverter.new
    assert_equal 42.0, converter.("42")
    assert_equal 42.5, converter.("42.5")
    assert_equal Float::INFINITY, converter.(Float::INFINITY)
    refute converter.(nil)
    refute converter.("")
    assert_raises(RangeComponentAttributes::TypeConversionError) { converter.("asdf") }
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
  end
end
