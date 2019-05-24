module OpeningHoursConverter
  class Tokenizer
    attr_reader :tokens

    def initialize(opening_hours_string)
      @opening_hours_string = opening_hours_string
      @index = 0
      @tokens = []
    end

    def tokenize
      puts "tokenizing #{@opening_hours_string}"
      while @index < @opening_hours_string.length
        skip_white_spaces
        @tokens << handle_ints if int?

        skip_white_spaces
        @tokens << handle_strings if string?

        skip_white_spaces
        @tokens << handle_quotes if quotation_mark?
      end

    end

    def token_array
      @tokens.map { |token| token[:value] }
    end

    private

    def handle_ints
      type = :integer
      start_index = @index
      value = ''

      while int?
        until current_character.nil? || !int?
          value << current_character
          @index += 1
        end

        if colon?
          value << current_character
          @index += 1
          type = :time
        end

        if hyphen?
          value << current_character
          @index += 1
          type = type == :time ? :time : :year
        end

        if comma?
          if type == :time
            @index += 1
            skip_white_spaces
            break
          else
            value << current_character
            @index += 1
            skip_white_spaces
          end
        end

        if slash?
          value << current_character
          @index += 1
        end
      end

      token(value, type, start_index)
    end

    def handle_strings
      type = :string
      start_index = @index
      value = ''

      while string?
        until current_character.nil? || !string?
          value << current_character
          @index += 1
        end

        if colon?
          value << current_character
          @index += 1
        end

        if hyphen?
          value << current_character
          @index += 1
        end

        if comma?
          value << current_character
          @index += 1
          skip_white_spaces
        end

        if opening_square_bracket?
          value << current_character
          @index += 1
          until current_character.nil? || !int? || hyphen?
            value << current_character
            @index += 1
          end

          raise "missing closing square bracket in opening_hours #{@opening_hours_string}" unless closing_square_bracket?

          value << current_character
          @index += 1
        end

        if value.include?('week')
          type = :week
          skip_white_spaces
          week_tokens = handle_ints
          value += " #{week_tokens[:value]}"

          if slash?
            # rock on
            value << current_character
            @index += 1
            while int?
              value << current_character
              @index += 1
            end
          end
        end

        break if quotation_mark?
      end

      token(value, type, start_index)
    end

    def handle_quotes
      type = :comment
      start_index = @index

      value = current_character
      @index += 1

      until quotation_mark?
        value << current_character
        @index += 1
        raise if current_character.nil?
      end

      value << current_character
      @index += 1

      token(value, type, start_index)
    end

    def token(value, type, start_index)
      {
        value: value,
        type: type,
        start_index: start_index
      }
    end

    def add_token(value, type, start_index)
      @tokens << token(value, type, start_index)
    end

    def current_character
      @opening_hours_string[@index]
    end

    def skip_white_spaces
      until current_character.nil? || !white_space?
        @index += 1
      end
    end

    def int?
      !(current_character =~ /[0-9]/).nil?
    end

    def white_space?
      !(current_character =~ /\s/).nil?
    end

    def string?
      # all char but space, digits and punctuations
      !(current_character =~ /[^\s\d.,;:"()\[\]]/).nil?
    end

    def punctuation?
      !(current_character =~ /[.,;:"'()\[\]]/).nil?
    end

    def quotation_mark?
      current_character == '"'
    end

    def hyphen?
      current_character == '-'
    end

    def colon?
      current_character == ':'
    end

    def slash?
      current_character == '/'
    end

    def semicolon?
      current_character == ';'
    end

    def comma?
      current_character == ','
    end

    def opening_square_bracket?
      current_character == '['
    end

    def closing_square_bracket?
      current_character == ']'
    end
  end
end
