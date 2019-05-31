require 'opening_hours_converter/utils/constants'
require 'opening_hours_converter/utils/utils'

module OpeningHoursConverter
  class TokensHandler
    include Constants
    include Utils

    attr_reader :tokens, :data, :date_range_list

    def initialize(tokens)
      @unhandled_tokens = tokens
      @index = 0
      @tokens = []
      @date_range_list = nil
      @data = TokenData.new

      handle_tokens
    end

    def handle_tokens
      while current_token?
        if current_token.year?
          @tokens << handle_year
          next
        end

        if current_token.month?
          @tokens << handle_month
          next
        end

        if current_token.week?
          @tokens << handle_week
          next
        end

        if current_token.weekday?
          @tokens << handle_weekday
          next
        end

        if current_token_is_time?
          @tokens << handle_time
          next
        end

        if current_token.public_holiday?
          @tokens << handle_public_holiday
          next
        end

        if current_token_is_all_time?
          @tokens << handle_all_time
          next
        end

        if current_token.off?
          @tokens << handle_off
          next
        end

        if current_token.quote?
          @tokens << handle_quote
          next
        end

        if current_token.comma?
          # catches "Mo off, Tu 10:00-20:00"
          @index += 1
          next
        end

        binding.pry

        raise "can't read current token #{current_token}"
      end
    end

    private

    def add_current_token_value_to(value, leading = '', trailing = '')
      "#{value}#{leading}#{current_token.value}#{trailing}"
    end

    def add_current_token_to(base_value, base_type, made_from, type = nil, leading = '', trailing = '')
      base_type[type] = true unless type.nil? || type.length.zero?
      value = add_current_token_value_to(base_value, leading, trailing)
      made_from << current_token
      @index += 1

      [value, made_from, base_type]
    end

    def handle_year
      type = { year: true }
      start_index = current_token.start_index
      value = current_token.value
      made_from = [current_token]
      @data.years << { from: current_token.value.to_i, to: current_token.value.to_i }

      @index += 1

      while current_token?
        if current_token.hyphen? || current_token.comma?  || current_token.slash?
          value, made_from, type = add_current_token_to(value, type, made_from)
          next
        end

        if current_token.year?
          if previous_token.hyphen?
            @data.years.last[:to] = current_token.value.to_i
            value, made_from, type = add_current_token_to(value, type, made_from)
            next
          elsif previous_token.comma?
            @data.years << { from: current_token.value.to_i, to: current_token.value.to_i }
            value, made_from, type = add_current_token_to(value, type, made_from)
            next
          end
          raise "you can\'t have two years with just space between them previous token: #{previous_token}, current token: #{current_token}"
        end

        if current_token.string?
          break if current_token.weekday?

          if current_token.week?
            @data.years.last[:weeks] ||= []
            value, made_from, type = add_current_token_to(value, type, made_from, :week, ' ')
            next
          end

          if current_token.month?
            @data.months ||= []
            if previous_token.hyphen?
              if (@unhandled_tokens[@index - 2].monthday? && @unhandled_tokens[@index - 3].month?) # Jan 10-Feb 20
                from = @data.months.last[:from]
                @data.months.last[:from] = { month: from, day: @data.months.last[:days].last[:from] }
                @data.months.last.delete(:days)
                @data.months.last[:to] = { month: month_index(current_token.value) }
                value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
                next
              else
                @data.months.last[:to] = month_index(current_token.value)
                value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
                next
              end
            elsif previous_token.comma?
              @data.months << { from: month_index(current_token.value), to: month_index(current_token.value) }
              value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
              next
            elsif previous_token.year? && @unhandled_tokens[@index - 2]&.hyphen? && !@unhandled_tokens[@index - 3]&.year? # 2010 Jan 10-2011 Feb 20
              from = @data.months.last[:from]
              @data.months.last[:from] = { month: from, day: @data.months.last[:days]&.last[:from] }
              @data.months.last[:to] = { month: month_index(current_token.value) }

              @data.months.last[:to][:month] = month_index(current_token.value)
              value, made_from, type = add_current_token_to(value, type, made_from, :month, ' ')
              next
            else
              @data.months ||= []
              @data.months << { from: month_index(current_token.value), to: month_index(current_token.value) }
              value, made_from, type = add_current_token_to(value, type, made_from, :month, ' ')
              next
            end
          end
        end

        if current_token.integer?
          break if current_token_is_time? # we don't want time range in the wide interval token
          break if current_token_is_all_time? # nor 24/7

          if type[:week]
            if current_token.week_index?
              if previous_token.slash?
                value, made_from, type = add_current_token_to(value, type, made_from, :modified_week)
                next
              elsif previous_token.comma?
                @data.weeks << { from: current_token.value.to_i, to: current_token.value.to_i }
                value, made_from, type = add_current_token_to(value, type, made_from, :multi_week)
                next
              elsif previous_token.hyphen?
                @data.weeks.last[:to] = current_token.value.to_i
                value, made_from, type = add_current_token_to(value, type, made_from, :multi_week)
                next
              elsif current_token_is_week_modifier?
                @data.weeks.last[:modifier] = current_token.value.to_i
                value, made_from, type = add_current_token_to(value, type, made_from, :modified_week)
                next
              else
                @data.weeks << { from: current_token.value.to_i, to: current_token.value.to_i }
                value, made_from, type = add_current_token_to(value, type, made_from, :week, ' ')
                next
              end

            end

          elsif type[:month]
            if current_token_monthday?
              if previous_token.comma?
                @data.months.last[:days] << { from: current_token.value.to_i, to: current_token.value.to_i }
                value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
                next
              elsif previous_token.hyphen?
                @data.months.last[:days].last[:to] = current_token.value.to_i
                value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
                next
              elsif (previous_token.month? && @unhandled_tokens[@index - 2]&.hyphen? && !@unhandled_tokens[@index - 3].month?) || # 2010 Jan 10-Feb 20
                (previous_token.month? && @unhandled_tokens[@index - 2]&.year? && @unhandled_tokens[@index - 3].hyphen? && !@unhandled_tokens[@index - 4].year?) # 2010 Jan 10-2011 Feb 20
                @data.months.last[:to][:day] = current_token.value.to_i
                value, made_from, type = add_current_token_to(value, type, made_from, :month, ' ')
                next
              else
                if @data.months.last[:from].is_a?(Hash) && @data.months.last[:from].key?(:month)
                  @data.months.last[:from][:day] = current_token.value.to_i
                elsif @data.months.last[:days].nil?
                  @data.months.last[:days] = [{ from: current_token.value.to_i, to: current_token.value.to_i }]
                else
                  @data.months.last[:days].last[:to] = current_token.value.to_i
                end
                value, made_from, type = add_current_token_to(value, type, made_from, :month, ' ')
                next
              end
            end
          end
        end

        break
      end

      token(value, type, start_index, made_from)
    end

    def token(value, type, start_index, made_from)
      OpeningHoursConverter::Token.new(value, type, start_index, made_from)
    end

    def handle_month
      type = { month: true }
      start_index = current_token.start_index
      value = current_token.value
      made_from = [current_token]
      @data.months << { from: month_index(current_token.value), to: month_index(current_token.value) }

      @index += 1

      while current_token?
        break if current_token_is_all_time?
        break if current_token_is_time?

        if current_token.hyphen? || current_token.comma? || current_token.slash?
          value, made_from, type = add_current_token_to(value, type, made_from)
          next
        end

        if current_token_monthday?
          if previous_token.comma?
            @data.months.last[:days] << { from: current_token.value.to_i, to: current_token.value.to_i }
            value, made_from, type = add_current_token_to(value, type, made_from, :multi_monthday)
            next
          elsif previous_token.hyphen?
            @data.months.last[:days].last[:to] = current_token.value.to_i
            value, made_from, type = add_current_token_to(value, type, made_from, :multi_monthday)
            next
          else
            if @data.months.last[:from].is_a?(Hash) && @data.months.last[:from].key?(:month)
              if previous_token.month? && @unhandled_tokens[@index - 2]&.hyphen?
                @data.months.last[:to][:day] = current_token.value.to_i
              else
                @data.months.last[:from][:day] = current_token.value.to_i
              end
            elsif @data.months.last[:days].nil?
              @data.months.last[:days] = [{ from: current_token.value.to_i, to: current_token.value.to_i }]
            else
              @data.months.last[:days].last[:to] = current_token.value.to_i
            end
            value, made_from, type = add_current_token_to(value, type, made_from, :monthday, ' ')
            next
          end
        end

        if current_token.month?
          if previous_token.comma?
            @data.months << { from: month_index(current_token.value), to: month_index(current_token.value) }
            value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
            next
          elsif previous_token.hyphen?
            if (@unhandled_tokens[@index - 2].monthday? && @unhandled_tokens[@index - 3].month?) # Jan 10-Feb 20
              from = @data.months.last[:from]
              @data.months.last[:from] = { month: from, day: @data.months.last[:days].last[:from] }
              @data.months.last.delete(:days)
              @data.months.last[:to] = { month: month_index(current_token.value) }
              value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
              next
            else
              @data.months.last[:to] = month_index(current_token.value)
              value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
              next
            end
            value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
            next
          else
            @data.months ||= []
            @data.months << { from: month_index(current_token.value), to: month_index(current_token.value) }
            value, made_from, type = add_current_token_to(value, type, made_from, :month, ' ')
            next
          end
        end

        break
      end

      token(value, type, start_index, made_from)
    end

    def handle_week
      type = { week: true }
      start_index = current_token.start_index
      value = current_token.value
      made_from = [current_token]
      @index += 1

      while current_token?
        break if current_token.string?
        break if current_token_is_time?

        if current_token.hyphen? || current_token.comma?
          value, made_from, type = add_current_token_to(value, type, made_from, :multi_week)
          next
        end

        if current_token.slash?
          value, made_from, type = add_current_token_to(value, type, made_from, :modified_week)
          next
        end

        if current_token.week_index?
          if previous_token.week?
            value = add_current_token_value_to(value, ' ')
          else
            value = add_current_token_value_to(value)
          end
          made_from << current_token
          @index += 1
          next
        end

        break
      end

      token(value, type, start_index, made_from)
    end

    def handle_weekday
      type = { weekday: true }
      start_index = current_token.start_index
      value = current_token.value
      made_from = [current_token]
      @index += 1

      while current_token?
        break if current_token.integer?

        if current_token.hyphen? || current_token.comma?
          value, made_from, type = add_current_token_to(value, type, made_from, :multi_weekday)
          next
        end

        if current_token.weekday?
          value, made_from, type = add_current_token_to(value, type, made_from, :multi_weekday)
          next
        end

        if current_token.public_holiday?
          value, made_from, type = add_current_token_to(value, type, made_from, :public_holiday)
          next
        end

        if current_token.opening_square_bracket?
          value, made_from, type = add_current_token_to(value, type, made_from, :modified_weekday)

          while current_token?
            if current_token.closing_square_bracket?
              value, made_from, type = add_current_token_to(value, type, made_from)
              break
            end

            if current_token.hyphen? || current_token.weekday_modifier?
              value, made_from, type = add_current_token_to(value, type, made_from)
              next
            end
          end

          next
        end

        break
      end

      token(value, type, start_index, made_from)
    end

    def handle_time
      type = { time: true }
      start_index = current_token.start_index

      value = current_token.value
      made_from = [current_token]
      @index += 1

      raise unless current_token.colon?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise unless current_token.time?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise unless current_token.hyphen?
      value, made_from, type = add_current_token_to(value, type, made_from)

      # second part of time range
      raise unless current_token.time?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise unless current_token.colon?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise unless current_token.time?
      value, made_from, type = add_current_token_to(value, type, made_from)

      token(value, type, start_index, made_from)
    end

    def handle_public_holiday
      type = { time: true }
      start_index = current_token.start_index

      value = current_token.value
      made_from = [current_token]
      @index += 1

      if current_token.comma?
        value, made_from, type = add_current_token_to(value, type, made_from)

        weekdays_token = handle_weekday
        value += weekdays_token.value
      end

      token(value, type, start_index, made_from)
    end

    def handle_all_time
      type = { all_time: true }
      start_index = current_token.start_index

      value = current_token.value
      made_from = [current_token]
      @index += 1

      raise unless current_token.slash?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise unless current_token.value == '7'
      value, made_from, type = add_current_token_to(value, type, made_from)

      token(value, type, start_index, made_from)
    end

    def handle_off
      type = { off: true }
      start_index = current_token.start_index

      value = current_token.value
      made_from = [current_token]
      @index += 1

      token(value, type, start_index, made_from)
    end

    def handle_quote
      type = { comment: true }
      start_index = current_token.start_index

      value = current_token.value
      made_from = [current_token]
      @index += 1

      token(value, type, start_index, made_from)
    end

    def current_token_is_time?
      return false unless current_token?

      if current_token.time?
        if previous_token.hyphen?
          return false unless next_token? && next_token.colon?
          return true
        end
        if next_token? && next_token.hyphen?
          return false unless previous_token.colon?
          return true
        end

        return false unless previous_token.colon? || next_token? && next_token.colon?
        return true
      end

      return false
    end

    def current_token_is_week_modifier?
      current_token? &&

      # check if current token is 2 in week 1-10/2
      current_token.integer? && current_token.value.to_i <= 53 &&
        previous_token? && previous_token.slash? &&
        next_token?
    end

    def current_token_monthday?
      current_token? &&

      # check if current token is 22 in either Jan 22 off or Jan 21,22 or Jan 21-22
      current_token.monthday? &&
        previous_token? && (previous_token.month? || previous_token.comma? || previous_token.hyphen?)
        # &&
        # next_token?
    end

    def current_token_is_all_time?
      current_token? &&

      # check if current token is 24 or / or 7 in 24/7
      current_token.integer? &&
        previous_token? && previous_token.slash? && current_token.value == '7' ||
        next_token? && next_token.slash? && current_token.value == '24' ||

      current_token.slash? &&
        previous_token? && previous_token.value == '24' &&
        next_token? && next_token.value == '7'
    end

    def current_token
      @unhandled_tokens[@index]
    end

    def next_token
      @unhandled_tokens[@index + 1]
    end

    def previous_token
      @unhandled_tokens[@index - 1]
    end

    def current_token?
      !current_token.nil?
    end

    def next_token?
      !next_token.nil?
    end

    def previous_token?
      !previous_token.nil?
    end
  end
end