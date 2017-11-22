require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class Interval
    include Constants
    attr_reader :day_start, :day_end, :start, :end, :is_off

    def initialize(day_start, min_start, day_end=0, min_end=0, is_off=false)
      @day_start = day_start
      @day_end = day_end
      @start = min_start
      @end = min_end
      @is_off = is_off

      if @day_end == 0 && @end == 0
        @day_end = DAYS_MAX
        @end = MINUTES_MAX
      end
    end
  end
end
