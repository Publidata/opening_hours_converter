require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class OpeningHoursDate
    include Constants
    attr_accessor :weekdays, :weekdays_over
    attr_reader :wide_interval

    def initialize(wide_interval, weekdays)
      if wide_interval.nil? || weekdays.nil? || !wide_interval.is_a?(OpeningHoursConverter::WideInterval)
        raise ArgumentError
      end

      @wide_interval = wide_interval
      @weekdays = weekdays.sort
      @weekdays_over = []
    end

    def get_weekdays
      result = ''
      weekdays = @weekdays.concat(@weekdays_over).sort.uniq

      if !weekdays.empty? && weekdays[0] == -2
        result = 'PH'
        weekdays.shift
      end

      if !weekdays.empty? && weekdays.include?(6) && weekdays.include?(0) && (weekdays.include?(5) || weekdays.include?(1))
        start_week_end = 6
        i = weekdays.length - 2
        stop_looking = false

        while !stop_looking && i >= 0
          if weekdays[i] == weekdays[i + 1] - 1
            start_week_end = weekdays[i]
            i -= 1
          else
            stop_looking = true
          end
        end

        i = 1
        stop_looking = false
        end_week_end = 0

        while !stop_looking && i < weekdays.length
          if weekdays[i - 1] == weekdays[i] - 1
            end_week_end = weekdays[i]
            i += 1
          else
            stop_looking = true
          end
        end

        length = 7 - start_week_end + end_week_end + 1

        if length >= 3 && start_week_end > end_week_end
          result += ',' if !result.empty?
          result += "#{OSM_DAYS[start_week_end]}-#{OSM_DAYS[end_week_end]}"

          j = 0
          while j < weekdays.length
            if weekdays[j] <= end_week_end || weekdays[j] >= start_week_end
              weekdays.slice!(j, 1)
            else
              j += 1
            end
          end
        end
      end

      if weekdays.length > 1 || (weekdays.length == 1 && weekdays[0] != -1)
        result += !result.empty? ? ",#{OSM_DAYS[weekdays[0]]}" : OSM_DAYS[weekdays[0]]
        first_in_row = weekdays[0]
        for i in 1...weekdays.length
          if weekdays[i - 1] != weekdays[i] - 1
            if first_in_row != weekdays[i - 1]
              result += if weekdays[i - 1] - first_in_row == 1
                          ",#{OSM_DAYS[weekdays[i - 1]]}"
                        else
                          "-#{OSM_DAYS[weekdays[i - 1]]}"
                        end
            end
            result += ",#{OSM_DAYS[weekdays[i]]}"
            first_in_row = weekdays[i]
          elsif i == weekdays.length - 1
            result += if weekdays[i] - first_in_row == 1
                        ",#{OSM_DAYS[weekdays[i]]}"
                      else
                        "-#{OSM_DAYS[weekdays[i]]}"
                      end
          end
        end
      end

      result = '' if result == 'Mo-Su'
      result
    end

    def add_weekday(weekday)
      return if @weekdays.include?(weekday) || @weekdays_over.include?(weekday)

      @weekdays << weekday
      @weekdays.sort!
    end

    def add_ph_weekday
      add_weekday(-2)
    end

    def add_overwritten_weekday(weekday)
      return if @weekdays_over.include?(weekday)

      @weekdays_over << weekday
      @weekdays_over.sort!
    end

    def same_kind_as?(date)
      @wide_interval.type == date.wide_interval.type && date.same_weekdays?(@weekdays)
    end

    def same_weekdays?(weekdays)
      weekdays == @weekdays
    end

    def equals(o)
      o.instance_of?(OpeningHoursConverter::OpeningHoursDate) && @wide_interval.type == o.wide_interval.type && @wide_interval.equals(o.wide_interval) && o.same_weekdays?(@weekdays)
    end
  end
end
