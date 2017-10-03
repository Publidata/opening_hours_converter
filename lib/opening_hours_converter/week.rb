require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class Week
    include Constants
    attr_accessor :intervals

    def initialize
      @intervals = []
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
                intervals << OpeningHoursConverter::Interval.new(day_start, minute_start, day_index, minute_index)
              end
            else
              if minute && day_start < 0
                day_start = day_index
                minute_start = minute_index
              elsif !minute && day_start >= 0
                if minute_index == 0
                  intervals << OpeningHoursConverter::Interval.new(day_start, minute_start, day_index - 1, MINUTES_MAX)
                else
                  intervals << OpeningHoursConverter::Interval.new(day_start, minute_start, day_index, minute_index - 1)
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
                intervals[:open] << OpeningHoursConverter::Interval.new(day_start, min_start, d, m)
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
                  intervals[:open] << OpeningHoursConverter::Interval.new(day_start, min_start, d - 1, MINUTES_MAX)
                else
                  intervals[:open] << OpeningHoursConverter::Interval.new(day_start, min_start, d, m - 1)
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
          intervals[:open] << OpeningHoursConverter::Interval.new(day_start, min_start, d-1, MINUTES_MAX)
          day_start = -1
          min_start = -1
        end
        if diff_day && day_start == -1 && intervals_length == intervals[:open].length
          if intervals[:closed].length > 0 && intervals[:closed][intervals[:closed].length - 1].day_end == d - 1
            intervals[:closed][intervals[:closed].length - 1] = OpeningHoursConverter::Interval.new(intervals[:closed][intervals[:closed].length - 1].day_start, 0, d, MINUTES_MAX)
          else
            intervals[:closed] << OpeningHoursConverter::Interval.new(d, 0, d, MINUTES_MAX)
          end
        end
      end
      return intervals
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

    def remove_intervals_during_day(day)
      @intervals.each_with_index do |interval, i|
        unless interval.nil?
          if interval.day_start <= day && interval.day_end >= day
            day_diff = interval.day_end - interval.day_start

            if day_diff > 1 || day_diff == 0 || interval.day_start == day || interval.start <= interval.end
              if interval.day_end - interval.day_start >= 1 && interval.start <= interval.end
                if interval.day_start < day
                  add_interval(OpeningHoursConverter::Interval.new(interval.day_start, interval.start, day - 1, 24*60))
                end
                if interval.day_end > day
                  add_interval(OpeningHoursConverter::Interval.new(day + 1, 0, interval.day_end, interval.end))
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
      week.get_as_minute_array == get_as_minute_array
    end
  end
end
