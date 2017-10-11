require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class OpeningHoursRule
    include Constants
    attr_accessor :date, :time

    def initialize
      @date = []
      @time = []
    end

    def get
      get_wide_selector if @date.length > 1
      result = ""
      if @date.length > 1 || @date[0]&.wide != ""
        @date.each_with_index do |d, i|
          if (i > 0)
            result += ","
          end
          result += d.wide.get_time_selector
        end
      end
      # if @date.length > 0
      #   m = @date[0].get_months
      #   if m.length > 0
      #     result += " #{m}"
      #   end
      # end
      if @date.length > 0
        wd = @date[0].get_weekdays
        if wd.length > 0
          result += " #{wd}"
        end
      end

      if @time.length > 0
        result += " "
        @time.each_with_index do |t, i|
          if (i > 0)
            result += ","
          end
          result += t.get
        end
      else
        result += " off"
      end
      if result.strip == "00:00-24:00"
        result = "24/7"
      end


      result = clean(result)
      result.strip
    end

    def get_wide_selector

      years = build_day_array

      year_start = -1
      month_start = -1
      day_start = -1

      result = []

      if !years["always"].nil?
        always = years.delete("always")

        always.each_with_index do |month_array, month|
          month_array.each_with_index do |day_bool, day|
            if day_bool && month_start < 0
              month_start = month
              day_start = day
            elsif day_bool && month_start >= 0 && month == 11 && day == 30
              result << {start: { day: day_start, month: month_start }, end: { day: 30, month: 11 }}
              month_start = -1
              day_start = -1
            elsif !day_bool && month_start >= 0
              end_res = day == 0 ?
                month == 0 ?
                  { day: 30, month: 11 } : { day: MONTH_END_DAY[month-1]-1, month: month-1 } :
                { day: day-1, month: month }
              result << { start: { day: day_start, month: month_start }, end: end_res }
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
            elsif day_bool && year_start >= 0 && month == 11 && day == 30
              result << {start: {day: day_start, month: month_start, year: year_start}, end: { day: 30, month: 11, year: year }}
              year_start = -1
              month_start = -1
              day_start = -1
            elsif !day_bool && year_start >= 0
              end_res = day == 0 ?
                month == 0 ?
                  { day: 30, month: 11, year: year } : { day: MONTH_END_DAY[month-1]-1, month: month-1, year: year } :
                {day: day-1, month: month, year: year}
              result << {start: {day: day_start, month: month_start, year: year_start}, end: end_res}
              year_start = -1
              month_start = -1
              day_start = -1
            end
          end
        end
      end
      result_to_string(result)
      binding.pry

    end

    def result_to_string(result)
      str_result = ""
      result.each do |r|
        if str_result.length > 0
          str_result += ","
        end
        if !r[:start][:year].nil?
          if is_full_year?(r)
            str_result += "#{r[:start][:year]}"
          elsif is_full_month?(r)
            str_result += "#{r[:start][:year]} #{OSM_MONTHS[r[:start][:month]]}"
          elsif starts_month?(r) && ends_month?(r)
            str_result += "#{r[:start][:year]} #{OSM_MONTHS[r[:start][:month]]}-#{OSM_MONTHS[r[:end][:month]]}"
          elsif starts_year?(r) && ends_year?(r)
            str_result += "#{r[:start][:year]}-#{OSM_MONTHS[r[:end][:year]]}"
          elsif is_same_year?(r) && is_same_month?(r)
            str_result += "#{r[:start][:year]} #{OSM_MONTHS[r[:start][:month]]} #{r[:start][:day]+1}-#{r[:end][:day]+1}"
          elsif is_same_year?(r)
            str_result += "#{r[:start][:year]} #{OSM_MONTHS[r[:start][:month]]} #{r[:start][:day]+1}-#{OSM_MONTHS[r[:end][:month]]} #{r[:end][:day]+1}"
          else
            str_result += "#{r[:start][:year]} #{OSM_MONTHS[r[:start][:month]]} #{r[:start][:day]+1}-#{r[:end][:year]} #{OSM_MONTHS[r[:end][:month]]} #{r[:end][:day]+1}"
          end
        else
          if is_full_month?(r)
            str_result += "#{OSM_MONTHS[r[:start][:month]]}"
          elsif starts_month?(r) && ends_month?(r)
            str_result += "#{OSM_MONTHS[r[:start][:month]]}-#{OSM_MONTHS[r[:end][:month]]}"
          elsif is_same_month?(r)
            str_result += "#{OSM_MONTHS[r[:start][:month]]} #{r[:start][:day]+1}-#{r[:end][:day]+1}"
          else
            str_result += "#{OSM_MONTHS[r[:start][:month]]} #{r[:start][:day]+1}-#{OSM_MONTHS[r[:end][:month]]} #{r[:end][:day]+1}"
          end
        end
      end
      str_result
    end

    def is_full_year?(r)
      is_same_year?(r) && starts_year?(r) && ends_month?(r)
    end

    def is_full_month?(r)
      is_same_year?(r) && is_same_month?(r) && starts_month?(r) && ends_month?(r)
    end

    def is_same_year?(r)
      r[:start][:year] == r[:end][:year]
    end

    def is_same_month?(r)
      r[:start][:month] == r[:end][:month]
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

    def build_day_array
      years = {}
      @date.each do |date|
        if !date.wide.start[:year].nil?
          if date.wide.end.nil? || date.wide.end[:year].nil? || date.wide.start[:year] == date.wide.end[:year]
            if !years[date.wide.start[:year]].nil?
              years = process_single_year(date, years)
            else
              years[date.wide.start[:year]] = Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
              years = process_single_year(date, years)
            end
          else
            for year in date.wide.start[:year]..date.wide.end[:year]
              if years[year].nil?
                years[year] = Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
              end
            end
            process_multiple_years(date, years)
          end
        else
          if years["always"].nil?
            years["always"] = Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
          end
          years = process_always(date, years)
        end
      end
      years
    end

    def process_always(date, years, get_iterator=false)
      if !get_iterator
        if !date.wide.start[:day].nil?
          if date.wide.end.nil? || (date.wide.end[:month].nil? && date.wide.end[:day].nil?) ||
            (date.wide.start[:month] == date.wide.end[:month] && date.wide.start[:day] == date.wide.end[:day])
            years["always"][date.wide.start[:month]-1][date.wide.start[:day]-1] = true
          elsif date.wide.start[:month] == date.wide.end[:month]
            for day in date.wide.start[:day]-1..date.wide.end[:day]-1
              years["always"][date.wide.start[:month]-1][day] = true
            end
          elsif date.wide.start[:month] != date.wide.end[:month]
            for month in date.wide.start[:month]-1..date.wide.end[:month]-1
              if month == date.wide.start[:month]-1
                for day in date.wide.start[:day]-1...MONTH_END_DAY[month]
                  years["always"][month][day] = true
                end
              elsif month == date.wide.end[:month]-1
                for day in 0..date.wide.end[:day]-1
                  years["always"][month][day] = true
                end
              else
                for day in 0...MONTH_END_DAY[month]
                  years["always"][month][day] = true
                end
              end
            end
          end
        elsif !date.wide.start[:month].nil?
          if date.wide.end.nil? || date.wide.end[:month].nil? || date.wide.start[:month] == date.wide.end[:month]
            years["always"][date.wide.start[:month]-1].each_with_index do |month, i|
              years["always"][date.wide.start[:month]-1][i] = true
            end
          else
            for month in date.wide.start[:month]-1..date.wide.end[:month]-1
              years["always"][month].each_with_index do |day, i|
                years["always"][month][i] = true
              end
            end
          end
        end
      else
        for year in DateTime.now.year..DateTime.now.year + 5
          if years[year].nil?
            years[year] = Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
          end
          if !date.wide.start[:day].nil?
            if date.wide.end.nil? || (date.wide.end[:month].nil? && date.wide.end[:day].nil?) ||
              (date.wide.start[:month] == date.wide.end[:month] && date.wide.start[:day] == date.wide.end[:day])
              years[year][date.wide.start[:month]-1][date.wide.start[:day]-1] = true
            elsif date.wide.start[:month] == date.wide.end[:month]
              for day in date.wide.start[:day]-1..date.wide.end[:day]-1
                years[year][date.wide.start[:month]-1][day] = true
              end
            elsif date.wide.start[:month] != date.wide.end[:month]
              for month in date.wide.start[:month]-1..date.wide.end[:month]-1
                if month == date.wide.start[:month]-1
                  for day in date.wide.start[:day]-1...MONTH_END_DAY[month]
                    years[year][month][day] = true
                  end
                elsif month == date.wide.end[:month]-1
                  for day in 0..date.wide.end[:day]-1
                    years[year][month][day] = true
                  end
                else
                  for day in 0...MONTH_END_DAY[month]
                    years[year][month][day] = true
                  end
                end
              end
            end
          elsif !date.wide.start[:month].nil?
            if date.wide.end.nil? || date.wide.end[:month].nil? || date.wide.start[:month] == date.wide.end[:month]
              years[year][date.wide.start[:month]-1].each_with_index do |month, i|
                years[year][date.wide.start[:month]-1][i] = true
              end
            else
              for month in date.wide.start[:month]-1..date.wide.end[:month]-1
                years[year][month].each_with_index do |day, i|
                  years[year][month][i] = true
                end
              end
            end
          end
        end
      end
      return years
    end

    def process_multiple_years(date, years)
      if date.wide.type == "year"
        for year in date.wide.start[:year]..date.wide.end[:year]
          years[year].each_with_index do |month,i|
            month.each_with_index do |day,j|
              years[year][i][j] = true
            end
          end
        end
      elsif date.wide.type == "month"
        for year in date.wide.start[:year]..date.wide.end[:year]
          if year == date.wide.start[:year]
            for month in date.wide.start[:month]-1..11
              years[year][month].each_with_index do |day, i|
                years[year][month][day] = true
              end
            end
          elsif year == date.wide.end[:year]
            for month in 0..date.wide.end[:month]-1
              years[year][month].each_with_index do |day, i|
                years[year][month][day] = true
              end
            end
          else
            for month in 0..11
              years[year][month].each_with_index do |day, i|
                years[year][month][day] = true
              end
            end
          end
        end
      elsif date.wide.type == "day"
        for year in date.wide.start[:year]..date.wide.end[:year]
          if year == date.wide.start[:year]
            for month in date.wide.start[:month]-1..11
              if month == date.wide.start[:month]-1
                for day in date.wide.start[:day]-1...MONTH_END_DAY[month]
                  years[year][month][day] = true
                end
              else
                for day in 0...MONTH_END_DAY[month]
                  years[year][month][day] = true
                end
              end
            end
          elsif year == date.wide.end[:year]
            for month in 0..date.wide.end[:month]-1
              if month == date.wide.end[:month]-1
                for day in 0..date.wide.end[:day]-1
                  years[year][month][day] = true
                end
              else
                for day in 0...MONTH_END_DAY[month]
                  years[year][month][day] = true
                end
              end
            end
          else
            for day in 0...MONTH_END_DAY[month]
              years[year][month][day] = true
            end
          end
        end
      end
      return years
    end

    def process_single_year(date, years, always=false)
      if date.wide.type == "year"
        years[date.wide.start[:year]].each_with_index do |month,i|
          month.each_with_index do |day,j|
            years[date.wide.start[:year]][i][j] = true
          end
        end
      elsif date.wide.type == "month"
        if date.wide.end.nil? || date.wide.end[:month].nil? || date.wide.start[:month] == date.wide.end[:month]
          years[date.wide.start[:year]][date.wide.start[:month]-1].each_with_index do |month, i|
            years[date.wide.start[:year]][date.wide.start[:month]-1][i] = true
          end
        else
          for month in date.wide.start[:month]-1..date.wide.end[:month]-1
            years[date.wide.start[:year]][month].each_with_index do |day, i|
              years[date.wide.start[:year]][month][i] = true
            end
          end
        end
      elsif date.wide.type == "day"
        if date.wide.start[:month] == date.wide.end[:month] || date.wide.end[:month].nil?
          if date.wide.start[:day] == date.wide.end[:day]
            years[date.wide.start[:year]][date.wide.start[:month]-1][date.wide.start[:day]-1] = true
          else
            for day in date.wide.start[:day]-1..date.wide.end[:day]-1
              years[date.wide.start[:year]][date.wide.start[:month]-1][date.wide.end[:day]-1] = true
            end
          end
        else
          for month in date.wide.start[:month]-1..date.wide.end[:month]-1
            if month == date.wide.start[:month]-1
              for day in date.wide.start[:day]-1...MONTH_END_DAY[month]
                years[date.wide.start[:year]][month][day] = true
              end
            elsif month == date.wide.end[:month]-1
              for day in 0..date.wide.end[:day]-1
                years[date.wide.start[:year]][month][day] = true
              end
            else
              for day in 0...MONTH_END_DAY[month]
                years[date.wide.start[:year]][month][day] = true
              end
            end
          end
        end
      end
      return years
    end

    def clean(result)
      result = remove_duplicate_year(result)
      result = remove_bad_spaces(result)
    end

    def remove_bad_spaces(result)
      return result if (result =~ /\,\s/).nil?
      return result.split(', ').join(',')
    end

    def remove_duplicate_year(result)
      return result if (result =~ /(\d{4})[^;]+(\1)/).nil? && (result =~ /(\d{4}\-\d{4})[^;]+(\1)/).nil?
      result_parts = result.split(';')
      sanitized_parts = []
      result_parts.each do |rp|

        # string with year range repeating separated by a comma
        if !(rp =~ /(\d{4}\-\d{4})\,(\1)/).nil?
          # binding.pry
          first_occurence = (rp =~ /(\d{4}\-\d{4})/)
          years = result[first_occurence...first_occurence + 9]

          sanitized_parts << years + rp[first_occurence + 10, rp.length].split(year).join('')

        # string with year repeating separrated by a comma
        elsif !(rp =~ /(\d{4})\,(\1)/).nil?
          # binding.pry
          first_occurence = (rp =~ /(\d{4})/)
          year = result[first_occurence...first_occurence + 4]

          sanitized_parts << year + rp[first_occurence + 5, rp.length].split(year).join('')

        # string with year range repeating
        elsif !(rp =~ /(\d{4}\-\d{4})[^;]+(\1)/).nil?
          # binding.pry
          first_occurence = (rp =~ /(\d{4}\-\d{4})/)
          years = result[first_occurence...first_occurence + 9]

          sanitized_parts << years + rp[first_occurence + 9, rp.length].split(year).join('')

        # string with year repeating
        elsif !(rp =~ /(\d{4})[^;]+(\1)/).nil?
          # binding.pry
          first_occurence = (rp =~ /(\d{4})/)
          year = result[first_occurence...first_occurence + 4]

          sanitized_parts << year + rp[first_occurence + 4, rp.length].split(year).join('')
        end
      end
      sanitized_parts.join('')
    end

    def same_time?(o)
      if o.nil? || o.time.length != @time.length
        return false
      else
        @time.each_with_index do |t, i|
          return false if !t.equals(o.time[i])
        end
        return true
      end
    end

    def is_off?
      @time.length == 0 || (@time.length == 1 && time[0].start.nil?)
    end

    def has_overwritten_weekday?
      @date.length > 0 && @date[0].weekdays_over.length > 0
    end

    def add_weekday(weekday)
      @date.each do |d|
        d.add_weekday(weekday)
      end
    end

    def add_overwritten_weekday(weekday)
      @date.each do |d|
        d.add_overwritten_weekday(weekday)
      end
    end

    # def add_date(date)
    #   if date.nil? || !date.instance_of?(OpeningHoursConverter::OpeningHoursYear)
    #     raise ArgumentError
    #   end

    #   if @date.length == 0
    #     @date << date
    #   elsif @date.first.same_kind_as?(date) && @date.same_weekdays(date)
    #     date.months.each do |month|
    #       @date.first.add_months(month)
    #     end
    #   else
    #     if @date.length != 1 || !@date.first.same_weekdays?(date.weekdays)
    #       raise ArgumentError, "This date #{@date.inspect} can't be added to this rule #{self.inspect}"
    #     end
    #   end
    # end

    def add_date(date)
      if date.nil? || !date.instance_of?(OpeningHoursConverter::OpeningHoursDate)
        raise ArgumentError
      end

      if @date.length == 0 || @date.first.wide_type != "always" && @date.first.same_kind_as?(date)
        @date << date
      else
        if @date.length != 1 || @date.first.wide_type != "always" || !@date.first.same_weekdays?(date.weekdays)
          raise ArgumentError, "This date #{@date.inspect} can't be added to this rule #{self.inspect}"
        end
      end
    end

    def add_time(time)
      if (@time.length == 0 || @time[0].get != "off") && !@time.include?(time)
        @time << time
      else
        raise ArgumentError, "This time can't be added to this rule"
      end
    end
  end
end
