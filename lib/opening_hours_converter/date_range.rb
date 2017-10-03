module OpeningHoursConverter
  class DateRange
    attr_accessor :wide_interval, :typical

    def initialize(w=nil)
      @wide_interval = nil
      @typical = nil
      update_range(w)
    end

    def defines_typical_day?
      @typical.instance_of?(OpeningHoursConverter::Day)
    end

    def defines_typical_week?
      @typical.instance_of?(OpeningHoursConverter::Week)
    end

    def update_range(wide)
      @wide_interval = !wide.nil? ? wide : OpeningHoursConverter::WideInterval.new.always

      if @typical.nil?
        case @wide_interval.type
        when "day"
          if @wide_interval.end.nil?
            @typical = OpeningHoursConverter::Day.new
          else
            @typical = OpeningHoursConverter::Week.new
          end
        when "week"
          @typical = OpeningHoursConverter::Week.new
        when "month"
          @typical = OpeningHoursConverter::Week.new
        when "always"
          @typical = OpeningHoursConverter::Week.new
        end
      end
    end

    def has_same_typical?(date_range)
      defines_typical_day? == date_range.defines_typical_day? && @typical.same_as?(date_range.typical)
    end

    def is_general_for?(date_range)
      defines_typical_day? == date_range.defines_typical_day? && @wide_interval.contains?(date_range.wide_interval)
    end
  end
end
