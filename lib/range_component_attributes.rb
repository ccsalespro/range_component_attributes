require "range_component_attributes/range_wrapper"
require "range_component_attributes/type_conversion"
require "range_component_attributes/version"

require "active_support"

module RangeComponentAttributes
  extend ActiveSupport::Concern

  class_methods do
    def range_component_attributes(
      range_name,
      lower_name: "#{range_name}_lower",
      upper_name: "#{range_name}_upper",
      type_converter:,
      exclude_end: true
    )
      range_wrapper_name = "#{range_name}_wrapper"

      mod = Module.new do
        define_method range_wrapper_name do
          instance_variable_get("@#{range_wrapper_name}") ||
            instance_variable_set("@#{range_wrapper_name}",
              RangeWrapper.new(type_converter: type_converter, exclude_end: exclude_end, range: send(range_name)))
        end

        define_method "#{lower_name}" do
          send(range_wrapper_name).lower
        end

        define_method "#{lower_name}=" do |val|
          range_wrapper = send(range_wrapper_name)
          range_wrapper.lower = val
          if range_wrapper.valid?
            send("#{range_name}=", range_wrapper.range)
          end
        end

        define_method "#{upper_name}" do
          send(range_wrapper_name).upper
        end

        define_method "#{upper_name}=" do |val|
          range_wrapper = send(range_wrapper_name)
          range_wrapper.upper = val
          if range_wrapper.valid?
            send("#{range_name}=", range_wrapper.range)
          end
        end

        define_method "#{range_name}=" do |val|
          send(range_wrapper_name).range = val
          super val
        end

        define_method "check_#{range_name}_errors" do
          range_wrapper = send(range_wrapper_name)
          unless range_wrapper.valid?
            errors.add lower_name, range_wrapper.errors[:lower] if range_wrapper.errors[:lower]
            errors.add upper_name, range_wrapper.errors[:upper] if range_wrapper.errors[:upper]
            errors.add upper_name, range_wrapper.errors[:range] if range_wrapper.errors[:range]
          end
        end
      end

      validate "check_#{range_name}_errors".to_sym

      self.include mod
    end
  end
end
