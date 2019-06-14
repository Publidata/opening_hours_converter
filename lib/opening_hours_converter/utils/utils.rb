module OpeningHoursConverter
  module Utils
    def month_index(month)
      %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].index(month) + 1
    end

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

    def consecutives?(array_of_int)
      return [] if array_of_int.nil? || array_of_int == []
      array_of_int.reduce(array_of_int.first - 1) do |reduced, value|
        return false unless reduced == value - 1
        reduced += 1
      end
    end

    def consecutives(array_of_int)
      array_of_int.reduce([]) do |reduced, value|
        if reduced == []
          reduced << value
        else
          if reduced.last.is_a?(Hash)
            if reduced.last[:to] == value - 1
              reduced.last[:to] = value
            else
              reduced << value
            end
          elsif reduced.last.is_a?(Integer)
            if reduced.last == value - 1
              from = reduced.last
              reduced[reduced.length - 1] = { from: from, to: value }
            else
              reduced << value
            end
          end
        end

        reduced
      end
    end

    def consecutives_with_modifiers(sorted_array_of_int)
      return [] if sorted_array_of_int.nil? || sorted_array_of_int == []

      with_modifiers = sorted_array_of_int.each_with_object([]) do |value, reduced|
        if reduced == []
          reduced << { from: value, to: value, modifier: 0 } if value.is_a?(Integer)
          reduced << value if value.is_a?(Hash)
        elsif value.is_a?(Hash)
          reduced << value
        elsif reduced.last.is_a?(Hash)
          if reduced.last.key?(:modifier)
            if reduced.last[:to] + reduced.last[:modifier] == value
              reduced.last[:to] = value
            elsif reduced.last[:modifier] == 0
              reduced.last[:modifier] = value - reduced.last[:to]
              reduced.last[:to] = value
            else
              if reduced.last[:from] + reduced.last[:modifier] == reduced.last[:to]
                last = reduced.slice!(-1)

                last[:from].step(last[:to], last[:modifier]) do |week|
                  reduced << week
                end
              end

              reduced << { from: value, to: value, modifier: 0 }
            end
          else
            reduced << value
          end
        elsif reduced.last.is_a?(Integer)
          reduced << { from: value, to: value, modifier: 0 }
        end
      end

      with_modifiers.each_with_index.map { |value, index|
        if value.is_a?(Hash) && value.key?(:modifier)
          if value[:modifier] == 0
            with_modifiers[index] = value[:from]
          end
        else
          value
        end
      }

      with_modifiers
    end
  end
end
