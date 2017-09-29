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
    unless end_day.nil? && end_month.nil? && (end_day != start_day || end_month != start_month)
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
        o.starts_month? &&
        (!o.end.nil? && @end.nil? && o.end[:month] == @start[:month] && o.ends_month?) ||
        (!o.end.nil? && !@end.nil? && o.end[:month] == @end[:month] && o.ends_month?)) ||
        (o.type == "month" &&
        (o.start[:month] == @start[:month] &&
        (o.end.nil? && @end.nil?) ||
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
    other_minutes_array = get_as_minute_array

    intervals = { open: [], closed: [] }
    day_start = -1
    min_start = -1


    for d in 0...DAYS_MAX do
      diff_day = false
      m = 0
      intervals_length = intervals[:open].length
      while m <= MINUTES_MAX
        if diff_day
          if d == 0 && m == 0
            if self_minutes_array[d][m]
              day_start = d
              min_start = m
            end
          elsif d == DAYS_MAX && m == MINUTES_MAX
            if day_start >= 0 && self_minutes_array[d][m]
              intervals[:open] << Interval.new(day_start, min_start, d, m)
            end
          else
            if self_minutes_array[d][m] && day_start < 0
              day_start = d
              min_start = m

            elsif !self_minutes_array[d][m] && day_start >= 0
              if m == 0
                intervals.open << Interval.new(day_start, min_start, d - 1, MINUTES_MAX)
              else
                intervals.open << Interval.new(day_start, min_start, d, m - 1)
              end
              day_start = -1
              min_start = -1
            end
          end
          m += 1
        else
          diff_day = self_minutes_array[d][m] ? !other_minutes_array[d][m] : other_minutes_array[d][m]

          if diff_day
            m = 0
          else
            m += 1
          end
        end
        if !diff_day && day_start > -1
          binding.pry
          intervals[:open] << Interval.new(day_start, min_start, d-1, MINUTES_MAX)
          day_start = -1
          min_start = -1
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
        if interval.start_day <= day && interval.end_day >= day
          day_diff = interval.end_day - interval.start_day

          if day_diff > 1 || day_diff == 0 || interval.start_day == day || interval.start <= interval.end
            if interval.end_day - interval.start_day >= 1 && interval.start <= interval.end
              if interval.start_day < day
                add_interval(Interval.new(interval.start_day, interval.start, day - 1, 24*60))
              end
              if interval.end_day > day
                add_interval(Interval.new(day + 1, 0, interval.end_day, interval.end))
              end
              remove_interval(i)
            end
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

  def initialize(w)
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
    wd = @weekdays.concat(@weekdays_over).sort

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
      @weekdays_over << wd
      @weekdays_over.sort!
    end
  end

  def same_kind_as?(date)
    @wide_type == d.wide_type && d.same_weekdays(@weekdays)
  end

  def same_weekdays(weekdays)
    weekdays.equals(@weekdays)
  end

  def equals(o)
    o.instance_of?(OpeningHoursDate) && @wide_type == o.wide_type && @wide == o.wide && o.same_weekdays(@weekdays)
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

    if @date.length > 1 || @date.first.wide != ""
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
    @date.length == 0 && @date[0].weekdays_over.length > 0
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
      if @date.length != 1 || @date.first.wide_type != "always" || !@date.first.same_weekdays(date.weekdays)
        raise "This date can't be added to this rule"
      end
    end
  end

  def add_time(time)
    if (@time.length == 0 || @time[0].get != "off") && !@time.include?(time)
      @time << time
    else
      raise "This time can't be added to this rule"
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
              rescue
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
          end
          oh_rule_index += 1
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
            days[md_off].add_weekday(i)
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

    intervals.closed.each do |interval|
      for i in interval.start_day...interval.end_day do
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
              days_status[j] = -i - 1
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
        if interval.day_start == 0 && interval.day_end == 0 && interval.end == 0
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
            for j in interval.start...interval.end do
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
























































def test

  interval1 = WideInterval.new.day(1, 1)
  interval2 = WideInterval.new.week(1, 1)


  date_range1 = DateRange.new(interval1)
  # date_range2 = DateRange.new(interval2)
  date_range1.typical.add_interval(Interval.new(0, 0, 0, MINUTES_MAX))

  OpeningHoursBuilder.new.build([date_range1])


end

class Month
  # WIP
  attr_accessor :intervals

  def initialize
    @intervals = []
  end

  def get_as_minute_array
    minute_array = []
    MONTH_END_DAY.each_with_index do |days, index|
      minute_array.push(Array.new(days, Array.new(MINUTES_MAX, false)))
    end


    @intervals.each do |interval|
      for month in interval.month_start...interval.month_end
        start_day = (month == interval.month_start) ? interval.day_start : 0
        end_day = (month == interval.month_end) ? interval.day_end : MONTH_END_DAY[month]
        for day in start_day..end_day
          start_minute = (day == interval.day_start) ? interval.min_start : 0;
          end_minute = (day == interval.day_end) ? interval.min_end : MINUTES_MAX;
          for minute in start_minute..end_minute
            minute_array[day][minute] = true
          end
        end
      end
    end

    minute_array
  end

  def add_interval(interval)
    @intervals.push(interval)
  end

  def edit_interval(id, interval)
    @intervals[id] = interval
  end

  def remove_interval(id)
    @intervals[id] = nil
  end
end
  date_ranges = [DateRange.new(WideInterval.new.always)]
  date_ranges[0].typical.add_interval(Interval.new(0, 23*60, 0, 24*60))
  date_ranges[0].typical.add_interval(Interval.new(1, 0, 1, 3*60))
  date_ranges[0].typical.add_interval(Interval.new(1, 23*60, 1, 24*60))
  date_ranges[0].typical.add_interval(Interval.new(2, 0, 2, 3*60))
  puts OpeningHoursBuilder.new.build(date_ranges).inspect

#     QUnit.module("Model > OpeningHoursBuilder");
#     QUnit.test("Build void", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       assert.equal(builder.build([]), "");
#     });
#     QUnit.test("Build Mo 08:00-10:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
      # var dateranges = [ new DateRange(new WideInterval().always()) ];

      # dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 10*60));

#       assert.equal(builder.build(dateranges), "Mo 08:00-10:00");
#     });
#     QUnit.test("Build Mo,We 08:00-10:00", function(assert) {
      # var builder = new OpeningHoursBuilder();
      # var dateranges = [ new DateRange(new WideInterval().always()) ];

      # dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 10*60));
      # dateranges[0].getTypical().addInterval(new Interval(2, 2, 8*60, 10*60));

#       assert.equal(builder.build(dateranges), "Mo,We 08:00-10:00");
#     });
#     QUnit.test("Build Mo-We 08:00-10:00", function(assert) {
      # var builder = new OpeningHoursBuilder();
      # var dateranges = [ new DateRange(new WideInterval().always()) ];

      # dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 10*60));
      # dateranges[0].getTypical().addInterval(new Interval(1, 1, 8*60, 10*60));
      # dateranges[0].getTypical().addInterval(new Interval(2, 2, 8*60, 10*60));

      # assert.equal(builder.build(dateranges), "Mo-We 08:00-10:00");
#     });
#     QUnit.test("Build Mo-We 08:00-10:00; Sa,Su 07:00-13:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
      # var dateranges = [ new DateRange(new WideInterval().always()) ];

      # dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 10*60));
      # dateranges[0].getTypical().addInterval(new Interval(1, 1, 8*60, 10*60));
      # dateranges[0].getTypical().addInterval(new Interval(2, 2, 8*60, 10*60));
      # dateranges[0].getTypical().addInterval(new Interval(5, 5, 7*60, 13*60));
      # dateranges[0].getTypical().addInterval(new Interval(6, 6, 7*60, 13*60));

      # assert.equal(builder.build(dateranges), "Mo-We 08:00-10:00; Sa,Su 07:00-13:00");
#     });
#     QUnit.test("Build Mo,Tu 23:00-03:00 continuous", function(assert) {
      # var builder = new OpeningHoursBuilder();
      # var dateranges = [ new DateRange(new WideInterval().always()) ];

      # dateranges[0].getTypical().addInterval(new Interval(0, 1, 23*60, 3*60));
      # dateranges[0].getTypical().addInterval(new Interval(1, 2, 23*60, 3*60));

      # assert.equal(builder.build(dateranges), "Mo,Tu 23:00-03:00");
#     });
#     QUnit.test("Build Mo,Tu 23:00-03:00 following", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 23*60, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 0, 3*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 23*60, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 0, 3*60));

#       assert.equal(builder.build(dateranges), "Mo,Tu 23:00-03:00");
#     });
#     /*QUnit.test("Build Mo,Su 23:00-03:00 continuous", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 1, 23*60, 3*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 0, 23*60, 3*60));

#       assert.equal(builder.build(dateranges), "Mo,Su 23:00-03:00");
#     });*/
#     QUnit.test("Build Mo,Su 23:00-03:00 following", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 23*60, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 0, 3*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 23*60, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 0, 3*60));

#       assert.equal(builder.build(dateranges), "Mo,Su 23:00-03:00");
#     });
#     QUnit.test("Build Mo 08:00-10:00 merging", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 9*60));
#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 9*60, 10*60));

#       assert.equal(builder.build(dateranges), "Mo 08:00-10:00");
#     });
#     QUnit.test("Build Mo 08:00-24:00; Tu 00:00-09:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 1, 8*60, 9*60));

#       assert.equal(builder.build(dateranges), "Mo 08:00-24:00; Tu 00:00-09:00");
#     });
#     QUnit.test("Build 08:00-18:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(5, 5, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "08:00-18:00");
#     });
#     QUnit.test("Build 24/7 continuous", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));

#       assert.equal(builder.build(dateranges), "24/7");
#     });
#     QUnit.test("Build 24/7 following", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 0, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 0, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 0, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 0, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 0, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(5, 5, 0, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 0, 24*60));

#       assert.equal(builder.build(dateranges), "24/7");
#     });
#     QUnit.test("Build 24/7; Jun 08:00-18:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()), new DateRange(new WideInterval().month(6)) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 3, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(4, 4, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(5, 5, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(6, 6, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "24/7; Jun 08:00-18:00");
#     });
#     QUnit.test("Build 24/7; Jun 08:00-18:00; Jun We off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()), new DateRange(new WideInterval().month(6)) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 3, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(4, 4, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(5, 5, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(6, 6, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "24/7; Jun 08:00-18:00; Jun We off");
#     });
#     QUnit.test("Build 08:00-18:00; We off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(5, 5, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "08:00-18:00; We off");
#     });
#     QUnit.test("Build 24/7; Jun Mo-We 08:00-18:00; Jun Th-Su off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()), new DateRange(new WideInterval().month(6)) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "24/7; Jun Mo-We 08:00-18:00; Jun Th-Su off");
#     });
#     QUnit.test("Build 24/7; Jun Mo-We 08:00-18:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()), new DateRange(new WideInterval().month(6)) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 6, 0, 24*60));

#       assert.equal(builder.build(dateranges), "24/7; Jun Mo-We 08:00-18:00");
#     });
#     QUnit.test("Build 24/7; Jun-Aug Mo-We 08:00-18:00; Jun-Aug Th-Su off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()), new DateRange(new WideInterval().month(6, 8)) ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "24/7; Jun-Aug Mo-We 08:00-18:00; Jun-Aug Th-Su off");
#     });
#     QUnit.test("Build 24/7; Jun Mo 08:00-18:00; Jun Tu-Su off; PH off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().month(6)),
#         new DateRange(new WideInterval().holiday("PH"))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "24/7; Jun Mo 08:00-18:00; Jun Tu-Su off; PH off");
#     });
#     QUnit.test("Build 24/7; Jun Mo 08:00-18:00; Jun Tu-Su off; PH off; SH Tu 09:00-17:00; SH Mo,We-Su off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().month(6)),
#         new DateRange(new WideInterval().holiday("PH")),
#         new DateRange(new WideInterval().holiday("SH"))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[3].getTypical().addInterval(new Interval(1, 1, 9*60, 17*60));

#       assert.equal(builder.build(dateranges), "24/7; Jun Mo 08:00-18:00; Jun Tu-Su off; PH off; SH We-Mo off; SH Tu 09:00-17:00");
#     });
#     QUnit.test("Build Mo 08:00-18:00 grouping", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().month(6)),
#         new DateRange(new WideInterval().holiday("SH"))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[2].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "Mo 08:00-18:00");
#     });
#     QUnit.test("Build 24/7; week 01-15 We 05:00-07:00; PH off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().week(1, 15)),
#         new DateRange(new WideInterval().holiday("PH"))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 1, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 5*60, 7*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 6, 0, 24*60));

#       assert.equal(builder.build(dateranges), "24/7; week 01-15 We 05:00-07:00; PH off");
#     });
#     QUnit.test("Build 24/7; week 01-15 Fr-We 05:00-07:00; PH off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().week(1, 15)),
#         new DateRange(new WideInterval().holiday("PH"))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 5*60, 7*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 5*60, 7*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 5*60, 7*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 3, 0, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(4, 4, 5*60, 7*60));
#       dateranges[1].getTypical().addInterval(new Interval(5, 5, 5*60, 7*60));
#       dateranges[1].getTypical().addInterval(new Interval(6, 6, 5*60, 7*60));

#       assert.equal(builder.build(dateranges), "24/7; week 01-15 Fr-We 05:00-07:00; PH off");
#     });
#     QUnit.test("Build 05:00-07:00; Th,Fr 00:00-24:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always())
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 5*60, 7*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 5*60, 7*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 5*60, 7*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 0, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 0, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(5, 5, 5*60, 7*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 5*60, 7*60));

#       assert.equal(builder.build(dateranges), "05:00-07:00; Th,Fr 00:00-24:00");
#     });
#     QUnit.test("Build Mo-Fr 01:00-02:00; We off; Jun We 02:00-03:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().month(6))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 2*60, 3*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 3, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(4, 4, 1*60, 2*60));

#       assert.equal(builder.build(dateranges), "Mo-Fr 01:00-02:00; We off; Jun We 02:00-03:00");
#     });
#     QUnit.test("Build 01:00-02:00; Jun Th 02:00-03:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().month(6))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(5, 5, 1*60, 2*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 3, 2*60, 3*60));
#       dateranges[1].getTypical().addInterval(new Interval(4, 4, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(5, 5, 1*60, 2*60));
#       dateranges[1].getTypical().addInterval(new Interval(6, 6, 1*60, 2*60));

#       assert.equal(builder.build(dateranges), "01:00-02:00; Jun Th 02:00-03:00");
#     });
#     QUnit.test("Build 24/7; week 01 Su 01:00-08:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().week(1))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0*60, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 5, 0*60, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(6, 6, 1*60, 8*60));

#       assert.equal(builder.build(dateranges), "24/7; week 01 Su 01:00-08:00");
#     });
#     QUnit.test("Build 24/7; week 01 Su 01:00-08:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().week(1))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 6, 0*60, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 5, 0*60, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(6, 6, 1*60, 8*60));

#       assert.equal(builder.build(dateranges), "24/7; week 01 Su 01:00-08:00");
#     });
#     QUnit.test("Build Tu,Su 23:00-01:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always())
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(1, 2, 23*60, 1*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 23*60, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 0*60, 1*60));

