module OpeningHoursConverter
  class OpeningHoursRule
    attr_accessor :date, :time

    def initialize
      @date = []
      @time = []
    end

    def get
      result = ""
      if @date.length > 1 || @date[0]&.wide != ""
        @date.each_with_index do |d, i|
          if (i > 0)
            result += ","
          end
          result += d.wide
        end
      end

      if @date.length > 0
        if result.length > 0
          result += " "
        end
        result += @date.first.get_months
      end

      if @date.length > 0
        if result.length > 0
          result += " "
        end
        result += @date.first.days
      end

      if @date.length > 0
        wd = @date[0].get_weekdays
        if wd.length > 0
          result += " #{wd}"
        end
      end

      if @time.length > 0
        result += " "
        @time.each_with_index do |t, i|
          if (i > 0)
            result += ","
          end
          result += t.get
        end
      else
        result += " off"
      end
      if result.strip == "00:00-24:00"
        result = "24/7"
      end

      result.strip.gsub('  ', ' ')
    end

    def same_time?(o)
      if o.nil? || o.time.length != @time.length
        return false
      else
        @time.each_with_index do |t, i|
          return false if !t.equals(o.time[i])
        end
        return true
      end
    end

    def is_off?
      @time.length == 0 || (@time.length == 1 && time[0].start.nil?)
    end

    def has_overwritten_weekday?
      @date.length > 0 && @date[0].weekdays_over.length > 0
    end

    def add_weekday(weekday)
      @date.each do |d|
        d.add_weekday(weekday)
      end
    end

    def add_overwritten_weekday(weekday)
      @date.each do |d|
        d.add_overwritten_weekday(weekday)
      end
    end

    def same_wide?(wide)
      result = ""
      if @date.length > 1 || @date[0]&.wide != ""
        @date.each_with_index do |d, i|
          if (i > 0)
            result += ","
          end
          result += d.wide
        end
      end
      if @date.length > 1 || @date[0]&.wide != ""
        @date.each_with_index do |d, i|
          if (i > 0)
            result += ","
          end
          result += d.days
        end
      end
      puts result
      wide == result
    end

    def add_date(date)
      if date.nil? || !date.instance_of?(OpeningHoursConverter::OpeningHoursYear)
        raise ArgumentError
      end

      if @date.length == 0
        @date << date
      elsif @date.first.same_weekdays?(date.weekdays) && same_wide?(date.wide)
        @date.each do |d|
          date.months.each do |month|
            d.add_month(month)
          end
        end
      elsif @date.first.same_weekdays?(date.weekdays) && @date.first.same_months?(date.months) && @date.first.wide != date.wide
        @date << date
      elsif @date.first.wide_type == "always" && date.wide_type == "always"
        @date << date
      else
        raise ArgumentError, "This date #{@date.inspect} can't be added to this rule #{self.inspect}"
      end
    end

    # def add_date(date)
    #   if date.nil? || !date.instance_of?(OpeningHoursConverter::OpeningHoursDate)
    #     raise ArgumentError
    #   end

    #   if @date.length == 0 || @date.first.same_kind_as?(date)
    #     @date << date
    #   else
    #     if @date.length != 1 || @date.first.wide_type != "always" || !@date.first.same_weekdays?(date.weekdays)
    #       raise ArgumentError, "This date #{@date.inspect} can't be added to this rule #{self.inspect}"
    #     end
    #   end
    # end

    def add_time(time)
      if (@time.length == 0 || @time[0].get != "off") && !@time.include?(time)
        @time << time
      else
        raise ArgumentError, "This time can't be added to this rule"
      end
    end
  end
end
