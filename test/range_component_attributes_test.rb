require "test_helper"

class Widget < ActiveRecord::Base
  include RangeComponentAttributes

  range_component_attributes :range, lower_name: :lower, upper_name: :upper
end

class RangeComponentAttributesTest < Minitest::Test
  def test_component_attributes_are_populated_on_load
    widget = Widget.create! range: Date.new(2000,1,1)...Date.new(2000,1,10)
    widget = Widget.find widget.id
    assert_equal Date.new(2000,1,1), widget.lower
    assert_equal Date.new(2000,1,10), widget.upper
  end

  def test_component_attributes_are_converted_to_range_on_save
    widget = Widget.create! lower: Date.new(2000,1,1), upper: Date.new(2000,1,10)
    widget = Widget.find widget.id
    assert_equal Date.new(2000,1,1), widget.range.begin
    assert_equal Date.new(2000,1,10), widget.range.end
  end
end
