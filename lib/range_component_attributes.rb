require "range_component_attributes/range_wrapper"
require "range_component_attributes/type_conversion"
require "range_component_attributes/version"

require "active_support"

module RangeComponentAttributes
  extend ActiveSupport::Concern

  class_methods do
    # range_component_attributes creates attributes corresponding to the lower
    # and upper bounds of `range_name`. `lower_name` and `upper_name` controls
    # the names of these attributes.
    #
    # `type_converter` is a callable object that converts its argument to the
    # proper type. There are builtin type converters `IntegerConverter`,
    # `DecimalConverter`, `FloatConverter`, and `DateConverter`.
    #
    # In addition, `lower_type_converter` and `upper_type_converter` can be
    # separately specified. This is especially useful when the attributes should
    # behave differently for blank values. For example, the upper bound may want
    # to consider a blank value as Float::INFINITY.
    #
    # `exclude_end` controls whether the end is exclusive or not. Ranges are
    # automatically normalized to this type. This is useful because PostgreSQL
    # automatically normalizes ranges of discrete values to exclusive ends. e.g.
    # `[1, 10]` becomes `[1,11)`. RangeComponentAttributes will handle this so
    # the exact bound values persist even when PostgreSQL has changed them.
    #
    # Validations are automatically added that create an error if an assignment
    # to bounds attribute fails due to a type conversion error. In addition, a
    # validation checks that the lower bound is less than the upper bound. This
    # error message can be customized by supplying `crossed_bounds_message`.
    def range_component_attributes(
      range_name,
      lower_name: "#{range_name}_lower",
      upper_name: "#{range_name}_upper",
      type_converter: nil,
      lower_type_converter: nil,
      upper_type_converter: nil,
      exclude_end: true,
      crossed_bounds_message: "must be less than upper bound"
    )
      range_wrapper_name = "#{range_name}_wrapper"
      lower_type_converter ||= type_converter
      upper_type_converter ||= type_converter
      raise ArgumentError, "must provide lower_type_converter or type_converter" unless lower_type_converter
      raise ArgumentError, "must provide upper_type_converter or type_converter" unless upper_type_converter

      mod = Module.new do
        define_method range_wrapper_name do
          if instance_variable_defined?("@#{range_wrapper_name}")
            instance_variable_get("@#{range_wrapper_name}")
          else
            instance_variable_set("@#{range_wrapper_name}",
              RangeWrapper.new(
                lower_type_converter: lower_type_converter,
                upper_type_converter: upper_type_converter,
                exclude_end: exclude_end,
                range: send(range_name),
                crossed_bounds_message: crossed_bounds_message
              )
            )
          end
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

        define_method "reload" do |options=nil|
          result = super options
          send(range_wrapper_name).range = send(range_name)
          result
        end
      end

      validate "check_#{range_name}_errors".to_sym

      self.include mod
    end
  end
end
