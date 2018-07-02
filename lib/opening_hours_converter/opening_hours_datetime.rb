require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class OpeningHoursDatetime
    include Constants
    attr_accessor :weekdays, :weekdays_over, :weekdays_with_time
    attr_reader :wide_type, :wide

    def initialize(wide, wide_type)
      if wide.nil? || wide_type.nil?
        raise ArgumentError
      end

      @wide = wide
      @wide_type = wide_type
      @weekdays_with_time = {}

    end

    def clean(weekdays)
      merge_times(weekdays)
      sort_times
      merge_weekdays
    end

    def merge_times(weekdays)
      times = @weekdays_with_time[weekdays]
      return unless times
      times.each_with_index do |time, index|
        next if time.nil?
        for i in 0...times.length
          next if i == index || times[i].nil?
          if time.touch?(times[i]) && time.same_modifiers?(times[i])
            time = time.dup
            time.merge!(times[i])
            @weekdays_with_time[weekdays][index] = nil
            @weekdays_with_time[weekdays][i] = nil
            @weekdays_with_time[weekdays] << time
          end
        end
      end
      @weekdays_with_time[weekdays].compact!
    end

    def merge_weekdays
      keys = @weekdays_with_time.keys
      keys.each do |weekdays|
        next if @weekdays_with_time[weekdays].nil?
        days = [weekdays]
        times = @weekdays_with_time[weekdays]
        (keys - weekdays).each do |compare_weekdays|
          next if @weekdays_with_time[compare_weekdays].nil?
          if same_times(compare_weekdays, times)
            days << compare_weekdays
          end
        end
        days.each do |weekdays|
          @weekdays_with_time.delete(weekdays)
        end
        @weekdays_with_time[days.flatten.uniq] = times
      end
    end

    def sort_times
      @weekdays_with_time.each do |weekdays, times|
        @weekdays_with_time[weekdays].sort! { |a, b| a.start <=> b.start }
      end
    end

    def add_time_to_weekday(weekday, time)
      if @weekdays_with_time.keys.empty?
        @weekdays_with_time[[weekday]] = [time]
      end
      @weekdays_with_time.keys.each do |weekdays|
        if weekdays.include?(weekday)
          times = @weekdays_with_time[weekdays]
          return if times.include? time
          remove_weekday(weekdays, weekday)

          weekday_times = times + [time]
          if key = times_exist(weekday_times)
            add_weekday(key, weekday)
            clean(key)
          else
            @weekdays_with_time[[weekday]] = weekday_times
            clean([weekday])
          end
          return
        end
      end

      if key = times_exist([time])
        add_weekday(key, weekday)
        clean(weekdays)
      else
        @weekdays_with_time[[weekday]] = [time]
        clean(weekdays)
      end
    end

    def remove_time_from_weekday(weekday, compare_time)
      @weekdays_with_time.each do |weekdays, times|
        if weekdays.include?(weekday)

          return unless times.any? { |time| time.equal?(compare_time) }

          remove_weekday(weekdays, weekday)
          weekday_times = times - [compare_time]

          if key = times_exist(weekday_times)
            add_weekday(key, weekday)
          else
            @weekdays_with_time[[weekday]] = weekday_times
          end

          return

        end
      end
    end

    def add_time_to_weekdays(weekdays, time)
      weekdays.each do |weekday|
        add_time_to_weekday(weekday, time)
      end
    end

    def remove_weekday(weekdays, weekday_to_remove)
      if weekdays.length == 1
        @weekdays_with_time.delete(weekdays)
        return
      end
      @weekdays_with_time[(weekdays - [weekday_to_remove]).sort] = @weekdays_with_time.delete(weekdays)
    end

    def add_weekday(weekdays, weekday_to_add)
      @weekdays_with_time[(weekdays + [weekday_to_add]).sort] = @weekdays_with_time.delete(weekdays)
    end

    def time_exist(comparison_time)
      @weekdays_with_time.each do |weekdays, times|
        return weekdays if times.any? { |time| time.equals(comparison_time) }
      end
      false
    end

    def times_exist(comparison_times)
      @weekdays_with_time.each do |weekdays, times|
        return weekdays if same_times(weekdays, comparison_times)
      end
      false
    end

    def same_times(weekdays, times)
      return false unless @weekdays_with_time[weekdays].length == times.length

      @weekdays_with_time[weekdays].each do |self_time|
        return false unless times.any? { |time| time.equals(self_time) }
      end

      true
    end

    def get
      result = ""
      @weekdays_with_time.each do |weekdays, times|
        if times.map { |t| [t.comment, t.get_modifier] }.uniq.length == 1
          result = get_for(result, weekdays, times)
        else
          times.map(&:comment).uniq.each do |comment|
            comment_times = times.select { |t| t.comment == comment }
            if comment_times.map(&:get_modifier).uniq.length == 1
              result = get_for(result, weekdays, comment_times)
            else
              comment_times.map(&:get_modifier).uniq.each do |modifier|
                modified_times = comment_times.select { |t| t.get_modifier == modifier }
                result = get_for(result, weekdays, modified_times)
              end
            end
          end
        end
      end
      result
    end

    def get_for(result, weekdays, times)
      result += result.length > 0 ? ", #{@wide}" : @wide
      result += result.length > 0 ? " #{get_weekdays(weekdays)}" : get_weekdays(weekdays)
      result += result.length > 0 ? " #{get_times(times)}" : get_times(times)
      result
    end

    def get_weekdays(weekdays)
      result = ""

      if weekdays.length > 0 && weekdays[0] == -2
        result = "PH"
        weekdays.shift
      end


      if weekdays.length > 0 && weekdays.include?(6) && weekdays.include?(0) && (weekdays.include?(5) || weekdays.include?(1))
        start_we = 6
        i = weekdays.length - 2
        stop_looking = false

        while !stop_looking && i >= 0
          if weekdays[i] == weekdays[i+1] - 1
            start_we = weekdays[i]
            i -= 1
          else
            stop_looking = true
          end
        end

        i = 1
        stop_looking = false
        end_we = 0

        while !stop_looking && i < weekdays.length
          if weekdays[i-1] == weekdays[i] - 1
            end_we = weekdays[i]
            i += 1
          else
            stop_looking = true
          end
        end

        length = 7 - start_we + end_we + 1

        if length >= 3 && start_we > end_we
          if result.length > 0
            result += ","
          end
          result += "#{OSM_DAYS[start_we]}-#{OSM_DAYS[end_we]}"

          j=0
          while j < weekdays.length
            if weekdays[j] <= end_we || weekdays[j] >= start_we
              weekdays.slice!(j, 1)
            else
              j+=1
            end
          end
        end
      end

      if weekdays.length > 1 || (weekdays.length == 1 && weekdays[0] != -1)
        result += result.length > 0 ? ",#{OSM_DAYS[weekdays[0]]}" : OSM_DAYS[weekdays[0]]
        first_in_row = weekdays[0]
        for i in 1...weekdays.length
          if weekdays[i-1] != weekdays[i] - 1
            if first_in_row != weekdays[i-1]
              if weekdays[i-1] - first_in_row == 1
                result += ",#{OSM_DAYS[weekdays[i-1]]}"
              else
                result += "-#{OSM_DAYS[weekdays[i-1]]}"
              end
            end
            result += ",#{OSM_DAYS[weekdays[i]]}"
            first_in_row = weekdays[i]
          elsif i == weekdays.length - 1
            if weekdays[i] - first_in_row == 1
              result += ",#{OSM_DAYS[weekdays[i]]}"
            else
              result += "-#{OSM_DAYS[weekdays[i]]}"
            end
          end
        end
      end

      if result == "Mo-Su"
        result = ""
      end
      return result
    end

    def get_times(times)
      result = ""
      times.each do |time|
        result += result.length > 0 ? ", #{time.get}" : time.get
      end
      result
    end

  end
end
