require 'opening_hours_converter'

# Expected values in this file come from opening_hours.js, the reference
# implementation this gem is compared against.
RSpec.describe OpeningHoursConverter::OpenIntervals do
  def intervals(opening_hours, from, to)
    OpeningHoursConverter::Iterator.new.get_open_intervals(opening_hours, from, to)
  end

  def pairs(opening_hours, from, to)
    intervals(opening_hours, from, to).map { |i| [i[:start], i[:end]] }
  end

  describe 'window' do
    it 'clamps the intervals to the window' do
      result = pairs('Mo-Fr 09:00-17:00', Time.new(2026, 6, 3, 12, 0), Time.new(2026, 6, 5, 10, 0))

      expect(result).to eql(
        [
          [Time.new(2026, 6, 3, 12, 0), Time.new(2026, 6, 3, 17, 0)],
          [Time.new(2026, 6, 4, 9, 0), Time.new(2026, 6, 4, 17, 0)],
          [Time.new(2026, 6, 5, 9, 0), Time.new(2026, 6, 5, 10, 0)]
        ]
      )
    end

    it 'returns nothing when the opening hours are off' do
      expect(intervals('off', Time.new(2026, 1, 1), Time.new(2027, 1, 1))).to eql([])
    end

    it 'covers a window later than next year' do
      result = intervals('Mo-Fr 09:00-17:00', Time.new(2029, 1, 1), Time.new(2030, 1, 1))

      expect(result.size).to eql(261)
    end

    it 'covers a leap day' do
      result = intervals('Mo-Su 08:00-12:00', Time.new(2028, 1, 1), Time.new(2029, 1, 1))
               .select { |i| i[:start].month == 2 && i[:start].day == 29 }

      expect(result).to eql([{ start: Time.new(2028, 2, 29, 8, 0), end: Time.new(2028, 2, 29, 12, 0) }])
    end
  end

  describe 'off rules' do
    it 'removes a day of the week' do
      result = pairs('Mo-Fr 08:00-12:00; Tu off', Time.new(2026, 6, 1), Time.new(2026, 6, 8))

      expect(result).to eql(
        [
          [Time.new(2026, 6, 1, 8, 0), Time.new(2026, 6, 1, 12, 0)],
          [Time.new(2026, 6, 3, 8, 0), Time.new(2026, 6, 3, 12, 0)],
          [Time.new(2026, 6, 4, 8, 0), Time.new(2026, 6, 4, 12, 0)],
          [Time.new(2026, 6, 5, 8, 0), Time.new(2026, 6, 5, 12, 0)]
        ]
      )
    end

    it 'removes a single date' do
      result = pairs('Mo-Fr 08:00-18:00; Dec 25 off', Time.new(2026, 12, 21), Time.new(2026, 12, 28))

      expect(result.map(&:first)).to eql(
        [
          Time.new(2026, 12, 21, 8, 0),
          Time.new(2026, 12, 22, 8, 0),
          Time.new(2026, 12, 23, 8, 0),
          Time.new(2026, 12, 24, 8, 0)
        ]
      )
    end

    it 'removes public holidays' do
      # 2026-05-01 and 2026-05-08 are public holidays on a Friday, 2026-05-14 is
      # Ascension, on a Thursday.
      result = pairs('Mo-Fr 08:00-12:00; PH off', Time.new(2026, 5, 1), Time.new(2026, 5, 15))

      expect(result.map { |interval| interval.first.day }).to eql([4, 5, 6, 7, 11, 12, 13])
    end

    it 'lets a later rule override an earlier off rule' do
      result = intervals('Jul-Aug off; Mo-Fr 09:00-17:00', Time.new(2026, 7, 1), Time.new(2026, 8, 1))

      expect(result.size).to eql(23)
    end

    it 'lets a later off rule override an earlier rule' do
      result = intervals('Mo-Fr 09:00-17:00; Jul-Aug off', Time.new(2026, 7, 1), Time.new(2026, 8, 1))

      expect(result).to eql([])
    end

    # An off rule naming hours closes those hours and leaves the rest of the
    # day open, which is how the specification writes a lunch break.
    it 'cuts the hours a timed off rule names out of the day' do
      result = pairs('Mo-Fr 08:00-18:00; Mo-Fr 12:00-13:00 off', Time.new(2026, 6, 1), Time.new(2026, 6, 3))

      expect(result).to eql(
        [
          [Time.new(2026, 6, 1, 8, 0), Time.new(2026, 6, 1, 12, 0)],
          [Time.new(2026, 6, 1, 13, 0), Time.new(2026, 6, 1, 18, 0)],
          [Time.new(2026, 6, 2, 8, 0), Time.new(2026, 6, 2, 12, 0)],
          [Time.new(2026, 6, 2, 13, 0), Time.new(2026, 6, 2, 18, 0)]
        ]
      )
    end

    it 'leaves the weekdays a timed off rule does not name alone' do
      result = pairs('Mo-Fr 08:00-18:00; We 12:00-13:00 off', Time.new(2026, 6, 2), Time.new(2026, 6, 4))

      expect(result).to eql(
        [
          [Time.new(2026, 6, 2, 8, 0), Time.new(2026, 6, 2, 18, 0)],
          [Time.new(2026, 6, 3, 8, 0), Time.new(2026, 6, 3, 12, 0)],
          [Time.new(2026, 6, 3, 13, 0), Time.new(2026, 6, 3, 18, 0)]
        ]
      )
    end

    it 'shortens a day when the hours it closes end it' do
      result = pairs('Mo-Fr 08:00-18:00; Mo-Fr 17:00-18:00 off', Time.new(2026, 6, 1), Time.new(2026, 6, 2))

      expect(result).to eql([[Time.new(2026, 6, 1, 8, 0), Time.new(2026, 6, 1, 17, 0)]])
    end

    it 'closes hours reaching into two windows of the same day' do
      result = pairs('Mo-Fr 08:00-12:00,14:00-18:00; Mo-Fr 11:00-15:00 off',
                     Time.new(2026, 6, 1), Time.new(2026, 6, 2))

      expect(result).to eql(
        [
          [Time.new(2026, 6, 1, 8, 0), Time.new(2026, 6, 1, 11, 0)],
          [Time.new(2026, 6, 1, 15, 0), Time.new(2026, 6, 1, 18, 0)]
        ]
      )
    end

    it 'closes hours of a single date' do
      result = pairs('Jan 01 08:00-18:00; Jan 01 12:00-13:00 off', Time.new(2026, 1, 1), Time.new(2026, 1, 2))

      expect(result).to eql(
        [
          [Time.new(2026, 1, 1, 8, 0), Time.new(2026, 1, 1, 12, 0)],
          [Time.new(2026, 1, 1, 13, 0), Time.new(2026, 1, 1, 18, 0)]
        ]
      )
    end
  end

  describe 'intervals crossing midnight' do
    it 'ends them on the following day' do
      result = pairs('Mo-Fr 22:00-02:00', Time.new(2026, 6, 1), Time.new(2026, 6, 8))

      expect(result).to eql(
        [
          [Time.new(2026, 6, 1, 22, 0), Time.new(2026, 6, 2, 2, 0)],
          [Time.new(2026, 6, 2, 22, 0), Time.new(2026, 6, 3, 2, 0)],
          [Time.new(2026, 6, 3, 22, 0), Time.new(2026, 6, 4, 2, 0)],
          [Time.new(2026, 6, 4, 22, 0), Time.new(2026, 6, 5, 2, 0)],
          [Time.new(2026, 6, 5, 22, 0), Time.new(2026, 6, 6, 2, 0)]
        ]
      )
    end

    it 'keeps the part of an interval that started before the window' do
      # Sunday 2026-06-07 22:00 to Monday 02:00, seen from Monday onwards.
      result = pairs('Su 22:00-02:00', Time.new(2026, 6, 8), Time.new(2026, 6, 9))

      expect(result).to eql([[Time.new(2026, 6, 8), Time.new(2026, 6, 8, 2, 0)]])
    end
  end

  describe 'ISO weeks' do
    it 'includes the days a declared week borrows from the next year' do
      # Week 1 of 2026 starts on 2025-12-29, so that Wednesday belongs to it.
      result = pairs('2025 week 1-52/2 We 00:00-23:59', Time.new(2025, 1, 1), Time.new(2026, 1, 1))

      expect(result.last).to eql([Time.new(2025, 12, 31), Time.new(2025, 12, 31, 23, 59)])
    end

    it 'ignores a week index the year does not have' do
      # 2025 has 52 ISO weeks, so "week 53" selects nothing.
      result = intervals('2025 week 37-53/2 We 00:00-23:59', Time.new(2025, 1, 1), Time.new(2026, 1, 1))

      expect(result.size).to eql(8)
    end
  end

  describe 'date ranges' do
    it 'wraps a range that runs over New Year inside a single year' do
      result = pairs('2025 Dec 26-2025 Jan 13 00:00-23:59', Time.new(2025, 1, 1), Time.new(2026, 1, 1))

      expect(result.size).to eql(19)
      expect(result.first.first).to eql(Time.new(2025, 1, 1))
      expect(result.last.first).to eql(Time.new(2025, 12, 31))
    end
  end
end
