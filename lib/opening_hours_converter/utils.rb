module OpeningHoursConverter
  class Utils
    def timstring_as_minutes(time)
      values = time.split(':')
      values[0].to_i * 60 + values[1].to_i
    end
  end
end