#       assert.equal(builder.build(dateranges), "Tu,Su 23:00-01:00");
#     });
#     QUnit.test("Build Tu,Su 23:00-01:00; week 01 Tu,We off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().week(1))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(1, 2, 23*60, 1*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 23*60, 24*60));
#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 0*60, 1*60));
#       dateranges[1].getTypical().addInterval(new Interval(6, 6, 23*60, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 0*60, 1*60));

#       assert.equal(builder.build(dateranges), "Tu,Su 23:00-01:00; week 01 Tu,We off");
#     });
#     QUnit.test("Build 08:00-18:00; Aug off", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().month(8))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(5, 5, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "08:00-18:00; Aug off");
#     });
#     QUnit.test("Build Mo 10:00; PH 11:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().holiday("PH"))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 10*60, 10*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 11*60, 11*60));

#       assert.equal(builder.build(dateranges), "Mo 10:00; PH 11:00");
#     });
#     QUnit.test("Build Mo-Fr 00:00-24:00; Aug-Sep Sa 00:00-24:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().always()),
#         new DateRange(new WideInterval().month(8,9))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 4, 0*60, 24*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 5, 0*60, 24*60));

#       assert.equal(builder.build(dateranges), "Mo-Fr 00:00-24:00; Aug-Sep Sa 00:00-24:00");
#     });
#     QUnit.test("Build May-Jun,Sep 14:00-18:00 (month factoring)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().month(5,6)),
#         new DateRange(new WideInterval().month(9))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 14*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 14*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 14*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 14*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 14*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(5, 5, 14*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 3, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(4, 4, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(5, 5, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(6, 6, 14*60, 18*60));

