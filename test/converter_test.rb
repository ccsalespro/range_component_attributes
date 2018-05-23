require "test_helper"

class ConverterTest < Minitest::Test
  def test_new_with_lower_and_upper
    r = RangeComponentAttributes::Converter.new lower: 1, upper: 5
    assert_equal 1, r.lower
    assert_equal 5, r.upper
    assert_equal 1...5, r.range
  end

  def test_new_with_range
    r = RangeComponentAttributes::Converter.new range: 1...5
    assert_equal 1, r.lower
    assert_equal 5, r.upper
    assert_equal 1...5, r.range
  end

  def test_assigning_range_sets_lower_and_upper
    r = RangeComponentAttributes::Converter.new
    r.range = 1...5
    assert_equal 1, r.lower
    assert_equal 5, r.upper
  end

  def test_assigning_lower_and_upper_sets_range
    r = RangeComponentAttributes::Converter.new
    r.lower = 1
    r.upper = 5
    assert_equal 1...5, r.range
  end

  def test_nil_lower_and_upper_is_nil
    r = RangeComponentAttributes::Converter.new lower: 1, upper: 5
    assert_equal 1...5, r.range
    r.lower = nil
    r.upper = nil
    refute r.range
  end

  def test_assigning_nil_range_sets_lower_and_upper_to_nil
    r = RangeComponentAttributes::Converter.new lower: 1, upper: 5
    r.range = nil
    refute r.lower
    refute r.upper
  end

  def test_range_raises_InvalidRangeError_when_range_is_invalid
    r = RangeComponentAttributes::Converter.new lower: 1, upper: "foo"
    assert_raises(RangeComponentAttributes::InvalidRangeError) { r.range }
  end

  def test_valid
    r = RangeComponentAttributes::Converter.new
    assert r.valid?
    r.lower = 42
    refute r.valid?
    r.upper = 50
    assert r.valid?
    r.lower = "foo"
    refute r.valid?
  end
end
