module OpeningHoursConverter
  module Utils
    def reindex_sunday_week_to_monday_week(wday)
      (wday + 6) % 7
    end

    def timstring_as_minutes(time)
      values = time.split(':')
      values[0].to_i * 60 + values[1].to_i
    end

    def add_days_to_time(time, days)
      time + days * seconds_in_day
    end

    def day_difference(from, to)
      to - from
    end

    def week_difference(from, to)
      day_diff = to - from
      day_diff -= (day_diff % 7)
      (day_diff / 7).to_i
    end

    def seconds_in_day
      24 * 60 * 60
    end

    def leap_year?(year = Time.now.year)
      year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    end
  end
end
