require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class Interval
    include Constants
    attr_reader :day_start, :day_end, :start, :end, :is_off, :index, :is_unknown, :open_ended

    # is_unknown is the OSM third state ("unknown", alongside open/off) and
    # open_ended is a time with no known closing time ("18:00+"). Both are
    # carried purely for round-trip serialization; for interval computation
    # is_unknown behaves like is_off (not open) and open_ended is treated as
    # running to the end of the day.
    def initialize(day_start, min_start, day_end = 0, min_end = 0, is_off = false, index = nil, is_unknown = false, open_ended = false)
      @day_start = day_start
      @day_end = day_end
      @start = min_start
      @end = min_end
      @is_off = is_off
      @index = index
      @is_unknown = is_unknown
      @open_ended = open_ended

      if @day_end == 0 && @end == 0
        @day_end = DAYS_MAX
        @end = MINUTES_MAX
      end
    end

    def single_day?
      @day_start == @day_end
    end

    def max?
      @day_end == DAYS_MAX && @end == MINUTES_MAX
    end

    def single_day_end_at_midnight?
      @day_end == @day_start + 1 && @end == 0
    end
  end
end
