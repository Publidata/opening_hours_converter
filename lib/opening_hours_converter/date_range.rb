module OpeningHoursConverter
  class DateRange
    attr_accessor :wide_interval, :typical, :comment

    def initialize(w=nil)
      @wide_interval = nil
      @typical = nil
      @comment = ""
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
        else
          @typical = OpeningHoursConverter::Week.new
        end
      end
    end

    def add_comment(comment="")
      @comment += comment
    end

    def has_same_typical?(date_range)
      defines_typical_day? == date_range.defines_typical_day? && @typical.same_as?(date_range.typical)
    end

    def is_general_for?(date_range)
      defines_typical_day? == date_range.defines_typical_day? && @wide_interval.contains?(date_range.wide_interval) && @comment == date_range.comment
    end

    def is_holiday?
      result = false
      result = @wide_interval.type == "holiday"
      if !result
        @typical.intervals.each do |i|
          result = true if i.day_start == -2 && i.day_end == -2
        end
      end
      result
    end
  end
end
