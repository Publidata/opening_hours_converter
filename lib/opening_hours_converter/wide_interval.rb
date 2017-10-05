require 'opening_hours_converter/constants'
require 'pry-nav'

module OpeningHoursConverter
  class WideInterval
    include Constants
    attr_accessor :start, :end, :type

    def initialize
      @start = nil
      @end = nil
      @type = nil
    end

    def get_time_selector
      result = ""

      case @type
      when "day"
        result = "#{@start[:year].nil? ? "" : "#{@start[:year]} "}#{OSM_MONTHS[@start[:month]-1]} #{@start[:day] < 10 ? "0" : ""}#{@start[:day]}"
        if !@end.nil?
          if @start[:month] == @end[:month]
            result += "-#{@start[:year] == @end[:year] ? "" : "#{@end[:year]} "}#{@end[:day] < 10 ? "0" : ""}#{@end[:day]}"
          else
            result += "-#{@start[:year] == @end[:year] ? "" : "#{@end[:year]} "}#{OSM_MONTHS[@end[:month]-1]} #{@end[:day] < 10 ? "0" : ""}#{@end[:day]}"
          end
        end
      when "month"
        result = "#{@start[:year].nil? ? "" : "#{@start[:year]} "}#{OSM_MONTHS[@start[:month]-1]}"
        if !@end.nil?
          result += "-#{@start[:year] == @end[:year] ? "" : "#{@end[:year]} "}#{OSM_MONTHS[@end[:month]-1]}"
        end
      when "year"
        result = "#{@start[:year]}"
        if !@end.nil?
          result += "-#{@end[:year]}"
        end
      when "always"
        result = ""
      else
        result = ""
      end
      result
    end

    def get_time_for_humans
      result = ""

      case @type
      when "day"
        if !@end.nil?
          result = "toutes les semaines du #{@start[:day]} #{IRL_MONTHS[@start[:month] - 1]}"
          if @start[:month] != @end[:month]
            result += " au #{@end[:day]} #{IRL_MONTHS[@end[:month] - 1]}"
          end
        else
          result = "le #{@start[:day]} #{IRL_MONTHS[@start[:month] - 1]}"
        end
      when "month"
        if !@end.nil?
          result = "toutes les semaines de #{IRL_MONTHS[@start[:month] - 1]} à #{IRL_MONTHS[@endd[:month] - 1]}"
        else
          result = "toutes les semaines de #{IRL_MONTHS[@start[:month] - 1]}"
        end
      when "always"
        result = "toutes les semaines"
      end
      return result
    end

    def day(start_day, start_month, start_year=nil, end_day=nil, end_month=nil, end_year=nil)
      if start_day.nil? || start_month.nil?
        raise(ArgumentError, "start_day, start_month and start_year are required")
      end
      @start = { day: start_day, month: start_month, year: start_year }
      if (!end_day.nil? && !end_month.nil? && (end_day != start_day || end_month != start_month || (!start_year.nil? && !end_year.nil? && end_year != start_year)))
        @end = { day: end_day, month: end_month, year: end_year }
      end
      @type = "day"
      self
    end

    def month(start_month, start_year=nil, end_month=nil, end_year=nil)
      if start_month.nil?
        raise(ArgumentError, "start_month is required")
      end
      @start = { month: start_month, year: start_year }
      if !end_month.nil? && (end_month != start_month || (!start_year.nil? && !end_year.nil? && end_year != start_year))
        @end = { month: end_month, year: end_year }
      end
      @type = "month"
      self
    end

    def year(start_year, end_year=nil)
      if start_year.nil?
        raise(ArgumentError, "start_year is required")
      end
      @start = { year: start_year }
      unless end_year.nil? || end_year == start_year
        @end = { year: end_year }
      end
      @type = "year"
      self
    end

    def always
      @start = nil
      @end = nil
      @type = "always"
      self
    end

    def is_full_month?
      return true if @type == "month" && @end.nil?
      return false if @end.nil?
      return false if !@start[:year].nil? && !@end[:year].nil? && @start[:year] != @end[:year]
      if @type == "day"
        @start[:day] == 1 && !@end.nil? && @start[:month] == @end[:month] &&
        !@end[:day].nil? && @end[:day] == MONTH_END_DAY[@end[:month] - 1]
      else
        false
      end
    end

    def starts_month?
      @type == "month" || @type == "always" || @type == "year" || (@type == "day" && @start[:day] == 1)
    end

    def ends_month?
      @type == "month" || @type == "always" || @type == "year" || (@type == "day" && !@end.nil? && @end[:day] == MONTH_END_DAY[@end[:month] - 1])
    end

    def is_full_year?
      return true if @end.nil? && type == "year"
      return false if @end.nil?
      return false if !@start[:year].nil? && !@end[:year].nil? && @start[:year] != @end[:year]
      if @type == "month"
        @start[:month] == 1 && !@end.nil? && @start[:year] == @end[:year] && !@end[:month].nil? && @end[:month] == 12
      elsif @type == "day"
        @start[:day] == 1 && @start[:month] == 1 && !@end.nil? && !@start[:year].nil? && !@end[:year].nil? && @start[:year] == @end[:year] &&
        !@end[:month].nil? && @end[:month] == 12 && !@end[:day].nil? && @end[:day] == MONTH_END_DAY[@end[:month] - 1]
      else
        false
      end
    end

    def starts_year?
      @type == "year" || @type == "always" || (@type == "day" && @start[:day] == 1 && @start[:month] == 1) || (@type == "month" && @start[:month] == 1)
    end

    def ends_year?
      @type == "year" || @type == "always" || (@type == "day" && !@end.nil? && @end[:month] == 12 && @end[:day] == MONTH_END_DAY[@end[:month] - 1])
    end

    def contains?(o)
      return false if o.type == "always"
      result = false
      if self.equals(o)
        result = false
      elsif @type == "always"
        result = true
      else
        my = to_day
        o = o.to_day
        result = has_superior_or_equal_start_day?(my, o) && has_inferior_or_equal_end_day?(my, o)
      end
      return result
    end

    def has_superior_or_equal_start_day?(my, o)
      result = false
      if has_start_year?(o) && has_start_year?(my)
        result = o.start[:year] > my.start[:year] || (o.start[:year] == my.start[:year] && has_superior_start_month?(my, o))
      elsif !has_start_year?(o) && !has_start_year?(my)
        result = has_superior_start_month?(my, o)
      end
      result
    end

    def has_superior_start_month?(my, o)
      (o.start[:month] > my.start[:month] ||
        (o.start[:month] == my.start[:month] &&
          o.start[:day] >= my.start[:day]))
    end

    def has_inferior_or_equal_end_day?(my, o)
      result = false
      return false if my.end.nil?
      if !o.end.nil?
        if has_end_year?(o) && has_end_year?(my)
          result = o.end[:year] < my.end[:year] || (o.end[:year] == my.end[:year] && has_inferior_end_month?(my, o))
        elsif !has_end_year?(o) && !has_end_year?(my)
          result = has_inferior_end_month?(my, o)
        end
      else
        if has_start_year?(o) && has_end_year?(my)
          result = o.start[:year] < my.end[:year] || (o.start[:year] == my.end[:year] && has_inferior_end_month?(my, o))
        elsif !has_start_year?(o) && !has_end_year?(my)
          result = has_inferior_end_month?(my, o)
        end
      end

      result
    end

    def has_inferior_end_month?(my, o)
      if !o.end.nil?
        (o.end[:month] < my.end[:month] ||
          (o.end[:month] == my.end[:month] &&
            o.end[:day] <= my.end[:day]))
      else
        (o.start[:month] < my.end[:month] ||
          (o.start[:month] == my.end[:month] &&
            o.start[:day] <= my.end[:day]))
      end
    end

    def has_start_year?(date)
      !date.start[:year].nil?
    end
    def has_end_year?(date)
      !date.end[:year].nil?
    end

    def equals(o)
      return false unless o.instance_of?(OpeningHoursConverter::WideInterval)
      return @type == "always" if o.type == "always"
      return false if @type == "always"
      self_to_day = to_day
      o_to_day = o.to_day
      return (self_to_day.start[:year] == o_to_day.start[:year] &&
        self_to_day.start[:month] == o_to_day.start[:month] &&
        self_to_day.start[:day] == o_to_day.start[:day]) &&
        ((self_to_day.end.nil? && o_to_day.end.nil?) || ((!self_to_day.end.nil? && !o_to_day.end.nil?) &&
          (self_to_day.end[:year] == o_to_day.end[:year] &&
            self_to_day.end[:month] == o_to_day.end[:month] &&
            self_to_day.end[:day] == o_to_day.end[:day])))
    end
    def to_day
      case @type
      when "day"
        if @end.nil?
          OpeningHoursConverter::WideInterval.new.day(@start[:day], @start[:month], @start[:year])
        else
          OpeningHoursConverter::WideInterval.new.day(@start[:day], @start[:month], @start[:year], @end[:day], @end[:month], @end[:year])
        end
      when "month"
        if @end.nil?
          OpeningHoursConverter::WideInterval.new.day(1, @start[:month], @start[:year], MONTH_END_DAY[@start[:month] - 1], @start[:month], @start[:year])
        else
          OpeningHoursConverter::WideInterval.new.day(1, @start[:month], @start[:year], MONTH_END_DAY[@end[:month] - 1], @end[:month], @end[:year])
        end
      when "year"
        if @end.nil?
          OpeningHoursConverter::WideInterval.new.day(1, 1, @start[:year], 31, 12, @start[:year])
        else
          OpeningHoursConverter::WideInterval.new.day(1, 1, @start[:year], 31, 12, @end[:year])
        end
      end
    end
  end
end
