require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class Tokenizer
    include Constants

    attr_reader :tokens

    def initialize(opening_hours_string)
      @opening_hours_string = opening_hours_string
      @index = 0
      @tokens = []
      tokenize
      @tokens_handler = OpeningHoursConverter::TokensHandler.new(@tokens)
      @tokens = @tokens_handler.tokens.map(&:value)
    end

    def tokenize
      counter = 0
      while @index < @opening_hours_string.length
        binding.pry if counter > 200
        skip_white_spaces
        @tokens << handle_string if string?

        skip_white_spaces
        @tokens << handle_integer if integer?

        skip_white_spaces
        @tokens << handle_quote if quote?

        skip_white_spaces
        @tokens << handle_slash if slash?

        skip_white_spaces
        @tokens << handle_opening_square_bracket if opening_square_bracket?

        skip_white_spaces
        @tokens << handle_closing_square_bracket if closing_square_bracket?

        skip_white_spaces
        @tokens << handle_colon if colon?

        skip_white_spaces
        @tokens << handle_comma if comma?

        skip_white_spaces
        @tokens << handle_hyphen if hyphen?
        counter += 1
      end
    end

    private

    def current_character
      @opening_hours_string[@index]
    end

    def current_character?
      !current_character.nil?
    end

    def handle_string
      type = :string
      start_index = @index
      value = ''

      while string? && current_character?
        value << current_character
        @index += 1
      end

      token(value, type, start_index)
    end

    def handle_integer
      type = :integer
      start_index = @index
      value = ''

      while integer? && current_character?
        value << current_character
        @index += 1
      end

      token(value, type, start_index)
    end

    def handle_quote
      type = :quote
      start_index = @index

      value = current_character
      @index += 1

      while current_character?
        if quote?
          value << current_character
          @index += 1
          break
        else
          value << current_character
          @index += 1
        end
      end

      token(value, type, start_index)
    end

    def handle_slash
      type = :slash
      start_index = @index

      value = current_character
      @index += 1

      token(value, type, start_index)
    end

    def handle_opening_square_bracket
      type = :opening_square_bracket
      start_index = @index

      value = current_character
      @index += 1

      token(value, type, start_index)
    end

    def handle_closing_square_bracket
      type = :closing_square_bracket
      start_index = @index

      value = current_character
      @index += 1

      token(value, type, start_index)
    end

    def handle_colon
      type = :colon
      start_index = @index

      value = current_character
      @index += 1

      token(value, type, start_index)
    end

    def handle_comma
      type = :comma
      start_index = @index

      value = current_character
      @index += 1

      token(value, type, start_index)
    end

    def handle_hyphen
      type = :hyphen
      start_index = @index

      value = current_character
      @index += 1

      token(value, type, start_index)
    end

    def token(value, type, start_index)
      OpeningHoursConverter::Token.new(value, type, start_index)
    end

    def skip_white_spaces
      until current_character.nil? || !white_space?
        @index += 1
      end
    end

    def integer?
      !(current_character =~ /[0-9]/).nil?
    end

    def white_space?
      !(current_character =~ /\s/).nil?
    end

    def string?
      # all char but space, digits and punctuations
      !(current_character =~ /[^\s\d.,;:"()\[\]\-\_]/).nil?
    end

    def punctuation?
      !(current_character =~ /[.,;:"'()\[\]]/).nil?
    end

    def quote?
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
