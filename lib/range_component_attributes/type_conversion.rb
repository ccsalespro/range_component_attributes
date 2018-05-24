module RangeComponentAttributes
  class TypeConversionError < StandardError
    attr_reader :original_error, :target_type

    def initialize(original_error, target_type)
      @original_error = original_error
      @target_type = target_type
    end
  end

  class IntegerConverter
    def call(value)
      return nil if value.blank?
      Integer(value)
    rescue StandardError => e
      raise TypeConversionError.new(e, "integer")
    end
  end

  class DecimalConverter
    def call(value)
      return nil if value.blank?
      BigDecimal(value, 16)
    rescue StandardError => e
      raise TypeConversionError.new(e, "number")
    end
  end

  class FloatConverter
    def call(value)
      return nil if value.blank?
      Float(value)
    rescue StandardError => e
      raise TypeConversionError.new(e, "number")
    end
  end

  class DateConverter
    def call(value)
      return nil if value.blank?
      return value if value.kind_of? Date
      value = value.to_s
      if value =~ /\A(\d\d\d\d)-(\d\d)-(\d\d)\z/
        ::Date.civil($1.to_i, $2.to_i, $3.to_i)
      else
        ::Date.strptime(value, "%m/%d/%Y")
      end
    rescue StandardError => e
      raise TypeConversionError.new(e, "date")
    end
  end
end
