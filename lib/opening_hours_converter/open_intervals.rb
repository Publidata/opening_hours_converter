require 'opening_hours_converter/constants'

module OpeningHoursConverter
  # Projects parsed date ranges onto a concrete window and returns the open
  # intervals it contains.
  #
  # Rules are applied in the order they were parsed, and a later rule overrides
  # an earlier one on the minutes it selects, as the OpenStreetMap
  # specification requires: "Jul-Aug off; Mo-Fr 09:00-17:00" is open in July,
  # while "Mo-Fr 09:00-17:00; Jul-Aug off" is closed.
  #
  # A rule behind a "||" is the exception. It is a fallback: it speaks only for
  # the minutes the rules before it leave closed, and never over the ones they
  # open. "Mo-Fr 08:00-12:00 || Sa 10:00-12:00" opens on Saturday and changes
  # nothing from Monday to Friday.
  class OpenIntervals
    include Constants
    include Utils

    # The state of a minute an open-ended time covers, told apart from a plain
    # open minute so that the two never run into a single interval.
    OPEN_ENDED = :open_ended

    def self.call(opening_hours_string, from, to)
      date_ranges = OpeningHoursConverter::OpeningHoursParser.new.parse(opening_hours_string)
      new(from, to).apply(date_ranges).intervals
    end

    def initialize(from, to)
      @from = from
      @to = to
      # One day before the window, so an interval crossing midnight into it is
      # not lost.
      @first_date = from.to_date - 1
      @last_date = to.to_date
      @masks = {}
      @fallback = false
      @holidays = {}
    end

    def apply(date_ranges)
      expand(date_ranges).each { |date_range, bounds| apply_date_range(date_range, bounds) }

      fallback = date_ranges.first&.fallback_ranges
      return self if fallback.nil? || fallback.empty?

      # Everything past a "||" is a fallback, and stays one: a chained
      # "a || b || c" nests, c falling back on what a and b leave closed.
      @fallback = true
      apply(fallback)
    end

    def intervals
      runs.select { |run| run[:end] > @from && run[:start] < @to }
          .map { |run| { start: [run[:start], @from].max, end: [run[:end], @to].min } }
    end

    private

    # Week and holiday selectors carry several date ranges rather than one, and
    # WideInterval#to_day resolves them for Time.now.year only. They are
    # expanded here for every year the window touches instead.
    #
    # Returns [date_range, bounds] pairs, bounds being the dates the range is
    # allowed to cover (nil for the whole window).
    def expand(date_ranges)
      date_ranges.flat_map do |date_range|
        case date_range.wide_interval.type
        when 'week' then expand_to_days(date_range, :get_weeks_for_year)
        when 'holiday' then expand_to_days(date_range, :get_public_holidays_for_year)
        when 'variable_day' then expand_to_days(date_range, :get_variable_days_for_year)
        else [[clamp_open_ended_year(date_range), nil]]
        end
      end
    end

    # "2020+" applies from its start year through the end of the window:
    # Year#build_day_array_from_date_range has no concept of an unbounded
    # range, so it needs a concrete (if window-dependent) end year here.
    def clamp_open_ended_year(date_range)
      wide_interval = date_range.wide_interval
      return date_range unless wide_interval.type == 'year' && wide_interval.open_ended && wide_interval.end.nil?

      copy = date_range.dup
      copy.update_range(OpeningHoursConverter::WideInterval.new.year(wide_interval.start[:year], @last_date.year))
      copy
    end

    # An ISO week declared with a year can start in the previous year or end in
    # the next one ("2025 week 1" starts on 2025-12-29), so the neighbouring
    # years are expanded too and their surplus days are cut back by the declared
    # years. Without a declared year the window itself selects the years.
    def expand_to_days(date_range, builder)
      wide_interval = date_range.wide_interval
      bounds = declared_bounds(wide_interval)
      years = if bounds
                (bounds.first.year - 1)..(bounds.last.year + 1)
              else
                @first_date.year..@last_date.year
              end

      years.flat_map { |year| wide_interval.send(builder, year) }
           .map { |day| [with_range(date_range, day), bounds] }
    end

    def declared_bounds(wide_interval)
      return nil if wide_interval.start.nil? || wide_interval.start[:year].nil?

      last_year = wide_interval.end && wide_interval.end[:year] || wide_interval.start[:year]
      Date.new(wide_interval.start[:year], 1, 1)..Date.new(last_year, 12, 31)
    end

    def with_range(date_range, wide_interval)
      copy = date_range.dup
      copy.update_range(wide_interval)
      copy
    end

    def apply_date_range(date_range, bounds = nil)
      intervals = date_range.typical.intervals.compact
      return if intervals.empty?

      weekly = date_range.typical.is_a?(OpeningHoursConverter::Week)
      days = covered_days(date_range)
      days = days.select { |date| bounds.cover?(date) } if bounds

      days.each do |date|
        intervals.each do |interval|
          next if weekly && !selects?(interval, date)

          write(date, interval)
        end
      end
    end

    # A day array keyed by "always" is a yearly pattern and applies to every
    # year of the window; one keyed by a year applies to that year only.
    def covered_days(date_range)
      years = OpeningHoursConverter::Year.build_day_array_from_date_range(date_range, false)

      (@first_date..@last_date).select do |date|
        months = years[date.year] || years['always']
        next false if months.nil?

        days = months[date.month - 1]
        # February rows are MONTH_END_DAY long, so Feb 29 follows Feb 28.
        !days.nil? && days[[date.day, days.size].min - 1]
      end
    end

    def selects?(interval, date)
      # A day offset shifts the date the selector names onto another one, so
      # the selector is asked about the day it counts from rather than the day
      # the interval is written on.
      date -= interval.day_offset
      return public_holiday?(date) if interval.day_start == PH_WEEKDAY
      return easter?(date) if interval.day_start == EASTER_WEEKDAY
      return false unless interval.day_start == reindex_sunday_week_to_monday_week(date.wday)
      return true if interval.index.nil?

      interval.index.any? { |index| nth_weekday_of_month?(index, interval.day_start, date) }
    end

    def easter?(date)
      OpeningHoursConverter::PublicHoliday.easter(date.year).to_date == date
    end

    def nth_weekday_of_month?(index, weekday, date)
      target = OpeningHoursConverter::WeekIndex.nth_wday_of_month(index, weekday, date.month, date.year)
      target == date
    rescue ArgumentError
      false
    end

    def public_holiday?(date)
      @holidays[date.year] ||= OpeningHoursConverter::PublicHoliday.ph_for_year(date.year)
                                                                  .map { |holiday| [holiday.month, holiday.day] }
      @holidays[date.year].include?([date.month, date.day])
    end

    # An interval runs from (day_start, start) to (day_end, end). Only midnight
    # crossings give day_end > day_start, and their remaining minutes are
    # written on the dates that follow.
    #
    # A fallback rule skips the minutes that are already open: what the rules
    # before the "||" leave closed is what it answers for, whether they were
    # silent about it or closed it with an "off".
    def write(date, interval)
      remaining = (interval.day_end - interval.day_start) * MINUTES_MAX + interval.end
      first_minute = interval.start
      current = date
      open = !interval.is_off

      while remaining > 0
        mask = mask_for(current)
        minutes = [first_minute, 0].max...[remaining, MINUTES_MAX].min
        minutes.each { |minute| mask[minute] = open unless @fallback && mask[minute] } unless mask.nil?
        remaining -= MINUTES_MAX
        first_minute = 0
        current += 1
      end

      write_open_end(date, interval) if interval.open_ended && !interval.is_off
    end

    # An open end names no closing time ("10:00-12:00+"), so the rest of the
    # day stays open without being certain. It is written as a state of its
    # own, which keeps it from merging with the hours the string does name:
    # the reference reports the two as two intervals.
    def write_open_end(date, interval)
      mask = mask_for(date + (interval.day_end - interval.day_start))
      return if mask.nil?

      (interval.end...MINUTES_MAX).each { |minute| mask[minute] = OPEN_ENDED }
    end

    def mask_for(date)
      return nil unless (@first_date..@last_date).cover?(date)

      @masks[date] ||= Array.new(MINUTES_MAX, false)
    end

    # Walks the window as a continuous timeline, so a run of open minutes that
    # spans midnight comes out as a single interval. A minute carries the state
    # that opened it rather than a plain flag, so an open end closes the
    # interval before it instead of extending it.
    def runs
      result = []
      start = nil
      state = nil

      (@first_date..(@last_date + 1)).each do |date|
        mask = @masks[date]

        if mask.nil?
          next if start.nil?

          result << { start: start, end: time_at(date, 0) }
          start = nil
          state = nil
          next
        end

        (0...MINUTES_MAX).each do |minute|
          next if mask[minute] == state

          result << { start: start, end: time_at(date, minute) } if start
          start = mask[minute] ? time_at(date, minute) : nil
          state = mask[minute]
        end
      end

      result
    end

    # Built from wall clock components rather than by adding seconds, so a
    # daylight saving change does not shift the time of day.
    def time_at(date, minute)
      Time.new(date.year, date.month, date.day, minute / 60, minute % 60)
    end
  end
end
