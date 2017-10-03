require 'date'
# require 'pry'
require 'pry-nav'

DAYS = {
  LUNDI: 0,
  MARDI: 1,
  MERCREDI: 2,
  JEUDI: 3,
  VENDREDI: 4,
  SAMEDI: 5,
  DIMANCHE: 6
}
OSM_DAYS = [ "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su" ]
IRL_DAYS = [ "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche" ]
OSM_MONTHS = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
IRL_MONTHS = [ "Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre",
  "Octobre", "Novembre", "Décembre" ]
MONTH_END_DAY = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
MINUTES_MAX = 1440
DAYS_MAX = 6
YEAR_DAYS_MAX = 365

class Array
  def equals(array)
    return false if !array.instance_of?(Array)
    return false if array.length != length
    each_with_index do |val, i|
      if val.instance_of?(Array)
        return false unless val.equals(array[i])
      end
      return false if val != array[i]
    end
    return true
  end
end

class Interval
  attr_accessor :day_start, :day_end, :start, :end

  def initialize(day_start, min_start, day_end=0, min_end=0)
    @day_start = day_start
    @day_end = day_end
    @start = min_start
    @end = min_end

    if @day_end == 0 && @end == 0
      @day_end = DAYS_MAX
      @end = MINUTES_MAX
    end
  end
end

class WideInterval
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
    return false unless o.instance_of?(WideInterval)
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

class Day
  attr_accessor :intervals, :next_interval

  def initialize
    @intervals = []
    @next_interval = 0
  end

  def get_as_minute_array
    minute_array = Array.new(MINUTES_MAX + 1, false)

    @intervals.each do |interval|
      if !interval.nil?
        start_minute = nil
        end_minute = nil

        if interval.day_start == interval.day_end || interval.day_end == DAYS_MAX && interval.end == MINUTES_MAX
          start_minute = interval.start
          end_minute = interval.end
        end

        unless start_minute.nil? && end_minute.nil?
          for minute in start_minute..end_minute
            minute_array[minute] = true
          end
        else
          raise "Invalid interval #{interval.inspect}"
        end
      end
    end

    minute_array
  end

  def get_intervals(clean=false)
    if clean
      minute_array = get_as_minute_array
      intervals = []
      minute_start = -1
      minute_end = nil
      minute_array.each_with_index do |minute, i|
        if i == 0
          if minute
            minute_start = i
          end
        elsif i == minute_array.length - 1
          if minute
            intervals << Interval.new(0, minute_start, 0, i - 1)
            minute_start = -1
          end
        else
          if minute && minute_start < 0
            minute_start = i
          elsif !minute && minute_start >= 0
            intervals << Interval.new(0, minute_start, 0, i - 1)
            minute_start = -1
          end
        end
      end
      intervals
    else
      @intervals
    end
  end

  def add_interval(interval)
    @intervals[@next_interval] = interval
    @next_interval += 1
    return @next_interval - 1
  end

  def edit_interval(id, interval)
    @intervals[id] = interval
  end

  def remove_interval(id)
    @intervals[id] = nil
  end

  def clear_intervals
    @intervals = []
  end

  def copy_intervals(intervals)
    @intervals = []
    intervals.each do |interval|
      if !interval.nil? && interval.day_start == 0 && interval.day_end == 0
        @intervals << interval.dup
      end
    end
    @intervals = get_intervals(true)
  end

  def same_as?(day)
    day.get_as_minute_array.equals(get_as_minute_array)
  end
end


