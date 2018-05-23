require "range_component_attributes/converter"
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
      converter_name = "#{range_name}_converter"

      mod = Module.new do
        define_method converter_name do
          instance_variable_get("@#{converter_name}") ||
            instance_variable_set("@#{converter_name}", Converter.new(range: send(range_name), exclude_end: exclude_end))
        end

        define_method "#{lower_name}" do
          send(converter_name).lower
        end

        define_method "#{lower_name}=" do |val|
          converter = send(converter_name)
          converter.lower = val
          if converter.valid?
            send("#{range_name}=", converter.range)
          end
        end

        define_method "#{upper_name}" do
          send(converter_name).upper
        end

        define_method "#{upper_name}=" do |val|
          converter = send(converter_name)
          converter.upper = val
          if converter.valid?
            send("#{range_name}=", converter.range)
          end
        end

        define_method "#{range_name}=" do |val|
          send(converter_name).range = val
          super val
        end
      end

      self.include mod
    end
  end
end
