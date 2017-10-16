require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class OpeningHoursDate
    include Constants
    attr_accessor :weekdays, :weekdays_over
    attr_reader :wide_type, :wide

    def initialize(wide, wide_type, weekdays)
      if wide.nil? || wide_type.nil? || weekdays.nil?
        raise ArgumentError
      end

      @wide = wide
      @wide_type = wide_type
      @weekdays = weekdays.sort
      @weekdays_over = []
    end

    def get_weekdays
      result = ""
      wd = @weekdays.concat(@weekdays_over).sort.uniq

      if wd.length > 0 && wd.include?(6) && wd.include?(0) && (wd.include?(5) || wd.include?(1))
        start_we = 6
        i = wd.length - 2
        stop_looking = false

        while !stop_looking && i >= 0
          if wd[i] == wd[i+1] - 1
            start_we = wd[i]
            i -= 1
          else
            stop_looking = true
          end
        end

        i = 1
        stop_looking = false
        end_we = 0

        while !stop_looking && i < wd.length
          if wd[i-1] == wd[i] - 1
            end_we = wd[i]
            i += 1
          else
            stop_looking = true
          end
        end

        length = 7 - start_we + end_we + 1

        if length >= 3 && start_we > end_we
          if result.length > 0
            result += ","
          end
          result += "#{OSM_DAYS[start_we]}-#{OSM_DAYS[end_we]}"

          j=0
          while j < wd.length
            if wd[j] <= end_we || wd[j] >= start_we
              wd.slice!(j, 1)
            else
              j+=1
            end
          end
        end
      end

      if wd.length > 1 || (wd.length == 1 && wd[0] != -1)
        result += result.length > 0 ? ",#{OSM_DAYS[wd[0]]}" : OSM_DAYS[wd[0]]
        first_in_row = wd[0]
        for i in 1...wd.length
          if wd[i-1] != wd[i] - 1
            if first_in_row != wd[i-1]
              if wd[i-1] - first_in_row == 1
                result += ",#{OSM_DAYS[wd[i-1]]}"
              else
                result += "-#{OSM_DAYS[wd[i-1]]}"
              end
            end
            result += ",#{OSM_DAYS[wd[i]]}"
            first_in_row = wd[i]
          elsif i == wd.length - 1
            if wd[i] - first_in_row == 1
              result += ",#{OSM_DAYS[wd[i]]}"
            else
              result += "-#{OSM_DAYS[wd[i]]}"
            end
          end
        end
      end

      if result == "Mo-Su"
        result = ""
      end
      return result
    end

    def add_weekday(weekday)
      if !@weekdays.include?(weekday) && !@weekdays_over.include?(weekday)
        @weekdays << weekday
        @weekdays.sort!
      end
    end

    def add_overwritten_weekday(weekday)
      unless @weekdays_over.include?(weekday) && @weekdays_over.include?(weekday)
        @weekdays_over << weekday
        @weekdays_over.sort!
      end
    end

    def same_kind_as?(date)
      @wide_type == date.wide_type && date.same_weekdays?(@weekdays)
    end

    def same_weekdays?(weekdays)
      weekdays == @weekdays
    end

    def equals(o)
      o.instance_of?(OpeningHoursConverter::OpeningHoursDate) && @wide_type == o.wide_type && @wide == o.wide && o.same_weekdays?(@weekdays)
    end
  end
end
