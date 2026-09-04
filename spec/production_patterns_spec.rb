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
    ['Mo[1]', 2026, 2027, 12, [2026, 1, 5, 0, 0], [2026, 1, 5, 23, 59]] # D[N] — 325 records
  ].freeze

  supported.each do |opening_hours, first_year, last_year, count, start_at, end_at|
    it "matches the reference for #{opening_hours.inspect}" do
      result = intervals(opening_hours, Time.new(first_year, 1, 1), Time.new(last_year, 1, 1))

      expect(result.size).to eql(count)
      expect(result.first).to eql(start_at.nil? ? nil : { start: Time.new(*start_at), end: Time.new(*end_at) })
    end
  end

  # Selectors the parser does not read yet. They are 1266 of the 10808 distinct
  # values, 3.23% of the records, and callers fall back to the JavaScript
  # evaluator for them. Should support be added, these examples fail and become
  # the place to assert the new behaviour.
  unsupported = [
    'Jan: Tu[2,4] 09:00-19:00', # M: D[N,N] T-T — 565 records
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
