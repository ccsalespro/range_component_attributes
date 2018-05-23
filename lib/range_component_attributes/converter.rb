module RangeComponentAttributes
  class InvalidRangeError < StandardError; end

  class Converter
    def initialize(lower: nil, upper: nil, range: nil, exclude_end: true)
      raise ArgumentError, "lower/upper and range are mutually exclusive" if (lower || upper) && range

      @valid = true
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
      @lower = x
      convert_lower_and_upper_to_range
    end

    def upper
      @upper
    end

    def upper=(x)
      @upper = x
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
