module OpeningHoursConverter
  class WeekList < DateRangeList
    def initialize(weeks = [])
      @date_ranges = weeks
      @weeks = weeks
    end
  end
end