class Week
  attr_accessor :intervals, :next_interval

  def initialize
    @intervals = []
    @next_interval = 0
  end

  def get_as_minute_array
    minute_array = Array.new(DAYS_MAX + 1) { Array.new(MINUTES_MAX + 1, false) }

    @intervals.each do |interval|
      if !interval.nil?
        for day in interval.day_start..interval.day_end
          start_minute = (day == interval.day_start) ? interval.start : 0
          end_minute = (day == interval.day_end) ? interval.end : MINUTES_MAX
          if start_minute && end_minute
            for minute in start_minute..end_minute
              minute_array[day][minute] = true
            end
          end
        end
      end
    end
    minute_array
  end

  def get_intervals(clean=false)
    if clean
      minute_array = get_as_minute_array
      intervals = []
      day_start = -1
      minute_start = -1
      minute_end = nil


      minute_array.each_with_index do |day, day_index|
        day.each_with_index do |minute, minute_index|
          if day_index == 0 && minute_index == 0
            if minute
              day_start = day_index
              minute_start = minute_index
            end
          elsif day_index == DAYS_MAX && minute_index == day.length - 1
            if day_start >= 0 && minute
              intervals << Interval.new(day_start, minute_start, day_index, minute_index)
            end
          else
            if minute && day_start < 0
              day_start = day_index
              minute_start = minute_index
            elsif !minute && day_start >= 0
              if minute_index == 0
                intervals << Interval.new(day_start, minute_start, day_index - 1, MINUTES_MAX)
              else
                intervals << Interval.new(day_start, minute_start, day_index, minute_index - 1)
              end
              day_start = -1
              minute_start = - 1
            end
          end
        end
      end
      return intervals
    else
      return @intervals
    end
  end

  def get_intervals_diff(week)
    self_minutes_array = get_as_minute_array
    other_minutes_array = week.get_as_minute_array

    intervals = { open: [], closed: [] }
    day_start = -1
    min_start = -1


    for d in 0..DAYS_MAX
      diff_day = false
      m = 0
      intervals_length = intervals[:open].length
      while m <= MINUTES_MAX
        # Copy entire day
        if diff_day
          # first minute of monday
          if d == 0 && m == 0
            if self_minutes_array[d][m]
              day_start = d
              min_start = m
            end
          # last minute of sunday
          elsif d == DAYS_MAX && m == MINUTES_MAX
            if day_start >= 0 && self_minutes_array[d][m]
              intervals[:open] << Interval.new(day_start, min_start, d, m)
            end
          #  other days and minutes
          else
            # new interval
            if self_minutes_array[d][m] && day_start < 0
              day_start = d
              min_start = m
            # end interval
            elsif !self_minutes_array[d][m] && day_start >= 0
              if m == 0
                intervals[:open] << Interval.new(day_start, min_start, d - 1, MINUTES_MAX)
              else
                intervals[:open] << Interval.new(day_start, min_start, d, m - 1)
              end
              day_start = -1
              min_start = -1
            end
          end
          m += 1
        # check diff
        else
          diff_day = self_minutes_array[d][m] ? !other_minutes_array[d][m] : other_minutes_array[d][m]
          if diff_day
            m = 0
          else
            m += 1
          end
        end
      end
      if !diff_day && day_start > -1
        intervals[:open] << Interval.new(day_start, min_start, d-1, MINUTES_MAX)
        day_start = -1
        min_start = -1
      end
      if diff_day && day_start == -1 && intervals_length == intervals[:open].length
        if intervals[:closed].length > 0 && intervals[:closed][intervals[:closed].length - 1].day_end == d - 1
          intervals[:closed][intervals[:closed].length - 1] = Interval.new(intervals[:closed][intervals[:closed].length - 1].day_start, 0, d, MINUTES_MAX)
        else
          intervals[:closed] << Interval.new(d, 0, d, MINUTES_MAX)
        end
      end
    end
    return intervals
  end

  def add_interval(interval)
    @intervals[@next_interval] = interval
    @next_interval += 1
    return @next_interval - 1
  end

  def edit_interval(id, interval)
    @intervals[id] = interval
  end

  def remove_interval(id)
    @intervals[id] = nil
  end

  def remove_intervals_during_day(day)
    @intervals.each_with_index do |interval, i|
      unless interval.nil?
        if interval.day_start <= day && interval.day_end >= day
          day_diff = interval.day_end - interval.day_start

          if day_diff > 1 || day_diff == 0 || interval.day_start == day || interval.start <= interval.end
            if interval.day_end - interval.day_start >= 1 && interval.start <= interval.end
              if interval.day_start < day
                add_interval(Interval.new(interval.day_start, interval.start, day - 1, 24*60))
              end
              if interval.day_end > day
                add_interval(Interval.new(day + 1, 0, interval.day_end, interval.end))
              end
            end
            remove_interval(i)
          end
        end
      end
    end
  end

  def clear_intervals
    @intervals = []
  end

  def copy_intervals(intervals)
    @intervals = []
    intervals.each do |interval|
      unless interval.nil?
        @intervals << interval.dup
      end
    end
  end

  def same_as?(week)
    week.get_as_minute_array.equals(get_as_minute_array)
  end
end

class DateRange
  attr_accessor :wide_interval, :typical

  def initialize(w=nil)
    @wide_interval = nil
    @typical = nil
    update_range(w)
  end

  def defines_typical_day?
    @typical.instance_of?(Day)
  end

  def defines_typical_week?
    @typical.instance_of?(Week)
  end

  def update_range(wide)
    @wide_interval = !wide.nil? ? wide : WideInterval.new.always

    if @typical.nil?
      case @wide_interval.type
      when "day"
        if @wide_interval.end.nil?
          @typical = Day.new
        else
          @typical = Week.new
        end
      when "week"
        @typical = Week.new
      when "month"
        @typical = Week.new
      when "always"
        @typical = Week.new
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

