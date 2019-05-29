require 'opening_hours_converter/utils/constants'

module OpeningHoursConverter
  class DateRangeTip
    include Constants
    attr_accessor :date, :known_year

    def initialize date, known_year
      @date = date
      @known_year = known_year
    end

    def to_s(format = 'MONTH DAY')
      format.gsub!('DAY', day.to_s)
      format.gsub!('MONTH', OSM_MONTHS[month - 1])
      format.gsub!('YEAR', year.to_s) if known_year

      format
    end

    def day
      date.day
    end

    def month
      date.month
    end

    def year
      date.year if known_year
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
      if known_year && period_tip.known_year
        yield date, period_tip.date
      elsif known_year
        if !period_tip.known_year
          same_year_copy = Date.new(year, period_tip.month, period_tip.day) # TODO : period tip is 29/02 bisextile
          yield date, same_year_copy
        end
      elsif period_tip.known_year
        if !known_year
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
