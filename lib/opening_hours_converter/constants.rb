require 'date'
module OpeningHoursConverter
  module Constants
    DAYS = {
      LUNDI: 0,
      MARDI: 1,
      MERCREDI: 2,
      JEUDI: 3,
      VENDREDI: 4,
      SAMEDI: 5,
      DIMANCHE: 6
    }.freeze
    OSM_DAYS = %w[Mo Tu We Th Fr Sa Su].freeze
    IRL_DAYS = %w[Lundi Mardi Mercredi Jeudi Vendredi Samedi Dimanche].freeze
    OSM_MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
    IRL_MONTHS = %W[Janvier Fevrier Mars Avril Mai Juin Juillet Aout Septembre
                    Octobre Novembre D\u00E9cembre].freeze
    MONTH_END_DAY = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31].freeze
    MINUTES_MAX = 1440
    DAYS_MAX = 6
    YEAR_DAYS_MAX = 365
    PH_WEEKDAY = -2
  end
end
