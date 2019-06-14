require 'opening_hours_converter/utils/utils'

module OpeningHoursConverter
  class WeekList < DateRangeList
    include Utils

    def initialize(weeks = [])
      @date_ranges = weeks

      clean
    end

    def clean
      if known_years?
        @date_ranges = date_ranges.reject { |week| week.index == 53 && week.to.month == 1 && WeekIndex.week_count(week.from.year) == 52 }
      end
    end

    def to_s
      "#{years_to_s} #{weeks_to_s}"
    end

    def weeks_to_s
      if consecutives?(week_indexes)
        "#{week_indexes[0].to_s}-#{week_indexes.last.to_s}"
      else
        consecutives_with_modifiers(week_indexes).map do |week_index|
          if week_index.is_a?(Integer)
            week_index.to_s
          elsif week_index.is_a?(Hash)
            if week_index.key?(:modifier)
              "#{week_index[:from]}-#{week_index[:to]}/#{week_index[:modifier]}"
            else
              "#{week_index[:from]}-#{week_index[:to]}"
            end
          end
        end.join(',')
      end
    end

    def week_indexes
      date_ranges.map(&:index).sort
    end

    def years_to_s
      binding.pry

      if consecutives?(years)
        min = years.min
        max = years.max
        if min == max
          min.to_s
        else
          "#{min}-#{max}"
        end
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
        if date_range.from.year == date_range.to.year
          [date_range.from.year]
        elsif date_range.from.year < date_range.to.year
          if date_range.index == 1
            [date_range.to.year]
          elsif [52, 53].include?(date_range.index)
            binding.pry

            [date_range.from.year]
          else
            binding.pry

            [date_range.from.year, date_range.to.year]
          end
        else
          raise 'what?'
        end
      end.flatten.uniq.compact
    end
  end
end
