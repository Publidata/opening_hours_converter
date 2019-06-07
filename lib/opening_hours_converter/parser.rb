require 'opening_hours_converter/tokens/tokenizer'
require 'opening_hours_converter/tokens/tokens_handler'

module OpeningHoursConverter
  class Parser
    attr_reader :tokens, :date_range_list

    def initialize(opening_hours_string)
      @tokenizer = OpeningHoursConverter::Tokenizer.new(opening_hours_string)
      @tokens_handler = OpeningHoursConverter::TokensHandler.new(@tokenizer.tokens)
      @tokens = @tokens_handler.tokens.map(&:value)
      @date_range_list = @tokens_handler.data.to_date_range_list
    end

    def to_s
      @date_range_list.to_s
    end
  end
end
