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
              intervals << OpeningHoursConverter::Interval.new(0, minute_start, 0, i - 1)
              minute_start = -1
            end
          else
            if minute && minute_start < 0
              minute_start = i
            elsif !minute && minute_start >= 0
              intervals << OpeningHoursConverter::Interval.new(0, minute_start, 0, i - 1)
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
      @intervals << interval
      return @intervals.length - 1
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
      day.get_as_minute_array == get_as_minute_array
    end
  end
end
