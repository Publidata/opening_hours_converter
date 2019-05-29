module OpeningHoursConverter
  class PeriodTip
    include Constants
    attr_accessor :date, :available_parts

    def initialize date, available_parts
      @date = date
      @available_parts = available_parts
    end

    def to_s(format = 'MONTH DAY')
      format.gsub!('DAY', day.to_s) if part_available?(:day)
      format.gsub!('MONTH', OSM_MONTHS[month - 1]) if part_available?(:month)
      format.gsub!('YEAR', year.to_s) if part_available?(:month)
    end

    def part_available? part
      available_parts.dig(part).nil? ? false : available_parts.dig(part)
    end

    def day
      date.day if part_available? :day
    end

    def month
      date.month if part_available? :month
    end

    def year
      date.year if part_available? :year
    end

    def all_available?
      [:day, :month, :year].all? { |part| part_available? part }
    end

    def > period_tip
      compare period_tip do |_date, period_tip_date|
        _date > period_tip_date
      end
    end

    def >= period_tip
      compare period_tip do |_date, period_tip_date|
        _date >= period_tip_date
      end
    end

    def < period_tip
      compare period_tip do |_date, period_tip_date|
        _date < period_tip_date
      end
    end

    def <= period_tip
      compare period_tip do |_date, period_tip_date|
        _date <= period_tip_date
      end
    end

    def == period_tip
      compare period_tip do |_date, period_tip_date|
        _date == period_tip_date
      end
    end

    def != period_tip
      compare period_tip do |_date, period_tip_date|
        _date != period_tip_date
      end
    end

    def - period_tip
      compare period_tip do |_date, period_tip_date|
        (_date - period_tip_date).to_i
      end
    end

    def compare period_tip, &block
      if all_available? && period_tip.all_available?
        yield date, period_tip.date
      elsif part_available? :year
        if !period_tip.part_available? :year
          same_year_copy = Date.new(year, period_tip.month, period_tip.day) # TODO : period tip is 29/02 bisextile
          yield date, same_year_copy
        end
      elsif period_tip.part_available? :year
        if !part_available? :year
          same_year_copy = Date.new(period_tip.year, month, day) # TODO : period tip is 29/02 bisextile
          yield same_year_copy, period_tip.date
        end
      else
        same_year_copy = Date.new(Date.today.year, period_tip.month, period_tip.day)
        yield date, same_year_copy
      end
    end
  end
end
