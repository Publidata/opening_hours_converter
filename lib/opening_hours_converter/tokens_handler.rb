require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class TokensHandler
    include Constants

    attr_reader :tokens

    def initialize(tokens)
      @unhandled_tokens = tokens
      @index = 0
      @tokens = []

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

        raise ParseError, "can't read current token #{current_token}"
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
      @index += 1

      while current_token?
        if current_token.hyphen? || current_token.comma?  || current_token.slash?
          value, made_from, type = add_current_token_to(value, type, made_from)
          next
        end

        if current_token.year?
          type[:multi_year] = true
          if previous_token.hyphen? || previous_token.comma?
            value, made_from, type = add_current_token_to(value, type, made_from)
            next
          end
          raise ParseError, "you can\'t have two years with just space between them previous token: #{previous_token}, current token: #{current_token}"
        end

        if current_token.string?
          break if current_token.weekday?

          if current_token.week?
            value, made_from, type = add_current_token_to(value, type, made_from, :week, ' ')
            next
          end

          if current_token.month?
            if previous_token.hyphen? || previous_token.comma?
              value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
              next
            else
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
              elsif previous_token.comma? || previous_token.hyphen?
                value, made_from, type = add_current_token_to(value, type, made_from, :multi_week)
                next
              else
                value, made_from, type = add_current_token_to(value, type, made_from, :week, ' ')
                next
              end
              if current_token_is_week_modifier?
                value, made_from, type = add_current_token_to(value, type, made_from, :modified_week)
                next
              end
            end

          elsif type[:month]
            if current_token_monthday?
              if previous_token.comma? || previous_token.hyphen?
                value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
                next
              else
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
      @index += 1

      while current_token?
        break if current_token_is_all_time?
        break if current_token_is_time?

        if current_token.hyphen? || current_token.comma? || current_token.slash?
          value, made_from, type = add_current_token_to(value, type, made_from)
          next
        end

        if current_token_monthday?
          if previous_token.comma? || previous_token.hyphen?
            value, made_from, type = add_current_token_to(value, type, made_from, :multi_monthday)
            next
          else
            value, made_from, type = add_current_token_to(value, type, made_from, :monthday, ' ')
            next
          end
        end

        if current_token.month?
          if previous_token.hyphen? || previous_token.comma?
            value, made_from, type = add_current_token_to(value, type, made_from, :multi_month)
            next
          else
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

      raise ParseError unless current_token.colon?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise ParseError unless current_token.time?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise ParseError unless current_token.hyphen?
      value, made_from, type = add_current_token_to(value, type, made_from)

      # second part of time range
      raise ParseError unless current_token.time?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise ParseError unless current_token.colon?
      value, made_from, type = add_current_token_to(value, type, made_from)

      raise ParseError unless current_token.time?
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
        previous_token? && previous_token.month? || previous_token.comma? || previous_token.hyphen? &&
        next_token?
    end

    def current_token_is_all_time?
      return false unless current_token?
      return false unless ['24', '7', '/'].include?(current_token.value)

      if current_token.value == '24'
        return false unless next_token? && next_token.slash?
        return false unless !@unhandled_tokens[@index + 2].nil? && @unhandled_tokens[@index + 2].value == '7'
      elsif current_token.slash?
        return false unless previous_token? && previous_token.value == '24'
        return false unless next_token? && next_token.value == '7'
      else # current token is 7
        return false unless previous_token? && previous_token.slash?
        return false unless !@unhandled_tokens[@index - 2].nil? && @unhandled_tokens[@index - 2].value == '24'
      end

      true
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
