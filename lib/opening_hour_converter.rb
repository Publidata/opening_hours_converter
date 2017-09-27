require 'date'

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
    else
      raise ArgumentError
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
          result += "#{@end[:day]} #{IRL_MONTHS[@end[:month] - 1]}"
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
    @type == "month" || @type == "always" || (@type == "day" && @end[:day] == MONTH_END_DAY[@end[:month] - 1])
  end

  def contains?(o)
    result = false
    if self.equals(o)
      result = false
    elsif @type == "always"
      result = true
    elsif @type ==  "day"
      if o.type == "day"
        if o.start[:month] > @start[:month] || (o.start[:month] == @start[:month] && @start[:day] >= @start[:day])

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
        if o.start[:month] > this.start[:month] || (o.start[:month] == this.start[:month] && this.start[:day] == 1)
          if !o.end.nil? && !@end.nil? && (o.end[:month] < this.end[:month] || (o.end[:month] == this.end[:month] && this.end[:day] == MONTH_END_DAY[@end.month-1]))
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
            else
              if o.start[:month] >= @start[:month] && o.end[:month] <= @end[:month]
                if (o.start[:month] > this.start[:month] && o.end[:month] < this.end[:month]) ||
                  (o.start[:month] == this.start[:month] && o.end[:month] < this.end[:month] && start.day > 1) ||
                  (o.start[:month] > this.start[:month] && o.end[:month] == this.end[:month] && o.end[:day] < MONTH_END_DAY[o.end[:month]-1]) ||
                  (o.start[:day] >= 1 && o.end[:day] < MONTH_END_DAY[o.end[:month]-1]) ||
                  (o.start[:day] > 1 && o.end[:day] <= MONTH_END_DAY[o.end[:month]-1])
                  result = true
                end
              end
            end
          end
        else
          if @end.nil?
            if @start[:month] == o.start[:month]
              result = true
            end
          else
            if @start[:month] == o.start[:month] && o.start[:month] < @end[:month]
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
        o.start[:month] = @start[:month] &&
        (o.is_full_month? && is_full_month?) ||
        (!o.end.nil? && !@end.nil? &&
          o.end[:month] == @end[:month] &&
          o.end[:day] == @end[:day] &&
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
        o.start[:month] == @start[:month] &&
        (o.end.nil? && @end.nil?) ||
        (!o.end.nil? && !@end.nil? && o.end[:month] == @end[:month]))
    end
    result
  end

end

class Day
  attr_accessor :intervals

  def initialize
    @intervals = []
  end

  def get_as_minute_array
    minute_array = Array.new(MINUTES_MAX, false)

    @intervals.each do |interval|
      start_minute = nil
      end_minute = nil

      if interval.day_start == interval.day_end || interval.day_end == DAYS_MAX && interval.end == MINUTES_MAX
        start_minute = interval.start
        end_minute = interval.end
      end

      unless start_minute.nil? && end_minute.nil?
        for minute in start_minute...end_minute
          minute_array[minute] = true
        end
      else
        raise "Invalid interval"
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
          end
        end
      end
      intervals
    else
      @intervals
    end
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

  def copy_interval(intervals)
    @intervals = []
    intervals.each do |interval|
      if !interval.nil? && interval.start_day == 0 && interval.end_day == 0
        @interval << interval.dup
      end
    end
    @intervals = get_intervals(true)
  end

  def same_as?(day)
    day.get_as_minute_array.equals(get_as_minute_array)
  end
end


class Week
  attr_accessor :intervals

  def initialize
    @intervals = []
  end

  def get_as_minute_array
    minute_array = Array.new(DAYS_MAX, Array.new(MINUTES_MAX, false))

    @intervals.each do |interval|

      for day in interval.day_start...interval.day_end
        start_minute = (day == interval.day_start) ? interval.min_start : 0;
        end_minute = (day == interval.day_end) ? interval.min_end : MINUTES_MAX;
        for minute in start_minute...end_minute
          minute_array[day][minute] = true
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
    # TODO
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

  def copy_interval(intervals)
    @intervals = []
    intervals.each do |interval|
      unless interval.nil?
        @interval << interval.dup
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

# DONE
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
  end

  def get_weekdays

  end

  def add_weekday(weekday)
    unless @weekdays.include?(weekday) && @weekdays_over.include?(weekday)
      @weekdays << wd
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
    puts self
    puts weekdays
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

    result
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
    if (@time.length > 0 || @time.first.get != "off") && !@time.include?(time)
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
          range_general_id-=1
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
        oh_rule_length = oh_rules.length

        while oh_rule_index < oh_rule_length do
          oh_rule = oh_rules[oh_rule_index]
          oh_rule_added = false
          rule_index = 0

          while !oh_rule_added && rule_index < rules.length

            if rules[rule_index].same_time?(oh_rule)
              begin
                puts oh_rule.date.length
                for date_id in 0...oh_rule.date.length
                  # puts oh_rule.date[date_id]
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
        rule.add_time(OpeningHoursTime(interval.start, interval.end))
      end
    end

    return [ rule ]
  end
end




def test
  interval1 = WideInterval.new.day(1, 1)
  interval2 = WideInterval.new.day(2, 2)

  date_range1 = DateRange.new(interval1)
  date_range2 = DateRange.new(interval2)
  OpeningHoursBuilder.new.build([date_range1, date_range2])
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



