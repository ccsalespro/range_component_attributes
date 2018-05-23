require "range_component_attributes/version"

require "active_support"

module RangeComponentAttributes
  extend ActiveSupport::Concern

  class_methods do
    def range_component_attributes(
      range_name,
      lower_name: "#{range_name}_lower",
      upper_name: "#{range_name}_upper",
      exclude_end: true
    )
      mod = Module.new do
        [lower_name, upper_name].each do |part_name|
          attr_reader part_name
          define_method "#{part_name}=" do |val|
            instance_variable_set "@#{range_name}_invalidated", true
            instance_variable_set "@#{part_name}", val
          end
        end

        define_method "load_#{range_name}_components" do
          instance_variable_set "@#{lower_name}", send(range_name).begin
          instance_variable_set "@#{upper_name}", send(range_name).end
        end

        define_method "convert_#{range_name}_components_to_range" do
          if instance_variable_get("@#{range_name}_invalidated")
            send "#{range_name}=", Range.new(send(lower_name), send(upper_name), exclude_end)
          end
        end
      end

      self.include mod

      after_find "load_#{range_name}_components".intern
      before_save "convert_#{range_name}_components_to_range".intern
    end
  end
end
