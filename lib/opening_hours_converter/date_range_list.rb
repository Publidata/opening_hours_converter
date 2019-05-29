module OpeningHoursConverter
  class DateRangeList
    attr_accessor :date_ranges

    def width
      return 0 if date_ranges.length == 0

      date_ranges.map(&:width).sum
    end

    def == date_range
      date_ranges.all? { |dr| dr == date_range } if date_range.is_a?(DateRange)
      date_ranges == date_range.date_ranges if date_range.is_a?(DateRangeList)
    end

    def touch? date_range
      date_ranges.any? { |dr| dr.touch? date_range } if date_range.is_a?(DateRange)
      date_ranges.any? { |dr| date_range.any? { |dr2| dr.touch? dr2 } } if date_range.is_a?(DateRangeList)
    end

    def contains? date_range
      date_ranges.any? { |dr| p.contains? date_range } if date_range.is_a?(DateRange)
      date_range.all? { |dr2| date_ranges.any? { |dr| dr.contains? dr2 } } if date_range.is_a?(DateRangeList)
    end
  end
end
