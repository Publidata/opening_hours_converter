# frozen_string_literal: true

module OpeningHoursConverter
  class RegexHandler
    def rule_modifier_regex
      /^(open|closed|off)$/i
    end

    def week_key_regex
      compile(line(week))
    end

    def week_regex
      compile(
        line(
          week + space + potential_list(
            potential_range(int_range(53))
          )
        )
      )
    end

    def week_with_modifier_regex
      compile(
        line(
          week + space + potential_list(
            potential_range(int_range(53), group(int_range(53) + potential(week_modifier)))
          )
        )
      )
    end

    def week_value_with_modifier_regex
      compile(
        line(
          potential_list(
            potential_range(int_range(53), group(int_range(53) + potential(week_modifier)))
          )
        )
      )
    end

    def month_day_regex
      compile(
        line(
          potential_range(
            month + space + month_day,
            potential(month + space) + month_day
          )
        )
      )
    end

    def month_regex
      compile(line(potential_range(month)))
    end

    def holiday_regex
      compile(line(ph))
    end

    def time_regex
      compile(
        line(
          potential_list(
            group(
              potential_range(
                group(time)
              ) + '|' + group(full_time)
            )
          )
        )
      )
    end

    def week_day_or_holiday_regex
      compile(
        line(
          potential_list(
            group(
              potential_range(
                group(week_day)
              ) + '|' + group(ph)
            )
          )
        )
      )
    end

    def week_day_regex
      compile(
        line(
          potential_range(week_day)
        )
      )
    end

    def week_day_with_modifier_regex
      compile(
        line(
          week_day + week_day_modifier
        )
      )
    end

    def year_regex
      compile(
        line(
          potential_range(year)
        )
      )
    end

    def day_regex
      compile(
        line(
          potential_range(month_day)
        )
      )
    end

    def year_ph_regex
      compile(
        line(
          year + group(space + ph + '|' + '-' + year + space + ph)
        )
      )
    end

    def year_week_regex
      compile(
        line(
          potential_range(year) + space + week + space +
          group(
            potential_list(potential_range(week_number))
          )
        )
      )
    end

    def year_week_with_modifier_regex
      compile(
        line(
          potential_range(year) + space + week + space +
          potential_list(week_with_modifier)
        )
      )
    end

    def year_month_day_regex
      compile(
        line(
          potential_range(
            year + space + month + space + month_day,
            potential(year + space) + potential(month + space) + month_day
          )
        )
      )
    end

    def year_multi_month_day_regex
      compile(
        line(
          year + space +
          potential_list(
            month +
            group(
              space, potential_range(month_day)
            )
          )
        )
      )
    end

    def year_multi_month_regex
      compile(line(year + space + group(potential_range(month), potential_comma) + '*'))
    end

    def multi_month_regex
      compile(line(potential_list(potential_range(month))))
    end

    def week_value_regex
      compile(line(potential_list(potential_range(int_range(53)))))
    end

    def comment_regex
      compile(line(comment))
    end

    def year_month_regex
      compile(line(potential_range(year + space + month, potential(year + space) + month)))
    end

    def group(*args)
      "(#{args.join})"
    end

    def time
      group(int_range(24)) + ':' + group(int_range(59))
    end

    def full_time
      '24/7'
    end

    def int_range(max)
      raise ArgumentError, 'too high' if max > 99

      base = max / 10

      unit_max = max - base * 10
      base_ten = "[0-#{base - 1}]?"
      base_unit = '[0-9]'
      group(group("#{base_ten}#{base_unit}") + '|' + group("#{base}[0-#{unit_max}]"))
    end

    def potential(pattern)
      group(pattern) + '?'
    end

    def potential_range(pattern, optional_pattern = pattern)
      group(pattern, group('-', optional_pattern), '?')
    end

    def potential_list(pattern, optional_pattern = pattern)
      group(pattern, group(group(comma, optional_pattern), '?'), '*')
    end

    def week_day_modifier
      '\\[' + group('[1-5]|\\-1') + '\\]'
    end

    def comma
      ',' + space + '?'
    end

    def potential_comma
      ',? ?'
    end

    def space
      ' '
    end

    def week_number
      group('[01234]?[0-9]|5[0123]')
    end

    def week_modifier
      '\/[1-9]'
    end

    def week_with_modifier
      group(
        potential_range(week_number, week_number + potential(week_modifier))
      )
    end

    def week
      'week'
    end

    def modifier
      'off'
    end

    def ph
      'PH'
    end

    def week_day
      group('Mo|Tu|We|Th|Fr|Sa|Su')
    end

    def month_day
      group('[012]?[0-9]|3[01]')
    end

    def month
      group('Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec')
    end

    def year
      '\\d{4}'
    end

    def comment
      '\"[^\"]*\"'
    end

    def start_of_line
      '^'
    end

    def end_of_line
      '$'
    end

    def line(pattern)
      start_of_line + pattern + end_of_line
    end

    def compile(string)
      @compile ||= {}
      @compile[string] ||= Regexp.compile(string)
    end

    def escape(string)
      @escape ||= {}
      @escape[string] ||= Regexp.escape(string)
    end
  end
end
