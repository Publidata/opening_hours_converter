require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class TokensHandler
    include Constants

    attr_reader :tokens

    def initialize(tokens)
      @unhandled_tokens = tokens
      @index = 0
      @tokens = []
      binding.pry

      handle_tokens
    end

    def handle_tokens
      while current_token?
        if current_token.year?
          @tokens += handle_year
          next

        elsif current_token.month?
          @tokens += handle_month
          next

        elsif current_token.week?
          @tokens += handle_week
          next

        elsif current_token.weekday?
          @tokens += handle_weekday
          next

        elsif current_token_is_time?
          @tokens << handle_time

          while current_token? && current_token.comma?
            @index += 1
            @tokens << handle_time
          end

          next

        elsif current_token.public_holiday?
          @tokens += handle_public_holiday
          next

        elsif current_token_is_all_time?
          @tokens += handle_all_time
          next

        else
          binding.pry

        end
      end

      if current_token[:type] == :string
        # if first token choices are (for wide interval) :

        # Détecter la presence de week
        if current_token[:value] == 'week'
        # week 1
        # week 1, 2
        # week 1-2
        # week 1-2,3
        # week 1,2-3
        # week 1,2-3,4
        # week 1,2-3,4...

        # Détecter la presence de mois dans les tokens
        elsif current_token[:value].include?
        # Jan
        # Jan 10-20
        # Jan-Jun
        # Jan 10-Jun 20
        # Jan,Jun
        # Jan,Jun-Jul
        # Jan,Jun-Jul,Dec

        # not wide interval :

        # off / closed
        # PH

        # Détecter la presence des jours
        # Mo
        # Mo,PH
        # Mo-Su
        # Mo-Su,PH
        # Mo-We,Su
        # Mo-We,Su,PH...
        end
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
      end

      t = token(value, type, start_index, made_from)

      # 2019
      # 2019-2020
      # 2019-2020, 2021
      # 2019, 2020
      # 2019 week 10
      # 2019 week 10,11
      # 2019 week 10,11-12
      # 2019 Jan 10
      # 2019 Jan 10-20
      # 2019 Jan-Feb
      # 2019 Jan 10-Feb 20
      # 2019 Jan-2020 Feb
      # 2019 Jan 10-2020 Feb 20

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
        if current_token.hyphen? || current_token.comma?  || current_token.slash?
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
      end
    end

    def handle_week

    end

    def handle_weekday

    end

    def handle_time
      type = { time: true }
      start_index = current_token.start_index

      value = current_token.value
      made_from = [current_token]
      @index += 1

      raise unless current_token.colon?
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

      token(value, type, start_index, made_from)
    end

    def handle_all_week

    end


    def current_token_is_time?
      current_token? &&

      # check if current token is either 12 or 34 in 12:34
      (current_token.integer? && current_token.value.length == 2 &&
        (previous_token? && previous_token.colon?) ||
        (next_token? && next_token.colon?)) ||

      # check if current token is : in 12:34
      (current_token.colon? &&
        previous_token? && previous_token.time? &&
        next_token? && next_token.time?) ||

      # check if current token is - in 12:34-56:78s
      (current_token.hyphen? &&
        previous_token? && previous_token.time? &&
        next_token? && next_token.time?)
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
