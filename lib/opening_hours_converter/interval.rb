require 'opening_hours_converter/constant'

class Interval
  attr_accessor :day_start, :day_end, :start, :end

  def initialize(day_start, min_start, day_end=0, min_end=0)
    @day_start = day_start
    @day_end = day_end
    @start = min_start
    @end = min_end

    if @day_end == 0 && @end == 0
      @day_end = DAYS_MAX
      @end = MINUTES_MAX
    end
  end
end
