require 'opening_hours_converter/utils/constants'
require 'opening_hours_converter/utils/utils'

module OpeningHoursConverter
  class PeriodList < DateRangeList
    include Constants
    include Utils
    attr_accessor :periods

    def initialize(periods = [])
      @date_ranges = periods
      @periods = periods
    end

    def to_s
      return '' if periods.length == 0
      if periods.length == 1
        periods.first.to_s
      else
        if all_years_similar?
          if periods.all?(&:full_year?)
            years_to_s
          else
            years_to_s + ' ' + months_with_days_to_s
          end
        else
          super
        end
      end
    end

    def years_to_s
      if consecutives?(years)
        "#{sorted_periods(part = :from).first.to_s('FROM YEAR')}-#{sorted_periods(part = :to).last.to_s('TO YEAR')}"
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

    def months_with_days_to_s
      x=months_with_days(years.first).map do |month, days|
        if month.is_a?(Integer) && days.is_a?(Array)
          days = consecutives(days.map(&:day))

          result = "#{OSM_MONTHS[month - 1]} "
          result += days.map do |day|
            if day.is_a?(Integer)
              day.to_s
            elsif day.is_a?(Hash)
              "#{day[:from]}-#{day[:to]}"
            end
          end.join(',')

        elsif month[0] == month[1]
          if days[0].day == 1 && days[1].day == last_day_of_month(month[0] - 1, years.first)
            OSM_MONTHS[month[0] - 1]
          else
            "#{OSM_MONTHS[month[0] - 1]} #{days[0].day}-#{days[1].day}"
          end
        else
          "#{OSM_MONTHS[month[0] - 1]} #{days[0].day}-#{OSM_MONTHS[month[1] - 1]} #{days[1].day}"
        end
      end.join(',')
    end

    def consecutives?(array_of_int)
      array_of_int.reduce(array_of_int.first - 1) do |reduced, value|
        return false unless reduced == value - 1
        reduced += 1
      end
    end

    def consecutives(array_of_int)
      array_of_int.reduce([]) do |reduced, value|
        if reduced == []
          reduced << value
        else
          if reduced.last.is_a?(Hash)
            if reduced.last[:to] == value - 1
              reduced.last[:to] = value
            else
              reduced << value
            end
          elsif reduced.last.is_a?(Integer)
            if reduced.last == value - 1
              from = reduced.last
              reduced[reduced.length - 1] = { from: from, to: value }
            else
              reduced << value
            end
          end
        end

        reduced
      end
    end

    def all_years_similar?
      years.all? { |year| same_days(year, years.first) }
    end

    def years
      sorted_periods.map do |period|
        [period.from.year, period.to.year]
      end.flatten.uniq.compact
    end

    def months
      sorted_periods.map do |period|
        [period.from.month, period.to.month]
      end.flatten.uniq.compact
    end

    def days
      sorted_periods.map do |period|
        [period.from.day, period.to.day]
      end.flatten.uniq.compact
    end

    def months_with_days(year = nil)
      m = {}
      if years.nil?
        months.each do |month|
          periods.select { |period|
            period.from.month == month || period.to.month == month
          }.each do |period|
            if period.from.month != period.to.month
              m[[period.from.month, period.to.month]] = [period.from, period.to]
            else

              (period.from.date..period.to.date).map do |date|
                break unless date.month == month

                m[month] ||= []
                m[month] << date
              end
            end
          end
        end
      else
        months.each do |month|
          periods.select { |period|
            (period.from.year == year || period.to.year == year) &&
            (period.from.month == month || period.to.month == month)
          }.map do |period|
            if period.from.month != period.to.month
              m[[period.from.month, period.to.month]] = [period.from, period.to]
            else
              if period.full_month?
                m[[period.from.month, period.to.month]] = [period.from, period.to]
              else
                (period.from.date..period.to.date).map do |date|
                  break unless date.month == month

                  m[month] ||= []
                  m[month] << date
                end
              end
            end
          end
        end
      end
      m
    end

    def same_days(year1, year2)
      days_for_year(year1).map { |d| [d.month, d.day] unless d.month == 2 && d.day == 29 }.compact.sort == days_for_year(year2).map { |d| [d.month, d.day] unless d.month == 2 && d.day == 29 }.compact.sort
    end

    def days_for_year(year)
      periods.select { |period| period.from.year == year || period.to.year == year}.map do |period|
        (period.from.date..period.to.date).map do |date|
          break unless date.year == year

          date
        end
      end.flatten
    end

    def days_for_month(month, year = nil)
      if year.nil?
        periods.select { |period|
          period.from.month == month || period.to.month == month
        }.map do |period|
          if period.from.month != period.to.month
            [period.from, period.to]
          else
            (period.from.date..period.to.date).map do |date|
              break unless date.month == month

              date
            end
          end
        end.flatten
      else
        periods.select { |period|
          (period.from.year == year || period.to.year == year) &&
          (period.from.month == month || period.to.month == month)
        }.map do |period|
          (period.from.date..period.to.date).map do |date|
            break unless date.year == year && date.month == month

            date
          end
        end.flatten
      end
    end

    def month_for_year(year)
      periods.map do |period|
        if period.in_year?(year)
          [period.from.year, period.to.year]
        end
      end.flatten.uniq.compact
    end

    def sorted_periods(part = :from)
      @periods.sort { |period1, period2| period1.send(part) <=> period2.send(part) }
    end
  end
end
