require 'opening_hours_converter/utils/utils'

module OpeningHoursConverter
  class Period < DateRange
    include Utils

    attr_accessor :from, :to, :known_years

    def initialize(from = Date.today, to = Date.today, known_years = true)
      @from = DateRangeTip.new(from, known_years)
      @to = DateRangeTip.new(to, known_years)
      @known_years = known_years
    end
  end
end