#       assert.equal(builder.build(dateranges), "May-Jun,Sep 14:00-18:00");
#     });
#     QUnit.test("Build Jan 01-May 01,May 15-Oct 12 Mo,Fr 08:00-18:00 (day factoring)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().day(1,1,1,5)),
#         new DateRange(new WideInterval().day(15,5,12,10))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 8*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(4, 4, 8*60, 18*60));

#       assert.equal(builder.build(dateranges), "Jan 01-May 01,May 15-Oct 12 Mo,Fr 08:00-18:00");
#     });
#     QUnit.test("Build Mo-We 03:00-05:00; Jan 01-10,Feb 01-10 Tu off (off day factoring)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(),
#         new DateRange(new WideInterval().day(1,1,10,1)),
#         new DateRange(new WideInterval().day(1,2,10,2))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 3*60, 5*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 3*60, 5*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 3*60, 5*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 3*60, 5*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 3*60, 5*60));
#       dateranges[2].getTypical().addInterval(new Interval(0, 0, 3*60, 5*60));
#       dateranges[2].getTypical().addInterval(new Interval(2, 2, 3*60, 5*60));

#       assert.equal(builder.build(dateranges), "Mo-We 03:00-05:00; Jan 01-10,Feb 01-10 Tu off");
#     });
#     QUnit.test("Build Tu,Su 10:00-12:00; Jun Tu,Su off; Jun We,Sa 10:00-12:00 (off day factoring)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(),
#         new DateRange(new WideInterval().month(6))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 10*60, 12*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 10*60, 12*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 10*60, 12*60));
#       dateranges[1].getTypical().addInterval(new Interval(5, 5, 10*60, 12*60));

