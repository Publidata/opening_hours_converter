require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class Day
    include Constants
    attr_accessor :intervals

    def initialize
      @intervals = []
    end

    def get_as_minute_array
      minute_array = Array.new(MINUTES_MAX + 1, false)

      @intervals.compact.each do |interval|
        off, start_minute, end_minute = handle_interval(interval)

        raise ParseError, "Invalid interval #{interval.inspect}" if start_minute.nil? && end_minute.nil?

        (start_minute..end_minute).step do |minute|
          minute_array[minute] = off ? 'off' : true
        end
      end

      minute_array
    end

    def handle_interval(interval)
      off = interval.is_off

      if off
        start_minute = 0
        end_minute = MINUTES_MAX
      elsif interval.single_day? || interval.max?
        start_minute = interval.start
        end_minute = interval.end
      elsif interval.single_day_end_at_midnight?
        start_minute = interval.start
        end_minute = MINUTES_MAX
      end

      [off, start_minute, end_minute]
    end

    def get_intervals(clean = false)
      return @intervals unless clean

      minute_array = get_as_minute_array
      intervals = []
      minute_start = -1
      off = false

      minute_array.each_with_index do |minute, i|
        off, minute_start, intervals = handle_minute(minute, off, minute_start, intervals, i, minute_array)
      end
      intervals
    end

    def handle_minute(minute, off, minute_start, intervals, i, minute_array)
      if minute
        if i == 0
          off = true if minute == 'off'
          minute_start = i
        elsif minute_start < 0
          minute_start = i
        elsif i == minute_array.length - 1
          intervals << OpeningHoursConverter::Interval.new(0, minute_start, 0, i - 1, off)
          minute_start = -1
          off = false
        end
      elsif minute_start >= 0
        intervals << OpeningHoursConverter::Interval.new(0, minute_start, 0, i - 1, off)
        minute_start = -1
        off = false
      end
      [off, minute_start, intervals]
    end

    def add_interval(interval)
      @intervals << interval
      @intervals.length - 1
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
        if !interval.nil? && !interval.is_off && interval.day_start == 0 && interval.day_end == 0
          @intervals << interval.dup
        end
      end
      @intervals = get_intervals(true)
    end

    def same_as?(day)
      day.get_as_minute_array == get_as_minute_array
    end
  end
end
