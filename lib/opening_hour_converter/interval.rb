class Interval
  def initialize(day_start, day_end, min_start, min_end)
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
