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
    }
    OSM_DAYS = [ "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su" ]
    IRL_DAYS = [ "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche" ]
    OSM_MONTHS = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
    IRL_MONTHS = [ "Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre",
      "Octobre", "Novembre", "Décembre" ]
    MONTH_END_DAY = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
    MINUTES_MAX = 1440
    DAYS_MAX = 6
    YEAR_DAYS_MAX = 365
  end
end
