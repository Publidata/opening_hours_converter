require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class OpeningHoursYear
    include Constants
    attr_accessor :wide_type, :wide, :months, :days, :months_over, :weekdays, :weekdays_over

# wide_object = [
#   {start: {day: 1, month: 1, year: 2017}, end: {day: 10, month: 1, year: 2017}},
#   {start: {day: 13, month: 1, year: 2017}, end: {day: 10, month: 2, year: 2017}},
# ]


    def initialize(wide, wide_type, weekdays)
      if wide_year.nil? && wide_months.nil? && wide_days.nil? || wide_type.nil? || weekdays.nil?
        raise ArgumentError
      end

      @wide = wide
      @wide_type = wide_type
      @weekdays = weekdays.sort
      @weekdays_over = []
    end

    def parse_months(wide_months)
      months = []

      mis = wide_months.split(',')
      mis.each do |mi|
        single_month = mi.gsub(/\:$/, '').split('-')
        month_from = OSM_MONTHS.find_index(single_month[0]) + 1

        if single_month.length > 1
          month_to = OSM_MONTHS.find_index(single_month[1]) + 1
        else
          month_to = month_from
        end
        months << {start: month_from, end: month_to}
      end
      months
    end

    # def parse_months(wide_months)
    #   return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] if wide_months.length == 0
    #   months = []
    #   mis = wide_months.split(',')
    #   mis.each do |mi|
    #     single_month = mi.gsub(/\:$/, '').split('-')
    #     month_from = OSM_MONTHS.find_index(single_month[0]) + 1

    #     if single_month.length > 1
    #       month_to = OSM_MONTHS.find_index(single_month[1]) + 1
    #     else
    #       month_to = month_from
    #     end
    #     for i in month_from..month_to
    #       months << i
    #     end
    #   end
    #   months
    # end

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

    def get_months
      result = ""
      # binding.pry
      m = @months.concat(@months_over).sort.uniq

      if m.length > 1 || (m.length == 1 && m[0][:start] != -1)
        result += result.length > 0 ? ",#{OSM_MONTHS[m[0]-1]}" : OSM_MONTHS[m[0]-1]
        first_in_row = m[0]
        for i in 1...m.length
          # not following months
          if m[i-1] != m[i] - 1
            if first_in_row != m[i-1]
              if m[i-1] - first_in_row == 1
                result += ",#{OSM_MONTHS[m[i-1]-1]}"
              else
                result += "-#{OSM_MONTHS[m[i-1]-1]}"
              end
            end
            result += ",#{OSM_MONTHS[m[i]-1]}"
            first_in_row = m[i]
          elsif i == m.length - 1
            if m[i] - first_in_row == 1
              result += ",#{OSM_MONTHS[m[i]-1]}"
            else
              result += "-#{OSM_MONTHS[m[i]-1]}"
            end
          end
        end
      end

      if result == "Jan-Dec"
        result = ""
      end
      return result
    end

    def add_month(month)
      if !@months.include?(month) && !@months_over.include?(month)
        @months << month
        @months.sort!
      end
    end

    def add_overwritten_month(month)
      unless @months_over.include?(month) && @months_over.include?(month)
        @months_over << month
        @months_over.sort!
      end
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

    def same_months?(months)
      months == @months
    end

    def equals(o)
      o.instance_of?(OpeningHoursConverter::OpeningHoursYear) &&
        @wide_type == o.wide_type && @wide_year == o.wide_year &&
        @wide_month == o.wide_month && @wide_days == o.wide_days && o.same_weekdays?(@weekdays)
    end
  end
end
