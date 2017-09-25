require 'date'

require 'opening_hour_converter/day'
require 'opening_hour_converter/week'
require 'opening_hour_converter/month'

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

class OpeningHourConverter

  def initialize
    @interval = []
  end

  def add_interval(date)

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

  def initialize()
    @start = nil
    @end = nil
    @type = nil
  end

  def day(start_day, start_month, end_day, end_month)
    if start_dat.blank?
      raise ArgumentError, "start_dat is required"
    end
    @start = { day: start_day, month: start_month }
    @end = { day: end_day, month: end_month }
    @type = "day"
    self
  end

  def week(start_week, end_week)
    if start_week.blank?
      raise ArgumentError, "start_week is required"
    end
    @start = { week: start_week }
    @end = (!end_week.nil? && end_week !== start_week) ? { week: end_week } : nil
    @type = "week"
    self
  end

  def month(start_month, end_month)
    if start_month.blank?
      raise ArgumentError, "start_month is required"
    end
    @start = { month: start_month }
    @end = (!end_month.nil? && end_month !== start_month) ? { month: end_month } : nil
    @type = "month"
    self
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
        for minute in start_minute..end_minute
          minute_array[minute] = true
        end
      else
        puts interval.inspect
        raise "Invalid interval"
      end
    end

    minute_array
  end

  def addInterval(interval)
    @intervals.push(interval)
  end

  def editInterval(id, interval)
    @intervals[id] = interval
  end

  def removeInterval(id)
    @intervals[id] = nil
  end
end



