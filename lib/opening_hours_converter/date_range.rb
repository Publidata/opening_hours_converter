module OpeningHoursConverter
  class DateRange
    def to_s(template = nil)
      if template.nil?
        get
      else
        get_with_template(template)
      end
    end

    def get
      return '' if always?

      if all_available?
        return "#{@from.to_s('YEAR')}" if full_year?
        if same_year?
          return "#{@from.to_s('YEAR MONTH DAY')}" if same_day?
          return "#{@from.to_s('YEAR MONTH DAY')}-#{@to.to_s('DAY')}" if same_month?
          return "#{@from.to_s('YEAR MONTH DAY')}-#{@to.to_s('MONTH DAY')}"
        else
          return "#{@from.to_s('YEAR')}-#{@to.to_s('YEAR')}" if start_year? && end_year?
          return "#{@from.to_s('YEAR MONTH DAY')}-#{@to.to_s('YEAR MONTH DAY')}"
        end
      else
        return "#{@from.to_s('MONTH DAY')}" if same_day?
        return "#{@from.to_s('MONTH DAY')}-#{@to.to_s('DAY')}" if same_month?
        return "#{@from.to_s('MONTH DAY')}-#{@to.to_s('MONTH DAY')}"
      end
    end

    def get_with_template template
      template.gsub!('FROM DAY', @from.day.to_s)
      template.gsub!('FROM MONTH', OSM_MONTHS[@from.month - 1])
      template.gsub!('FROM YEAR', @from.year.to_s) if known_years
      template.gsub!('TO DAY', @to.day.to_s)
      template.gsub!('TO MONTH', OSM_MONTHS[@to.month - 1])
      template.gsub!('TO YEAR', @to.year.to_s) if known_years

      template
    end

    def known_year?(part)
      known_years.dig(part)
    end

    def always?
      is_a?(Always)
    end

    def full_month?
      return false if always?
      return false unless same_month?

      from.month == to.month && from.day == 1 && to.day == last_day_of_month(to.month, to.year)
    end

    def full_year?
      return false if always?
      return false unless same_year?

      start_year? && end_year?
    end

    def start_year?
      from.day == 1 && from.month == 1
    end

    def end_year?
      to.month == 12 && to.day == 31
    end

    def same_year?
      from.year == to.year
    end

    def same_month?
      same_year? && from.month == to.month
    end

    def same_day?
      from.date == to.date
    end

    def == period
      return false if always? != period.always?
      return true if always? && period.always?

      from == period.from && to == period.to
    end

    def touch? period
      return false if self == period
      return true if always?

      to == period.from || from == period.to
    end

    def overlap? period
      return true if self == period
      return true if always?

      (from < period.from && to > period.from) || (from < period.to && to > period.to)
    end

    def contains? period
      return false if self == period
      return true if always?

      from <= period.from && to >= period.to
    end

    def width
      return Float::INFINITY if always?

      to - from
    end
  end
end