#       assert.equal(builder.build(dateranges), "Tu,Su 10:00-12:00; Jun Tu,Su off; Jun We,Sa 10:00-12:00");
#     });
#     QUnit.test("Build week 01-09 Mo 03:00-06:00 (week factoring)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().week(1,2)),
#         new DateRange(new WideInterval().week(3,9))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 3*60, 6*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 3*60, 6*60));

#       assert.equal(builder.build(dateranges), "week 01-09 Mo 03:00-06:00");
#     });
#     QUnit.test("Build week 01-03,10-15 Mo 03:00-06:00 (week factoring)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().week(1,3)),
#         new DateRange(new WideInterval().week(10,15))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 3*60, 6*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 3*60, 6*60));

#       assert.equal(builder.build(dateranges), "week 01-09 Mo 03:00-06:00");
#     });
#     QUnit.test("Build May-Jun,Sep Mo,Tu 14:00-18:00 (month factoring)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().month(5,6)),
#         new DateRange(new WideInterval().month(9))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 14*60, 18*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 14*60, 18*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 14*60, 18*60));

#       assert.equal(builder.build(dateranges), "May-Jun,Sep Mo,Tu 14:00-18:00");
#     });
#     QUnit.test("Build Mo-Fr 12:00-14:00; PH,Sa,Su 12:00-16:00 (PH as weekday)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(),
#         new DateRange(new WideInterval().holiday("PH"))
#       ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 12*60, 14*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 12*60, 14*60));
#       dateranges[0].getTypical().addInterval(new Interval(2, 2, 12*60, 14*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 12*60, 14*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 12*60, 14*60));
#       dateranges[0].getTypical().addInterval(new Interval(5, 5, 12*60, 16*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 12*60, 16*60));
#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 12*60, 16*60));


