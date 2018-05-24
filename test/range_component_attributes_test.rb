require "test_helper"

class Widget < ActiveRecord::Base
  include RangeComponentAttributes

  range_component_attributes :valid_dates,
    lower_name: :valid_from,
    upper_name: :valid_to,
    type_converter: DateConverter.new,
    crossed_bounds_message: "must be less than valid to"

  range_component_attributes :valid_prices,
    lower_name: :min_price,
    upper_name: :max_price,
    lower_type_converter: DecimalConverter.new,
    upper_type_converter: DecimalConverter.new(blank_value: Float::INFINITY)
end

class RangeComponentAttributesTest < Minitest::Test
  def test_component_attributes_are_populated_on_load
    widget = Widget.create! valid_dates: Date.new(2000,1,1)...Date.new(2000,1,10)
    widget = Widget.find widget.id
    assert_equal Date.new(2000,1,1), widget.valid_from
    assert_equal Date.new(2000,1,10), widget.valid_to
  end

  def test_component_attributes_are_converted_to_range_on_save
    widget = Widget.create! valid_from: Date.new(2000,1,1), valid_to: Date.new(2000,1,10)
    widget = Widget.find widget.id
    assert_equal Date.new(2000,1,1), widget.valid_dates.begin
    assert_equal Date.new(2000,1,10), widget.valid_dates.end
  end

  def test_component_attributes_are_converted_to_proper_type_on_assignment
    widget = Widget.new valid_from: "2000-01-01", valid_to: "2000-01-10"
    assert_equal Date.new(2000,1,1), widget.valid_from
    assert_equal Date.new(2000,1,10), widget.valid_to
    assert_equal Date.new(2000,1,1), widget.valid_from
    assert_equal Date.new(2000,1,10), widget.valid_to
  end

  def test_detect_type_conversion_errors
    widget = Widget.new valid_from: "abc", valid_to: "xyz"
    refute widget.valid?
    assert_equal ["is not a date"], widget.errors[:valid_from]
    assert_equal ["is not a date"], widget.errors[:valid_to]
  end

  def test_separate_type_converters_for_each_bound
    widget = Widget.new min_price: "10", max_price: ""
    assert widget.valid?
    assert_equal BigDecimal("10"), widget.min_price
    assert_equal Float::INFINITY, widget.max_price
    assert_equal BigDecimal("10")...Float::INFINITY, widget.valid_prices
  end

  def test_crossed_bounds
    widget = Widget.new min_price: "10", max_price: "5"
    refute widget.valid?
    assert_equal ["must be less than upper bound"], widget.errors[:min_price]

    widget = Widget.new valid_from: Date.new(2001,1,1), valid_to: Date.new(2000,1,1)
    refute widget.valid?
    assert_equal ["must be less than valid to"], widget.errors[:valid_from]
  end
end
