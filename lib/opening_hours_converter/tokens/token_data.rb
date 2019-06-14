require 'opening_hours_converter/utils/constants'
require 'opening_hours_converter/utils/utils'

module OpeningHoursConverter
  class TokenData
    include Constants
    include Utils
    attr_accessor :years, :months, :weeks, :times

    def initialize
      @years = []
      @months = []
      @weeks = []
      @times = []
    end

    def valid?
      return months.length == 0 if weeks.length >= 1

      return true
    end

    def weeks?
      valid? && weeks.length >= 1
    end

    def periods?
      true
    end

    def create_period(from, to, year_available)
      from = Date.new(from[:year], from[:month], from[:day] || 1)
      to = Date.new(to[:year], to[:month], to[:day] || last_day_of_month(to[:month] - 1, to[:year] || Date.today.year))
      Period.new(from, to, year_available)
    end

    def create_periods
      if years.length > 0
        if months.length == 1 && months.first[:from].is_a?(Hash) && years.length == 1
          create_period_with({ from: years.first[:from], to: years.first[:to] }, true)
        else
          years.map do |year|
            (year[:from]..year[:to]).map do |range_year|
              create_period_with({ from: range_year, to: range_year }, true)
            end
          end.flatten
        end
      else
        create_period_with({ from: Date.today.year, to: Date.today.year }, false).flatten
      end
    end

    def create_period_with year, year_known
      if months.length == 0
        create_period({
          year: year[:from],
          month: 1,
          day: 1
        }, {
          year: year[:to],
          month: 12,
          day: 31
        }, year_known)
      else
        months.map do |month|
          if month[:from].is_a?(Hash)
            create_period({
              year: year[:from],
              month: month[:from][:month],
              day: month[:from][:day]
            }, {
              year: year[:to],
              month: month[:to][:month],
              day: month[:to][:day]
            }, year_known)
          elsif month[:days] && month[:days].length > 0
            month[:days].map do |day|
              (month[:from]..month[:to]).map do |range_month|
                create_period({
                  year: year[:from],
                  month: range_month,
                  day: day[:from]
                }, {
                  year: year[:to],
                  month: range_month,
                  day: day[:to]
                }, year_known)
              end
            end
          else
            create_period({
              year: year[:from],
              month: month[:from],
              day: nil
            }, {
              year: year[:to],
              month: month[:to],
              day: nil
            }, year_known)
          end
        end
      end
    end

    def create_weeks
      if years.length > 0
        years.map do |year|
          (year[:from]..year[:to]).map do |range_year|
            create_week_with(range_year, weeks, true)
          end
        end.flatten
      else
        create_week_with(Date.now.year, weeks, false)
      end
    end

    def create_week_with(year, weeks, year_known)
      weeks.map do |week|
        if week.key?(:modifier) && week[:modifier] > 1

          (week[:from]..week[:to]).each_with_index.map do |week_index, index|
            next unless index % week[:modifier] == 0

            Week.new(week_index, year, year_known)
          end.compact
        else
          (week[:from]..week[:to]).map do |week_index|
            Week.new(week_index, year, year_known)
          end
        end
      end.flatten
    end

    def to_date_range_list
      if weeks?
        WeekList.new(
          create_weeks
        )
      elsif periods?
        PeriodList.new(
          create_periods
        )
      end
    end
  end
end
