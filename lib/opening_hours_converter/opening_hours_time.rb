module OpeningHoursConverter
  class OpeningHoursTime
    attr_reader :start, :end, :priority, :open_ended

    def initialize(minute_start = nil, minute_end = nil, open_ended = false)
      @start = minute_start
      @end = minute_end unless minute_start == minute_end
      @open_ended = open_ended
    end

    def get
      return 'off' if @start.nil? && @end.nil?
      return "#{time_string(@start)}+" if @open_ended
      "#{time_string(@start)}#{@end.nil? ? '' : "-#{time_string(@end)}"}"
    end

    def equals(t)
      @start == t.start && @end == t.end
    end

    def time_string(minutes)
      fminutes = minutes.to_f
      h = (fminutes / 60).floor.to_i
      m = (fminutes % 60).to_i
      "#{h < 10 ? '0' : ''}#{h}:#{m < 10 ? '0' : ''}#{m}"
    end
  end
end
