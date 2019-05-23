require 'opening_hours_converter/constants'
require 'opening_hours_converter/utils'

module OpeningHoursConverter
  class WeekIndex
    include Constants
    extend Utils

    def self.week_from_index(index, year = Time.now.year)
      raise unless index <= week_count(year)
      raise unless index >= 1

      week = first_week(year)
      offset = (index - 1) * 7
      add_offset_to_week(week, offset)
    end

    def self.index_from_week(week, year = Time.now.year)
      week_difference(first_week(year)[:from], week[:from]) + 1
    end

    def self.week_count(year = Time.now.year)
      p = proc { |year| (year + (year / 4) - (year / 100) + (year / 400)) % 7 }

      return 53 if p.call(year) == 4 || p.call(year - 1) == 3
      return 52
    end

    def self.add_offset_to_week(week, offset)
      {
        from: week[:from] + offset,
        to: week[:to] + offset
      }
    end

    def self.first_week(year = Time.now.year)
      start_day = first_day_of_first_week(year)
      {
        from: start_day,
        to: start_day + 6
      }
    end

    def self.last_week(year = Time.now.year)
      end_day = last_day_of_last_week(year)
      {
        from: end_day - 6,
        to: end_day
      }
    end

    def self.last_day_of_last_week(year = Time.now.year)
      last_day_of_year = Date.new(year, 12, 31)
      last_wday_of_year = reindex_sunday_week_to_monday_week(last_day_of_year.wday)

      return last_day_of_year if last_wday_of_year == 6 # last day of year is sunday
      return Date.new(year + 1, 1, 7 - last_wday_of_year - 1) if last_wday_of_year >= 3 # last day of year is thursday friday or saturday
      return Date.new(year, 12, 31 - last_wday_of_year - 1) # last day of year is monday tuesday or wednesday
    end

    def self.first_day_of_first_week(year = Time.now.year)
      first_day_of_year = Date.new(year, 1, 1)
      first_wday_of_year = reindex_sunday_week_to_monday_week(first_day_of_year.wday)

      return first_day_of_year if first_wday_of_year == 0 # first day of year is monday
      return Date.new(year - 1, 12, 31 - first_wday_of_year + 1) if first_wday_of_year < 4 # first day of year is tuesday wednesday or thursday
      return Date.new(year, 1, 7 - first_wday_of_year + 1) # first day of year is friday saturday or sunday
    end

    def self.nth_wday_of_month(n, wday, month, year = Time.now.year)
      return last_wday_of_month(wday, month, year) if n == -1

      first_day_of_month = Date.new(year, month, 1)
      first_wday_of_month = reindex_sunday_week_to_monday_week(first_day_of_month.wday)

      date =
        if wday == first_wday_of_month
          # first day of the month is the weekday we are looking for

          first_day_of_month + (n - 1) * 7
        elsif wday < first_wday_of_month
          # first day of the month is after (in the week) than the weekday we are looking for
          # so we look in the next week

          last_monday_of_previous_month = first_day_of_month - first_wday_of_month
          first_monday_of_the_month = last_monday_of_previous_month + 7

          first_monday_of_the_month + wday + (n - 1) * 7
        else
          # first day of the month is before (in the week) than the weekday we are looking for
          # so we look in the current week

          first_day_of_the_week = first_day_of_month - first_wday_of_month
          first_day_of_the_week + wday + (n - 1) * 7
        end
      raise 'Out of bound' unless date.month == month

      date
    end

    def self.last_wday_of_month(wday, month, year = Time.now.year)
      last_day_of_month = Date.new(year, month, last_day_of_month(month - 1, year))
      last_wday_of_month = reindex_sunday_week_to_monday_week(last_day_of_month.wday)

      date =
        if wday == last_wday_of_month
          # last day of the month is the weekday we are looking for

          last_day_of_month
        elsif wday > last_wday_of_month
          # last day of the month is before (in the week) than the weekday we are looking for
          # so we look in the current week

          previous_week_monday = last_day_of_month - last_wday_of_month - 7
          previous_week_monday + wday
        else
          # last day of the month is after (in the week) than the weekday we are looking for
          # so we look in the previous week

          first_day_of_the_week = last_day_of_month - last_wday_of_month
          first_day_of_the_week + wday
        end
      raise 'Out of bound' unless date.month == month

      date
    end
  end
end