class OpeningHoursTime
  attr_accessor :start, :end

  def initialize(minute_start=nil, minute_end=nil)
    @start = minute_start
    unless minute_start == minute_end
      @end = minute_end
    end
  end

  def get
    return "off" if (@start.nil? && @end.nil?)
    "#{time_string(@start)}#{@end.nil? ? "" : "-#{time_string(@end)}"}"
  end

  def equals(t)
    @start == t.start && @end == t.end
  end

  def time_string(minutes)
    fminutes = minutes.to_f
    h = (fminutes/60).floor.to_i
    m = (fminutes%60).to_i
    "#{h < 10 ? "0" : ""}#{h}:#{m < 10 ? "0" : ""}#{m}"
  end
end


class OpeningHoursDate
  attr_accessor :wide_type, :wide, :weekdays, :weekdays_over

  def initialize(wide, wide_type, weekdays)
    if wide.nil? || wide_type.nil? || weekdays.nil?
      raise ArgumentError
    end

    @wide = wide
    @wide_type = wide_type
    @weekdays = weekdays.sort
    @weekdays_over = []
  end

  def get_weekdays

    result = ""
    wd = @weekdays.concat(@weekdays_over).sort.uniq

    if wd.length > 0 && wd.include?(6) && wd.include?(0) && (wd.include?(5) || wd.include?(1))
      start_we = 6
      i = wd.length - 2
      stop_looking = false

      while !stop_looking && i >= 0
        if wd[i] == wd[i+1] - 1
          start_we = wd[i]
          i -= 1
        else
          stop_looking = true
        end
      end

      i = 1
      stop_looking = false
      end_we = 0

      while !stop_looking && i < wd.length
        if wd[i-1] == wd[i] - 1
          end_we = wd[i]
          i += 1
        else
          stop_looking = true
        end
      end

      length = 7 - start_we + end_we + 1

      if length >= 3 && start_we > end_we
        if result.length > 0
          result += ","
        end
        result += "#{OSM_DAYS[start_we]}-#{OSM_DAYS[end_we]}"

        j=0
        while j < wd.length
          if wd[j] <= end_we || wd[j] >= start_we
            wd.slice!(j, 1)
          else
            j+=1
          end
        end
      end
    end

    if wd.length > 1 || (wd.length == 1 && wd[0] != -1)
      result += result.length > 0 ? ",#{OSM_DAYS[wd[0]]}" : OSM_DAYS[wd[0]]
      first_in_row = wd[0]
      for i in 1...wd.length
        if wd[i-1] != wd[i] - 1
          if first_in_row != wd[i-1]
            if wd[i-1] - first_in_row == 1
              result += ",#{OSM_DAYS[wd[i-1]]}"
            else
              result += "-#{OSM_DAYS[wd[i-1]]}"
            end
          end
          result += ",#{OSM_DAYS[wd[i]]}"
          first_in_row = wd[i]
        elsif i == wd.length - 1
          if wd[i] - first_in_row == 1
            result += ",#{OSM_DAYS[wd[i]]}"
          else
            result += "-#{OSM_DAYS[wd[i]]}"
          end
        end
      end
    end

    if result == "Mo-Su"
      result = ""
    end
    return result
  end

  def add_weekday(weekday)
    if !@weekdays.include?(weekday) && !@weekdays_over.include?(weekday)
      @weekdays << weekday
      @weekdays.sort!
    end
  end

  def add_overwritten_weekday(weekday)
    unless @weekdays_over.include?(weekday) && @weekdays_over.include?(weekday)
      @weekdays_over << weekday
      @weekdays_over.sort!
    end
  end

  def same_kind_as?(date)
    @wide_type == date.wide_type && date.same_weekdays?(@weekdays)
  end

  def same_weekdays?(weekdays)
    weekdays.equals(@weekdays)
  end

  def equals(o)
    o.instance_of?(OpeningHoursDate) && @wide_type == o.wide_type && @wide == o.wide && o.same_weekdays?(@weekdays)
  end
end

#DONE without ph
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

    result.strip
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

  def add_date(date)
    if date.nil? || !date.instance_of?(OpeningHoursDate)
      raise ArgumentError
    end

    if @date.length == 0 || @date.first.wide_type != "always" && @date.first.same_kind_as?(date)
      @date << date
    else
      if @date.length != 1 || @date.first.wide_type != "always" || !@date.first.same_weekdays?(date.weekdays)
        raise ArgumentError, "This date can't be added to this rule"
      end
    end
  end

  def add_time(time)
    if (@time.length == 0 || @time[0].get != "off") && !@time.include?(time)
      @time << time
    else
      raise ArgumentError, "This time can't be added to this rule"
    end
  end
