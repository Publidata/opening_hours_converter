module OpeningHoursConverter
  class OpeningHoursTime
    attr_reader :start, :end, :priority

    def initialize(minute_start=nil, minute_end=nil)
      @start = minute_start
      unless minute_start == minute_end
        @end = minute_end
      end
    end

    def get
      return "off" if (@start.nil? && @end.nil?)
      "#{time_string(@start)}#{@end.nil? ? "" : "-#{time_string(@end)}"}"
    end

    def equals(t)
      @start == t.start && @end == t.end
    end

    def time_string(minutes)
      fminutes = minutes.to_f
      h = (fminutes/60).floor.to_i
      m = (fminutes%60).to_i
      "#{h < 10 ? "0" : ""}#{h}:#{m < 10 ? "0" : ""}#{m}"
    end
  end
end
