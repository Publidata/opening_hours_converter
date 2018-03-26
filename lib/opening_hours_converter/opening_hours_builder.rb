require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class OpeningHoursBuilder
    include Constants
    def build(date_ranges)
      rules = []

      oh_rules = nil
      oh_rule_added = nil
      range_general = nil
      range_general_for = nil
      day_ph = false
      off_day_ph = false

      date_ranges.each_with_index do |date_range, date_range_index|
        if !date_range.nil?
          if date_range.typical.intervals.length != 1
            date_range.typical.intervals.each_with_index do |interval, interval_id|
              if interval&.day_start == -2 && interval&.day_start == interval&.day_end
                if interval.is_off
                  off_day_ph = true
                else
                  day_ph = true
                end
                date_range.typical.remove_interval(interval_id)
              end
            end
          end

          range_general = nil
          range_general_for = nil
          range_general_id = date_range_index - 1

          while range_general_id >= 0 && range_general.nil?
            if !date_range.nil?
              general_for = date_ranges[range_general_id].is_general_for?(date_range)
              if date_ranges[range_general_id].has_same_typical?(date_range) && (date_ranges[range_general_id].wide_interval.equals(date_range.wide_interval) || general_for)
                range_general = range_general_id
              elsif general_for && date_ranges[range_general_id].defines_typical_week? && date_range.defines_typical_week?
                range_general_for = range_general_id
              end
            end
            range_general_id -= 1
          end

          if date_range_index == 0 || range_general.nil?
            if date_range.typical&.intervals&.length == 1 && date_range.typical&.intervals[0].day_start == -2 && date_range.typical&.intervals[0].day_end == -2
              oh_rules = build_holiday(date_range)
            elsif date_range.defines_typical_week?
              if !range_general_for.nil?
                oh_rules = build_week_diff(date_range, date_ranges[range_general_for])
              else
                oh_rules = build_week(date_range)
              end
            else
              oh_rules = build_day(date_range)
            end



            oh_rules.each_with_index do |rule, i|
              oh_rules[i].add_comment(date_range.comment)
            end


            oh_rules.map do |oh_rule|
              oh_rule_added = false
              rule_index = 0

              while !oh_rule_added && rule_index < rules.length
                if rules[rule_index].same_time?(oh_rule) && !rules[rule_index].equals(oh_rule) && rules[rule_index].comment == oh_rule.comment
                  begin
                    for date_id in 0...oh_rule.date.length
                      rules[rule_index].add_date(oh_rule.date[date_id])
                    end
                    oh_rule_added = true
                  rescue Exception => e
                    puts e
                    if oh_rule.date[0].wide_type == "holiday" && oh_rule.date[0].wide.get_time_selector == "PH"
                      rules[rule_index].add_ph_weekday
                      oh_rule_added = true
                    elsif rules[rule_index].date[0].wide_type == "holiday" && rules[rule_index].date[0].wide.get_time_selector == "PH"
                      oh_rule.add_ph_weekday
                      rules[rule_index] = oh_rule
                      oh_rule_added = true
                    else
                      rule_index += 1
                    end
                  end
                else
                  rule_index+=1
                end
              end

              if day_ph
                oh_rule.add_ph_weekday
              end

              if off_day_ph
                rules += build_off_holiday(date_range)
              end

              if !oh_rule_added
                rules << oh_rule
              end

              if oh_rule == oh_rules.last && oh_rule.has_overwritten_weekday?
                oh_rule_over = OpeningHoursConverter::OpeningHoursRule.new

                oh_rule.date.each do |date|
                  oh_rule_over.add_date(OpeningHoursConverter::OpeningHoursDate.new(date.wide, date.wide_type, date.weekdays_over))
                end
                oh_rule_over.add_time(OpeningHoursConverter::OpeningHoursTime.new)
                oh_rules << oh_rule_over
              end
            end
          end
        end
      end

      result = ""
      if rules.length == 0
        date_ranges.each do |dr|
          result += "#{dr.wide_interval.get_time_selector} off"
        end
      else
        rules.each_with_index do |rule, rule_index|
          if rule_index > 0
            result += "; "
          end
          result += rule.get
        end
      end

      return result.strip
    end

    def build_off_holiday(date_range)

      start_year = date_range.wide_interval.start&.key?(:year) ? date_range.wide_interval.start[:year] : date_range.wide_interval.start
      end_year = date_range.wide_interval.end&.key?(:year) ? date_range.wide_interval.end[:year] : date_range.wide_interval.end

      date_range = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.holiday("PH", start_year, end_year))

      rule = OpeningHoursConverter::OpeningHoursRule.new
      date = OpeningHoursConverter::OpeningHoursDate.new(date_range.wide_interval, date_range.wide_interval.type, [-1])
      rule.add_date(date)
      rule.is_defined_off = true

      return [ rule ]
    end

    def build_holiday(date_range)

      start_year = date_range.wide_interval.start&.key?(:year) ? date_range.wide_interval.start[:year] : date_range.wide_interval.start
      end_year = date_range.wide_interval.end&.key?(:year) ? date_range.wide_interval.end[:year] : date_range.wide_interval.end


      intervals = date_range.typical.get_intervals(true)
      date_range = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.holiday("PH", start_year, end_year))

      for i in 0..6
        intervals.each do |interval|
          if !interval.nil?
            date_range.typical.add_interval(OpeningHoursConverter::Interval.new(i, interval.start, i, interval.end, interval.is_off))
          end
        end
      end
      rule = OpeningHoursConverter::OpeningHoursRule.new
      date = OpeningHoursConverter::OpeningHoursDate.new(date_range.wide_interval, date_range.wide_interval.type, [-1])
      rule.add_date(date)

      date_range.typical.intervals.each do |interval|
        if !interval.nil?
          rule.add_time(OpeningHoursConverter::OpeningHoursTime.new(interval.start, interval.end))
          rule.is_defined_off = rule.is_defined_off || interval.is_off
        end
      end


      return [ rule ]
    end

    def build_day(date_range)
      intervals = date_range.typical.get_intervals(true)

      rule = OpeningHoursConverter::OpeningHoursRule.new
      date = OpeningHoursConverter::OpeningHoursDate.new(date_range.wide_interval, date_range.wide_interval.type, [-1])
      rule.add_date(date)

      intervals.each do |interval|
        if !interval.nil?
          rule.add_time(OpeningHoursConverter::OpeningHoursTime.new(interval.start, interval.end))
          rule.is_defined_off = rule.is_defined_off ? true : interval.is_off
        end
      end

      return [ rule ]
    end

    def build_week(date_range)
      result = []

      intervals = date_range.typical.get_intervals(true)
      days = create_time_intervals(date_range.wide_interval, date_range.wide_interval.type, intervals)

      days_status = Array.new(OSM_DAYS.length, 0)

      days.each_with_index do |day, index|
        if day.is_off? && days_status[index] == 0
          days_status[index] = 8
        elsif day.is_off? && days_status[index] < 0 && days_status[index] > -8
          days_status[index] = -8
          merged = false
          md_off = 0
          while !merged && md_off < index
            if days[md_off].is_off?
              days[md_off].add_weekday(index)
              merged = true
            else
              md_off += 1
            end
            if !merged
              result << days[index]
            end
          end
        elsif days_status[index] <= 0 && days_status[index] > -8
          days_status[index] = index + 1
          last_same_day = index
          same_day_count = 1

          for j in (index+1)...days.length do
            if day.same_time?(days[j])
              days_status[j] = index + 1
              day.add_weekday(j)
              last_same_day = j
              same_day_count += 1
            end
          end
          if same_day_count == 1
            result << day
          elsif same_day_count == 2
            day.add_weekday(last_same_day)
            result << day
          elsif same_day_count > 2
            day.add_weekday(last_same_day)
            result << day
          end
        end
      end
      if result == [] && days_status == [8, 8, 8, 8, 8, 8, 8]
        result = days
      end

      result = merge_days(result)

      return result
    end

    def build_week_diff(date_range, general_date_range)
      intervals = date_range.typical.get_intervals_diff(general_date_range.typical)
      days = create_time_intervals(
        date_range.wide_interval,
        date_range.wide_interval.type,
        intervals[:open])



      intervals[:closed].each do |interval|
        for i in interval.day_start..interval.day_end do
          days[i].add_time(OpeningHoursConverter::OpeningHoursTime.new)
        end
      end

      days_status = Array.new(OSM_DAYS.length, 0)
      result = []

      days.each_with_index do |day, index|
        if day.is_off? && day.time.length == 1
          days_status[index] = -8
          merged = false
          md_off = 0

          while !merged && md_off < index
            if days[md_off].is_off? && days[md_off].time.length == 1
              days[md_off].add_weekday(index)
              merged = true
            else
              md_off += 1
            end
          end

          if !merged
            result << day
          end
        elsif day.is_off? && day.time.length == 0
          days_status[index] = 8
        elsif days_status[index] <= 0 && days_status[index] > -8
          days_status[index] = index + 1
          same_day_count = 1
          last_same_day = 1
          result << day

          for j in (index + 1)...days.length do
            if day.same_time?(days[j])
              days_status[j] = index + 1
              day.add_weekday(j)
              last_same_day = j
              same_day_count += 1
            end
          end

          if same_day_count == 1
            result << day
          elsif same_day_count == 2
            day.add_weekday(last_same_day)
            result << day
          elsif same_day_count > 2
            for j in (index + 1)...last_same_day do
              if days_status[j] == 0
                days_status[j] = -index - 1
                if days[j].time.length > 0
                  day.add_overwritten_weekday(j)
                end
              end
            end
            day.add_weekday(last_same_day)
            result << day
          end

        end
      end
      result = merge_days(result)
      return result
    end

    def merge_days(rules)
      return rules if rules.length == 0
      result = []
      result << rules[0]
      dm = 0

      for d in 1...rules.length do
        date_merged = false
        dm = 0
        while !date_merged && dm < d
          if rules[dm].same_time?(rules[d])
            wds = rules[d].date[0].weekdays
            wds.each do |wd|
              rules[dm].add_weekday(wd)
            end
            date_merged = true
          end
          dm += 1
        end
        if !date_merged
          result << rules[d]
        end
      end

      return result
    end

    def create_time_intervals(wide_interval, type, intervals)
      days = []
      for i in 0...7
        days << OpeningHoursConverter::OpeningHoursRule.new
        days[i].add_date(OpeningHoursConverter::OpeningHoursDate.new(wide_interval, type, [ i ]))
      end

      intervals.each do |interval|
        if !interval.nil?
          begin
            if interval.day_start == interval.day_end
              days[interval.day_start].add_time(OpeningHoursConverter::OpeningHoursTime.new(interval.start, interval.end))
              days[interval.day_start].is_defined_off = days[interval.day_start].is_defined_off ? true : interval.is_off
            elsif interval.day_end - interval.day_start == 1
              days[interval.day_start].add_time(OpeningHoursConverter::OpeningHoursTime.new(interval.start, MINUTES_MAX))
              days[interval.day_start].is_defined_off = days[interval.day_start].is_defined_off ? true : interval.is_off
              days[interval.day_end].add_time(OpeningHoursConverter::OpeningHoursTime.new(0, interval.end))
              days[interval.day_end].is_defined_off = days[interval.day_end].is_defined_off ? true : interval.is_off
            else
              for j in interval.day_start..interval.day_end
                days[j].is_defined_off = days[j].is_defined_off ? true : interval.is_off
                if j == interval.day_start
                  days[j].add_time(OpeningHoursConverter::OpeningHoursTime.new(interval.start, MINUTES_MAX))
                elsif j == interval.day_end
                  days[j].add_time(OpeningHoursConverter::OpeningHoursTime.new(0, interval.end))
                else
                  days[j].add_time(OpeningHoursConverter::OpeningHoursTime.new(0, MINUTES_MAX))
                end
              end
            end
          rescue Exception => e
            puts e
          end
        end
      end

      return days
    end
  end
end