end

class OpeningHoursBuilder
  def build(date_ranges)
    rules = []

    oh_rules = nil
    oh_rule_added = nil
    range_general = nil
    range_general_for = nil

    date_ranges.each_with_index do |date_range, date_range_index|
      if !date_range.nil?
        range_general = nil
        range_general_for = nil
        range_general_id = date_range_index - 1
        while range_general_id >= 0 && range_general.nil?
          if !date_range.nil?
            general_for = date_ranges[range_general_id].is_general_for?(date_range)
            if date_ranges[range_general_id].has_same_typical?(date_range) && (date_ranges[range_general_id].wide_interval.equals(date_range.wide_interval) || general_for)
              range_general = range_general_id
            elsif general_for && date_ranges[range_general_id].defines_typical_week? && date_range.defines_typical_week?
              range_general_for = range_general_id
            end
          end
          range_general_id -= 1
        end

        if date_range_index == 0 || range_general.nil?
          if date_range.defines_typical_week?
            if !range_general_for.nil?
              oh_rules = build_week_diff(date_range, date_ranges[range_general_for])
            else
              oh_rules = build_week(date_range)
            end
          else
            oh_rules = build_day(date_range)
          end
        end

        oh_rule_index = 0

        while oh_rule_index < oh_rules.length
          oh_rule = oh_rules[oh_rule_index]
          oh_rule_added = false
          rule_index = 0

          while !oh_rule_added && rule_index < rules.length
            if rules[rule_index].same_time?(oh_rule)
              begin
                for date_id in 0...oh_rule.date.length
                  rules[rule_index].add_date(oh_rule.date[date_id])
                end
                oh_rule_added = true
              rescue Exception => e
                puts e
                # if(
                #   ohrule.getDate()[0].getWideType() == "holiday"
                #   && ohrule.getDate()[0].getWideValue() == "PH"
                #   && rules[ruleId].getDate()[0].getWideType() == "always"
                # ) {
                #   rules[ruleId].addPhWeekday();
                #   ohruleAdded = true;
                # }
                # else if(
                #   rules[ruleId].getDate()[0].getWideType() == "holiday"
                #   && rules[ruleId].getDate()[0].getWideValue() == "PH"
                #   && ohrule.getDate()[0].getWideType() == "always"
                # ) {
                #   ohrule.addPhWeekday();
                #   rules[ruleId] = ohrule;
                #   ohruleAdded = true;
                # }
                # else {
                #   ruleId++;
                # }
                rule_index += 1
              end
            else
              rule_index+=1
            end

          end

          if !oh_rule_added
            rules << oh_rule
          end

          if oh_rule_index == oh_rules.length - 1 && oh_rule.has_overwritten_weekday?
            oh_rule_over = OpeningHoursRule.new

            oh_rule.date.each do |date|
              oh_rule_over.add_date(OpeningHoursDate.new(date.wide, date.wide_type, date.weekdays_over))
            end
            oh_rule_over.add_time(OpeningHoursTime.new)
            oh_rules << oh_rule_over
            oh_rule_index += 1
          else
            oh_rule_index += 1
          end
        end
      end
    end


    result = ""
    rules.each_with_index do |rule, rule_index|
      if rule_index > 0
        result += "; "
      end
      result += rule.get
    end

    return result
  end

  def build_day(date_range)
    intervals = date_range.typical.get_intervals(true)

    rule = OpeningHoursRule.new
    date = OpeningHoursDate.new(date_range.wide_interval.get_time_selector, date_range.wide_interval.type, [-1])
    rule.add_date(date)

    intervals.each do |interval|
      if !interval.nil?
        rule.add_time(OpeningHoursTime.new(interval.start, interval.end))
      end
    end

    return [ rule ]
  end

  def build_week(date_range)
    result = []
    intervals = date_range.typical.get_intervals(true)
    time_intervals = create_time_intervals(date_range.wide_interval.get_time_selector, date_range.wide_interval.type, intervals)

    monday0 = time_intervals[0]
    sunday24 = time_intervals[1]
    days = time_intervals[2]

    days = night_monday_sunday(days, monday0, sunday24)


    days_status = Array.new(OSM_DAYS.length, 0)

    days.each_with_index do |day, index|
      if day.is_off? && days_status[index] == 0
        days_status[index] = 8
      elsif day.is_off? && days_status[index] < 0 && days_status[index] > -8
        days_status[index] = -8
        merged = false
        md_off = 0
        while !merged && md_off < index
          if days[md_off].is_off?
            days[md_off].add_weekday(index)
            merged = true
          else
            md_off += 1
          end
          if !merged
            result << days[index]
          end
        end
      elsif days_status[index] <= 0 && days_status[index] > -8
        days_status[index] = index + 1
        last_same_day = index
        same_day_count = 1

        for j in (index+1)...days.length do
          if day.same_time?(days[j])
            days_status[j] = index + 1
            day.add_weekday(j)
            last_same_day = j
            same_day_count += 1
          end
        end
        if same_day_count == 1
          result << day
        elsif same_day_count == 2
          day.add_weekday(last_same_day)
          result << day
        elsif same_day_count > 2
          for j in (index+1)...last_same_day do
            if days_status[j] == 0
              days_status[j] = -index -1
              day.add_overwritten_weekday(j)
            end
          end
          day.add_weekday(last_same_day)
          result << day
        end
      end
    end
    result = merge_days(result)

    return result
  end

  def build_week_diff(date_range, general_date_range)
    intervals = date_range.typical.get_intervals_diff(general_date_range.typical)

    time_intervals = create_time_intervals(
      date_range.wide_interval.get_time_selector,
      date_range.wide_interval.type,
      intervals[:open])
    monday0 = time_intervals[0]
    sunday24 = time_intervals[1]
    days = time_intervals[2]
    intervals[:closed].each do |interval|
      for i in interval.day_start..interval.day_end do
        days[i].add_time(OpeningHoursTime.new)
      end
    end

    days = night_monday_sunday(days, monday0, sunday24)

    days_status = Array.new(OSM_DAYS.length, 0)
    result = []

    days.each_with_index do |day, index|
      if day.is_off? && day.time.length == 1
        days_status[index] = -8
        merged = false
        md_off = 0

        while !merged && md_off < index
          if days[md_off].is_off? && days[md_off].time.length == 1
            days[md_off].add_weekday(index)
            merged = true
          else
            md_off += 1
          end
        end

        if !merged
          result << day
        end
      elsif day.is_off? && day.time.length == 0
        days_status[index] = 8
      elsif days_status[index] <= 0 && days_status[index] > -8
        days_status[index] = index + 1
        same_day_count = 1
        last_same_day = 1
        result << day

        for j in (index + 1)...days.length do
          if day.same_time?(days[j])
            days_status[j] = index + 1
            day.add_weekday(j)
            last_same_day = j
            same_day_count += 1
          end
        end

        if same_day_count == 1
          result << day
        elsif same_day_count == 2
          day.add_weekday(last_same_day)
          result << day
        elsif same_day_count > 2
          for j in (index + 1)...last_same_day do
            if days_status[j] == 0
              days_status[j] = -index - 1
              if days[j].time.length > 0
                day.add_overwritten_weekday(j)
              end
            end
          end
          day.add_weekday(last_same_day)
          result << day
        end

      end
    end
    result = merge_days(result)
    return result
  end

  def merge_days(rules)
    return rules if rules.length == 0
    result = []
    result << rules[0]
    dm = 0

    for d in 1...rules.length do
      date_merged = false
      dm = 0
      while !date_merged && dm < d
        if rules[dm].same_time?(rules[d])
          wds = rules[d].date[0].weekdays
          wds.each do |wd|
            rules[dm].add_weekday(wd)
          end
          date_merged = true
        end
        dm += 1
      end
      if !date_merged
        result << rules[d]
      end
    end

    return result
  end

  def create_time_intervals(time_selector, type, intervals)
    monday0 = -1
    sunday24 = -1

    days = []
    for i in 0...7 do
      days << OpeningHoursRule.new
      days[i].add_date(OpeningHoursDate.new(time_selector, type, [ i ]))
    end

    intervals.each do |interval|
      if !interval.nil?
        if interval.day_start == DAYS_MAX && interval.day_end == DAYS_MAX && interval.end == MINUTES_MAX
          sunday24 = interval.start
        end
        if interval.day_start == 0 && interval.day_end == 0 && interval.start == 0
          monday0 = interval.end
        end
        begin
          if interval.day_start == interval.day_end
            days[interval.day_start].add_time(OpeningHoursTime.new(interval.start, interval.end))
          elsif interval.day_end - interval.day_start == 1
            if interval.start > interval.end
              days[interval.day_start].add_time(OpeningHoursTime.new(interval.start, interval.end))
            else
              days[interval.day_start].add_time(OpeningHoursTime.new(interval.start, MINUTES_MAX))
              days[interval.day_end].add_time(OpeningHoursTime.new(0, interval.end))
            end
          else
            for j in interval.day_start..interval.day_end do
              if j == interval.day_start
                days[j].add_time(OpeningHoursTime.new(interval.start, MINUTES_MAX))
              elsif j == interval.day_end
                days[j].add_time(OpeningHoursTime.new(0, interval.end))
              else
                days[j].add_time(OpeningHoursTime.new(0, MINUTES_MAX))
              end
            end
          end
        rescue Exception => e
          puts e
        end
      end
    end

    return [ monday0, sunday24, days ]
  end

  def night_monday_sunday(days, monday0, sunday24)
    if monday0 >= 0 && sunday24 >= 0 && monday0 < sunday24
      days[0].time.sort! { |a, b| a.start <=> b.start }
      days[6].time.sort! { |a, b| a.start <=> b.start }

      days[6].time[days[6].time.length - 1] = OpeningHoursTime.new(sunday24, monday0)
      days[0].time.shift
    end
    return days
  end
