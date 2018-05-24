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
      lower: :not_provided,
      upper: :not_provided,
      range: nil
    )
      @errors = {}
      @lower_type_converter = lower_type_converter
      @upper_type_converter = upper_type_converter
      @exclude_end = exclude_end

      if range
        self.range = range
      else
        self.lower = lower unless lower == :not_provided
        self.upper = upper unless upper == :not_provided
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
      @range = if @lower || @upper
        Range.new(@lower, @upper, @exclude_end)
      else
        nil
      end
      errors.clear
    rescue ArgumentError => e
      errors[:range] = e.to_s
    end
  end
end
