require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class Iterator
    include Constants
    include Utils

    def get_iterator(date_ranges)
      date_ranges_array = []
      years = nil

      date_ranges.each do |date_range|
        years = OpeningHoursConverter::Year.build_day_array_from_date_range(date_range, true)

        result = []

        year_start = -1
        month_start = -1
        day_start = -1

        years.each do |year, months|
          months.each_with_index do |month_array, month|
            month_array.each_with_index do |day_bool, day|
              if day_bool && year_start < 0
                year_start = year
                month_start = month
                day_start = day
              elsif day_bool && year_start >= 0 && month == 11 && day == 30 && years[year + 1].nil?
                result << { start: DateTime.new(year_start, month_start + 1, day_start + 1), end: DateTime.new(year, 12, 31) }

                year_start = -1
                month_start = -1
                day_start = -1
              elsif !day_bool && year_start >= 0
                end_res = {}

                end_res = if day == 0
                            if month == 0
                              DateTime.new(year - 1, 12, 31)
                            else
                              DateTime.new(year, month, MONTH_END_DAY[month - 1])
                            end
                          else
                            DateTime.new(year, month + 1, day)
                          end

                result << { start: DateTime.new(year_start, month_start + 1, day_start + 1), end: end_res }
                year_start = -1
                month_start = -1
                day_start = -1
              end

              if day_bool && year_start >= 0 && month == 11 && day == 30 && years[year + 1].nil?
                result << { start: DateTime.new(year_start, month_start + 1, day_start + 1), end: DateTime.new(year, 12, 31) }
              end

            end
          end
        end

        date_ranges_array << result
      end

      date_ranges_array
    end

    def get_time_iterator(date_ranges)
      is_ph = false
      year = nil
      year_ph = nil
      date_ranges.each do |date_range|
        is_ph = true if date_range.is_holiday?
      end

      date_ranges = date_ranges.flat_map do |date_range|
        if date_range.wide_interval.type == 'week' # Generate date range list from week syntax
          date_range.wide_interval.to_day.map do |day|
            day_range = date_range.dup
            day_range.update_range(day)
            day_range
          end
        else
          date_range
        end
      end

      date_ranges_array = get_iterator(date_ranges)
      datetime_result = []

      date_ranges_array.each_with_index do |result, index|
        result.each do |interval|
          (interval[:start]..interval[:end]).each do |day|
            if year != day.year && is_ph
              year = day.year
              year_ph = PublicHoliday.ph_for_year(year)
            end

            date_ranges[index].typical.intervals.each do |i|
              next unless !i.nil? && !i.is_off

              if date_ranges[index].typical.is_a? Week
                next unless (i.day_start..i.day_end).cover?(reindex_sunday_week_to_monday_week(day.wday)) || (is_ph && year_ph.include?(Time.new(day.year, day.month, day.day)))
              end

              itr = { start: Time.new(day.year, day.month, day.day, i.start / 60, i.start % 60), end: Time.new(day.year, day.month, day.day, i.end / 60, i.end % 60) }
              datetime_result << itr unless datetime_result.include?(itr)
            end
          end
        end
      end

      datetime_result.sort_by { |a| a[:start] }
    end

    def get_datetime_iterator(date_ranges)
      result = get_iterator(date_ranges)
      datetime_result = []

      date_ranges_array.each_with_index do |result, index|
        result.each do |interval|
          (interval[:start]..interval[:end]).each do |day|
            date_ranges[index].typical.intervals.each do |i|
              if (i.day_start..i.day_end).cover?(reindex_sunday_week_to_monday_week(day.wday))
                datetime_result << { start: DateTime.new(day.year, day.month, day.day, i.start / 60, i.start % 60),
                                     end: DateTime.new(day.year, day.month, day.day, i.end / 60, i.end % 60) }
              end
            end
          end
        end
      end

      datetime_result.sort_by { |a| a[:start] }
    end

    # from and to are Time
    def get_open_intervals(opening_hours_string, from, to)
      date_ranges = OpeningHoursConverter::OpeningHoursParser.new.parse(opening_hours_string)
      ti = get_time_iterator(date_ranges)

      data = {}

      ti.each do |interval|
        if interval[:start] >= from && interval[:end] <= to
          wday = reindex_sunday_week_to_monday_week(interval[:start].wday)
          data[wday] ||= []
          data[wday] << {
            from: interval[:start],
            to: interval[:end]
          }
        elsif interval[:end] > to
          break
        end
      end

      data
    end

    # Given an opening hours string and a time (default is now), returns current state (from, to, comment)
    def state(opening_hours_string, time = Time.now)
      date_ranges = OpeningHoursConverter::OpeningHoursParser.new.parse(opening_hours_string)
      ti = get_time_iterator(date_ranges)
      ti.each do |interval|
        return interval if interval[:start] <= time && interval[:end] >= time
      end
      false
    end

    # Given an opening hours string and a time (default is now), returns next state (from, to, comment)
    def next_state(opening_hours_string, time = Time.now)
      date_ranges = OpeningHoursConverter::OpeningHoursParser.new.parse(opening_hours_string)
      ti = get_time_iterator(date_ranges)
      ti.each_with_index do |interval, index|
        return { end: interval[:end] } if interval[:start] <= time && interval[:end] >= time
        return { start: interval[:start] } if interval[:start] > time && ti[index - 1][:end] <= time
      end
      false
    end

    def next_period(opening_hours_string, time = Time.now)
      date_ranges = OpeningHoursConverter::OpeningHoursParser.new.parse(opening_hours_string)
      ti = get_time_iterator(date_ranges)
      ti.each_with_index do |interval, index|
        return ti[index + 1] if interval[:start] <= time && interval[:end] >= time
        return interval if interval[:start] > time && ti[index - 1][:end] <= time
      end
      false
    end

    # Given an opening hours string and a time (default is now), returns current state as a boolean (true : open, false : close)
    def is_opened?(opening_hours_string, time = Time.now)
      date_ranges = OpeningHoursConverter::OpeningHoursParser.new.parse(opening_hours_string)
      ti = get_time_iterator(date_ranges)
      ti.each do |interval|
        return true if interval[:start] <= time && interval[:end] >= time
      end
      false
    end
  end
end
