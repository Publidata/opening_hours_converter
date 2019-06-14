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
        if known_years?
          if periods.all?(&:full_year?)
            years_to_s
          else
            years_to_s + ' ' + months_with_days_to_s
          end
        else
          months_with_days_to_s
        end
      end
    end

    def months_with_days_to_s
      months_with_days(years.first).map do |month, days|
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
          if days[0].day == 1 && days[1].day == last_day_of_month(month[0] - 1, years.first || Date.today.year)
            OSM_MONTHS[month[0] - 1]
          else
            "#{OSM_MONTHS[month[0] - 1]} #{days[0].day}-#{days[1].day}"
          end
        else
          "#{OSM_MONTHS[month[0] - 1]} #{days[0].day}-#{OSM_MONTHS[month[1] - 1]} #{days[1].day}"
        end
      end.join(',')
    end

    def months
      sorted_date_ranges.map do |period|
        [period.from.month, period.to.month]
      end.flatten.uniq.compact
    end

    def days
      sorted_date_ranges.map do |period|
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
  end
end
