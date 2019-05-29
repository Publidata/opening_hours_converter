module OpeningHoursConverter
  class PeriodList
    attr_accessor :periods, :type

    def initialize(periods = [], type = :normal)
      @periods = periods
      @type = type
    end

    def width
      return 0 if @periods.length == 0

      @periods.map(&:width).sum
    end

    def == period
      @periods.all? { |p| p == period } if period.is_a?(Period)
      @periods == period.periods if period.is_a?(PeriodList)
    end

    def touch? period
      @periods.any? { |p| p.touch? period } if period.is_a?(Period)
      @periods.any? { |p| period.any? { |p2| p.touch? p2 } } if period.is_a?(PeriodList)
    end

    def contains? period
      @periods.any? { |p| p.contains? period } if period.is_a?(Period)
      period.all? { |p2| @periods.any? { |p| p.contains? p2 } } if period.is_a?(PeriodList)
    end
  end
end
