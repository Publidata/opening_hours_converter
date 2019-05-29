module OpeningHoursConverter
  class Period
    include Utils

    attr_accessor :from, :to, :available_dates_parts, :type

    def initialize(from = Date.today, to = Date.today, available_dates_parts = {}, type = normal)
      @from = PeriodTip.new(from, available_dates_parts[:from])
      @to = PeriodTip.new(to, available_dates_parts[:to])
      @available_dates_parts = available_dates_parts

      # type can be :normal, :week or :public_holiday
      @type = type
    end

    def part_available?(part, sub_part = nil)
      if sub_part.nil?
        !available_dates_parts.dig(part).nil?
      else
        available_dates_parts.dig(part, sub_part).nil? ? false : available_dates_parts.dig(part, sub_part)
      end
    end

    def always?
      @available_dates_parts == {}
    end

    def full_month?
      return false if always?

      @from.month == @to.month && @from.day == 1 && @to.day == last_day_of_month(@to.month, @to.year)
    end

    def == period
      return false if always? != period.always?
      return true if always? && period.always?

      from == period.from && to == period.to
    end

    def touch? period
      return true if self == period
      return true if always?

      (from <= period.from && to >= period.from) || (from <= period.to && to >= period.to)
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
