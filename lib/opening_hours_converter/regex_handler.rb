module OpeningHoursConverter
  class RegexHandler
    def initialize
      @RGX_RULE_MODIFIER = /^(open|closed|off)$/i
      @RGX_WEEK_KEY = compile(line(week))
      @RGX_WEEK = compile(
        line(
          week + space + potential_list(
            potential_range(int_range(53))
          )
        )
      )

      @RGX_WEEK_VAL = compile(
        line(
          potential_list(
            potential_range(int_range(53))
          )
        )
      )

      @RGX_WEEK_WITH_MODIFIER = compile(
        line(
          week + space + potential_list(
            potential_range(int_range(53), non_capturing_group(int_range(53) + potential(week_modifier)))
          )
        )
      )

      @RGX_WEEK_VAL_WITH_MODIFIER = compile(
        line(
          potential_list(
            potential_range(int_range(53), non_capturing_group(int_range(53) + potential(week_modifier)))
          )
        )
      )


      @RGX_MONTH = compile(line(potential_range(month)))

      @RGX_MONTHDAY = compile(
        line(
          potential_range(month + space + month_day)
        )
      )

      @RGX_TIME = compile(
        line(
          potential_list(
            non_capturing_group(
              potential_range(
                non_capturing_group(time)
              ) + "|" + non_capturing_group(full_time)
            )
          )
        )
      )

      @RGX_WEEKDAY = compile(
        line(
          potential_list(
            non_capturing_group(
              potential_range(
                non_capturing_group(week_day)
              ) + "|" + non_capturing_group(ph)
            )
          )
        )
      )

      @RGX_HOLIDAY = compile(line(ph))

      @RGX_WD = compile(
        line(
          potential_range(week_day)
        )
      )

      @RGX_WD_WITH_MODIFIER = compile(
        line(
          week_day + week_day_modifier
        )
      )
      @RGX_DAY = compile(
        line(
          potential_range(month_day)
        )
      )
      @RGX_YEAR = compile(
        line(
          potential_range(year)
        )
      )

      @RGX_YEAR_PH = compile(
        line(
          year + non_capturing_group(space + ph + '|' + '-' + year + space + ph)
        )
      )
      # @RGX_MULTI_YEAR_PH = compile(
      #   line(
      #     year + '-' + year + space + ph
      #   )
      # ) # soon tm. We started with potential range but it would probably facilitate the code to detect in the regex whether we have
      # a range, a list of range, a list or a value

      @RGX_YEAR_WEEK = compile(
        line(
          potential_range(year) + space + week + space +
          non_capturing_group(
            potential_list(potential_range(week_number))
          )
        )
      )

      @RGX_YEAR_WEEK_WITH_MODIFIER = compile(
        line(
          potential_range(year) + space + week + space +
          potential_list(week_with_modifier)
        )
      )

      @RGX_YEAR_MONTH_DAY = compile(
        line(
          potential_range(
            year + space + month + space + month_day,
            potential(year + space) + potential(month + space) + month_day
          )
        )
      )

      @RGX_YEAR_MULTI_MONTH_DAY = compile(
        line(
          year + space +
          potential_list(
            month +
            non_capturing_group(
              space, potential_range(month_day)
            )
          )
        )
      )

      @RGX_YEAR_MULTI_MONTH = compile(
        line(
          year + space + non_capturing_group(potential_range(month), potential_comma) + '*'
        )
      )
      @RGX_YEAR_MONTH = compile(
        line(
          potential_range(year + space + month, potential(year + space) + month)
        )
      )
      @RGX_COMMENT = compile(
        line(
          comment
        )
      )
    end

    def group(*args)
      "(#{args.join})"
    end

    def time
      non_capturing_group(int_range(23)) + ":" + non_capturing_group(int_range(59))
    end

    def full_time
      "24/7"
    end

    def int_range(max)
      raise "too high" if max > 99
      base = max / 10

      unit_max = max - base * 10
      base_ten = "[0-#{base - 1}]?"
      base_unit = '[0-9]'
      non_capturing_group(non_capturing_group("#{base_ten}#{base_unit}") + "|" + non_capturing_group("#{base}[0-#{unit_max}]"))
    end

    def potential(pattern)
      non_capturing_group(pattern) + '?'
    end

    def potential_range(pattern, optional_pattern = pattern)
      non_capturing_group(pattern, non_capturing_group('-', optional_pattern), '?')
    end

    def potential_list(pattern, optional_pattern = pattern)
      non_capturing_group(pattern, non_capturing_group(non_capturing_group(comma, optional_pattern), '?'), '*')
    end

    def week_day_modifier
      "\\[" + non_capturing_group("[1-5]|\\-1") + "\\]"
    end

    def comma
      ',' + space + '?'
    end

    def capturing_group(*args)
      group(args)
    end

    def non_capturing_group(*args)
      group(['?:'] + args)
    end

    def potential_comma
      ',? ?'
    end

    def space
      ' '
    end

    def week_number
      non_capturing_group('[01234]?[0-9]|5[0123]')
    end

    def week_modifier
      '\/[1-9]'
    end

    def week_with_modifier
      non_capturing_group(
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
      non_capturing_group('Mo|Tu|We|Th|Fr|Sa|Su')
    end

    def month_day
      non_capturing_group('[012]?[0-9]|3[01]')
    end

    def month
      non_capturing_group('Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec')
    end

    def year
      "\\d{4}"
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
