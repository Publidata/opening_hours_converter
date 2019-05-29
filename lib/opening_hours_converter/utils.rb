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

    def leap_year?(year = Date.today.year)
      year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    end

    def last_day_of_month(month, year = Date.today.year)
      return [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month] unless leap_year?(year) && month == 1
      return 29
    end

    def time_to_datetime(time)
      DateTime.new(time.year, time.month, time.day, time.hour, time.min, time.sec, Rational(time.gmt_offset / 3600, 24))
    end

    def datetime_to_time(datetime)
      Time.new(datetime.year, datetime.month, datetime.day, datetime.hour, datetime.min, datetime.sec, datetime.zone)
    end
  end
end
