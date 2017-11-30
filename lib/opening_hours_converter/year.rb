require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class Year
    include Constants

    def self.build_day_array_from_date_range(date_range, get_iterator=false)
      years = {}
      if date_range.is_holiday? && get_iterator
        if date_range.wide_interval.type == "holiday"
          if !date_range.wide_interval.start[:year].nil?
            if !date_range.wide_interval.end.nil?
              for year in date_range.wide_interval.start[:year]..date_range.wide_interval.end[:year]
                years[year] ||= Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
              end
              years = process_holidays(date_range.wide_interval, years)
            else
              years[date_range.wide_interval.start[:year]] ||= Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
              years = process_holidays(date_range.wide_interval, years)
            end
          else
            remove_holiday!(date_range)

            years = process_always_holiday(date_range.wide_interval, years)
          end
        else

        end
      end
      if !date_range.wide_interval.start.nil? && !date_range.wide_interval.start[:year].nil?
        if date_range.wide_interval.end.nil? || date_range.wide_interval.end[:year].nil? || date_range.wide_interval.start[:year] == date_range.wide_interval.end[:year]
          if !years[date_range.wide_interval.start[:year]].nil?
            years = process_single_year(date_range.wide_interval, years)
          else
            years[date_range.wide_interval.start[:year]] = Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
            years = process_single_year(date_range.wide_interval, years)
          end
        else
          for year in date_range.wide_interval.start[:year]..date_range.wide_interval.end[:year]
            years[year] ||= Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
          end
          process_multiple_years(date_range.wide_interval, years)
        end
      else
        unless get_iterator
          years["always"] ||= Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
        end
        years = process_always(date_range.wide_interval, years, get_iterator)
      end
      years
    end

    def self.process_holidays(wide_interval, years)
      if !wide_interval.end[:year].nil?
        holidays = {}
        for year in wide_interval.start[:year]..wide_interval.end[:year]
          PublicHoliday.ph_for_year(year).each do |ht|
            years[year][ht.month-1][ht.day-1] = true
          end
        end
      else
        PublicHoliday.ph_for_year(wide_interval.start[:year]).each do |ht|
          years[wide_interval.start[:year]][ht.month-1][ht.day-1] = true
        end
      end
      years
    end

    def self.process_always_holiday(wide_interval, years)
      for year in (DateTime.now.year - 1)..(DateTime.now.year + 5)
        years[year] ||= Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
        PublicHoliday.ph_for_year(year).each do |ht|
          years[year][ht.month-1][ht.day-1] = true
        end
      end
      years
    end

    def self.remove_holiday!(date_range)
      date_range.typical.intervals.each_with_index do |interval, interval_index|
        date_range.remove_interval(interval_index) if interval.day_start == -2 && interval.day_end == -2
      end
    end

    def self.build_day_array_from_dates(dates, get_iterator=false)
      years = {}
      dates.each do |date|
        if !date.wide.start.nil? && !date.wide.start[:year].nil?
          if date.wide.end.nil? || date.wide.end[:year].nil? || date.wide.start[:year] == date.wide.end[:year]
            if !years[date.wide.start[:year]].nil?
              years = process_single_year(date.wide, years)
            else
              years[date.wide.start[:year]] = Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
              years = process_single_year(date.wide, years)
            end
          else
            for year in date.wide.start[:year]..date.wide.end[:year]
              years[year] ||= Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
            end
            process_multiple_years(date.wide, years)
          end
        else
          unless get_iterator
            years["always"] ||= Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
          end
          years = process_always(date.wide, years, get_iterator)
        end
      end
      years
    end

    def self.process_always(wide_interval, years, get_iterator=false)
      if !get_iterator
        if wide_interval.start.nil?
          years["always"] = Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { true } }
        elsif !wide_interval.start[:day].nil?
          if wide_interval.end.nil? || (wide_interval.end[:month].nil? && wide_interval.end[:day].nil?) ||
            (wide_interval.start[:month] == wide_interval.end[:month] && wide_interval.start[:day] == wide_interval.end[:day])
            years["always"][wide_interval.start[:month]-1][wide_interval.start[:day]-1] = true
          elsif wide_interval.start[:month] == wide_interval.end[:month]
            for day in wide_interval.start[:day]-1..wide_interval.end[:day]-1
              years["always"][wide_interval.start[:month]-1][day] = true
            end
          elsif wide_interval.start[:month] != wide_interval.end[:month]
            if wide_interval.end[:month] < wide_interval.start[:month]
              for month in wide_interval.start[:month]-1..11
                if month == wide_interval.start[:month]-1
                  for day in wide_interval.start[:day]-1...MONTH_END_DAY[month]
                    years["always"][month][day] = true
                  end
                else
                  for day in 0...MONTH_END_DAY[month]
                    years["always"][month][day] = true
                  end
                end
              end
              for month in 0..wide_interval.end[:month]-1
                if month == wide_interval.end[:month]-1
                  for day in 0..wide_interval.end[:day]-1
                    years["always"][month][day] = true
                  end
                else
                  for day in 0...MONTH_END_DAY[month]
                    years["always"][month][day] = true
                  end
                end
              end
            else
              for month in wide_interval.start[:month]-1..wide_interval.end[:month]-1
                if month == wide_interval.start[:month]-1
                  for day in wide_interval.start[:day]-1...MONTH_END_DAY[month]
                    years["always"][month][day] = true
                  end
                elsif month == wide_interval.end[:month]-1
                  for day in 0..wide_interval.end[:day]-1
                    years["always"][month][day] = true
                  end
                else
                  for day in 0...MONTH_END_DAY[month]
                    years["always"][month][day] = true
                  end
                end
              end
            end
          end
        elsif !wide_interval.start[:month].nil?
          if wide_interval.end.nil? || wide_interval.end[:month].nil? || wide_interval.start[:month] == wide_interval.end[:month]
            years["always"][wide_interval.start[:month]-1].each_with_index do |month, i|
              years["always"][wide_interval.start[:month]-1][i] = true
            end
          else
            for month in wide_interval.start[:month]-1..wide_interval.end[:month]-1
              years["always"][month].each_with_index do |day, i|
                years["always"][month][i] = true
              end
            end
          end
        end
      else
        for year in (DateTime.now.year - 1)..(DateTime.now.year + 5)
          if wide_interval.start.nil?
            years[year] = Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { true } }
          elsif !wide_interval.start[:day].nil?
            years[year] ||= Array.new(OSM_MONTHS.length) { |i| Array.new(MONTH_END_DAY[i]) { false } }
            if wide_interval.end.nil? || (wide_interval.end[:month].nil? && wide_interval.end[:day].nil?) ||
              (wide_interval.start[:month] == wide_interval.end[:month] && wide_interval.start[:day] == wide_interval.end[:day])
              years[year][wide_interval.start[:month]-1][wide_interval.start[:day]-1] = true
            elsif wide_interval.start[:month] == wide_interval.end[:month]
              for day in wide_interval.start[:day]-1..wide_interval.end[:day]-1
                years[year][wide_interval.start[:month]-1][day] = true
              end
            elsif wide_interval.start[:month] != wide_interval.end[:month]
              for month in wide_interval.start[:month]-1..wide_interval.end[:month]-1
                if month == wide_interval.start[:month]-1
                  for day in wide_interval.start[:day]-1...MONTH_END_DAY[month]
                    years[year][month][day] = true
                  end
                elsif month == wide_interval.end[:month]-1
                  for day in 0..wide_interval.end[:day]-1
                    years[year][month][day] = true
                  end
                else
                  for day in 0...MONTH_END_DAY[month]
                    years[year][month][day] = true
                  end
                end
              end
            end
          elsif !wide_interval.start[:month].nil?
            if wide_interval.end.nil? || wide_interval.end[:month].nil? || wide_interval.start[:month] == wide_interval.end[:month]
              years[year][wide_interval.start[:month]-1].each_with_index do |month, i|
                years[year][wide_interval.start[:month]-1][i] = true
              end
            else
              for month in wide_interval.start[:month]-1..date.wide.end[:month]-1
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

    def self.process_multiple_years(wide_interval, years)
      if wide_interval.type == "year"
        for year in wide_interval.start[:year]..wide_interval.end[:year]
          years[year].each_with_index do |month,i|
            month.each_with_index do |day,j|
              years[year][i][j] = true
            end
          end
        end
      elsif wide_interval.type == "month"
        for year in wide_interval.start[:year]..wide_interval.end[:year]
          if year == wide_interval.start[:year]
            for month in wide_interval.start[:month]-1..11
              years[year][month].each_with_index do |day, i|
                years[year][month][i] = true
              end
            end
          elsif year == wide_interval.end[:year]
            for month in 0..wide_interval.end[:month]-1
              years[year][month].each_with_index do |day, i|
                years[year][month][i] = true
              end
            end
          else
            for month in 0..11
              years[year][month].each_with_index do |day, i|
                years[year][month][i] = true
              end
            end
          end
        end
      elsif wide_interval.type == "day"
        for year in wide_interval.start[:year]..wide_interval.end[:year]
          if year == wide_interval.start[:year]
            for month in wide_interval.start[:month]-1..11
              if month == wide_interval.start[:month]-1
                for day in wide_interval.start[:day]-1...MONTH_END_DAY[month]
                  years[year][month][day] = true
                end
              else
                for day in 0...MONTH_END_DAY[month]
                  years[year][month][day] = true
                end
              end
            end
          elsif year == wide_interval.end[:year]
            for month in 0..wide_interval.end[:month]-1
              if month == wide_interval.end[:month]-1
                for day in 0..wide_interval.end[:day]-1
                  years[year][month][day] = true
                end
              else
                for day in 0...MONTH_END_DAY[month]
                  years[year][month][day] = true
                end
              end
            end
          else
            for month in 0..11
              for day in 0...MONTH_END_DAY[month]
                years[year][month][day] = true
              end
            end
          end
        end
      end
      return years
    end

    def self.process_single_year(wide_interval, years, always=false)
      if wide_interval.type == "year"
        years[wide_interval.start[:year]].each_with_index do |month,i|
          month.each_with_index do |day,j|
            years[wide_interval.start[:year]][i][j] = true
          end
        end
      elsif wide_interval.type == "month"
        if wide_interval.end.nil? || wide_interval.end[:month].nil? || wide_interval.start[:month] == wide_interval.end[:month]
          years[wide_interval.start[:year]][wide_interval.start[:month]-1].each_with_index do |month, i|
            years[wide_interval.start[:year]][wide_interval.start[:month]-1][i] = true
          end
        else
          for month in wide_interval.start[:month]-1..wide_interval.end[:month]-1
            years[wide_interval.start[:year]][month].each_with_index do |day, i|
              years[wide_interval.start[:year]][month][i] = true
            end
          end
        end
      elsif wide_interval.type == "day"
        if wide_interval.end.nil? || !wide_interval.end.nil? && wide_interval.start[:month] == wide_interval.end[:month]
          if wide_interval.end.nil? || !wide_interval.end.nil? && wide_interval.start[:day] == wide_interval.end[:day]
            years[wide_interval.start[:year]][wide_interval.start[:month]-1][wide_interval.start[:day]-1] = true
          else
            for day in wide_interval.start[:day]-1..wide_interval.end[:day]-1
              years[wide_interval.start[:year]][wide_interval.start[:month]-1][day] = true
            end
          end
        else
          for month in wide_interval.start[:month]-1..wide_interval.end[:month]-1
            if month == wide_interval.start[:month]-1
              for day in wide_interval.start[:day]-1...MONTH_END_DAY[month]
                years[wide_interval.start[:year]][month][day] = true
              end
            elsif month == wide_interval.end[:month]-1
              for day in 0..wide_interval.end[:day]-1
                years[wide_interval.start[:year]][month][day] = true
              end
            else
              for day in 0...MONTH_END_DAY[month]
                years[wide_interval.start[:year]][month][day] = true
              end
            end
          end
        end
      end
      return years
    end
  end
end
