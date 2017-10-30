module OpeningHoursConverter
  class PublicHoliday
    def self.easter(year=Time.now.year)
      # code from https://github.com/jrobertson/easter
      golden_number = (year % 19) + 1

      if year <= 1752 then
        # Julian calendar
        dominical_number = (year + (year / 4) + 5) % 7
        paschal_full_moon = (3 - (11 * golden_number) - 7) % 30
      else
        # Gregorian calendar
        dominical_number = (year + (year / 4) - (year / 100) + (year / 400)) % 7
        solar_correction = (year - 1600) / 100 - (year - 1600) / 400
        lunar_correction = (((year - 1400) / 100) * 8) / 25
        paschal_full_moon = (3 - 11 * golden_number + solar_correction - lunar_correction) % 30
      end

      dominical_number += 7 until dominical_number > 0

      paschal_full_moon += 30 until paschal_full_moon > 0
      paschal_full_moon -= 1 if paschal_full_moon == 29 or (paschal_full_moon == 28 and golden_number > 11)

      difference = (4 - paschal_full_moon - dominical_number) % 7
      difference += 7 if difference < 0

      day_easter = paschal_full_moon + difference + 1

      if day_easter < 11 then
        # Easter occurs in March.
        return Time.new(year, 3, day_easter + 21)
      else
        # Easter occurs in April.
        return Time.new(year, 4, day_easter - 10)
      end
    end

    def self.new_year(year=Time.now.year)
      Time.new(year, 1, 1)
    end

    def self.christmas(year=Time.now.year)
      Time.new(year, 12, 25)
    end

    def self.assomption(year=Time.now.year)
      Time.new(year, 8, 15)
    end

    def self.work_day(year=Time.now.year)
      Time.new(year, 5, 1)
    end

    def self.toussaint(year=Time.now.year)
      Time.new(year, 11, 1)
    end

    def self.victory(year=Time.now.year)
      Time.new(year, 5, 8)
    end

    def self.armistice(year=Time.now.year)
      Time.new(year, 11, 11)
    end

    def self.bastille_day(year=Time.now.year)
      Time.new(year, 7, 14)
    end

    def self.easter_monday(year=Time.now.year)
      easter(year) + days(1)
    end

    def self.good_friday(year=Time.now.year)
      easter(year) - days(2)
    end

    def self.rise(year=Time.now.year)
      easter(year) + days(39)
    end

    def self.pentecote(year=Time.now.year)
      easter(year) + days(49)
    end

    def self.pentecote_monday(year=Time.now.year)
      easter(year) + days(50)
    end

    def self.ph_for_year(year=Time.now.year)
      ph = []
      ph << new_year
      ph << good_friday
      ph << easter
      ph << easter_monday
      ph << work_day
      ph << victory
      ph << rise
      ph << pentecote
      ph << pentecote_monday
      ph << bastille_day
      ph << assomption
      ph << toussaint
      ph << armistice
      ph << christmas
      ph.sort
    end

    def self.days(days=0)
      days * 24 * 60 * 60
    end
  end
end
