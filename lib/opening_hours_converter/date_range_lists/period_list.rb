module OpeningHoursConverter
  class PeriodList
    attr_accessor :periods

    def initialize(periods = [])
      @date_ranges = periods
      @periods = periods
    end
  end
end
