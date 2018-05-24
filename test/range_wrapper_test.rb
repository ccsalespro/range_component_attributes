require "test_helper"

class RangeWrapperTest < Minitest::Test
  def test_new_with_lower_and_upper
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new,
      lower: 1,
      upper: 5
    assert_equal 1, r.lower
    assert_equal 5, r.upper
    assert_equal 1...5, r.range
  end

  def test_new_with_range
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new,
      range: 1...5
    assert_equal 1, r.lower
    assert_equal 5, r.upper
    assert_equal 1...5, r.range
  end

  def test_assigning_range_sets_lower_and_upper
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new
    r.range = 1...5
    assert_equal 1, r.lower
    assert_equal 5, r.upper
  end

  def test_assigning_lower_and_upper_sets_range
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new
    r.lower = 1
    r.upper = 5
    assert_equal 1...5, r.range
  end

  def test_nil_lower_and_upper_is_nil
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new,
      lower: 1, upper: 5
    assert_equal 1...5, r.range
    r.lower = nil
    r.upper = nil
    refute r.range
  end

  def test_assigning_nil_range_sets_lower_and_upper_to_nil
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new,
      lower: 1,
      upper: 5
    r.range = nil
    refute r.lower
    refute r.upper
  end

  def test_range_raises_InvalidRangeError_when_range_is_invalid
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new,
      lower: 1,
      upper: "foo"
    assert_raises(RangeComponentAttributes::InvalidRangeError) { r.range }
  end

  def test_valid
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new
    assert r.valid?
    r.lower = 42
    refute r.valid?
    r.upper = 50
    assert r.valid?
    r.lower = "foo"
    refute r.valid?
  end

  def test_type_conversion
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new
    r.lower = "42"
    assert_equal 42, r.lower
    r.upper = "45"
    assert_equal 45, r.upper
    assert_equal 42...45, r.range
  end

  def test_type_conversion_errors
    r = RangeComponentAttributes::RangeWrapper.new lower_type_converter: RangeComponentAttributes::IntegerConverter.new,
      upper_type_converter: RangeComponentAttributes::IntegerConverter.new
    r.lower = "abc"
    assert_equal "abc", r.lower
    refute r.valid?
    assert_equal "is not a integer", r.errors[:lower]

    r.upper = "xyz"
    assert_equal "xyz", r.upper
    refute r.valid?
    assert_equal "is not a integer", r.errors[:upper]

    r.lower = 40
    refute r.errors[:lower]

    r.upper = 50
    refute r.errors[:upper]

    assert r.valid?
  end
end
