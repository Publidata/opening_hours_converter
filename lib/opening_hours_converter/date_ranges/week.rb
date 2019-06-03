require 'opening_hours_converter/utils/utils'

module OpeningHoursConverter
  class Week < DateRange
    include Utils

    attr_accessor :index, :year, :known_year

    def initialize(index, year, known_year)
      @index = index
      week = WeekIndex.week_from_index
      @from = DateRangeTip.new(week.from, known_year)
      @to = DateRangeTip.new(week.to, known_year)
      @known_year = known_year
    end

    def to_s(template: nil, as_period: false)
      return super if as_period

      if template.nil?
        get
      else
        get_with_template(template)
      end
    end

    def get
      index.to_s
    end

    def get_with_template(template)
      template.gsub!('INDEX', index.to_s)

      template
    end

  end
end
