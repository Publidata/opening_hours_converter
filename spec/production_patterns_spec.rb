require 'opening_hours_converter'

# Patterns taken from a production dataset of 10808 distinct opening_hours
# values, reduced to syntactic signatures (days, months, years and times
# replaced by placeholders) and ranked by how many records use them. One
# representative string per signature.
#
# Expected values come from opening_hours.js, the reference implementation.
# Each case is annotated with its signature and its weight, so what a change
# would break is visible from here.
RSpec.describe OpeningHoursConverter::OpenIntervals, 'production patterns' do
  # The dataset these patterns come from is sanitised before evaluation: 24:00
  # becomes 23:59, 24/7 becomes a full day, and a string carrying no time at all
  # is read as a full day. The substitutions replace the first occurrence only,
  # as String#replace does in JavaScript without the global flag. Kept here so
  # the patterns are exercised exactly as they are stored.
  def sanitize(opening_hours)
    opening_hours.sub('24:00', '23:59').sub('24/7', '00:00-23:59')
  end

  def intervals(opening_hours, from, to)
    sane = sanitize(opening_hours)
    iterator = OpeningHoursConverter::Iterator.new

    if sane.include?(':') || sane.include?('off')
      iterator.get_open_intervals(sane, from, to)
    else
      begin
        iterator.get_open_intervals("#{sane} 00:00-23:59", from, to)
      rescue OpeningHoursConverter::ParseError
        iterator.get_open_intervals(sane, from, to)
      end
    end
  end

  # [opening hours, window first year, window last year, interval count,
  #  first interval start, first interval end]
  supported = [
    ['2024 Jan 2 06:00-22:00', 2024, 2025, 1, [2024, 1, 2, 6, 0], [2024, 1, 2, 22, 0]], # Y M N T-T — 48048 records
    ['24/7', 2026, 2027, 365, [2026, 1, 1, 0, 0], [2026, 1, 1, 23, 59]], # N/N — 43019 records
    ['2025 May 04 off', 2025, 2026, 0, nil, nil], # Y M N off — 38998 records
    ['Mo 9:00-12:00', 2026, 2027, 52, [2026, 1, 5, 9, 0], [2026, 1, 5, 12, 0]], # D T-T — 30724 records
    ['week 2-52/2 Th 6:00-12:00', 2026, 2027, 26, [2026, 1, 8, 6, 0], [2026, 1, 8, 12, 0]], # week N-N/N D T-T — 12062 records
    ['2023 Jan 01-2025 Jan 05 off "Fermeture"', 2023, 2026, 0, nil, nil], # Y M N-Y M N off "Fermeture" — 9280 records
    ['Tu,Fr 5:00-13:00', 2026, 2027, 104, [2026, 1, 2, 5, 0], [2026, 1, 2, 13, 0]], # D,D T-T — 8382 records
    ['2024 Oct-Dec off "Fermeture"', 2024, 2025, 0, nil, nil], # Y M-M off "Fermeture" — 4179 records
    ['2026 week 1-9/2 We 04:00-11:00', 2026, 2027, 4, [2026, 1, 14, 4, 0], [2026, 1, 14, 11, 0]], # Y week N-N/N D T-T — 3350 records
    ['2025 off "Fermeture"', 2025, 2026, 0, nil, nil], # Y off "Fermeture" — 3090 records
    ['Jan 01-Mar 08 off "Fermeture"', 2026, 2027, 0, nil, nil], # M N-M N off "Fermeture" — 2672 records
    ['Oct 5 10:00-14:00', 2026, 2027, 1, [2026, 10, 5, 10, 0], [2026, 10, 5, 14, 0]], # M N T-T — 2536 records
    ['PH off', 2026, 2027, 0, nil, nil], # PH off — 2466 records
    ['2026 week 1 Fr 00:00-23:59', 2026, 2027, 1, [2026, 1, 2, 0, 0], [2026, 1, 2, 23, 59]], # Y week N D T-T — 2180 records
    ['2026 Feb 22-2027 Jan 31 Th 06:00-23:59', 2026, 2028, 49, [2026, 2, 26, 6, 0], [2026, 2, 26, 23, 59]], # Y M N-Y M N D T-T — 1765 records
    ['2023 Jun 12-2030 Dec 31 off', 2023, 2026, 0, nil, nil], # Y M N-Y M N off — 1538 records
    ['Dec off "Fermeture"', 2026, 2027, 0, nil, nil], # M off "Fermeture" — 1516 records
    ['Jan 1 off', 2026, 2027, 0, nil, nil], # M N off — 1360 records
    ['09:00-19:00', 2026, 2027, 365, [2026, 1, 1, 9, 0], [2026, 1, 1, 19, 0]], # T-T — 1287 records
    ['Mo-Sa 9:30-19:00', 2026, 2027, 313, [2026, 1, 1, 9, 30], [2026, 1, 1, 19, 0]], # D-D T-T — 1127 records
    ['2025 week 8 off', 2025, 2026, 0, nil, nil], # Y week N off — 1032 records
    ['2021 May 01 off "work_day"', 2021, 2022, 0, nil, nil], # Y M N off "work_day" — 1014 records
    ['2023 Jan 01-2025 Jan 5 off;', 2023, 2026, 0, nil, nil], # Y M N-Y M N off; — 998 records
    ['2019 Dec 25 off "christmas"', 2019, 2020, 0, nil, nil], # Y M N off "christmas" — 990 records
    ['2022 Jan 01 off "new_year"', 2022, 2023, 0, nil, nil], # Y M N off "new_year" — 989 records
    ['Jan-Jun Mo 00:00-23:59', 2026, 2027, 26, [2026, 1, 5, 0, 0], [2026, 1, 5, 23, 59]], # M-M D T-T — 984 records
    ['2020 Aug 15 off "assomption"', 2020, 2021, 0, nil, nil], # Y M N off "assomption" — 926 records
    ['2020 Nov 01 off "toussaint"', 2020, 2021, 0, nil, nil], # Y M N off "toussaint" — 924 records
    ['week 1-17 Fr 05:30-13:00', 2026, 2027, 17, [2026, 1, 2, 5, 30], [2026, 1, 2, 13, 0]], # week N-N D T-T — 915 records
    ['week 33 off', 2026, 2027, 0, nil, nil], # week N off — 737 records
    ['2023 Jul 14 off "bastille_day"', 2023, 2024, 0, nil, nil], # Y M N off "bastille_day" — 666 records
    ['2023 May 18 off "rise"', 2023, 2024, 0, nil, nil], # Y M N off "rise" — 666 records
    ['2020 May 08 off "victory"', 2020, 2021, 0, nil, nil], # Y M N off "victory" — 666 records
    ['2023 Nov 11 off "armistice"', 2023, 2024, 0, nil, nil], # Y M N off "armistice" — 666 records
    ['2021 Apr 05 off "easter_monday"', 2021, 2022, 0, nil, nil], # Y M N off "easter_monday" — 666 records
    ['2022 Jun 06 off "pentecote_monday"', 2022, 2023, 0, nil, nil], # Y M N off "pentecote_monday" — 666 records
    ['Mo 13:00-20:00; Th 05:00-20:00', 2026, 2027, 105, [2026, 1, 1, 5, 0], [2026, 1, 1, 20, 0]], # D T-T; D T-T — 552 records
    ['2026 Mo 06:00-22:00', 2026, 2027, 52, [2026, 1, 5, 6, 0], [2026, 1, 5, 22, 0]], # Y D T-T — 551 records
    ['2019-2022 Mo 08:30-13:00', 2019, 2022, 156, [2019, 1, 7, 8, 30], [2019, 1, 7, 13, 0]], # Y-Y D T-T — 524 records
    ['2026-2028 week 1-53/2 Mo 00:00-23:59', 2026, 2029, 78, [2026, 1, 12, 0, 0], [2026, 1, 12, 23, 59]], # Y-Y week N-N/N D T-T — 487 records
    ['2023 Jun 12 - 2030 Dec 31 off', 2023, 2026, 0, nil, nil], # Y M N - Y M N off — 470 records
    ['2024 Nov 01 off "Fermeture"', 2024, 2025, 0, nil, nil], # Y M N off "Fermeture" — 448 records
    ['Th', 2026, 2027, 53, [2026, 1, 1, 0, 0], [2026, 1, 1, 23, 59]], # D — 406 records
    ['2023 off', 2023, 2024, 0, nil, nil], # Y off — 381 records
    ['Dec off', 2026, 2027, 0, nil, nil], # M off — 376 records
    ['Dec 1-Feb 28 off', 2026, 2027, 0, nil, nil], # M N-M N off — 360 records
    ['off', 2026, 2027, 0, nil, nil], # off — 346 records
    ['May-Sep Fr,Sa 10:00-19:00', 2026, 2027, 44, [2026, 5, 1, 10, 0], [2026, 5, 1, 19, 0]], # M-M D,D T-T — 329 records
    ['2026 Jan 3-2026 Jan 21', 2026, 2027, 19, [2026, 1, 3, 0, 0], [2026, 1, 3, 23, 59]], # Y M N-Y M N — 324 records
    ['Mar 14-Dec 27 Tu 05:00-13:00', 2026, 2027, 41, [2026, 3, 17, 5, 0], [2026, 3, 17, 13, 0]], # M N-M N D T-T — 310 records
    ['2023 Mo,Th 05:00-23:00', 2023, 2024, 104, [2023, 1, 2, 5, 0], [2023, 1, 2, 23, 0]], # Y D,D T-T — 294 records
    ['We[2] 5:00-20:00', 2026, 2027, 12, [2026, 1, 14, 5, 0], [2026, 1, 14, 20, 0]], # D[N] T-T — 4676 records
    ['Mar,Nov Sa[3] 09:00-17:00', 2026, 2027, 2, [2026, 3, 21, 9, 0], [2026, 3, 21, 17, 0]], # M,M D[N] T-T — 1909 records
    ['Jan,Mar,Jun Mo[4]', 2026, 2027, 3, [2026, 1, 26, 0, 0], [2026, 1, 26, 23, 59]], # M,M D[N] — 345 records
    ['2025 Jan,Apr,Jul,Oct Th[2] 05:00-12:00', 2025, 2026, 4, [2025, 1, 9, 5, 0], [2025, 1, 9, 12, 0]], # Y M,M D[N] T-T — 328 records
    ['Mo[1]', 2026, 2027, 12, [2026, 1, 5, 0, 0], [2026, 1, 5, 23, 59]], # D[N] — 325 records

    # The entries below complete the coverage of the "nth weekday of month"
    # selector and of everything the OSM specification lets combine with it.
    # They were collected from the same production dataset by walking its
    # distinct values rather than its ranked signatures, so no record count is
    # attached to them. Expected values still come from opening_hours.js,
    # evaluated through the same `intervals` helper as the rows above.
    #
    # A. weekday_selector — wday "[" nth_entry "]"
    ['Sa[-1] 9:00-12:00', 2026, 2027, 12, [2026, 1, 31, 9, 0], [2026, 1, 31, 12, 0]], # D[-N] T-T
    ['Mo[-1]', 2026, 2027, 12, [2026, 1, 26, 0, 0], [2026, 1, 26, 23, 59]], # D[-N]
    ['2026 Apr,Dec Th[-2]', 2026, 2027, 2, [2026, 4, 23, 0, 0], [2026, 4, 23, 23, 59]], # Y M,M D[-N] with N > 1
    ['Th[1,3] 06:00-23:59', 2026, 2027, 24, [2026, 1, 1, 6, 0], [2026, 1, 1, 23, 59]], # D[N,N] T-T
    ['Sa[1,2,3,4] 14:00-18:30', 2026, 2027, 48, [2026, 1, 3, 14, 0], [2026, 1, 3, 18, 30]], # D[N,N,N,N] T-T
    ['We[2-4] 05:30-13:00', 2026, 2027, 36, [2026, 1, 14, 5, 30], [2026, 1, 14, 13, 0]], # D[N-N] T-T
    ['Sa[2],Sa[4] 09:00-13:00', 2026, 2027, 24, [2026, 1, 10, 9, 0], [2026, 1, 10, 13, 0]], # D[N],D[N] T-T, same day twice
    ['We[1],Tu[3] 05:30-13:00', 2026, 2027, 24, [2026, 1, 7, 5, 30], [2026, 1, 7, 13, 0]], # D[N],D[N] T-T, two days
    # 77 = 53 Thursdays + 24 Saturdays: the index binds to Sa only, not to the
    # whole sequence. Getting 24 here would mean the index leaked onto Th.
    ['Th,Sa[1,3] 14:00-18:30', 2026, 2027, 77, [2026, 1, 1, 14, 0], [2026, 1, 1, 18, 30]], # D,D[N,N] T-T

    # B. wide_range_selectors combined with an index
    ['Sep Sa[3] 08:00-12:00', 2026, 2027, 1, [2026, 9, 19, 8, 0], [2026, 9, 19, 12, 0]], # M D[N] T-T
    ['Jan Mar May Jul Sep Nov Th[3] 06:00-23:59', 2026, 2027, 6, [2026, 1, 15, 6, 0], [2026, 1, 15, 23, 59]], # M M M D[N] T-T, months separated by spaces
    ['Jan-Sep Th[2] 05:00-12:00', 2026, 2027, 9, [2026, 1, 8, 5, 0], [2026, 1, 8, 12, 0]], # M-M D[N] T-T
    ['Dec-Feb Su[3] 10:00-12:00', 2026, 2027, 3, [2026, 1, 18, 10, 0], [2026, 1, 18, 12, 0]], # M-M D[N] T-T, range wrapping the year
    ['Jan-Jun,Sep-Nov Sa[2,4] 09:00-12:00', 2026, 2027, 18, [2026, 1, 10, 9, 0], [2026, 1, 10, 12, 0]], # M-M,M-M D[N,N] T-T
    ['Jan: Tu[2,4] 09:00-19:00', 2026, 2027, 2, [2026, 1, 13, 9, 0], [2026, 1, 13, 19, 0]], # M: D[N,N] T-T — 565 records
    ['Jul: Th[1,3,5] 00:00-23:59', 2026, 2027, 3, [2026, 7, 2, 0, 0], [2026, 7, 2, 23, 59]], # M: D[N,N,N] T-T, including a 5th occurrence
    # No time selector at all, so the helper leaves the string untouched (it
    # holds a ":") and the whole day is expected, midnight to midnight.
    ['Feb,Apr,Jun,Sep: Tu[3]', 2026, 2027, 4, [2026, 2, 17, 0, 0], [2026, 2, 18, 0, 0]], # M,M: D[N]
    ['Mar 1-Nov 30 Mo[1] 13:00-16:00', 2026, 2027, 9, [2026, 3, 2, 13, 0], [2026, 3, 2, 16, 0]], # M N-M N D[N] T-T
    ['Sep 16-Jun 14 Sa[1] 09:00-12:00,13:00-17:00', 2026, 2027, 18, [2026, 1, 3, 9, 0], [2026, 1, 3, 12, 0]], # M N-M N D[N] T-T,T-T, range wrapping the year
    ['2026 Th[4] 05:00-12:00', 2026, 2027, 12, [2026, 1, 22, 5, 0], [2026, 1, 22, 12, 0]], # Y D[N] T-T
    ['2026-2027 We[4] 06:00-22:00', 2026, 2028, 24, [2026, 1, 28, 6, 0], [2026, 1, 28, 22, 0]], # Y-Y D[N] T-T
    ['2025 Oct-Dec Th[1] 06:00-22:00', 2025, 2026, 3, [2025, 10, 2, 6, 0], [2025, 10, 2, 22, 0]], # Y M-M D[N] T-T
    ['2025 Dec We[4] 06:00-22:00', 2025, 2026, 1, [2025, 12, 24, 6, 0], [2025, 12, 24, 22, 0]], # Y M D[N] T-T
    ['2026 Jul: Fr[1,3] 00:00-23:59', 2026, 2027, 2, [2026, 7, 3, 0, 0], [2026, 7, 3, 23, 59]], # Y M: D[N,N] T-T
    ['2025 Oct 01-2025 Dec 31 Th[4] 06:00-22:00', 2025, 2026, 3, [2025, 10, 23, 6, 0], [2025, 10, 23, 22, 0]], # Y M N-Y M N D[N] T-T
    ['2026 Feb 01-2027 Dec 31 Mo[4]', 2026, 2028, 23, [2026, 2, 23, 0, 0], [2026, 2, 23, 23, 59]], # Y M N-Y M N D[N]
    ['2022 Jan 01-2022 Sep 30 Tu[2],We[4] 05:30-13:00', 2022, 2023, 18, [2022, 1, 11, 5, 30], [2022, 1, 11, 13, 0]], # Y M N-Y M N D[N],D[N] T-T
    ['week 19-53 Fr[1] 05:30-13:00', 2026, 2027, 7, [2026, 6, 5, 5, 30], [2026, 6, 5, 13, 0]], # week N-N D[N] T-T
    ['week 12-52 Mo[2,4] 06:00-23:59', 2026, 2027, 18, [2026, 3, 23, 6, 0], [2026, 3, 23, 23, 59]], # week N-N D[N,N] T-T

    # C. variable_date — the index is a bound of the month-day range, not a
    # weekday selector. "Jun Mo[1]" means "the first Monday of June", and the
    # weekday selector that follows applies inside that range.
    ['Jun Mo[1]-Sep Sa[1] Mo-Sa 07:00-14:00', 2026, 2027, 83, [2026, 6, 1, 7, 0], [2026, 6, 1, 14, 0]], # M D[N]-M D[N] D-D T-T
    ['Oct Su[-1]-Mar Mo[1] Mo-Sa 08:30-12:15,13:45-17:30', 2026, 2027, 218, [2026, 1, 1, 8, 30], [2026, 1, 1, 12, 15]], # M D[-N]-M D[N] D-D T-T,T-T, wrapping the year
    ['Mar Mo[1]-Oct Su[-1] Mo-Sa 08:30-12:15,13:45-18:30', 2026, 2027, 408, [2026, 3, 2, 8, 30], [2026, 3, 2, 12, 15]], # M D[N]-M D[-N] D-D T-T,T-T
    # The additional rule after the comma carries no wide range of its own, so
    # its Fridays run all year and the first interval is in January, outside
    # the Jun-Sep range of the primary rule.
    ['Jun Mo[1]-Sep Sa[1] Mo,We,Sa 07:00-14:00, Fr 08:00-12:00', 2026, 2027, 93, [2026, 1, 2, 8, 0], [2026, 1, 2, 12, 0]], # M D[N]-M D[N] D,D,D T-T, D T-T

    # D. time_selector shapes carried by an indexed weekday
    ['Sa[4] 10:00-12:00,15:00-18:00', 2026, 2027, 24, [2026, 1, 24, 10, 0], [2026, 1, 24, 12, 0]], # D[N] T-T,T-T
    ['We[2] 00:00-24:00', 2026, 2027, 12, [2026, 1, 14, 0, 0], [2026, 1, 14, 23, 59]], # D[N] T-24:00, rewritten to 23:59 by the helper
    ['Tu[2] 15:00-00:00', 2026, 2027, 12, [2026, 1, 13, 15, 0], [2026, 1, 14, 0, 0]], # D[N] T-T crossing midnight
    ['Tu[2] 15:00-00:00; We[2] 00:00-13:30', 2026, 2027, 14, [2026, 1, 13, 15, 0], [2026, 1, 14, 13, 30]], # D[N] T-T; D[N] T-T, second rule resuming at midnight

    # E. rule modifiers and rule separators
    ['Jul-Aug Th[2,4] 09:00-19:00, Sep-Nov Th 09:00-19:00', 2026, 2027, 17, [2026, 7, 9, 9, 0], [2026, 7, 9, 19, 0]], # M-M D[N,N] T-T, M-M D T-T — additional rule
    ['Sa[1] 14:30-17:30 open "first weekend in the month"', 2026, 2027, 12, [2026, 1, 3, 14, 30], [2026, 1, 3, 17, 30]], # D[N] T-T open "comment"
    ['Mo[4] 5:00-12:00; 2019 Jan 01 off "new_year"', 2019, 2020, 12, [2019, 1, 28, 5, 0], [2019, 1, 28, 12, 0]], # D[N] T-T; Y M N off "comment"

    # F. Values the specification does not allow but the reference evaluator
    # still reads. They exist in the dataset, so the expectation here is the
    # reference's own output, not a parse error.
    ['Dec-Jan We [2,4] 09:00-19:00', 2026, 2027, 4, [2026, 1, 14, 9, 0], [2026, 1, 14, 19, 0]], # M-M D [N,N] T-T, space before the bracket
    ['Dec-Feb Mo [2, 4]  09:00-19:00', 2026, 2027, 6, [2026, 1, 12, 9, 0], [2026, 1, 12, 19, 0]], # M-M D [N, N]  T-T, spaces before the bracket, inside the list and before the time
    ['We[2,4] Sa[3] 09:30-12:30', 2026, 2027, 36, [2026, 1, 14, 9, 30], [2026, 1, 14, 12, 30]], # D[N,N] D[N] T-T, days separated by a space instead of a comma
    ['Sat[1] 09:00-13:00', 2026, 2027, 12, [2026, 1, 3, 9, 0], [2026, 1, 3, 13, 0]], # D[N] T-T with a three-letter weekday
    ['Feb: Mo[1,3] 09:00-19:00 Mar-Jun Th 09:00-19:00', 2026, 2027, 31, [2026, 2, 2, 9, 0], [2026, 2, 2, 19, 0]] # two rules with no separator between them
  ].freeze

  supported.each do |opening_hours, first_year, last_year, count, start_at, end_at|
    it "matches the reference for #{opening_hours.inspect}" do
      result = intervals(opening_hours, Time.new(first_year, 1, 1), Time.new(last_year, 1, 1))

      expect(result.size).to eql(count)
      expect(result.first).to eql(start_at.nil? ? nil : { start: Time.new(*start_at), end: Time.new(*end_at) })
    end
  end

  # Selectors the parser does not read yet, and that the list above does not
  # claim. Callers fall back to the JavaScript evaluator for them. Should
  # support be added, these examples fail and become the place to assert the
  # new behaviour.
  unsupported = [
    '2024 Jan 01-2025 Jan 31 week 02-52/2 Mo 06:00-23:59', # Y M N-Y M N week N-N/N D T-T — 383 records
    '2024,2025 Tu 14:00-21:00' # Y,Y D T-T — 302 records
  ].freeze

  unsupported.each do |opening_hours|
    it "does not read #{opening_hours.inspect} yet" do
      expect { intervals(opening_hours, Time.new(2026, 1, 1), Time.new(2027, 1, 1)) }
        .to raise_error(OpeningHoursConverter::ParseError)
    end
  end

  describe 'known divergence from the reference' do
    it 'opens a single date whose weekday selector the parser dropped' do
      # 2022-01-01 is a Saturday, so opening_hours.js returns nothing here. The
      # parser turns a single date into a Day typical and discards the weekday
      # selector, which makes the date open whatever weekday it names: "Mo",
      # "Th" and "Mo,Th" all parse to the same thing. 96 distinct values and 546
      # records in production; closing the gap means keeping a Week typical in
      # the parser.
      result = intervals('2022 Jan 01-2022 Jan 01 Mo,Th 06:00-12:00', Time.new(2022, 1, 1), Time.new(2023, 1, 1))

      expect(result).to eql([{ start: Time.new(2022, 1, 1, 6, 0), end: Time.new(2022, 1, 1, 12, 0) }])
    end
  end
end
