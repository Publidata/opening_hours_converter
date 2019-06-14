module OpeningHoursConverter
  class DateRangeList
    attr_accessor :date_ranges

    def to_s(template: nil, as_period: true)
      date_ranges.map(&:to_s).join(',')
    end

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

    def known_years?
      date_ranges.all?(&:known_years)
    end

    def years_to_s
      if consecutives?(years)
        "#{sorted_date_ranges(part = :from).first.to_s('FROM YEAR')}-#{sorted_date_ranges(part = :to).last.to_s('TO YEAR')}"
      else
        consecutives(years).map do |year|
          if year.is_a?(Integer)
            year.to_s
          elsif year.is_a?(Hash)
            "#{year[:from]}-#{year[:to]}"
          end
        end.join(',')
      end
    end

    def all_years_similar?
      years.all? { |year| same_days(year, years.first) }
    end

    def years
      sorted_date_ranges.map do |date_range|
        [date_range.from.year, date_range.to.year]
      end.flatten.uniq.compact
    end

    def sorted_date_ranges(part = :from)
      @date_ranges.sort { |date_range1, date_range2| date_range1.send(part) <=> date_range2.send(part) }
    end
  end
end
