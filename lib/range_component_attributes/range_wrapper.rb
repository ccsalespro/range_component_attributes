module RangeComponentAttributes
  class InvalidRangeError < StandardError; end

  class RangeWrapper
    attr_reader :errors

    def initialize(
      # Range type
      lower_type_converter:,
      upper_type_converter:,
      exclude_end: true,

      # Initial values
      lower: nil,
      upper: nil,
      range: nil,

      crossed_bounds_message: "must be less than upper bound"
    )
      raise ArgumentError, "lower/upper and range are mutually exclusive" if (lower || upper) && range

      @errors = {}
      @lower_type_converter = lower_type_converter
      @upper_type_converter = upper_type_converter
      @exclude_end = exclude_end
      @crossed_bounds_message = crossed_bounds_message

      if range
        self.range = range
      else
        self.lower = lower
        self.upper = upper
      end
    end

    def range
      raise InvalidRangeError unless valid?
      @range
    end

    def range=(x)
      if x
        @lower = x.begin
        @upper = x.end
        if x.exclude_end? != @exclude_end && @upper.respond_to?(:next)
          @upper += x.exclude_end? ? -1 : 1
        end
        convert_lower_and_upper_to_range
      else
        @lower = nil
        @upper = nil
        @range = nil
      end
    end

    def lower
      @lower
    end

    def lower=(x)
      @lower = begin
        @lower_type_converter.(x).tap { errors.delete(:lower) }
      rescue TypeConversionError => e
        errors[:lower] = "is not a #{e.target_type}"
        x
      end
      convert_lower_and_upper_to_range
    end

    def upper
      @upper
    end

    def upper=(x)
      @upper = begin
        @upper_type_converter.(x).tap { errors.delete(:upper) }
      rescue TypeConversionError => e
        errors[:upper] = "is not a #{e.target_type}"
        x
      end
      convert_lower_and_upper_to_range
    end

    def valid?
      errors.empty?
    end

  private

    def convert_lower_and_upper_to_range
      return nil unless errors.keys.reject { |k| k == :range }.empty?
      @range = if @lower != @lower_type_converter.blank_value || @upper != @upper_type_converter.blank_value
        Range.new(@lower, @upper, @exclude_end)
      else
        nil
      end
      errors.clear

      crossed_bounds = lower > upper rescue nil
      errors[:lower] = @crossed_bounds_message if crossed_bounds
    rescue ArgumentError => e
      errors[:range] = e.to_s
    end
  end
end
