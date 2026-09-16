require 'opening_hours_converter/constants'
require 'opening_hours_converter/utils'
require 'json'

module OpeningHoursConverter
  class OpeningHoursParser
    include Constants
    include Utils

    def initialize
      @regex_handler = RegexHandler.new
    end

    def parse(oh)
      result = []

      # "||" is the OSM fallback-rule separator: what follows it applies only
      # where the rules before it leave the place closed. The two sides are
      # parsed apart, since the fallback is neither an additional rule nor an
      # override; its own date ranges and its text both ride on the first
      # DateRange, where OpenIntervals applies them and the builder rebuilds
      # the string unchanged. A chained "a || b || c" nests: parsing "b || c"
      # hangs "c" on "b" in turn.
      fallback_suffix = nil
      if oh.include?('||')
        oh, fallback = oh.split('||', 2)
        fallback_suffix = fallback.strip
      end

      # ";" separates rules, and so does "," when it stands between two rule
      # sequences rather than inside a selector. The tokenizer drops that
      # comma, so the blocks are split again on the tokens themselves.
      blocks = oh.split(';')
               .map(&:strip)
               .reject(&:empty?)
               .flat_map { |block| split_into_rules(OpeningHoursConverter::Tokenizer.new(block).tokens) }

      comment = ''
      time_selector = nil
      weekday_selector = nil
      wide_range_selector = nil

      weekdays = nil
      months = nil
      years = nil

      date_ranges = nil
      date_range = nil
      dr_obj = nil
      res_dr_id = nil

      blocks.each do |tokens, additional|
        next if tokens.empty?

        @current_token = tokens.length - 1

        weekdays = {}
        comment = ''
        closing = false

        # get comment
        if @current_token >= 0 && is_comment?(tokens[@current_token])
          comment = tokens[@current_token]
          @current_token -= 1
        end

        # get state and time associated with weekdays
        while @current_token >= 0 && (is_rule_modifier?(tokens[@current_token]) || is_time?(tokens[@current_token])) || is_weekday?(tokens[@current_token])
          if is_rule_modifier?(tokens[@current_token])
            local_modifier = tokens[@current_token].downcase

            # "open" only restates what a time selector already means, so it
            # carries no weekday selector of its own and the rule is read as
            # if it were absent.
            if local_modifier == 'open'
              @current_token -= 1
              next
            end

            # "Mo-Fr 12:00-13:00 off" closes the hours it names, not the days:
            # the modifier belongs to the time selector standing before it, and
            # the branch reading that selector below is the one that applies
            # it. A modifier with no time selector of its own ("Sa off") keeps
            # closing whole days.
            if %w[closed off].include?(local_modifier) && @current_token > 0 && is_time?(tokens[@current_token - 1])
              closing = true
              @current_token -= 1
              next
            end

            @current_token -= 1
            begin
              weekday_selector = tokens[@current_token]
              weekdays_and_holidays = get_weekdays(weekday_selector)
            rescue StandardError
              weekdays[[{ from: 0, to: 6, index: nil }]] ||= {}
              weekdays[[{ from: 0, to: 6, index: nil }]][:modifiers] ||= []
              weekdays[[{ from: 0, to: 6, index: nil }]][:modifiers] << local_modifier
            else
              weekdays[weekdays_and_holidays] ||= {}
              weekdays[weekdays_and_holidays][:modifiers] ||= []
              weekdays[weekdays_and_holidays][:modifiers] << local_modifier
              @current_token -= 1
            end
          else
            local_times = []
            while @current_token >= 0 && is_time?(tokens[@current_token])
              time_selector = tokens[@current_token]
              local_times.concat get_times(time_selector)
              @current_token -= 1
            end

            if local_times.empty?
              local_times.concat get_times("00:00-23:59")
            end

            # Times a "off" modifier closes are kept apart from the ones that
            # open, since they are cut out of what earlier rules left rather
            # than added to it.
            times_key = closing ? :closed_times : :times
            closing = false

            begin
              weekday_selector = tokens[@current_token]
              weekdays_and_holidays = get_weekdays(weekday_selector)
            rescue StandardError
              weekdays[[{ from: 0, to: 6, index: nil }]] ||= {}
              weekdays[[{ from: 0, to: 6, index: nil }]][times_key] ||= []
              weekdays[[{ from: 0, to: 6, index: nil }]][times_key].concat(local_times)
            else
              weekdays[weekdays_and_holidays] ||= {}
              weekdays[weekdays_and_holidays][times_key] ||= []
              weekdays[weekdays_and_holidays][times_key].concat(local_times)
              @current_token -= 1
            end
          end
        end

        weeks = []
        months = []
        years = []
        holidays = []
        variable_dates = []
        if @current_token >= 0
          wide_range_selector = tokens[0]
          for i in 1..@current_token
            wide_range_selector += " #{tokens[i]}"
          end
          if !wide_range_selector.empty?
            wide_range_selector = wide_range_selector.strip

            if !(@regex_handler.variable_date_range_regex =~ wide_range_selector).nil?
              variable_dates << get_variable_date_range(wide_range_selector)
            elsif !(@regex_handler.year_month_day_regex =~ wide_range_selector).nil?
              years << get_year_month_day(wide_range_selector)
            elsif !(@regex_handler.year_month_regex =~ wide_range_selector).nil?
              years << get_year_month(wide_range_selector)
            elsif !(@regex_handler.month_day_regex =~ wide_range_selector).nil?
              months << get_month_day(wide_range_selector)
            elsif !(@regex_handler.month_regex =~ wide_range_selector).nil?
              months += get_month(wide_range_selector)
            elsif !(@regex_handler.year_regex =~ wide_range_selector).nil?
              years << get_year(wide_range_selector)
            elsif !(@regex_handler.multi_month_regex =~ wide_range_selector).nil?
              months += get_multi_month(wide_range_selector)
            elsif !(@regex_handler.year_multi_month_regex =~ wide_range_selector).nil?
              months += get_year_multi_month(wide_range_selector)
            elsif !(@regex_handler.year_multi_month_day_regex =~ wide_range_selector).nil?
              months += get_year_multi_month_day(wide_range_selector)
            elsif !(@regex_handler.year_week_with_modifier_regex =~ wide_range_selector).nil?
              weeks << get_year_week_with_modifier(wide_range_selector)
            elsif !(@regex_handler.year_week_regex =~ wide_range_selector).nil?
              weeks << get_year_week(wide_range_selector)
            elsif !(@regex_handler.week_with_modifier_regex =~ wide_range_selector).nil?
              weeks << get_week_with_modifier(wide_range_selector)
            elsif !(@regex_handler.week_regex =~ wide_range_selector).nil?
              weeks << get_week(wide_range_selector)
            else

              raise ParseError, "Unsupported selector #{wide_range_selector}"
            end
          end
        end

        # puts "weekdays : #{weekdays}"
        # puts "weeks : #{weeks}"
        # puts "months : #{months}"
        # puts "years : #{years}"

        date_ranges = []
        if !variable_dates.empty?
          variable_dates.each do |variable_date|
            date_ranges << OpeningHoursConverter::WideInterval.new.variable_day(variable_date[:from], variable_date[:to])
          end
        elsif !months.empty?
          months.each do |month|
            if !month[:from_day].nil?
              if !month[:to_day].nil?
                date_range = OpeningHoursConverter::WideInterval.new.day(month[:from_day][:day], month[:from_day][:month], month[:from_day][:year],
                                                                         month[:to_day][:day], month[:to_day][:month], month[:to_day][:year])
              else
                date_range = OpeningHoursConverter::WideInterval.new.day(month[:from_day][:day], month[:from_day][:month], month[:from_day][:year])
              end
            else
              date_range = if !month[:to].nil?
                             OpeningHoursConverter::WideInterval.new.month(month[:from], nil, month[:to])
                           else
                             OpeningHoursConverter::WideInterval.new.month(month[:from])
                           end
            end
            date_ranges << date_range
          end
        elsif !weeks.empty?

          weeks.each do |week|
            date_ranges << OpeningHoursConverter::WideInterval.new.week(week[:week_indexes], week[:year_from], week[:year_to])
          end

        elsif !years.empty?
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
              date_range = if !year[:to].nil?
                             OpeningHoursConverter::WideInterval.new.year(year[:from], year[:to])
                           else
                             OpeningHoursConverter::WideInterval.new.year(year[:from], nil, open_ended: !!year[:open_ended])
                           end
            end
            date_ranges << date_range
          end
        else
          date_ranges << OpeningHoursConverter::WideInterval.new.always
        end

        if weekdays.empty?
          weekdays[[{ from: 0, to: 6, index: nil }]] = {}
          weekdays[[{ from: 0, to: 6, index: nil }]][:times] = [{ from: 0, to: 24 * 60 }]
        end

        date_ranges.each do |dr|
          found_date_range = false
          res_dr_id = 0
          while res_dr_id < result.length && !found_date_range
            if result[res_dr_id].wide_interval.equals(dr) && result[res_dr_id].comment == comment
              found_date_range = true
            else
              res_dr_id += 1
            end
          end

          if found_date_range
            dr_obj = result[res_dr_id]
          else
            dr_obj = OpeningHoursConverter::DateRange.new(dr)
            dr_obj.add_comment(comment) if !comment.nil?

            general = -1
            for res_dr_id in 0...result.length
              general = res_dr_id if result[res_dr_id].is_general_for?(dr_obj)
            end
            dr_obj.typical.copy_intervals(result[general].typical.intervals) if general >= 0
            result << dr_obj
          end

          # What the block selects replaces what earlier blocks left on those
          # weekdays, so every weekday it names is cleared before anything is
          # written. The two passes are separate: clearing while writing would
          # make "Sa[2],Sa[4]" drop its first index, the second entry wiping
          # the Saturday the first one had just filled.
          #
          # An additional rule adds to what comes before it instead of
          # replacing it, so it clears nothing. Neither does a rule closing
          # named hours: it subtracts a window from the day, which is only
          # meaningful if the day survives.
          unless additional
            weekdays.each do |weekday_ranges, weekday_object|
              next if weekday_object[:closed_times]

              weekday_ranges.each { |weekday_range| clear_weekdays(dr_obj, weekday_range) }
            end
          end

          weekdays.each do |weekday_ranges, weekday_object|
            weekday_ranges.each do |weekday_range|
              weekday_object[:closed_times]&.each do |time_range|
                remove_time_range(dr_obj.typical, weekday_range, time_range)
              end

              weekday_object[:modifiers]&.each do |modifier|
                if modifier == 'closed' || modifier == 'off'
                  remove_interval(dr_obj, weekday_range)
                  add_off_interval(dr_obj, weekday_range)
                elsif modifier == 'unknown'
                  remove_interval(dr_obj, weekday_range)
                  add_unknown_interval(dr_obj, weekday_range)
                end
              end

              next unless weekday_object[:times]

              weekday_object[:times]&.each do |time_range|
                add_interval(dr_obj.typical, weekday_range, time_range)
              end
            end
          end
        end
      end

      if !result.empty? && fallback_suffix
        result.first.fallback_suffix = fallback_suffix
        result.first.fallback_ranges = self.class.new.parse(fallback_suffix)
      end

      result
    end

    def from_json(json)
      parsed = JSON.parse(json)
      date_range = []
      parsed.each do |dr|
        wi = {}
        start_day = DateTime.parse(dr['wide_interval']['start'])
        end_day = DateTime.parse(dr['wide_interval']['end'])
        case dr['wide_interval']['type']
        when 'always'
          wi = OpeningHoursConverter::WideInterval.new.day(start_day.day, start_day.month, nil, end_day.day, end_day.month)
        else
          wi = OpeningHoursConverter::WideInterval.new.day(start_day.day, start_day.month, start_day.year, end_day.day, end_day.month, end_day.year)
        end
        date_range << OpeningHoursConverter::DateRange.new(wi)
        date_range.last.add_comment(dr['comment'])
        dr['typical']['intervals'].each do |interval|
          next unless !interval.nil?
          start_interval = DateTime.parse(interval['start'])
          end_interval = DateTime.parse(interval['end'])
          if end_interval.day == start_interval.day + 1 && end_interval.hour == 0 && end_interval.min == 0
            end_interval -= (1 / 1440.0)
          end
          date_range.last.typical.add_interval(
            OpeningHoursConverter::Interval.new(
              reindex_sunday_week_to_monday_week(start_interval.wday),
              (start_interval.hour * 60 + start_interval.min),
              reindex_sunday_week_to_monday_week(end_interval.wday),
              (end_interval.hour * 60 + end_interval.min)
            )
          )
        end
      end
      date_range
    end

    def get_year(wrs)
      open_ended = wrs.end_with?('+')
      wrs = wrs.chomp('+') if open_ended

      single_year = wrs.gsub(/\:$/, '').split('-')
      year_from = single_year[0].to_i
      raise ArgumentError, "Invalid year : #{single_year[0]}" if year_from < 1

      if single_year.length > 1
        year_to = single_year[1].to_i
        raise ArgumentError, "Invalid year : #{single_year[1]}" if year_to < 1
      else
        year_to = nil
      end
      { from: year_from, to: year_to, open_ended: open_ended }
    end

    def get_year_week_with_modifier(wrs)
      year, weeks = wrs.split(/ week /i)
      years = year.split('-')

      indexes = weeks.split(',').map { |week_index|
        if week_index.include?('-')
          if week_index.include?('/')
            from, to = week_index.split('-')
            to, modifier = to.split('/')
            { from: from.to_i, to: to.to_i, modifier: modifier.to_i }
          else
            from, to = week_index.split('-').map(&:to_i)
            { from: from, to: to }
          end
        else
          week_index.to_i
        end
      }.sort_by do |index|
        if index.is_a?(Integer)
          index
        elsif index.is_a?(Hash)
          index[:from]
        else
          0
        end
      end

      { year_from: years[0].to_i, week_indexes: indexes }.tap do |hsh|
        hsh[:year_to] = years.length > 1 ? years[1].to_i : nil
      end
    end

    def get_year_week(wrs)
      year, weeks = wrs.split(/ week /i)
      # does not handle 2018,2019
      years = year.split('-')
      # does not handle week 1,2,3
      indexes = weeks.split(',').map { |week_index|
        if week_index.include?('-')
          from, to = week_index.split('-').map(&:to_i)
          { from: from, to: to }
        else
          week_index.to_i
        end
      }

      { week_indexes: indexes, year_from: year[0].to_i }.tap do |hsh|
        hsh[:year_to] = years.length > 1 ? year[1].to_i : nil
      end
    end

    def get_week_with_modifier(wrs)
      weeks = wrs.gsub(/week /i, '').split(',')

      indexes = weeks.map { |week_index|
        if week_index.include?('-')
          if week_index.include?('/')
            from, to = week_index.split('-')
            to, modifier = to.split('/')
            { from: from.to_i, to: to.to_i, modifier: modifier.to_i }
          else
            from, to = week_index.split('-').map(&:to_i)
            { from: from, to: to }
          end
        else
          week_index.to_i
        end
      }

      { week_indexes: indexes }
    end

    def get_week(wrs)
      weeks = wrs.gsub(/week /i, '').split(',')

      indexes = weeks.map { |week_index|
        if week_index.include?('-')
          from, to = week_index.split('-').map(&:to_i)
          { from: from, to: to }
        else
          week_index.to_i
        end
      }

      { week_indexes: indexes }
    end


    def get_month(wrs)
      single_month = wrs.gsub(/\:$/, '').split('-')
      month_from = OSM_MONTHS.find_index(single_month[0].capitalize) + 1
      raise ArgumentError, "Invalid month : #{single_month[0]}" if month_from < 1

      if single_month.length > 1
        month_to = OSM_MONTHS.find_index(single_month[1].capitalize) + 1
        raise ArgumentError, "Invalid month : #{single_month[1]}" if month_to < 1
      else
        month_to = month_from
      end

      if month_from > month_to
        [
          {
            from: month_from,
            to: 12
          },
          {
            from: 1,
            to: month_to
          }
        ]
      else
        [
          { from: month_from, to: month_to }
        ]
      end
    end

    def get_month_day(wrs)
      single_month = wrs.gsub(/\:$/, '').split('-')

      month_from = single_month[0].split(' ')
      month_from = { day: month_from[1].to_i, month: OSM_MONTHS.find_index(month_from[0].capitalize) + 1 }
      raise ArgumentError, "Invalid month : #{month_from.inspect}" if month_from[:month] < 1

      if single_month.length > 1
        month_to = single_month[1].split(' ')
        month_to = if month_to.length > 1
                     { day: month_to[1].to_i, month: OSM_MONTHS.find_index(month_to[0].capitalize) + 1 }
                   else
                     { day: month_to[0].to_i, month: month_from[:month] }
                   end
        raise ArgumentError, "Invalid month : #{month_to.inspect}" if month_to[:month] < 1
      else
        month_to = nil
      end

      { from_day: month_from, to_day: month_to }
    end

    def get_year_month(wrs)
      single_year_month = wrs.gsub(/\:$/, '').split('-')
      year_month_from = single_year_month[0].split(' ')
      year_month_from = { month: OSM_MONTHS.find_index(year_month_from[1].capitalize) + 1, year: year_month_from[0].to_i }
      if year_month_from.empty?
        raise ArgumentError, "Invalid year_month : #{year_month_from.inspect}"
      end
      if single_year_month.length > 1
        year_month_to = single_year_month[1].split(' ')
        if year_month_to.length == 2
          year_month_to = { month: OSM_MONTHS.find_index(year_month_to[1].capitalize) + 1, year: year_month_to[0].to_i }
        elsif year_month_to.length == 1
          year_month_to = { month: OSM_MONTHS.find_index(year_month_to[0].capitalize) + 1, year: year_month_from[:year] }
        end
        raise ArgumentError, "Invalid year_month : #{year_month_to.inspect}" if year_month_to.empty?
      else
        year_month_to = nil
      end
      { from_month: year_month_from, to_month: year_month_to }
    end

    def get_year_holiday(wrs)
      single_year = wrs.gsub(/\:$/, '').split('-')
      if single_year.length == 1
        return { holiday: single_year[0].split(' ')[1], start: single_year[0].split(' ')[0] }
      elsif single_year.length == 2
        return { holiday: single_year[1].split(' ')[1], start: single_year[0], end: single_year[1].split(' ')[0] }
      else
        raise ArgumentError, "Invalid year_holiday : #{wrs.inspect}"
      end
    end

    def get_year_month_day(wrs)
      single_year_month_day = wrs.gsub(/\:$/, '').split('-')
      year_month_day_from = single_year_month_day[0].split(' ')
      year_month_day_from = { day: year_month_day_from[2].to_i,
                              month: OSM_MONTHS.find_index(year_month_day_from[1].capitalize) + 1,
                              year: year_month_day_from[0].to_i }
      if year_month_day_from.empty?
        raise ArgumentError, "Invalid year_month_day : #{year_month_day_from.inspect}"
      end
      if single_year_month_day.length > 1
        year_month_day_to = single_year_month_day[1].split(' ')
        if year_month_day_to.length == 3
          year_month_day_to = { day: year_month_day_to[2].to_i,
                                month: OSM_MONTHS.find_index(year_month_day_to[1].capitalize) + 1,
                                year: year_month_day_to[0].to_i }
        elsif year_month_day_to.length == 2
          year_month_day_to = { day: year_month_day_to[1].to_i,
                                month: OSM_MONTHS.find_index(year_month_day_to[0].capitalize) + 1,
                                year: year_month_day_from[:year] }
        elsif year_month_day_to.length == 1
          year_month_day_to = { day: year_month_day_to[0].to_i,
                                month: year_month_day_from[:month],
                                year: year_month_day_from[:year] }
        end
        if year_month_day_to.empty?
          raise ArgumentError, "Invalid year_month_day : #{year_month_day_to.inspect}"
        end
      else
        year_month_day_to = nil
      end

      { from_day: year_month_day_from, to_day: year_month_day_to }
    end

    def get_year_multi_month_day(wrs)
      year = wrs[0...4]

      wrs.split(',').map.with_index do |wr|
        if wr =~ /^#{@regex_handler.year}/
          year = wr[0...4]
          wr = wr[5...wr.length]
        end
        month = wr[0...3]
        days = wr[4...wr.length].split('-').reject { |e| e == '' }.map(&:to_i)
        if days.length == 2
          from = {
            year: year.to_i,
            month: OSM_MONTHS.find_index(wr[0...3].capitalize) + 1,
            day: days[0]
          }
          to = {
            year: year.to_i,
            month: OSM_MONTHS.find_index(wr[0...3].capitalize) + 1,
            day: days[1]
          }
          { from_day: from, to_day: to }
        else
          from = {
            year: year.to_i,
            month: OSM_MONTHS.find_index(wr[0...3]) + 1,
            day: wr[4...wr.length].to_i
          }
          { from_day: from, to_day: from }
        end
      end
    end

    def get_multi_month(wrs)
      wrs.split(',').map do |wr|
        if wr.include?('-')
          start_month_day, end_month_day = wr.split('-')

          start_month = start_month_day[0...3]
          start_day = start_month_day[4...start_month_day.length]&.to_i

          end_month = end_month_day[0...3]
          end_day = end_month_day[4...end_month_day.length]&.to_i

          from = {
            month: OSM_MONTHS.find_index(start_month.capitalize) + 1,
            day: start_day || 1
          }
          to = {
            month: OSM_MONTHS.find_index(end_month.capitalize) + 1,
            day: end_day || MONTH_END_DAY[OSM_MONTHS.find_index(end_month.capitalize)]
          }
        else
          month = wr[0...3]
          day = wr[4...wr.length]&.to_i

          from = {
            month: OSM_MONTHS.find_index(month.capitalize) + 1,
            day: day || 1
          }
          to = {
            month: OSM_MONTHS.find_index(month.capitalize) + 1,
            day: day || MONTH_END_DAY[OSM_MONTHS.find_index(month.capitalize)]
          }
        end

        { from_day: from, to_day: to }
      end
    end

    def get_year_multi_month(wrs)
      year = wrs[0...4]
      wrs = wrs[5..wrs.length]

      wrs.split(',').map do |wr|
        if wr.include?('-')
          start_month, end_month = wr.split('-')
          from = {
            year: year.to_i,
            month: OSM_MONTHS.find_index(start_month.capitalize) + 1,
            day: 1
          }
          to = {
            year: year.to_i,
            month: OSM_MONTHS.find_index(end_month.capitalize) + 1,
            day: MONTH_END_DAY[OSM_MONTHS.find_index(end_month.capitalize)]
          }
        else
          from = {
            year: year.to_i,
            month: OSM_MONTHS.find_index(wr[0...3].capitalize) + 1,
            day: 1
          }
          to = {
            year: year.to_i,
            month: OSM_MONTHS.find_index(wr[0...3].capitalize) + 1,
            day: MONTH_END_DAY[OSM_MONTHS.find_index(wr[0...3].capitalize)]
          }
        end
        { from_day: from, to_day: to }
      end
    end

    def get_times(time_selector)
      times = []
      from = nil
      to = nil
      if time_selector == '24/7'
        times << { from: 0, to: 24 * 60 }
      else
        time_selector = time_selector.split(',')
        time_selector.each do |ts|
          open_ended = ts.end_with?('+')
          ts = ts.chomp('+') if open_ended

          single_time = ts.split('-')
          from = as_minutes(single_time[0])
          to = if open_ended
                 24 * 60
               elsif single_time.length > 1
                 as_minutes(single_time[1])
               else
                 from
               end
          times << { from: from, to: to, open_ended: open_ended }
        end
      end
      times
    end

    def get_weekdays(weekday_selector)
      weekdays = []
      wd_from = nil
      wd_to = nil

      weekday_selector = split_weekday_selector(weekday_selector)

      weekday_selector.each do |wd|
        if !(@regex_handler.holiday_regex =~ wd).nil?
          weekdays << { from: PH_WEEKDAY, to: PH_WEEKDAY, index: nil }
        elsif !(@regex_handler.easter_regex =~ wd).nil?
          weekdays << { from: EASTER_WEEKDAY, to: EASTER_WEEKDAY, index: nil }
        elsif !(@regex_handler.week_day_regex =~ wd).nil?
          single_weekday = wd.split('-')

          wd_from = weekday_index(single_weekday[0])
          wd_to = if single_weekday.length > 1
                    weekday_index(single_weekday[1])
                  else
                    wd_from
                  end

          weekdays << { from: wd_from, to: wd_to, index: nil }
        elsif !(@regex_handler.week_day_with_modifier_regex =~ wd).nil?
          day = wd[0...wd.index('[')]
          index = wd[wd.index('[') + 1...wd.index(']')]

          wd_from = weekday_index(day)

          weekdays << { from: wd_from, to: wd_from, index: get_weekday_indexes(index) }
        else
          raise ArgumentError, "Invalid weekday interval : #{wd}"
        end
      end

      weekdays
    end

    # A time selector closes a rule sequence, so any selector standing right
    # after one opens a new rule. That is what the additional rule separator
    # means ("Jan We 11:00-12:00,Mo off" is two rules, and the second one
    # carries no month), and it also reads the rules the data writes with no
    # separator at all ("Feb: Mo[1,3] 09:00-19:00 Mar-Jun Th 09:00-19:00").
    #
    # A rule modifier and a comment belong to the rule they follow, and a
    # second time selector only widens the current one.
    # Returns [tokens, additional] pairs. Every rule but the first of a ";"
    # block is an additional rule: it adds to what comes before it rather
    # than replacing it, which is what "Sa,Su 18:00-24:00; Jan Fr 10:00-20:00,
    # Sa 00:00-03:00" means, the Saturday of the first rule surviving.
    def split_into_rules(tokens)
      rules = []
      current = []

      tokens.each_with_index do |token, i|
        current << token
        following = tokens[i + 1]
        next if following.nil? || !is_time?(token)
        next if is_time?(following) || is_comment?(following) || is_rule_modifier?(following)

        rules << [current, !rules.empty?]
        current = []
      end

      rules << [current, !rules.empty?] unless current.empty?
      rules
    end

    # "Jun Mo[1]-Sep Sa[1]" splits on the only "]-" it can hold, since an
    # index list never contains a closing bracket.
    def get_variable_date_range(wrs)
      from, to = wrs.split(']-')
      { from: get_variable_date("#{from}]"), to: get_variable_date(to) }
    end

    def get_variable_date(part)
      month_name, weekday = part.strip.split(' ')
      day = weekday[0...weekday.index('[')]
      index = get_weekday_indexes(weekday[weekday.index('[') + 1...weekday.index(']')])

      {
        month: OSM_MONTHS.find_index(month_name.capitalize) + 1,
        weekday: weekday_index(day),
        index: index.first
      }
    end

    # "Sa" and its three letter form "Sat" name the same weekday.
    def weekday_index(name)
      name = name.strip.capitalize
      OSM_DAYS.find_index(name) || OSM_DAYS.find_index(name[0, 2])
    end

    # A weekday sequence is comma separated, but an index list is comma
    # separated too ("Sa[1,3],Su[2]"), so only the commas outside the brackets
    # separate weekdays.
    def split_weekday_selector(weekday_selector)
      weekday_selector.split(/,(?![^\[]*\])/)
    end

    # The OSM nth_entry list of a weekday index: "2", "1,3", "2-4", "-1".
    # Always returns an array, so a single index and a list are handled alike
    # downstream.
    def get_weekday_indexes(raw)
      raw.split(',').flat_map do |entry|
        entry = entry.strip
        if entry.start_with?('-')
          [entry.to_i]
        elsif entry.include?('-')
          from, to = entry.split('-').map(&:to_i)
          raise ArgumentError, "Invalid weekday index range : #{entry}" if to < from

          (from..to).to_a
        else
          [entry.to_i]
        end
      end
    end

    def clear_weekdays(date_range, weekday_range)
      if weekday_range[:from] <= weekday_range[:to]
        clear_weekday_range(date_range, weekday_range[:from]..weekday_range[:to])
      else
        clear_weekday_range(date_range, weekday_range[:from]..6)
        clear_weekday_range(date_range, 0..weekday_range[:to])
      end
    end

    def clear_weekday_range(date_range, weekdays)
      weekdays.each do |wd|
        if date_range.defines_typical_week?
          date_range.typical.remove_intervals_during_day(wd)
        else
          date_range.typical.clear_intervals
        end
      end
    end

    def remove_interval(date_range, weekdays)
      if date_range.typical.instance_of?(OpeningHoursConverter::Day)
        date_range.typical.clear_intervals
      else
        if weekdays[:from] <= weekdays[:to]
          for wd in weekdays[:from]..weekdays[:to]
            date_range.typical.remove_intervals_during_day(wd)
          end
        else
          for wd in weekdays[:from]..6
            date_range.typical.remove_intervals_during_day(wd)
          end
          for wd in 0..weekdays[:to]
            date_range.typical.remove_intervals_during_day(wd)
          end
        end
      end
    end

    def remove_interval_wd(typical, times, wd)
      if times[:to] >= times[:from]
        typical.remove_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd, times[:to]))
      else
        if wd < 6
          typical.remove_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd + 1, times[:to]))
        else
          typical.remove_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd + 1, 24 * 60))
          typical.remove_interval(OpeningHoursConverter::Interval.new(0, 0, 0, times[:to]))
        end
      end
    end

    # The times a rule closes ("Mo-Fr 12:00-13:00 off") are cut out of what
    # earlier rules left open on those weekdays, which is what leaves a lunch
    # break rather than a closed day.
    def remove_time_range(typical, weekdays, times)
      if typical.instance_of?(OpeningHoursConverter::Day)
        remove_time_range_wd(typical, times, 0)
      elsif weekdays[:from] <= weekdays[:to]
        for wd in weekdays[:from]..weekdays[:to]
          remove_time_range_wd(typical, times, wd)
        end
      else
        for wd in weekdays[:from]..6
          remove_time_range_wd(typical, times, wd)
        end
        for wd in 0..weekdays[:to]
          remove_time_range_wd(typical, times, wd)
        end
      end
    end

    def remove_time_range_wd(typical, times, wd)
      if times[:to] >= times[:from]
        remove_minutes(typical, wd, times[:from], times[:to])
      else
        remove_minutes(typical, wd, times[:from], MINUTES_MAX)
        remove_minutes(typical, wd < 6 ? wd + 1 : 0, 0, times[:to])
      end
    end

    # What the window covers on that weekday is taken out of every interval
    # reaching it: an interval inside the window disappears, one straddling it
    # is split in two, and one only touching its edge is left alone. An open
    # end belongs to the half that still runs to the end of the day.
    def remove_minutes(typical, wd, from, to)
      typical.intervals.dup.each_with_index do |interval, id|
        next if interval.nil? || interval.is_off
        next unless (interval.day_start..interval.day_end).cover?(wd)

        start_minute = interval.day_start == wd ? interval.start : 0
        end_minute = interval.day_end == wd ? interval.end : MINUTES_MAX
        next if from >= end_minute || to <= start_minute

        typical.remove_interval(id)

        if wd > interval.day_start || from > interval.start
          typical.add_interval(OpeningHoursConverter::Interval.new(interval.day_start, interval.start, wd, from, false, interval.index))
        end
        if wd < interval.day_end || to < interval.end
          typical.add_interval(OpeningHoursConverter::Interval.new(wd, to, interval.day_end, interval.end, false, interval.index, false, interval.open_ended))
        end
      end
    end

    def add_interval(typical, weekdays, times)
      if typical.instance_of?(OpeningHoursConverter::Day)
        if weekdays[:from] != 0 || (weekdays[:to] != 0 && times[:from] <= times[:to])
          weekdays = weekdays.dup
          weekdays[:from] = 0
          weekdays[:to] = if times[:from] <= times[:to]
                            0
                          else
                            1
                          end
        end
      end

      if weekdays[:from] <= weekdays[:to]
        for wd in weekdays[:from]..weekdays[:to]
          add_interval_wd(typical, times, wd, weekdays[:index])
        end
      else
        for wd in weekdays[:from]..6
          add_interval_wd(typical, times, wd, weekdays[:index])
        end
        for wd in 0..weekdays[:to]
          add_interval_wd(typical, times, wd, weekdays[:index])
        end
      end
    end

    def add_off_interval(date_range, weekdays)
      if date_range.typical.instance_of?(OpeningHoursConverter::Day)
        if weekdays[:from] != 0 || weekdays[:to] != 0
          weekdays = weekdays.dup
          weekdays[:from] = 0
          weekdays[:to] = 0
        end
      end

      if weekdays[:from] <= weekdays[:to]
        for wd in weekdays[:from]..weekdays[:to]
          date_range.typical.add_interval(OpeningHoursConverter::Interval.new(wd, 0, wd, 24 * 60, true, weekdays[:index]))
        end
      else
        for wd in weekdays[:from]..6
          date_range.typical.add_interval(OpeningHoursConverter::Interval.new(wd, 0, wd, 24 * 60, true, weekdays[:index]))
        end
        for wd in 0..weekdays[:to]
          date_range.typical.add_interval(OpeningHoursConverter::Interval.new(wd, 0, wd, 24 * 60, true, weekdays[:index]))
        end
      end
    end

    def add_unknown_interval(date_range, weekdays)
      if date_range.typical.instance_of?(OpeningHoursConverter::Day)
        if weekdays[:from] != 0 || weekdays[:to] != 0
          weekdays = weekdays.dup
          weekdays[:from] = 0
          weekdays[:to] = 0
        end
      end

      if weekdays[:from] <= weekdays[:to]
        for wd in weekdays[:from]..weekdays[:to]
          date_range.typical.add_interval(OpeningHoursConverter::Interval.new(wd, 0, wd, 24 * 60, true, weekdays[:index], true))
        end
      else
        for wd in weekdays[:from]..6
          date_range.typical.add_interval(OpeningHoursConverter::Interval.new(wd, 0, wd, 24 * 60, true, weekdays[:index], true))
        end
        for wd in 0..weekdays[:to]
          date_range.typical.add_interval(OpeningHoursConverter::Interval.new(wd, 0, wd, 24 * 60, true, weekdays[:index], true))
        end
      end
    end

    def add_interval_wd(typical, times, wd, index = nil)
      if times[:to] >= times[:from]
        typical.add_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd, times[:to], false, index, false, times[:open_ended]))
      else
        if wd < 6
          typical.add_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd + 1, times[:to], false, index))
        else
          typical.add_interval(OpeningHoursConverter::Interval.new(wd, times[:from], wd, 24 * 60, false, index))
          typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 0, times[:to], false, index))
        end
      end
    end

    def tokenize(block)
      if block.split('"').length > 1
        comment = block.split('"')[1]

        groups = block.split('"')[0].split(',').map { |s| s.split(' ') }
        groups[-1] << "\"#{comment}\""

        merge_groups(groups)
      else
        merge_groups(block.split(',').map { |s| s.split(' ') })
      end
    end

    def merge_groups(groups)
      new_tokens = []
      weekday_merge = []
      wide_interval_merge = []
      merged_wide_interval = []

      groups.each_with_index do |group, group_index|
        if !wide_interval_merge.empty?
          merged_wide_interval += [wide_interval_merge.join(' ')]
          wide_interval_merge = []
        end
        group.each_with_index do |token, token_index|
          if !wide_interval_merge.empty? && !is_part_of_wide_interval?(token)
            merged_wide_interval += [wide_interval_merge.join(' ')]
            wide_interval_merge = []
            new_tokens << merged_wide_interval.join(',')
          end
          if is_weekday?(token) || is_weekday_with_modifier?(token)
            weekday_merge << token
            if token_index == group.length - 1 && group_index == groups.length - 1
              new_tokens << weekday_merge.join(',')
            end
          elsif !weekday_merge.empty?
            new_tokens << weekday_merge.join(',')
            new_tokens << token
            weekday_merge = []
          elsif is_part_of_wide_interval?(token)
            wide_interval_merge << token
            if token_index == group.length - 1 && group_index == groups.length - 1
              new_tokens << wide_interval_merge.join(',')
            end
          else
            new_tokens << token
          end
        end
      end

      new_tokens
    end

    def as_minutes(time)
      values = time.split(':')
      values[0].to_i * 60 + values[1].to_i
    end

    def is_part_of_wide_interval?(string)
      is_wide_interval = false
      string.split('-').each do |str|
        if (!(@regex_handler.year_regex =~ str).nil? || !(@regex_handler.year_month_regex =~ str).nil? || !(@regex_handler.year_month_day_regex =~ str).nil? ||
            !(@regex_handler.month_day_regex =~ str).nil? || !(@regex_handler.month_day_regex =~ str).nil? || !(@regex_handler.month_regex =~ str).nil? ||
            !(@regex_handler.week_key_regex =~ str).nil? || !(@regex_handler.week_value_regex =~ str).nil? || !(@regex_handler.week_value_with_modifier_regex =~ str).nil?) &&
            ((@regex_handler.time_regex =~ str).nil? && (@regex_handler.week_day_or_holiday_regex =~ str).nil?)
          is_wide_interval = true
        else
          return false
        end
      end
      is_wide_interval
    end

    def is_comment?(token)
      !(@regex_handler.comment_regex =~ token).nil?
    end

    def is_holiday?(token)
      !(@regex_handler.holiday_regex =~ token).nil?
    end

    def is_rule_modifier?(token)
      !(@regex_handler.rule_modifier_regex =~ token).nil?
    end

    def is_time?(token)
      !(@regex_handler.time_regex =~ token).nil?
    end

    def is_weekday?(token)
      !(@regex_handler.week_day_or_holiday_regex =~ token).nil? || is_weekday_with_modifier?(token) || is_easter?(token)
    end

    def is_easter?(token)
      !(@regex_handler.easter_regex =~ token).nil?
    end

    def is_weekday_with_modifier?(token)
      !(@regex_handler.week_day_with_modifier_regex =~ token).nil?
    end

    def is_year?(token)
      !(@regex_handler.year_regex =~ token).nil?
    end

    def is_week_key?(token)
      !(@regex_handler.week_key_regex =~ token).nil?
    end

    def is_week_val?(token)
      !(@regex_handler.week_value_regex =~ token).nil?
    end

    def is_week_with_modifier?(token)
      !(@regex_handler.week_with_modifier_regex =~ token).nil?
    end

    def is_week_val_with_modifier?(token)
      !(@regex_handler.week_value_with_modifier_regex =~ token).nil?
    end

    def is_year_week?(token)
      !(@regex_handler.year_week_regex =~ token).nil?
    end

    def is_year_week_with_modifier?(token)
      !(@regex_handler.year_week_with_modifier_regex =~ token).nil?
    end
    def is_year_multi_month_day?(token)
      !(@regex_handler.year_multi_month_day_regex =~ token).nil?
    end
  end
end


