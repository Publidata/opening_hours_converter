require 'opening_hours_converter'

# OSM's "nth weekday of month" selector: `We[1]` (first Wednesday), `Sa[-1]`
# (last Saturday), etc. Every expected date below is derived by hand from the
# day-of-week of the 1st of the relevant month (checked independently with
# plain Ruby `Date#strftime('%A')`, not through the library under test):
#
#   2026-01-01 Thursday   2026-02-01 Sunday   2026-03-01 Sunday
#   2026-04-01 Wednesday  2026-05-01 Friday   2026-08-01 Saturday
#   2026-11-01 Sunday     2025-11-01 Saturday 2025-12-01 Monday
#
# The key assertion for every case is not just "it parses" but that the
# produced intervals contain ONLY the nth occurrence of the weekday per month,
# not every occurrence of that weekday.
RSpec.describe OpeningHoursConverter::OpenIntervals, 'nth weekday of month selector' do
  def intervals(opening_hours, from, to)
    OpeningHoursConverter::Iterator.new.get_open_intervals(opening_hours, from, to)
  end

  def dates(opening_hours, from, to)
    intervals(opening_hours, from, to).map { |i| i[:start].to_date }
  end

  it 'reads a single day + index + simple time range, one occurrence per month' do
    # First Wednesdays: Jan 1 is a Thursday so the first Wednesday is Jan 7;
    # Feb 1 and Mar 1 are Sundays so their first Wednesdays are Feb 4 and Mar 4.
    result = intervals('We[1] 05:00-20:00', Time.new(2026, 1, 1), Time.new(2026, 4, 1))

    expect(result).to eql(
      [
        { start: Time.new(2026, 1, 7, 5, 0), end: Time.new(2026, 1, 7, 20, 0) },
        { start: Time.new(2026, 2, 4, 5, 0), end: Time.new(2026, 2, 4, 20, 0) },
        { start: Time.new(2026, 3, 4, 5, 0), end: Time.new(2026, 3, 4, 20, 0) }
      ]
    )
  end

  it 'reads a day + index alone as a full day, like a bare weekday does' do
    # 4th Tuesdays: Jan 6,13,20,27 -> Jan 27. Feb 1 is a Sunday so Tuesdays
    # are 3,10,17,24 -> Feb 24. Mar 1 is a Sunday so Tuesdays are
    # 3,10,17,24,31 -> Mar 24.
    result = dates('Tu[4]', Time.new(2026, 1, 1), Time.new(2026, 4, 1))

    expect(result).to eql([Date.new(2026, 1, 27), Date.new(2026, 2, 24), Date.new(2026, 3, 24)])

    full_day = intervals('Tu[4]', Time.new(2026, 1, 27), Time.new(2026, 1, 28))
    expect(full_day).to eql([{ start: Time.new(2026, 1, 27, 0, 0), end: Time.new(2026, 1, 27, 23, 59) }])
  end

  it 'combines two rules with different indexes' do
    # Jan 1 is a Thursday: 1st Thursday is Jan 1. Saturdays are 3,10,17,24,31
    # so the 3rd is Jan 17. Feb 1 is a Sunday: Thursdays are 5,12,19,26 so the
    # 1st is Feb 5. Saturdays are 7,14,21,28 so the 3rd is Feb 21.
    result = dates('Th[1] 09:00-13:00; Sa[3] 09:00-13:00', Time.new(2026, 1, 1), Time.new(2026, 3, 1))

    expect(result).to eql(
      [Date.new(2026, 1, 1), Date.new(2026, 1, 17), Date.new(2026, 2, 5), Date.new(2026, 2, 21)]
    )
  end

  it 'combines a month-day range with a day + index, excluding months outside the range' do
    # Feb 1 2026 is a Sunday, so Feb's first Monday (Feb 2) would match Mo[1]
    # but falls outside "Mar 1-Nov 30" and must not appear. Mar 1 is a Sunday
    # so its first Monday is Mar 2. Apr 1 is a Wednesday so its first Monday
    # is Apr 6.
    result = dates('Mar 1-Nov 30 Mo[1] 13:00-16:00', Time.new(2026, 2, 1), Time.new(2026, 5, 1))

    expect(result).to eql([Date.new(2026, 3, 2), Date.new(2026, 4, 6)])
  end

  it 'combines a month list with a day + index' do
    # We[3] per listed month: Feb 1 is a Sunday (Wed 4,11,18,25 -> 18); May 1
    # is a Friday (Wed 6,13,20,27 -> 20); Aug 1 is a Saturday (Wed 5,12,19,26
    # -> 19); Nov 1 is a Sunday (Wed 4,11,18,25 -> 18). Months not listed
    # (e.g. Mar, Apr) must contribute nothing.
    result = dates('Feb,May,Aug,Nov We[3] 05:00-12:00', Time.new(2026, 1, 1), Time.new(2027, 1, 1))

    expect(result).to eql(
      [Date.new(2026, 2, 18), Date.new(2026, 5, 20), Date.new(2026, 8, 19), Date.new(2026, 11, 18)]
    )
  end

  it 'combines a full year-month-day range with a day + index' do
    # Nov 1 2025 is a Saturday: Fridays are 7,14,21,28 -> 2nd is Nov 14.
    # Dec 1 2025 is a Monday: Fridays are 5,12,19,26 -> 2nd is Dec 12.
    result = intervals('2025 Nov 01-2025 Dec 31 Fr[2] 06:00-22:00', Time.new(2025, 1, 1), Time.new(2026, 1, 1))

    expect(result).to eql(
      [
        { start: Time.new(2025, 11, 14, 6, 0), end: Time.new(2025, 11, 14, 22, 0) },
        { start: Time.new(2025, 12, 12, 6, 0), end: Time.new(2025, 12, 12, 22, 0) }
      ]
    )
  end

  it 'reads the negative index as the last occurrence of the weekday in the month' do
    # Last Saturdays: Jan has 3,10,17,24,31 -> 31. Feb 1 is a Sunday so
    # Saturdays are 7,14,21,28 -> 28. Mar 1 is a Sunday so Saturdays are
    # 7,14,21,28 (next would be Apr 4) -> 28.
    result = dates('Sa[-1] 09:00-12:00', Time.new(2026, 1, 1), Time.new(2026, 4, 1))

    expect(result).to eql([Date.new(2026, 1, 31), Date.new(2026, 2, 28), Date.new(2026, 3, 28)])
  end
end