end

class OpeningHoursParser
  attr_accessor :RGX_RULE_MODIFIER, :RGX_WEEK_KEY, :RGX_WEEK_VAL, :RGX_MONTH, :RGX_MONTHDAY, :RGX_TIME, :RGX_WEEKDAY, :RGX_HOLIDAY, :RGX_WD
  def initialize
    @RGX_RULE_MODIFIER = /^(open|closed|off)$/i
    @RGX_WEEK_KEY = /^week$/
    @RGX_WEEK_VAL = /^([01234]?[0-9]|5[0123])(\-([01234]?[0-9]|5[0123]))?(,([01234]?[0-9]|5[0123])(\-([01234]?[0-9]|5[0123]))?)*\:?$/
    @RGX_MONTH = /^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)(\-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))?\:?$/
    @RGX_MONTHDAY = /^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ([012]?[0-9]|3[01])(\-((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) )?([012]?[0-9]|3[01]))?\:?$/
    @RGX_TIME = /^((([01]?[0-9]|2[01234])\:[012345][0-9](\-([01]?[0-9]|2[01234])\:[012345][0-9])?(,([01]?[0-9]|2[01234])\:[012345][0-9](\-([01]?[0-9]|2[01234])\:[012345][0-9])?)*)|(24\/7))$/
    @RGX_WEEKDAY = /^(((Mo|Tu|We|Th|Fr|Sa|Su)(\-(Mo|Tu|We|Th|Fr|Sa|Su))?)|(PH|SH|easter))(,(((Mo|Tu|We|Th|Fr|Sa|Su)(\-(Mo|Tu|We|Th|Fr|Sa|Su))?)|(PH|SH|easter)))*$/
    @RGX_HOLIDAY = /^(PH|SH|easter)$/
    @RGX_WD = /^(Mo|Tu|We|Th|Fr|Sa|Su)(\-(Mo|Tu|We|Th|Fr|Sa|Su))?$/
  end

  def parse(oh)
    result = []
    blocks = oh.split(';')

    rule_modifier = nil
    time_selector = nil
    weekday_selector = nil
    wide_range_selector = nil
    month_selector = nil

    times = nil
    weekdays = nil
    weeks = nil
    months = nil

    single_time = nil
    from = nil
    to = nil

    single_month = nil
    month_from = nil
    month_to = nil

    single_week = nil
    week_from = nil
    week_to = nil

    date_ranges = nil
    date_range = nil
    dr_obj = nil
    res_dr_id = nil

    blocks.each do |block|
      block.strip!
      next if block.length == 0

      tokens = tokenize(block)
      current_token = tokens.length - 1

      # get state
      if current_token >= 0 && is_rule_modifier?(tokens[current_token])
        rule_modifier = tokens[current_token].downcase
        current_token -= 1
      end


      # get time selector
      from = nil
      to = nil
      times = []
      if current_token >= 0 && is_time?(tokens[current_token])
        time_selector = tokens[current_token]

        if time_selector == "24/7"
          times << {from: 0, to: 24*60}
        else
          time_selector = time_selector.split(',')
          time_selector.each do |ts|
            single_time = ts.split('-')
            from = as_minutes(single_time[0])
            if single_time.length > 1
              to = as_minutes(single_time[1])
            else
              to = from
            end
            times << {from: from, to: to}
          end
        end
        current_token -= 1
      end

      # get weekdays selector
      weekdays = []
      if time_selector == "24/7"
        weekdays << {from: 0, to: 6}
      elsif current_token >= 0 && is_weekday?(tokens[current_token])
        weekday_selector = tokens[current_token]
        weekday_selector = weekday_selector.split(',')
        weekday_selector.each do |wd|
          if !(@RGX_HOLIDAY =~ wd).nil?
          elsif !(@RGX_WD =~ wd).nil?
            single_weekday = wd.split('-')
            wd_from = OSM_DAYS.find_index(single_weekday[0])
            if single_weekday.length > 1
              wd_to = OSM_DAYS.find_index(single_weekday[1])
            else
              wd_to = wd_from
            end

            weekdays << {from: wd_from, to: wd_to}
          else
            raise ArgumentError, "Invalid weekday interval : #{wd}"
          end
        end
        current_token -= 1
      end

      weeks = []
      months = []
      if current_token >= 0
        wide_range_selector = tokens[0]
        for i in 1..current_token
          wide_range_selector += " #{tokens[i]}"
        end
        if wide_range_selector.length > 0
          wide_range_selector = wide_range_selector.gsub(/\:$/, '').split('week')
          month_selector = wide_range_selector[0].strip
          if month_selector.length == 0
            month_selector = nil
          end

          if wide_range_selector.length > 1
            week_selector = wide_range_selector[1].strip
            if week_selector.length = 0
              week_selector = nil
            end
          else
            week_selector = nil
          end

          if (!month_selector.nil? && !week_selector.nil?)
            raise ArgumentError, "unsupported simultaneous month and week selector"
          elsif !month_selector.nil?
            month_selector = month_selector.split(',')

            month_selector.each do |ms|
              if ms == "SH"
              elsif !(@RGX_MONTH =~ ms).nil?
                single_month = ms.split('-')
                month_from = OSM_MONTHS.find_index(single_month[0]) + 1
                if month_from < 1
                  raise ArgumentError, "Invalid month : #{single_month[0]}"
                end

                if single_month.length > 1
                  month_to = OSM_MONTHS.find_index(single_month[1]) + 1
                  if month_to < 1
                    raise ArgumentError, "Invalid month : #{single_month[1]}"
                  end
                else
                  month_to = month_from
                end
                months << {from: month_from, to: month_to}
              elsif !(@RGX_MONTHDAY =~ ms).nil?
                single_month = ms.gsub(/\:$/, '').split('-')

                month_from = single_month[0].split(' ')
                month_from = { day: month_from[1].to_i, month: OSM_MONTHS.find_index(month_from[0]) + 1 }
                if month_from[:month] < 1
                  raise ArgumentError, "Invalid month : #{month_from.inspect}"
                end

                if single_month.length > 1
                  month_to = single_month[1].split(' ')
                  month_to = { day: month_to[1].to_i, month: OSM_MONTHS.find_index(month_to[0]) + 1 }
                  if month_to[:month] < 1
                    raise ArgumentError, "Invalid month : #{month_to.inspect}"
                  end
                else
                  month_to = nil
                end
                months << {from_day: month_from, to_day: month_to}
              else
                raise ArgumentError, "Unsupported month selector #{ms}"
              end
            end
          elsif !week_selector.nil?
            week_selector = week_selector.split(',')
            week_selector.each do |ws|
              single_week = ws.split('-')
              week_from = single_week[0].to_i
              if single_week.length > 1
                week_to = single_week[1].to_i
              else
                week_to = nil
              end
              weeks << {from: week_from, to: week_to}
            end
          else
            raise ArgumentError, "Invalid date selector"
          end
        end
      end
      if current_token == tokens.length - 1
        raise ArgumentError, "Unreadable string"
      end
      puts "months : #{months}"
      puts "weeks : #{weeks}"
      puts "weekdays : #{weekdays}"
      puts "times : #{times}"
      puts "rule_modifier : #{rule_modifier}"

      date_ranges = []

      if months.length > 0
        months.each do |month|
          if !month[:from_day].nil?
            if !month[:to_day].nil?
              date_range = WideInterval.new.day(month[:from_day][:day], month[:from_day][:month], month[:to_day][:day], month[:to_day][:month])
            else
              date_range = WideInterval.new.day(month[:from_day][:day], month[:from_day][:month])
            end
            date_ranges << date_range
          else
            if !month[:to].nil?
              date_range = WideInterval.new.month(month[:from], month[:to])
            else
              date_range = WideInterval.new.month(month[:from])
            end
            date_ranges << date_range
          end
        end
      elsif weeks.length > 0
        weeks.each do |week|
          if !week[:to].nil?
            date_range = WideInterval.new.week(week[:from], week[:to])
          else
            date_range = WideInterval.new.week(week[:from])
          end
          date_ranges << date_range
        end
      else
        date_ranges << WideInterval.new.always
      end

      if weekdays.length == 0
        weekdays << {from: 0, to: OSM_DAYS.length - 1}
      end

      if times.length == 0
        times << {from: 0, to: 24*60}
      end

      # pasur
      date_ranges.each do |dr|
        found_date_range = false
        res_dr_id = 0

        while res_dr_id < result.length && !found_date_range
          if result[res_dr_id].wide_interval.equals(dr)
            found_date_range = true
          else
            res_dr_id += 1
          end
        end

        if found_date_range
          dr_obj = result[res_dr_id]
        else
          dr_obj = DateRange.new(dr)

          general = -1
          for res_dr_id in 0...result.length
            if result[res_dr_id].is_general_for?(DateRange.new(dr))
              general = res_dr_id
            end
          end
          if general >= 0
            dr_obj.typical.copy_intervals(result[general].typical.intervals)
          end
          result << dr_obj
        end

        for wd_id in 0...weekdays.length
          if weekdays[wd_id][:from] <= weekdays[wd_id][:to]
            for wd_rm in weekdays[wd_id][:from]..weekdays[wd_id][:to]
              if dr_obj.defines_typical_week?
                dr_obj.typical.remove_intervals_during_day(wd_rm)
              else
                dr_obj.typical.clear_intervals
              end
            end
          else
            for wd_rm in weekdays[wd_id][:from]..6
              if dr_obj.defines_typical_week?
                dr_obj.typical.remove_intervals_during_day(wd_rm)
              else
                dr_obj.typical.clear_intervals
              end
            end
            for wd_rm in 0..weekdays[wd_id][:to]
              if dr_obj.defines_typical_week?
                dr_obj.typical.remove_intervals_during_day(wd_rm)
              else
                dr_obj.typical.clear_intervals
              end
            end
          end

          for t_id in 0...times.length
            if rule_modifier == "closed" || rule_modifier == "off"
              remove_interval(dr_obj.typical, weekdays[wd_id], times[t_id])
            else
              add_interval(dr_obj.typical, weekdays[wd_id], times[t_id])
            end
          end
        end
      end
    end
    return result
  end

  def remove_interval(typical, weekdays, times)
    if weekdays[:from] <= weekdays[:to]
      for wd in weekdays[:from]..weekdays[:to]
        typical.remove_intervals_during_day(wd)
      end
    else
      for wd in weekdays[:from]..6
        typical.remove_intervals_during_day(wd)
      end
      for wd in 0..weekdays[:from]
        typical.remove_intervals_during_day(wd)
      end
    end
  end

  def remove_interval_wd(typical, times, wd)
    if times[:to] >= times[:from]
      typical.remove_interval(Interval.new(wd, times[:from], wd, times[:to]))
    else
      if wd < 6
        typical.remove_interval(Interval.new(wd, times[:from], wd+1, times[:to]))
      else
        typical.remove_interval(Interval.new(wd, times[:from], wd+1, 24*60))
        typical.remove_interval(Interval.new(0, 0, 0, times[:to]))
      end
    end
  end

  def add_interval(typical, weekdays, times)
    if typical.instance_of?(Day)
      if weekdays[:from] != 0 || (weekdays[:to] !=0 && times[:from] <= times[:to])
        weekdays = weekdays.dup
        weekdays[:from] = 0
        if times[:from] <= times[:to]
          weekdays[:to] = 0
        else
          weekdays[:to] = 1
        end
      end
    end

    if weekdays[:from] <= weekdays[:to]
      for wd in weekdays[:from]..weekdays[:to]
        add_interval_wd(typical, times, wd)
      end
    else
      for wd in weekdays[:from]..6
        add_interval_wd(typical, times, wd)
      end
      for wd in 0..weekdays[:to]
        add_interval_wd(typical, times, wd)
      end
    end
  end

  def add_interval_wd(typical, times, wd)
    if times[:to] >= times[:from]
      typical.add_interval(Interval.new(wd, times[:from], wd, times[:to]))
    else
      if wd < 6
        typical.add_interval(Interval.new(wd, times[:from], wd+1, times[:to]))
      else
        typical.add_interval(Interval.new(wd, times[:from], wd+1, 24*60))
        typical.add_interval(Interval.new(0, 0, 0, times[:to]))
      end
    end
  end

  def tokenize(block)
    block.split(' ')
  end

  def as_minutes(time)
    values = time.split(':')
    values[0].to_i * 60 + values[1].to_i
  end

  def is_rule_modifier?(token)
    !(@RGX_RULE_MODIFIER =~ token).nil?
  end
  def is_time?(token)
    !(@RGX_TIME =~ token).nil?
  end
  def is_weekday?(token)
    !(@RGX_WEEKDAY =~ token).nil?
  end
end
