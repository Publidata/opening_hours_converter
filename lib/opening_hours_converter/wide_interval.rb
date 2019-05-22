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
      result = ''

      case @type
      when 'day'
        result = "#{@start[:year].nil? ? '' : "#{@start[:year]} "}#{OSM_MONTHS[@start[:month] - 1]} #{@start[:day] < 10 ? '0' : ''}#{@start[:day]}"
        if !@end.nil?
          if @start[:month] == @end[:month]
            result += "-#{@start[:year] == @end[:year] ? '' : "#{@end[:year]} "}#{@end[:day] < 10 ? '0' : ''}#{@end[:day]}"
          else
            result += "-#{@start[:year] == @end[:year] ? '' : "#{@end[:year]} "}#{OSM_MONTHS[@end[:month] - 1]} #{@end[:day] < 10 ? '0' : ''}#{@end[:day]}"
          end
        end
      when 'month'
        result = "#{@start[:year].nil? ? '' : "#{@start[:year]} "}#{OSM_MONTHS[@start[:month] - 1]}"
        if !@end.nil?
          result += "-#{@start[:year] == @end[:year] ? '' : "#{@end[:year]} "}#{OSM_MONTHS[@end[:month] - 1]}"
        end
      when 'year'
        result = (@start[:year]).to_s
        result += "-#{@end[:year]}" if !@end.nil?
      when 'holiday'
        result = "#{@start[:year].nil? ? '' : "#{@start[:year]} "}PH"
        if !@end.nil?
          result = "#{@start[:year]}#{@start[:year] == @end[:year] ? '' : "-#{@end[:year]}"} PH"
        end
      when 'always'
        result = ''
      else
        result = ''
      end
      result
    end

    def get_time_for_humans
      result = ''

      case @type
      when 'day'
        if !@end.nil?
          if @start[:year] && !@end[:year] || @start[:year] && @start[:year] == @end[:year]
            result = "du #{@start[:day]} #{IRL_MONTHS[@start[:month] - 1]} #{@start[:year]} au #{@end[:day]} #{IRL_MONTHS[@end[:month] - 1]} #{@start[:year]}"
          elsif @start[:year] && @end[:year] && @start[:year] != @end[:year]
            result = "du #{@start[:day]} #{IRL_MONTHS[@start[:month] - 1]} #{@start[:year]} au #{@end[:day]} #{IRL_MONTHS[@end[:month] - 1]} #{@end[:year]}"
          elsif @start[:month] != @end[:month]
            result = "du #{@start[:day]} #{IRL_MONTHS[@start[:month] - 1]} au #{@end[:day]} #{IRL_MONTHS[@end[:month] - 1]}"
          else
            result = "le #{@start[:day]} #{IRL_MONTHS[@start[:month] - 1]}"
          end
        else
          result = "le #{@start[:day]} #{IRL_MONTHS[@start[:month] - 1]} #{@start[:year] || ''}"
        end
      when 'month'
        if !@end.nil?
          if @start[:year] && !@end[:year] || @start[:year] && @start[:year] == @end[:year]
            result = "de #{IRL_MONTHS[@start[:month] - 1]} #{@start[:year]} à #{IRL_MONTHS[@end[:month] - 1]} #{@start[:year]}"
          elsif @start[:year] && @end[:year] && @start[:year] != @end[:year]
            result = "de #{IRL_MONTHS[@start[:month] - 1]} #{@start[:year]} à #{IRL_MONTHS[@end[:month] - 1]} #{@end[:year]}"
          else
            result = "de #{IRL_MONTHS[@start[:month] - 1]} à #{IRL_MONTHS[@end[:month] - 1]}"
          end
        else
          result = "#{IRL_MONTHS[@start[:month] - 1]}#{@start[:year] ? " #{@start[:year]}" : ''}"
        end
      when 'year'
        result = if !@end.nil?
                   "de #{@start[:year]} à #{@end[:year]}"
                 else
                   (@start[:year]).to_s
                 end
      when 'holiday'
        result = if !@end.nil?
                   if !@start[:year]
                     'jours fériés'
                   else
                     "les jours fériés de #{@start[:year]} à #{@end[:year]}"
                   end
                 elsif !@start[:year]
                   'jours fériés'
                 else
                   "les jours fériés de #{@start[:year]}"
                 end
      when 'always'
        result = 'tout le temps'
      end
      result
    end

    def day(start_day, start_month, start_year = nil, end_day = nil, end_month = nil, end_year = nil)
      if start_day.nil? || start_month.nil?
        raise(ArgumentError, 'start_day, start_month and start_year are required')
      end
      @start = { day: start_day, month: start_month, year: start_year }
      if !end_day.nil? && !end_month.nil? && (end_day != start_day || end_month != start_month || (!start_year.nil? && !end_year.nil? && end_year != start_year))
        @end = { day: end_day, month: end_month, year: end_year }
      end
      @type = 'day'
      self
    end

    def date_time(start_date, end_date = nil)
      raise(ArgumentError, 'start_date is required') if start_date.nil?
      raise(ArgumentError, 'start_date is not a DateTime') if !start_date.instance_of?(DateTime)
      raise(ArgumentError, 'end_date is not a DateTime') if !end_date.instance_of?(DateTime)
      @start = { day: start_date.day, month: start_date.month, year: start_date.year }
      if !end_date.nil? && end_date != start_date
        @end = { day: end_date.day, month: end_date.month, year: end_date.year }
      end
      @type = 'day'
      self
    end

    def month(start_month, start_year = nil, end_month = nil, end_year = nil)
      raise(ArgumentError, 'start_month is required') if start_month.nil?
      @start = { month: start_month, year: start_year }
      if !end_month.nil? && (end_month != start_month || (!start_year.nil? && !end_year.nil? && end_year != start_year))
        @end = { month: end_month, year: end_year }
      end
      @type = 'month'
      self
    end

    def year(start_year, end_year = nil)
      raise(ArgumentError, 'start_year is required') if start_year.nil?
      @start = { year: start_year }
      @end = { year: end_year } unless end_year.nil? || end_year == start_year
      @type = 'year'
      self
    end

    def holiday(holiday, start_year = nil, end_year = nil)
      if holiday.nil? || holiday != 'PH'
        raise(ArgumentError, 'holiday is required and can only be PH')
      end
      @start = { holiday: holiday, year: start_year }
      @end = { holiday: holiday, year: end_year } unless end_year.nil? || end_year == start_year
      @type = 'holiday'
      self
    end

    def always
      @start = nil
      @end = nil
      @type = 'always'
      self
    end

    def is_full_month?
      return true if @type == 'month' && @end.nil?
      return false if @end.nil?
      return false if !@start[:year].nil? && !@end[:year].nil? && @start[:year] != @end[:year]
      if @type == 'day'
        @start[:day] == 1 && !@end.nil? && @start[:month] == @end[:month] &&
          !@end[:day].nil? && @end[:day] == MONTH_END_DAY[@end[:month] - 1]
      else
        false
      end
    end

    def starts_month?
      @type == 'month' || @type == 'always' || @type == 'year' || (@type == 'day' && @start[:day] == 1)
    end

    def ends_month?
      @type == 'month' || @type == 'always' || @type == 'year' || (@type == 'day' && !@end.nil? && @end[:day] == MONTH_END_DAY[@end[:month] - 1])
    end

    def is_full_year?
      return true if @end.nil? && type == 'year'
      return false if @end.nil?
      return false if !@start[:year].nil? && !@end[:year].nil? && @start[:year] != @end[:year]
      if @type == 'month'
        @start[:month] == 1 && !@end.nil? && @start[:year] == @end[:year] && !@end[:month].nil? && @end[:month] == 12
      elsif @type == 'day'
        @start[:day] == 1 && @start[:month] == 1 && !@end.nil? && !@start[:year].nil? && !@end[:year].nil? && @start[:year] == @end[:year] &&
          !@end[:month].nil? && @end[:month] == 12 && !@end[:day].nil? && @end[:day] == MONTH_END_DAY[@end[:month] - 1]
      else
        false
      end
    end

    def starts_year?
      @type == 'year' || @type == 'always' || (@type == 'day' && @start[:day] == 1 && @start[:month] == 1) || (@type == 'month' && @start[:month] == 1)
    end

    def ends_year?
      @type == 'year' || @type == 'always' || (@type == 'day' && !@end.nil? && @end[:month] == 12 && @end[:day] == MONTH_END_DAY[@end[:month] - 1])
    end

    def contains?(o)
      return false if o.type == 'always'
      result = false
      if equals(o)
        result = false
      elsif @type == 'always'
        result = true
      else
        my = to_day
        o = o.to_day
        result = has_superior_or_equal_start_day?(my, o) && has_inferior_or_equal_end_day?(my, o)
      end
      result
    end

    def touch?(o)
      return true if contains?(o)
      return true if o.type == 'always' || @type == 'always'
      result = false
      if equals(o)
        result = true
      else
        my = to_day
        o = o.to_day

        result = ((my_start_is_before_o_end?(my, o) && my_start_is_after_o_start?(my, o)) ||
          (my_end_is_before_o_end?(my, o) && my_end_is_after_o_start?(my, o))) ||
                 ((my_start_is_before_o_end?(o, my) && my_start_is_after_o_start?(o, my)) ||
                   (my_end_is_before_o_end?(o, my) && my_end_is_after_o_start?(o, my)))
      end
      result
    end

    def my_start_is_after_o_start?(my, o)
      result = false
      if has_start_year?(o) && has_start_year?(my)
        result = o.start[:year] < my.start[:year] || (o.start[:year] == my.start[:year] &&
          my_start_day_is_after_o_start_day?(my, o))
      elsif !has_start_year?(o) && !has_start_year?(my)
        result = my_start_day_is_after_o_start_day?(my, o)
      end
      result
    end

    def my_start_is_before_o_start?(my, o)
      result = false
      if has_start_year?(o) && has_start_year?(my)
        result = o.start[:year] > my.start[:year] || (o.start[:year] == my.start[:year] &&
          my_start_day_is_before_o_start_day?(my, o))
      elsif !has_start_year?(o) && !has_start_year?(my)
        result = my_start_day_is_before_o_start_day?(my, o)
      end
      result
    end

    def my_end_is_before_o_end?(my, o)
      result = false
      if !my.end.nil? && !o.end.nil?
        if has_end_year?(o) && has_end_year?(my)
          result = o.end[:year] > my.end[:year] || (o.end[:year] == my.end[:year] &&
            my_end_day_is_before_o_end_day?(my, o))
        elsif !has_end_year?(o) && !has_end_year?(my)
          result = my_end_day_is_before_o_end_day?(my, o)
        end
      else
        my_start_is_before_o_start?(my, o)
      end
      result
    end

    def my_start_is_before_o_end?(my, o)
      result = false
      if has_start_year?(o) && has_start_year?(my)
        result = if o.end
                   o.end[:year] > my.start[:year] || (o.end[:year] == my.start[:year] &&
                     my_start_day_is_before_o_end_day?(my, o))
                 else
                   o.start[:year] > my.start[:year] || (o.start[:year] == my.start[:year] &&
                     my_start_day_is_before_o_end_day?(my, o))
                 end
      elsif !has_start_year?(o) && !has_start_year?(my)
        result = my_start_day_is_before_o_end_day?(my, o)
      end
      result
    end

    def my_end_is_after_o_start?(my, o)
      result = false
      if has_start_year?(o) && has_start_year?(my)
        result = if my.end
                   o.start[:year] < my.end[:year] || (o.start[:year] == my.end[:year] &&
                     my_end_day_is_after_o_start_day?(my, o))
                 else
                   o.start[:year] < my.start[:year] || (o.start[:year] == my.start[:year] &&
                     my_end_day_is_after_o_start_day?(my, o))
                 end
      elsif !has_start_year?(o) && !has_start_year?(my)
        result = my_end_day_is_after_o_start_day?(my, o)
      end
      result
    end

    def my_start_day_is_after_o_start_day?(my, o)
      (o.start[:month] < my.start[:month] ||
        (o.start[:month] == my.start[:month] &&
          o.start[:day] <= my.start[:day]))
    end

    def my_start_day_is_before_o_start_day?(my, o)
      (o.start[:month] > my.start[:month] ||
        (o.start[:month] == my.start[:month] &&
          o.start[:day] >= my.start[:day]))
    end

    def my_start_day_is_before_o_end_day?(my, o)
      if !o.end.nil?
        (o.end[:month] > my.start[:month] ||
          (o.end[:month] == my.start[:month] &&
            o.end[:day] >= my.start[:day]))
      else
        (o.start[:month] > my.start[:month] ||
          (o.start[:month] == my.start[:month] &&
            o.start[:day] >= my.start[:day]))
      end
    end

    def my_start_day_is_after_o_end_day?(my, o)
      if !o.end.nil?
        (o.end[:month] < my.start[:month] ||
          (o.end[:month] == my.start[:month] &&
            o.end[:day] <= my.start[:day]))
      else
        (o.start[:month] < my.start[:month] ||
          (o.start[:month] == my.start[:month] &&
            o.start[:day] <= my.start[:day]))
      end
    end

    def my_end_day_is_before_o_end_day?(my, o)
      if !o.end.nil? && !my.end.nil?
        (o.end[:month] > my.end[:month] ||
          (o.end[:month] == my.end[:month] &&
            o.end[:day] >= my.end[:day]))
      elsif o.end && my.end
        (o.start[:month] > my.start[:month] ||
          (o.start[:month] == my.start[:month] &&
            o.start[:day] >= my.start[:day]))
      elsif o.end
        (o.end[:month] > my.start[:month] ||
          (o.end[:month] == my.start[:month] &&
            o.end[:day] >= my.start[:day]))
      else
        (o.start[:month] > my.end[:month] ||
          (o.start[:month] == my.end[:month] &&
            o.start[:day] >= my.end[:day]))
      end
    end

    def my_end_day_is_after_o_start_day?(my, o)
      if !my.end.nil?
        (o.start[:month] < my.end[:month] ||
          (o.start[:month] == my.end[:month] &&
            o.start[:day] <= my.end[:day]))
      else
        (o.start[:month] < my.start[:month] ||
          (o.start[:month] == my.start[:month] &&
            o.start[:day] <= my.start[:day]))
      end
    end

    def my_end_day_is_before_o_start_day?(my, o)
      if !my.end.nil?
        (o.start[:month] < my.end[:month] ||
          (o.start[:month] == my.end[:month] &&
            o.start[:day] <= my.end[:day]))
      else
        (o.start[:month] < my.start[:month] ||
          (o.start[:month] == my.start[:month] &&
            o.start[:day] <= my.start[:day]))
      end
    end

    def has_superior_start_month?(my, o)
      (o.start[:month] > my.start[:month] ||
        (o.start[:month] == my.start[:month] &&
          o.start[:day] >= my.start[:day]))
    end

    def has_superior_or_equal_start_day?(my, o)
      result = false
      if has_start_year?(o) && has_start_year?(my)
        result = o.start[:year] > my.start[:year] || (o.start[:year] == my.start[:year] && has_superior_start_month?(my, o))
      elsif !has_start_year?(my)
        result = has_superior_start_month?(my, o)
      end
      result
    end

    def has_inferior_or_equal_end_day?(my, o)
      result = false
      return false if my.end.nil?
      if !o.end.nil?
        if has_end_year?(o) && has_end_year?(my)
          result = o.end[:year] < my.end[:year] || (o.end[:year] == my.end[:year] && has_inferior_end_month?(my, o))
        elsif !has_end_year?(my)
          result = has_inferior_end_month?(my, o)
        end
      else
        if has_start_year?(o) && has_end_year?(my)
          result = o.start[:year] < my.end[:year] || (o.start[:year] == my.end[:year] && has_inferior_end_month?(my, o))
        elsif !has_end_year?(my)
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
      return @type == 'always' if o.type == 'always'
      if @type == 'holiday'
        return (o.type == 'holiday' && (@start[:year] == o.start[:year]) &&
          (@end.nil? && o.end.nil? || (@end && o.end && @end[:year] == o.end[:year])))
      end
      return false if @type == 'always'
      self_to_day = to_day
      o_to_day = o.to_day
      (self_to_day.start[:year] == o_to_day.start[:year] &&
        self_to_day.start[:month] == o_to_day.start[:month] &&
        self_to_day.start[:day] == o_to_day.start[:day]) &&
        ((self_to_day.end.nil? && o_to_day.end.nil?) || ((!self_to_day.end.nil? && !o_to_day.end.nil?) &&
          (self_to_day.end[:year] == o_to_day.end[:year] &&
            self_to_day.end[:month] == o_to_day.end[:month] &&
            self_to_day.end[:day] == o_to_day.end[:day])))
    end

    def width
      return Float::INFINITY if @type == 'always'
      in_day = to_day
      days_count = 0
      if in_day.end
        if in_day.start[:year] && in_day.end[:year]
          if in_day.start[:year] != in_day.end[:year]
            for year in in_day.start[:year]..in_day.end[:year]
              if year == in_day.start[:year]
                for month in in_day.start[:month]..12
                  days_count += if month == in_day.start[:month]
                                  MONTH_END_DAY[month - 1] - in_day.start[:day] + 1
                                else
                                  MONTH_END_DAY[month - 1]
                                end
                end
              elsif year == in_day.end[:year]
                for month in 1..in_day.end[:month]
                  days_count += if month == in_day.end[:month]
                                  in_day.end[:day]
                                else
                                  MONTH_END_DAY[month - 1]
                                end
                end
              else
                for month in 1..12
                  days_count += MONTH_END_DAY[month - 1]
                end
              end
            end
          else
            if in_day.start[:month] == in_day.end[:month]
              days_count += in_day.end[:day] - in_day.start[:day] + 1
            else
              for month in in_day.start[:month]..in_day.end[:month]
                days_count += if month == in_day.end[:month]
                                in_day.end[:day]
                              elsif month == in_day.start[:month]
                                MONTH_END_DAY[month - 1] - in_day.start[:day] + 1
                              else
                                MONTH_END_DAY[month - 1]
                              end
              end
            end
          end
        else
          if in_day.start[:month] == in_day.end[:month]
            days_count += in_day.end[:day] - in_day.start[:day] + 1
          elsif in_day.start[:month] > in_day.end[:month]
            for month in in_day.start[:month]..12
              days_count += if month == in_day.start[:month]
                              MONTH_END_DAY[month - 1] - in_day.start[:day] + 1
                            else
                              MONTH_END_DAY[month - 1]
                            end
            end
            for month in 1..in_day.end[:month]
              days_count += if month == in_day.end[:month]
                              in_day.end[:day]
                            else
                              MONTH_END_DAY[month - 1]
                            end
            end
          else
            for month in in_day.start[:month]..in_day.end[:month]
              days_count += if month == in_day.end[:month]
                              in_day.end[:day]
                            elsif month == in_day.start[:month]
                              MONTH_END_DAY[month - 1] - in_day.start[:day] + 1
                            else
                              MONTH_END_DAY[month - 1]
                            end
            end
          end
        end
        return days_count
      else
        return 1
      end
    end

    def to_day
      case @type
      when 'day'
        if @end.nil?
          OpeningHoursConverter::WideInterval.new.day(@start[:day], @start[:month], @start[:year])
        else
          OpeningHoursConverter::WideInterval.new.day(@start[:day], @start[:month], @start[:year], @end[:day], @end[:month], @end[:year])
        end
      when 'month'
        if @end.nil?
          OpeningHoursConverter::WideInterval.new.day(1, @start[:month], @start[:year], MONTH_END_DAY[@start[:month] - 1], @start[:month], @start[:year])
        else
          OpeningHoursConverter::WideInterval.new.day(1, @start[:month], @start[:year], MONTH_END_DAY[@end[:month] - 1], @end[:month], @end[:year])
        end
      when 'year'
        if @end.nil?
          OpeningHoursConverter::WideInterval.new.day(1, 1, @start[:year], 31, 12, @start[:year])
        else
          OpeningHoursConverter::WideInterval.new.day(1, 1, @start[:year], 31, 12, @end[:year])
        end
      end
    end
  end
end
