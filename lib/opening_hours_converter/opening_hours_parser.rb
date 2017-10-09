require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class OpeningHoursParser
    include Constants
    attr_accessor :RGX_RULE_MODIFIER, :RGX_WEEK_KEY, :RGX_WEEK_VAL, :RGX_MONTH, :RGX_MONTHDAY, :RGX_TIME, :RGX_WEEKDAY, :RGX_HOLIDAY, :RGX_WD
    def initialize
      @RGX_RULE_MODIFIER = /^(open|closed|off)$/i
      @RGX_WEEK_KEY = /^week$/
      @RGX_WEEK_VAL = /^([01234]?[0-9]|5[0123])(\-([01234]?[0-9]|5[0123]))?(,([01234]?[0-9]|5[0123])(\-([01234]?[0-9]|5[0123]))?)*\:?$/
      @RGX_MONTH = /^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)(\-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))?\:?$/
      @RGX_MONTHDAY = /^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ([012]?[0-9]|3[01])(\-((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) )?([012]?[0-9]|3[01]))?\:?$/
      @RGX_TIME = /^((([01]?[0-9]|2[01234])\:[012345][0-9](\-([01]?[0-9]|2[01234])\:[012345][0-9])?(,([01]?[0-9]|2[01234])\:[012345][0-9](\-([01]?[0-9]|2[01234])\:[012345][0-9])?)*)|(24\/7))$/
      @RGX_WEEKDAY = /^(((Mo|Tu|We|Th|Fr|Sa|Su)(\-(Mo|Tu|We|Th|Fr|Sa|Su))?)|(PH|SH|easter))(,(((Mo|Tu|We|Th|Fr|Sa|Su)(\-(Mo|Tu|We|Th|Fr|Sa|Su))?)|(PH|SH|easter)))*$/
      @RGX_HOLIDAY = /^(PH|SH|easter)$/
      @RGX_WD = /^(Mo|Tu|We|Th|Fr|Sa|Su)(\-(Mo|Tu|We|Th|Fr|Sa|Su))?$/
      @RGX_YEAR = /^(\d{4})(\-(\d{4}))?$/
      @RGX_YEAR_MONTH_DAY = /^(\d{4}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ([012]?[0-9]|3[01])(\-((\d{4}) )?((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) )?([012]?[0-9]|3[01]))?\:?$/
      @RGX_YEAR_MONTH = /^(\d{4}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)(\-((\d{4}) )?((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)))?\:?$/
    end

    def parse(oh)
      result = []
      blocks = oh.split(';')

      rule_modifier = nil
      time_selector = nil
      weekday_selector = nil
      wide_range_selector = nil
      month_selector = nil

      times = nil
      weekdays = nil
      weeks = nil
      months = nil
      years = nil

      date_ranges = nil
      date_range = nil
      dr_obj = nil
      res_dr_id = nil

      blocks.each do |block|
        block.strip!
        next if block.length == 0

        tokens = tokenize(block)
        current_token = tokens.length - 1

        # get state
        if current_token >= 0 && is_rule_modifier?(tokens[current_token])
          rule_modifier = tokens[current_token].downcase
          current_token -= 1
        end

        times = []
        if current_token >= 0 && is_time?(tokens[current_token])
          time_selector = tokens[current_token]
          times = get_times(time_selector)
          current_token -= 1
        end

        # get weekdays selector
        weekdays = []
        if time_selector == "24/7"
          weekdays << {from: 0, to: 6}
        elsif current_token >= 0 && is_weekday?(tokens[current_token])
          weekday_selector = tokens[current_token]
          weekdays = get_weekdays(weekday_selector)
          current_token -= 1
        end

        # years = []
        # if current_token >= 0 && is_year?(tokens[current_token])
        #   year_selector = tokens[current_token]
        #   year_selector = year_selector.split(',')
        #   year_selector.each do |y|
        #     single_year = y.gsub(/\:$/, '').split('-')
        #     year_from = single_year[0]
        #     if single_year.length > 1
        #       year_to = single_year[1]
        #     else
        #       year_to = year_from
        #     end

        #     years << {from: year_from, to: year_to}
        #   end
        #   current_token -= 1
        # end

        months = []
        years = []
        if current_token >= 0

          wide_range_selector = tokens[0]
          for i in 1..current_token
            wide_range_selector += " #{tokens[i]}"
          end
          if wide_range_selector.length > 0
            wide_range_selector = wide_range_selector.strip
            wide_range_selector = wide_range_selector.split(',')
            wide_range_selector.each do |wrs|
              if !(@RGX_YEAR_MONTH_DAY =~ wrs).nil?
                years << get_year_month_day(wrs)
              elsif !(@RGX_YEAR_MONTH =~ wrs).nil?
                years << get_year_month(wrs)
              elsif !(@RGX_MONTHDAY =~ wrs).nil?
                months << get_month_day(wrs)
              elsif !(@RGX_MONTH =~ wrs).nil?
                months << get_month(wrs)
              elsif !(@RGX_YEAR =~ wrs).nil?
                years << get_year(wrs)
              else
                raise ArgumentError, "Unsupported selector #{wrs}"
              end
            end
          end
        end

        if current_token == tokens.length - 1
          raise ArgumentError, "Unreadable string"
        end
        # puts "months : #{months}"
        # puts "weekdays : #{weekdays}"
        # puts "times : #{times}"
        # puts "years : #{years}"
        # puts "rule_modifier : #{rule_modifier}"

        date_ranges = []
        if months.length > 0
          months.each do |month|
            if !month[:from_day].nil?
              if !month[:to_day].nil?
                date_range = OpeningHoursConverter::WideInterval.new.day(month[:from_day][:day], month[:from_day][:month], month[:from_day][:year],
                  month[:to_day][:day], month[:to_day][:month], month[:to_day][:year])
              else
                date_range = OpeningHoursConverter::WideInterval.new.day(month[:from_day][:day], month[:from_day][:month], month[:from_day][:year])
              end
              date_ranges << date_range
            else
              if !month[:to].nil?
                date_range = OpeningHoursConverter::WideInterval.new.month(month[:from], nil, month[:to])
              else
                date_range = OpeningHoursConverter::WideInterval.new.month(month[:from])
              end
              date_ranges << date_range
            end
          end
        elsif years.length > 0
          years.each do |year|
            if !year[:from_day].nil?
              if !year[:to_day].nil?
                date_range = OpeningHoursConverter::WideInterval.new.day(year[:from_day][:day], year[:from_day][:month], year[:from_day][:year],
                  year[:to_day][:day], year[:to_day][:month], year[:to_day][:year])
              else
                date_range = OpeningHoursConverter::WideInterval.new.day(year[:from_day][:day], year[:from_day][:month], year[:from_day][:year])
              end
            elsif !year[:from_month].nil?
              if !year[:to_month].nil?
                date_range = OpeningHoursConverter::WideInterval.new.month(year[:from_month][:month], year[:from_month][:year],
                  year[:to_month][:month], year[:to_month][:year])
              else
                date_range = OpeningHoursConverter::WideInterval.new.month(year[:from_month][:month], year[:from_month][:year])
              end
            elsif !year[:from].nil?
              if !year[:to].nil?
                date_range = OpeningHoursConverter::WideInterval.new.year(year[:from], year[:to])
              else
                date_range = OpeningHoursConverter::WideInterval.new.year(year[:from])
              end
            end
            date_ranges << date_range
          end
        else
          date_ranges << OpeningHoursConverter::WideInterval.new.always
        end

        if weekdays.length == 0
          weekdays << {from: 0, to: OSM_DAYS.length - 1}
        end

        if times.length == 0
          times << {from: 0, to: 24*60}
        end

        # pasur
        date_ranges.each do |dr|
          found_date_range = false
          res_dr_id = 0

          while res_dr_id < result.length && !found_date_range
            if result[res_dr_id].wide_interval.equals(dr)
              found_date_range = true
            else
              res_dr_id += 1
            end
          end

          if found_date_range
            dr_obj = result[res_dr_id]
          else
            dr_obj = OpeningHoursConverter::DateRange.new(dr)

            general = -1
            for res_dr_id in 0...result.length
              if result[res_dr_id].is_general_for?(OpeningHoursConverter::DateRange.new(dr))
                general = res_dr_id
              end
            end
            if general >= 0
              dr_obj.typical.copy_intervals(result[general].typical.intervals)
            end
            result << dr_obj
          end

          for wd_id in 0...weekdays.length
            if weekdays[wd_id][:from] <= weekdays[wd_id][:to]
              for wd_rm in weekdays[wd_id][:from]..weekdays[wd_id][:to]
                if dr_obj.defines_typical_week?
                  dr_obj.typical.remove_intervals_during_day(wd_rm)
                else
                  dr_obj.typical.clear_intervals
                end
              end
            else
              for wd_rm in weekdays[wd_id][:from]..6
                if dr_obj.defines_typical_week?
                  dr_obj.typical.remove_intervals_during_day(wd_rm)
                else
                  dr_obj.typical.clear_intervals
                end
              end
              for wd_rm in 0..weekdays[wd_id][:to]
                if dr_obj.defines_typical_week?
                  dr_obj.typical.remove_intervals_during_day(wd_rm)
                else
                  dr_obj.typical.clear_intervals
                end
              end
            end

            for t_id in 0...times.length
              if rule_modifier == "closed" || rule_modifier == "off"
                remove_interval(dr_obj.typical, weekdays[wd_id], times[t_id])
              else
                add_interval(dr_obj.typical, weekdays[wd_id], times[t_id])
              end
            end
          end
        end
      end
      puts result.inspect
      return result
    end

    def get_year(wrs)
      single_year = wrs.gsub(/\:$/, '').split('-')
      year_from = single_year[0].to_i
      if year_from < 1
        raise ArgumentError, "Invalid year : #{single_year[0]}"
      end

      if single_year.length > 1
        year_to = single_year[1].to_i
        if year_to < 1
          raise ArgumentError, "Invalid year : #{single_year[1]}"
        end
      else
        year_to = nil
      end
      { from: year_from, to: year_to }
    end

    def get_month(wrs)
      single_month = wrs.gsub(/\:$/, '').split('-')
      month_from = OSM_MONTHS.find_index(single_month[0]) + 1
      if month_from < 1
        raise ArgumentError, "Invalid month : #{single_month[0]}"
      end

      if single_month.length > 1
        month_to = OSM_MONTHS.find_index(single_month[1]) + 1
        if month_to < 1
          raise ArgumentError, "Invalid month : #{single_month[1]}"
        end
      else
        month_to = month_from
      end
      { from: month_from, to: month_to}
    end

    def get_month_day(wrs)
      single_month = wrs.gsub(/\:$/, '').split('-')

      month_from = single_month[0].split(' ')
      month_from = { day: month_from[1].to_i, month: OSM_MONTHS.find_index(month_from[0]) + 1 }
      if month_from[:month] < 1
        raise ArgumentError, "Invalid month : #{month_from.inspect}"
      end

      if single_month.length > 1
        month_to = single_month[1].split(' ')
        month_to = { day: month_to[1].to_i, month: OSM_MONTHS.find_index(month_to[0]) + 1 }
        if month_to[:month] < 1
          raise ArgumentError, "Invalid month : #{month_to.inspect}"
        end
      else
        month_to = nil
      end
      { from_day: month_from, to_day: month_to }
    end

    def get_year_month(wrs)
      single_year_month = wrs.gsub(/\:$/, '').split('-')
      year_month_from = single_year_month[0].split(' ')
      year_month_from = { month: OSM_MONTHS.find_index(year_month_from[1]) + 1, year: year_month_from[0].to_i }
      if year_month_from.length < 1
        raise ArgumentError, "Invalid year_month : #{year_month_from.inspect}"
      end
      if single_year_month.length > 1
        year_month_to = single_year_month[1].split(' ')
        if year_month_to.length == 2
          year_month_to = { month: OSM_MONTHS.find_index(year_month_to[1]) + 1, year: year_month_to[0].to_i }
        elsif year_month_to.length == 1
          year_month_to = { month: OSM_MONTHS.find_index(year_month_to[0]) + 1, year: year_month_from[:year] }
        end
        if year_month_to.length < 1
          raise ArgumentError, "Invalid year_month : #{year_month_to.inspect}"
        end
      else
        year_month_to = nil
      end
      { from_month: year_month_from, to_month: year_month_to }
    end

    def get_year_month_day(wrs)
      single_year_month_day = wrs.gsub(/\:$/, '').split('-')
      year_month_day_from = single_year_month_day[0].split(' ')
      year_month_day_from = { day: year_month_day_from[2].to_i,
        month: OSM_MONTHS.find_index(year_month_day_from[1]) + 1,
        year: year_month_day_from[0].to_i }
      if year_month_day_from.length < 1
        raise ArgumentError, "Invalid year_month_day : #{year_month_day_from.inspect}"
      end
      if single_year_month_day.length > 1
        year_month_day_to = single_year_month_day[1].split(' ')
        if year_month_day_to.length == 3
          year_month_day_to = { day: year_month_day_to[2].to_i,
            month: OSM_MONTHS.find_index(year_month_day_to[1]) + 1,
            year: year_month_day_to[0].to_i }
        elsif year_month_day_to.length == 2
          year_month_day_to = { day: year_month_day_to[1].to_i,
            month: OSM_MONTHS.find_index(year_month_day_to[0]) + 1,
            year: year_month_day_from[:year] }
        elsif year_month_day_to.length == 1
          year_month_day_to = { day: year_month_day_to[0].to_i,
            month: year_month_day_from[:month],
            year: year_month_day_from[:year] }
        end
        if year_month_day_to.length < 1
          raise ArgumentError, "Invalid year_month_day : #{year_month_day_to.inspect}"
        end
      else
        year_month_day_to = nil
      end

      { from_day: year_month_day_from, to_day: year_month_day_to }
    end

    def get_times(time_selector)
      times = []
      from = nil
      to = nil
      if time_selector == "24/7"
        times << {from: 0, to: 24*60}
      else
        time_selector = time_selector.split(',')
        time_selector.each do |ts|
          single_time = ts.split('-')
          from = as_minutes(single_time[0])
          if single_time.length > 1
            to = as_minutes(single_time[1])
          else
            to = from
          end
          times << {from: from, to: to}
        end
      end
      times
    end

    def get_weekdays(weekday_selector)
      weekdays = []
      wd_from = nil
      wd_to = nil

      weekday_selector = weekday_selector.split(',')
      weekday_selector.each do |wd|
        if !(@RGX_HOLIDAY =~ wd).nil?
        elsif !(@RGX_WD =~ wd).nil?
          single_weekday = wd.split('-')
          wd_from = OSM_DAYS.find_index(single_weekday[0])
          if single_weekday.length > 1
            wd_to = OSM_DAYS.find_index(single_weekday[1])
          else
            wd_to = wd_from
          end

          weekdays << {from: wd_from, to: wd_to}
        else
          raise ArgumentError, "Invalid weekday interval : #{wd}"
        end
      end

      weekdays
    end

    def remove_interval(typical, weekdays, times)
      if weekdays[:from] <= weekdays[:to]
        for wd in weekdays[:from]..weekdays[:to]
          typical.remove_intervals_during_day(wd)
        end
      else
        for wd in weekdays[:from]..6
          typical.remove_intervals_during_day(wd)
        end
        for wd in 0..weekdays[:to]
          typical.remove_intervals_during_day(wd)
        end
      end
    end

    def remove_interval_wd(typical, times, wd)
      if times[:to] >= times[:from]
        typical.remove_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd, times[:to]))
      else
        if wd < 6
          typical.remove_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd+1, times[:to]))
        else
          typical.remove_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd+1, 24*60))
          typical.remove_interval(OpeningHoursConverter::Interval.new(0, 0, 0, times[:to]))
        end
      end
    end

    def add_interval(typical, weekdays, times)
      if typical.instance_of?(OpeningHoursConverter::Day)
        if weekdays[:from] != 0 || (weekdays[:to] !=0 && times[:from] <= times[:to])
          weekdays = weekdays.dup
          weekdays[:from] = 0
          if times[:from] <= times[:to]
            weekdays[:to] = 0
          else
            weekdays[:to] = 1
          end
        end
      end

      if weekdays[:from] <= weekdays[:to]
        for wd in weekdays[:from]..weekdays[:to]
          add_interval_wd(typical, times, wd)
        end
      else
        for wd in weekdays[:from]..6
          add_interval_wd(typical, times, wd)
        end
        for wd in 0..weekdays[:to]
          add_interval_wd(typical, times, wd)
        end
      end
    end

    def add_interval_wd(typical, times, wd)
      if times[:to] >= times[:from]
        typical.add_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd, times[:to]))
      else
        if wd < 6
          typical.add_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd+1, times[:to]))
        else
          typical.add_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd+1, 24*60))
          typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 0, times[:to]))
        end
      end
    end

    def tokenize(block)
      block.split(' ')
    end

    def as_minutes(time)
      values = time.split(':')
      values[0].to_i * 60 + values[1].to_i
    end

    def is_rule_modifier?(token)
      !(@RGX_RULE_MODIFIER =~ token).nil?
    end
    def is_time?(token)
      !(@RGX_TIME =~ token).nil?
    end
    def is_weekday?(token)
      !(@RGX_WEEKDAY =~ token).nil?
    end
    def is_year?(token)
      !(@RGX_YEAR =~ token).nil?
    end
  end
end
