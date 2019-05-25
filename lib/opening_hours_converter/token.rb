require 'opening_hours_converter/constants'

module OpeningHoursConverter
  class Token
    include Constants

    attr_accessor :type, :made_from
    attr_reader :value, :start_index

    def initialize(value, type, start_index, made_from = [])
      @value = value
      @type = type
      @start_index = start_index
      @made_from = made_from
    end

    def year?
      integer? && @value.length == 4
    end

    def weekday?
      string? && OSM_DAYS.any? { |day| day == @value }
    end

    def month?
      string? && OSM_MONTHS.any? { |day| day == @value }
    end

    def week?
      string? && @value == 'week'
    end

    def week_index?
      # Nécessaire mais pas suffisant : 10 de 10:00 retourne true il faudra check le previous/next token pour décider ou garder le state week
      integer? && @value.to_i <= 53 && @value.to_i >= 1
    end

    def monthday?
      # Nécessaire mais pas suffisant : 10 de 10:00 retourne true il faudra check le previous/next token pour décider
      integer? && @value.to_i <= 31 && @value.to_i >= 1
    end

    def time?
      # Nécessaire mais pas suffisant : 10 de Jan 10 retourne true il faudra check le previous/next token pour décider
      integer? && @value.to_i < 60 && @value.to_i >= 0
    end

    def public_holiday?
      string? && @value.downcase == 'ph'
    end

    def off?
      string? && @value.downcase == 'off'
    end

    def string?
      @type == :string
    end

    def integer?
      @type == :integer
    end

    def hyphen?
      @type == :hyphen
    end

    def comma?
      @type == :comma
    end

    def quote?
      @type == :quote
    end

    def colon?
      @type == :colon
    end

    def slash?
      @type == :slash
    end

    def opening_square_bracket?
      @type == :opening_square_bracket
    end

    def closing_square_bracket?
      @type == :closing_square_bracket
    end
  end
end
