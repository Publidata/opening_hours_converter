require 'opening_hours_converter/constants'

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
        result = "#{OSM_MONTHS[@start[:month]-1]} #{@start[:day] < 10 ? "0" : ""}#{@start[:day]}"
        if !@end.nil?
          if @start[:month] == @end[:month]
            result += "-#{@end[:day] < 10 ? "0" : ""}#{@end[:day]}"
          else
            result += "-#{OSM_MONTHS[@end[:month]-1]} #{@end[:day] < 10 ? "0" : ""}#{@end[:day]}"
          end
        end
      when "week"
        result = "week #{@start[:week] < 10 ? "0" : ""}#{@start[:week]}"
        if !@end.nil?
          result += "-#{@end[:week] < 10 ? "0" : ""}#{@end[:week]}"
        end
      when "month"
        result = "#{OSM_MONTHS[@start[:month]-1]}"
        if !@end.nil?
          result += "-#{OSM_MONTHS[@end[:month]-1]}"
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
      when "week"
        if !@end.nil?
          result = "toutes les semaines de la semaine #{@start[:week]} à la semaine #{@end[:week]}"
        else
          result = "la semaine #{@start[:week]}"
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

    def day(start_day, start_month, end_day=nil, end_month=nil)
      if start_day.nil? || start_month.nil?
        raise(ArgumentError, "start_day and start_month are required")
      end
      @start = { day: start_day, month: start_month }
      if (!end_day.nil? && !end_month.nil? && (end_day != start_day || end_month != start_month))
        @end = { day: end_day, month: end_month }
      end
      @type = "day"
      self
    end

    def week(start_week, end_week=nil)
      if start_week.nil?
        raise(ArgumentError, "start_week is required")
      end
      @start = { week: start_week }
      unless end_week.nil? || end_week == start_week
        @end = { week: end_week }
      end
      @type = "week"
      self
    end

    def month(start_month, end_month=nil)
      if start_month.nil?
        raise(ArgumentError, "start_month is required")
      end
      @start = { month: start_month }
      unless end_month.nil? || end_month == start_month
        @end = { month: end_month }
      end
      @type = "month"
      self
    end

    def always
      @start = nil
      @end = nil
      @type = "always"
      self
    end

    def is_full_month?
      if @type == "month" && @end.nil?
        true
      elsif @type == "day"
        @start[:day] == 1 && !@end.nil? && @start[:month] == @end[:month] &&
        !@end[:day].nil? && @end[:day] == MONTH_END_DAY[@end[:month] - 1]
      else
        false
      end
    end

    def starts_month?
      @type == "month" || @type == "always" || (@type == "day" && @start[:day] == 1)
    end

    def ends_month?
      @type == "month" || @type == "always" || (@type == "day" && !@end.nil? && @end[:day] == MONTH_END_DAY[@end[:month] - 1])
    end

    def contains?(o)
      result = false
      if self.equals(o)
        result = false
      elsif @type == "always"
        result = true
      elsif @type ==  "day"
        if o.type == "day"
          if o.start[:month] > @start[:month] || (o.start[:month] == @start[:month] && o.start[:day] >= @start[:day])

            if !o.end.nil?
              if !@end.nil? && (o.end[:month] < @end[:month] || (o.end[:month] == @end[:month] && o.end[:day] <= @end[:day]))
                result = true
              end
            else
              if !@end.nil? && (o.start[:month] < @end[:month] || (o.start[:month] == @end[:month] && o.start[:day] <= @end[:day]))
                result = true
              end
            end

          end
        elsif o.type == "month"
          if o.start[:month] > @start[:month] || (o.start[:month] == @start[:month] && @start[:day] == 1)
            if !o.end.nil? && !@end.nil? && (o.end[:month] < @end[:month] || (o.end[:month] == @end[:month] && @end[:day] == MONTH_END_DAY[@end.month-1]))
              result = true
            elsif o.end.nil? && (!@end.nil? && o.start[:month] < @end[:month])
              result = true
            end
          end
        end
      elsif @type == "week"
        if o.type == "week"
          if o.start[:week] >= @start[:week]
            if !o.end.nil? && !@end.nil? && o.end[:week] <= @end[:week]
              result = true
            elsif o.end.nil? && ((!@end.nil? && o.start[:week] <= @end[:week]) || o.start[:week] == @start[:week])
              result = true
            end
          end
        end
      elsif @type == "month"
        if o.type == "month"
          if o.start[:month] >= @start[:month]
            if !o.end.nil? && !@end.nil? && o.end[:month] <= @end[:month]
              result = true
            elsif o.end.nil? && ((!@end.nil? && o.start[:month] <= @end[:month]) || o.start[:month] == @start[:month])
              result = true
            end
          end
        elsif o.type == "day"
          if !o.end.nil?
            if @end.nil?
              if o.start[:month] == @start[:month] &&
                o.end[:month] == @start[:month] &&
                ((o.start[:day] >= 1 && o.end[:day] < MONTH_END_DAY[o.start[:month]-1]) ||
                (o.start[:day] > 1 && o.end[:day] <= MONTH_END_DAY[o.start[:month]-1]))
                result = true
              end
            else
              if o.start[:month] >= @start[:month] && o.end[:month] <= @end[:month]
                if ((o.start[:month] > @start[:month] && o.end[:month] < @end[:month]) ||
                  (o.start[:month] == @start[:month] && o.end[:month] < @end[:month] && o.start.day > 1) ||
                  (o.start[:month] > @start[:month] && o.end[:month] == @end[:month] && o.end[:day] < MONTH_END_DAY[o.end[:month]-1]) ||
                  (o.start[:day] >= 1 && o.end[:day] < MONTH_END_DAY[o.end[:month]-1]) ||
                  (o.start[:day] > 1 && o.end[:day] <= MONTH_END_DAY[o.end[:month]-1]))
                  result = true
                end
              end
            end
          else
            if @end.nil?
              if @start[:month] == o.start[:month]
                result = true
              end
            else
              if o.start[:month] >= @start[:month] && o.start[:month] <= @end[:month]
                result = true
              end
            end
          end
        end
      end
      return result
    end

    def equals(o)
      return false unless o.instance_of?(OpeningHoursConverter::WideInterval)
      return @type == "always" if o.type == "always"

      result = false
      case @type
      when "always"
        result = o.start.nil?
      when "day"
        result = ((o.type == "day" &&
          o.start[:month] == @start[:month] &&
          o.start[:day] == @start[:day] &&
          ((o.end.nil? && @end.nil?) ||
          (!o.end.nil? && !@end.nil? &&
            o.end[:month] == @end[:month] &&
            o.end[:day] == @end[:day]))) ||
          (o.type == "month" &&
          o.start[:month] == @start[:month] &&
          (o.is_full_month? && is_full_month?) ||
          (!o.end.nil? && !@end.nil? &&
            o.end[:month] == @end[:month] &&
            o.ends_month? && ends_month?)))
      when "week"
        result = (o.type == "week" &&
          o.start[:week] == @start[:week] &&
          (o.end == @end ||
            (!o.end.nil? && !@end.nil? && o.end[:week] == @end[:week])))
      when "month"
        result = (o.type == "day" &&
          o.start[:month] == @start[:month] &&
          (o.starts_month? &&
          (!o.end.nil? && @end.nil? && o.end[:month] == @start[:month] && o.ends_month?) ||
          (!o.end.nil? && !@end.nil? && o.end[:month] == @end[:month] && o.ends_month?))) ||
          (o.type == "month" &&
          o.start[:month] == @start[:month] &&
          ((o.end.nil? && @end.nil?) ||
          (!o.end.nil? && !@end.nil? && o.end[:month] == @end[:month])))
      end
      result
    end
  end
end