#       assert.equal(builder.build(dateranges), "Mo-Fr 12:00-14:00; PH,Sa,Su 12:00-16:00");
#     });
#     QUnit.test("Build PH,Mo-Sa 12:00-14:00 (PH as weekday defined first)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [
#         new DateRange(new WideInterval().holiday("PH")),
#         new DateRange()
#       ];

#       dateranges[1].getTypical().addInterval(new Interval(0, 0, 12*60, 14*60));
#       dateranges[1].getTypical().addInterval(new Interval(1, 1, 12*60, 14*60));
#       dateranges[1].getTypical().addInterval(new Interval(2, 2, 12*60, 14*60));
#       dateranges[1].getTypical().addInterval(new Interval(3, 3, 12*60, 14*60));
#       dateranges[1].getTypical().addInterval(new Interval(4, 4, 12*60, 14*60));
#       dateranges[1].getTypical().addInterval(new Interval(5, 5, 12*60, 14*60));
#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 12*60, 14*60));


#       assert.equal(builder.build(dateranges), "PH,Mo-Sa 12:00-14:00");
#     });
#     QUnit.test("Build Su-Tu 12:00-14:00 (continuous week-end)", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange() ];

#       dateranges[0].getTypical().addInterval(new Interval(0, 0, 12*60, 14*60));
#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 12*60, 14*60));
#       dateranges[0].getTypical().addInterval(new Interval(6, 6, 12*60, 14*60));


#       assert.equal(builder.build(dateranges), "Su-Tu 12:00-14:00");
#     });
#     QUnit.test("Build Tu 00:00-24:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange() ];

#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 0*60, 24*60));

#       assert.equal(builder.build(dateranges), "Tu 00:00-24:00");
#     });
#     QUnit.test("Build Tu,Th,Fr 08:00-12:00", function(assert) {
#       var builder = new OpeningHoursBuilder();
#       var dateranges = [ new DateRange(new WideInterval().always()) ];

#       dateranges[0].getTypical().addInterval(new Interval(1, 1, 8*60, 12*60));
#       dateranges[0].getTypical().addInterval(new Interval(3, 3, 8*60, 12*60));
#       dateranges[0].getTypical().addInterval(new Interval(4, 4, 8*60, 12*60));

#       assert.equal(builder.build(dateranges), "Tu-Fr 08:00-12:00; We off");
#     });
