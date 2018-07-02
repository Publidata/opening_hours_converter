module OpeningHoursConverter
  class OpeningHoursTime
    attr_reader :start, :end
    attr_accessor :comment, :is_off

    def initialize(minute_start=nil, minute_end=nil, comment=nil, is_off=false)
      @start = minute_start
      if minute_start != minute_end
        @end = minute_end
      end
      @comment = comment
      @is_off = is_off
    end

    # GETTERS

    def get
      return "off#{get_comment}" if (@start.nil? && @end.nil?)
      result = ""
      result += time_string(@start)
      if !@end.nil?
        result += "-" + time_string(@end)
      end
      result += get_comment + get_modifier
      result
    end

    def get_modifier
      (@is_off || (@start.nil? && @end.nil?)) ? " off" : ""
    end

    def get_comment
      @comment ? " #{@comment}" : ""
    end

    def is_off?
      @is_off
    end

    def time_string(minutes)
      fminutes = minutes.to_f
      h = (fminutes/60).floor.to_i
      m = (fminutes%60).to_i
      "#{h < 10 ? "0" : ""}#{h}:#{m < 10 ? "0" : ""}#{m}"
    end

    # COMPARISONS

    def touch?(t)
      (@start <= t.start && @end >= t.start) || (@start <= t.end && @end >= t.end)
    end

    def same_modifiers?(t)
      @is_off == t.is_off && @comment == t.comment
    end

    def equals(t)
      @start == t.start && @end == t.end && same_modifiers?(t)
    end

    # MUTATIONS

    def merge!(t)
      raise ArgumentError unless touch?(t) && same_modifiers?(t)
      @start = t.start if t.start < @start
      @end = t.end if t.end > @end
    end
  end
end
