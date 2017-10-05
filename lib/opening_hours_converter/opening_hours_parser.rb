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

      single_time = nil
      from = nil
      to = nil

      single_month = nil
      month_from = nil
      month_to = nil

      single_week = nil
      week_from = nil
      week_to = nil

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


        # get time selector
        from = nil
        to = nil
        times = []
        if current_token >= 0 && is_time?(tokens[current_token])
          time_selector = tokens[current_token]

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
          current_token -= 1
        end

        # get weekdays selector
        weekdays = []
        if time_selector == "24/7"
          weekdays << {from: 0, to: 6}
        elsif current_token >= 0 && is_weekday?(tokens[current_token])
          weekday_selector = tokens[current_token]
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
          current_token -= 1
        end

        weeks = []
        months = []
        if current_token >= 0
          wide_range_selector = tokens[0]
          for i in 1..current_token
            wide_range_selector += " #{tokens[i]}"
          end
          if wide_range_selector.length > 0
            wide_range_selector = wide_range_selector.gsub(/\:$/, '').split('week')
            month_selector = wide_range_selector[0].strip
            if month_selector.length == 0
              month_selector = nil
            end

            if wide_range_selector.length > 1
              week_selector = wide_range_selector[1].strip
              if week_selector.length == 0
                week_selector = nil
              end
            else
              week_selector = nil
            end

            if (!month_selector.nil? && !week_selector.nil?)
              raise ArgumentError, "unsupported simultaneous month and week selector"
            elsif !month_selector.nil?
              month_selector = month_selector.split(',')

              month_selector.each do |ms|
                if ms == "SH"
                elsif !(@RGX_MONTH =~ ms).nil?
                  single_month = ms.split('-')
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
                  months << {from: month_from, to: month_to}
                elsif !(@RGX_MONTHDAY =~ ms).nil?
                  single_month = ms.gsub(/\:$/, '').split('-')

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
                  months << {from_day: month_from, to_day: month_to}
                else
                  raise ArgumentError, "Unsupported month selector #{ms}"
                end
              end
            elsif !week_selector.nil?
              week_selector = week_selector.split(',')
              week_selector.each do |ws|
                single_week = ws.split('-')
                week_from = single_week[0].to_i
                if single_week.length > 1
                  week_to = single_week[1].to_i
                else
                  week_to = nil
                end
                weeks << {from: week_from, to: week_to}
              end
            else
              raise ArgumentError, "Invalid date selector"
            end
          end
        end
        if current_token == tokens.length - 1
          raise ArgumentError, "Unreadable string"
        end
        # puts "months : #{months}"
        # puts "weeks : #{weeks}"
        # puts "weekdays : #{weekdays}"
        # puts "times : #{times}"
        # puts "rule_modifier : #{rule_modifier}"

        date_ranges = []

        if months.length > 0
          months.each do |month|
            if !month[:from_day].nil?
              if !month[:to_day].nil?
                date_range = OpeningHoursConverter::WideInterval.new.day(month[:from_day][:day], month[:from_day][:month], month[:to_day][:day], month[:to_day][:month])
              else
                date_range = OpeningHoursConverter::WideInterval.new.day(month[:from_day][:day], month[:from_day][:month])
              end
              date_ranges << date_range
            else
              if !month[:to].nil?
                date_range = OpeningHoursConverter::WideInterval.new.month(month[:from], month[:to])
              else
                date_range = OpeningHoursConverter::WideInterval.new.month(month[:from])
              end
              date_ranges << date_range
            end
          end
        # elsif weeks.length > 0
        #   weeks.each do |week|
        #     if !week[:to].nil?
        #       date_range = OpeningHoursConverter::WideInterval.new.week(week[:from], week[:to])
        #     else
        #       date_range = OpeningHoursConverter::WideInterval.new.week(week[:from])
        #     end
        #     date_ranges << date_range
        #   end
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
      return result
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
        for wd in 0..weekdays[:from]
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
  end
end
