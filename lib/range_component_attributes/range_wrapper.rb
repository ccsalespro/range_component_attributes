module RangeComponentAttributes
  class InvalidRangeError < StandardError; end

  class RangeWrapper
    def initialize(
      # Range type
      type_converter:,
      exclude_end: true,

      # Initial values
      lower: nil,
      upper: nil,
      range: nil
    )
      raise ArgumentError, "lower/upper and range are mutually exclusive" if (lower || upper) && range

      @valid = true
      @type_converter = type_converter
      @exclude_end = exclude_end

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
        @type_converter.(x)
      rescue TypeConversionError => e
        x
      end
      convert_lower_and_upper_to_range
    end

    def upper
      @upper
    end

    def upper=(x)
      @upper = begin
        @type_converter.(x)
      rescue TypeConversionError => e
        x
      end
      convert_lower_and_upper_to_range
    end

    def valid?
      @valid
    end

  private

    def convert_lower_and_upper_to_range
      @range = if @lower || @upper
        Range.new(@lower, @upper, @exclude_end)
      else
        nil
      end
      @valid = true
    rescue ArgumentError
      @valid = false
    end
  end
end
