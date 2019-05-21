require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class OpeningHoursRule
    include Constants
    attr_accessor :date, :time, :comment, :is_defined_off

    def initialize
      @date = []
      @time = []
      @is_defined_off = false
      @comment = ''
    end

    def get
      result = ''

      result += get_wide_selector if !@date.empty?

      if !@date.empty?
        wd = @date[0].get_weekdays
        result += " #{wd}" if !wd.empty?
      end
      if @is_defined_off
        result += ' off'
      elsif !@time.empty?
        result += ' '
        @time.uniq.each_with_index do |t, i|
          result += ',' if i > 0
          result += t.get
        end
      else
        result += ' off'
      end

      rgx_day = /(Mo|Tu|We|Th|Fr|Sa|Su)/

      if result.strip == '00:00-24:00' || (!(result =~ /00:00-24:00/).nil? && (result =~ rgx_day).nil?)
        result.gsub!('00:00-24:00', '24/7')
      end

      result += " #{comment}" if !comment.nil? && !comment.empty?

      result.strip
    end

    def get_wide_selector
      if @date.length == 1 && @date[0].wide_interval.type == 'holiday'
        if @date[0].wide_interval.start[:year].nil?
          return 'PH'
        else
          if @date[0].wide_interval.end && @date[0].wide_interval.end[:year]
            return "#{@date[0].wide_interval.start[:year]}-#{@date[0].wide_interval.end[:year]} PH"
          else
            return "#{@date[0].wide_interval.start[:year]} PH"
          end
        end
      end
      years = OpeningHoursConverter::Year.build_day_array_from_dates(@date)
      year_start = -1
      month_start = -1
      day_start = -1

      result = {}

      if !years['always'].nil?
        always = years.delete('always')

        always.each_with_index do |month_array, month|
          month_array.each_with_index do |day_bool, day|
            if day_bool && month_start < 0
              month_start = month
              day_start = day
            end
            if day_bool && month_start >= 0 && month == 11 && day == 30
              result['always'] ||= []
              result['always'] << { start: { day: day_start, month: month_start }, end: { day: 30, month: 11 } }
              month_start = -1
              day_start = -1
            elsif !day_bool && month_start >= 0
              result['always'] ||= []
              end_res = day == 0 ?
                month == 0 ?
                  { day: 30, month: 11 } : { day: MONTH_END_DAY[month - 1] - 1, month: month - 1 } :
                { day: day - 1, month: month }
              result['always'] << { start: { day: day_start, month: month_start }, end: end_res }
              month_start = -1
              day_start = -1
            end
          end
        end
      end

      years.each do |year, months|
        months.each_with_index do |month_array, month|
          month_array.each_with_index do |day_bool, day|
            if day_bool && year_start < 0
              year_start = year
              month_start = month
              day_start = day
            end
            if day_bool && year_start >= 0 && month == 11 && day == 30 && years[year + 1].nil?
              if year_start == year
                result[year] ||= []
                result[year] << { start: { day: day_start, month: month_start }, end: { day: 30, month: 11 } }
              else
                result['multi_year'] ||= {}
                result['multi_year']["#{year_start}-#{year}"] ||= []
                result['multi_year']["#{year_start}-#{year}"] << { start: { day: day_start, month: month_start, year: year_start },
                                                                   end: { day: 30, month: 11, year: year } }
              end
              year_start = -1
              month_start = -1
              day_start = -1
            elsif !day_bool && year_start >= 0
              end_res = {}

              end_res = if day == 0
                          if month == 0
                            { day: 30, month: 11 }
                          else
                            { day: MONTH_END_DAY[month - 1] - 1, month: month - 1 }
                                    end
                        else
                          { day: day - 1, month: month }
                        end

              if year_start == year
                result[year] ||= []
                result[year] << { start: { day: day_start, month: month_start }, end: end_res }
              else
                result['multi_year'] ||= {}
                result['multi_year']["#{year_start}-#{year}"] ||= []
                end_res[:year] = year
                result['multi_year']["#{year_start}-#{year}"] << { start: { day: day_start, month: month_start, year: year_start },
                                                                   end: end_res }
              end
              year_start = -1
              month_start = -1
              day_start = -1
            end
          end
        end
      end

      result_to_string(result)
    end

    def result_to_string(result)
      str_result = ''
      result.each do |selector, intervals|
        if selector == 'always'
          intervals.each do |interval|
            str_result += ',' if !str_result.empty?
            if is_full_year?(interval)
            elsif is_full_month?(interval)
              str_result += (OSM_MONTHS[interval[:start][:month]]).to_s
            elsif starts_month?(interval) && ends_month?(interval)
              str_result += "#{OSM_MONTHS[interval[:start][:month]]}-#{OSM_MONTHS[interval[:end][:month]]}"
            elsif is_same_month?(interval)
              if is_same_day?(interval)
                str_result += "#{OSM_MONTHS[interval[:start][:month]]} #{interval[:start][:day] + 1 < 10 ? "0#{interval[:start][:day] + 1}" : interval[:start][:day] + 1}"
              else
                str_result += "#{OSM_MONTHS[interval[:start][:month]]} #{interval[:start][:day] + 1 < 10 ? "0#{interval[:start][:day] + 1}" : interval[:start][:day] + 1}-#{interval[:end][:day] + 1 < 10 ? "0#{interval[:end][:day] + 1}" : interval[:end][:day] + 1}"
              end
            else
              str_result += "#{OSM_MONTHS[interval[:start][:month]]} #{interval[:start][:day] + 1 < 10 ? "0#{interval[:start][:day] + 1}" : interval[:start][:day] + 1}-#{OSM_MONTHS[interval[:end][:month]]} #{interval[:end][:day] + 1 < 10 ? "0#{interval[:end][:day] + 1}" : interval[:end][:day] + 1}"
            end
          end
        elsif selector == 'multi_year'
          intervals.each do |_years, intervals|
            intervals.each do |interval|
              str_result += ',' if !str_result.empty?
              if starts_year?(interval) && ends_year?(interval)
                str_result += "#{interval[:start][:year]}-#{interval[:end][:year]}"
              # elsif starts_month?(interval) && ends_month?(interval)
              #   str_result += "#{interval[:start][:year]} #{OSM_MONTHS[interval[:start][:month]]}-#{interval[:end][:year]} #{OSM_MONTHS[interval[:end][:month]]}"
              else
                str_result += "#{interval[:start][:year]} #{OSM_MONTHS[interval[:start][:month]]} #{interval[:start][:day] + 1 < 10 ? "0#{interval[:start][:day] + 1}" : interval[:start][:day] + 1}-#{interval[:end][:year]} #{OSM_MONTHS[interval[:end][:month]]} #{interval[:end][:day] + 1 < 10 ? "0#{interval[:end][:day] + 1}" : interval[:end][:day] + 1}"
              end
            end
          end
        else
          local_str = "#{selector} "
          intervals.each do |interval|
            if is_full_year?(interval)
              # elsif
              # local_str += "#{local_str.length > 5 ? "," : ""}#{OSM_MONTHS[interval[:start][:month]]}"
              # elsif
              # local_str += "#{local_str.length > 5 ? "," : ""}#{OSM_MONTHS[interval[:start][:month]]}-#{OSM_MONTHS[interval[:end][:month]]}"
            elsif is_same_month?(interval)
              if is_same_day?(interval)
                local_str += "#{local_str.length > 5 ? ',' : ''}#{OSM_MONTHS[interval[:start][:month]]} #{interval[:start][:day] + 1 < 10 ? "0#{interval[:start][:day] + 1}" : interval[:start][:day] + 1}"
              else
                local_str += "#{local_str.length > 5 ? ',' : ''}#{OSM_MONTHS[interval[:start][:month]]} #{interval[:start][:day] + 1 < 10 ? "0#{interval[:start][:day] + 1}" : interval[:start][:day] + 1}-#{interval[:end][:day] + 1 < 10 ? "0#{interval[:end][:day] + 1}" : interval[:end][:day] + 1}"
              end
            else
              local_str += "#{local_str.length > 5 ? ',' : ''}#{OSM_MONTHS[interval[:start][:month]]} #{interval[:start][:day] + 1 < 10 ? "0#{interval[:start][:day] + 1}" : interval[:start][:day] + 1}-#{selector} #{OSM_MONTHS[interval[:end][:month]]} #{interval[:end][:day] + 1 < 10 ? "0#{interval[:end][:day] + 1}" : interval[:end][:day] + 1}"
            end
          end
          str_result += "#{!str_result.empty? ? ',' : ''}#{local_str}"
        end
      end

      str_result.strip
    end

    def is_full_year?(r)
      starts_year?(r) && ends_year?(r)
    end

    def is_full_month?(r)
      is_same_month?(r) && starts_month?(r) && ends_month?(r)
    end

    def is_same_year?(r)
      r[:start][:year] == r[:end][:year]
    end

    def is_same_month?(r)
      r[:start][:month] == r[:end][:month]
    end

    def is_same_day?(r)
      r[:start][:day] == r[:end][:day]
    end

    def starts_month?(r)
      r[:start][:day] == 0
    end

    def ends_month?(r)
      r[:end][:day] == MONTH_END_DAY[r[:end][:month]] - 1
    end

    def starts_year?(r)
      r[:start][:month] == 0 && starts_month?(r)
    end

    def ends_year?(r)
      r[:end][:month] == 11 && ends_month?(r)
    end

    def same_time?(o)
      if o.nil? || o.time.length != @time.length || @is_defined_off != o.is_defined_off
        false
      else
        @time.each_with_index do |t, i|
          return false if !t.equals(o.time[i])
        end
        true
      end
    end

    def same_date?(o)
      if o.nil? || o.date.length != @date.length
        false
      else
        @date.each_with_index do |d, i|
          return false if !d.wide_interval.equals(o.date[i].wide_interval)
        end
        true
      end
    end

    def equals(o)
      return false unless o.instance_of?(OpeningHoursConverter::OpeningHoursRule)
      (same_time?(o) && same_date?(o))
    end

    def is_off?
      @time.empty? || (@time.length == 1 && time[0].start.nil?)
    end

    def has_overwritten_weekday?
      !@date.empty? && !@date[0].weekdays_over.empty?
    end

    def add_weekday(weekday)
      @date.each do |d|
        d.add_weekday(weekday)
      end
    end

    def add_ph_weekday
      @date.each(&:add_ph_weekday)
    end

    def add_overwritten_weekday(weekday)
      @date.each do |d|
        d.add_overwritten_weekday(weekday)
      end
    end

    def add_date(date)
      if date.nil? || !date.instance_of?(OpeningHoursConverter::OpeningHoursDate)
        raise ArgumentError
      end

      if @date.empty? || date.same_weekdays?(@date.first.weekdays)
        @date << date
      else
        if !@date.first.same_weekdays?(date.weekdays)
          raise ArgumentError, "This date #{@date.inspect} can't be added to this rule #{inspect}"
        end
      end
    end

    def include_time?(time)
      @time.each do |t|
        return true if t.start == time.start && t.end == time.end
      end
      false
    end

    def add_time(time)
      @time << time if (@time.empty? || @time[0].get != 'off') && !include_time?(time)
    end

    def add_comment(comment)
      @comment = comment
    end
  end
end
