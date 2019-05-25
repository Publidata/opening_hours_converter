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

        binding.pry
      end
    end

    private

    def add_current_token_value_to(value, leading = '', trailing = '')
      "#{value}#{leading}#{current_token.value}#{trailing}"
    end

    def handle_year
      type = { year: true }
      start_index = current_token.start_index
      value = current_token.value
      made_from = [current_token]
      @index += 1

      while current_token?
        if current_token.hyphen? || current_token.comma?  || current_token.slash?
          value = add_current_token_value_to(value)
          made_from << current_token
          @index += 1
          next
        end

        if current_token.year?
          type[:multi_year] = true
          if previous_token.hyphen? || previous_token.comma?
            value = add_current_token_value_to(value)
            made_from << current_token
            @index += 1
            next
          end
          raise "you can\'t have two years with just space between them previous token: #{previous_token}, current token: #{current_token}"
        end

        if current_token.string?
          break if current_token.weekday?

          if current_token.week?
            type[:week] = true
            value = add_current_token_value_to(value, ' ')
            made_from << current_token
            @index += 1
            next
          end

          if current_token.month?
            if previous_token.hyphen? || previous_token.comma?
              type[:multi_month] = true
              value = add_current_token_value_to(value)
              made_from << current_token
              @index += 1
              next
            else
              type[:month] = true
              value = add_current_token_value_to(value, ' ')
              made_from << current_token
              @index += 1
              next
            end
          end
        end

        if current_token.integer?
          break if current_token_is_time? # we don't want time range in the wide interval token
          break if current_token.weekday? # nor weekdays
          break if current_token_is_all_time? # nor 24/7

          if type[:week]
            if current_token.week_index?
              if previous_token.comma? || previous_token.hyphen?
                type[:multi_week] = true
                value = add_current_token_value_to(value)
                made_from << current_token
                @index += 1
                next
              else
                type[:week] = true
                value = add_current_token_value_to(value, ' ')
                made_from << current_token
                @index += 1
                next
              end
              if current_token_is_week_modifier?
                type[:modified_week] = true
                value = add_current_token_value_to(value)
                made_from << current_token
                @index += 1
                next
              end
            end

          elsif type[:month]
            if current_token_monthday?
              if previous_token.comma? || previous_token.hyphen?
                type[:multi_month] = true
                value = add_current_token_value_to(value)
                made_from << current_token
                @index += 1
                next
              else
                type[:month] = true
                value = add_current_token_value_to(value, ' ')
                made_from << current_token
                @index += 1
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
          value = add_current_token_value_to(value)
          made_from << current_token
          @index += 1
          next
        end

        if current_token_monthday?
          if previous_token.comma? || previous_token.hyphen?
            type[:multi_monthday] = true
            value = add_current_token_value_to(value)
            made_from << current_token
            @index += 1
            next
          else
            type[:monthday] = true
            value = add_current_token_value_to(value, ' ')
            made_from << current_token
            @index += 1
            next
          end
        end

        if current_token.month?
          if previous_token.hyphen? || previous_token.comma?
            type[:multi_month] = true
            value = add_current_token_value_to(value)
            made_from << current_token
            @index += 1
            next
          else
            type[:month] = true
            value = add_current_token_value_to(value, ' ')
            made_from << current_token
            @index += 1
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
        break if current_token.weekday?

        if current_token.hyphen? || current_token.comma?
          type[:multi_week] = true
          value = add_current_token_value_to(value)
          made_from << current_token
          @index += 1
          next
        end

        if current_token.week_index?
          value = add_current_token_value_to(value)
          made_from << current_token
          @index += 1
          next
        end
      end
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
          type[:multi_weekday] = true
          value = add_current_token_value_to(value)
          made_from << current_token
          @index += 1
          next
        end

        if current_token.weekday?
          type[:multi_weekday] = true
          value = add_current_token_value_to(value)
          made_from << current_token
          @index += 1
          next
        end

        if current_token.public_holiday?
          type[:public_holiday] = true
          value = add_current_token_value_to(value)
          made_from << current_token
          @index += 1
          next
        end

        if current_token.opening_square_bracket?
          type[:modified_weekday] = true
          value = add_current_token_value_to(value)
          made_from << current_token
          @index += 1

          while current_token?
            if current_token.closing_square_bracket?
              value = add_current_token_value_to(value)
              made_from << current_token
              @index += 1
              break
            end

            if current_token.hyphen? || current_token.weekday_modifier?
              value = add_current_token_value_to(value)
              made_from << current_token
              @index += 1
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

      binding.pry unless current_token.colon?
      value = add_current_token_value_to(value)
      made_from << current_token
      @index += 1

      raise unless current_token.time?
      value = add_current_token_value_to(value)
      made_from << current_token
      @index += 1

      raise unless current_token.hyphen?
      value = add_current_token_value_to(value)
      made_from << current_token
      @index += 1

      # second part of time range
      raise unless current_token.time?
      value = add_current_token_value_to(value)
      made_from << current_token
      @index += 1

      raise unless current_token.colon?
      value = add_current_token_value_to(value)
      made_from << current_token
      @index += 1

      raise unless current_token.time?
      value = add_current_token_value_to(value)
      made_from << current_token
      @index += 1

      token(value, type, start_index, made_from)
    end

    def handle_public_holiday
      type = { time: true }
      start_index = current_token.start_index

      value = current_token.value
      made_from = [current_token]
      @index += 1

      if current_token.comma?
        value = add_current_token_value_to(value)
        made_from << current_token
        @index += 1

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

      binding.pry unless current_token.slash?
      value = add_current_token_value_to(value)
      made_from << current_token
      @index += 1

      raise unless current_token.value == '7'
      value = add_current_token_value_to(value)
      made_from << current_token
      @index += 1

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
