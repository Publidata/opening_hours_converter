require 'opening_hours_converter/utils/utils'

module OpeningHoursConverter
  class Week < DateRange
    include Utils

    attr_accessor :index, :year_known

    def initialize(index, year_known)
      @index = index
      week = WeekIndex.index_from_week
      @from = DateRangeTip.new(week.from, year_known)
      @to = DateRangeTip.new(week.to, year_known)
      @year_known = year_known
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
