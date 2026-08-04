require 'opening_hours_converter'
require 'stringio'

RSpec.describe OpeningHoursConverter::Tokenizer do
  # Tokenizing runs from the constructor, and the tokens the reader exposes are
  # the values the tokens handler kept, not the Token objects themselves.
  #
  # [opening hours string, tokens]
  cases = [
    ['Mo-Fr 08:00-18:00', ['Mo-Fr', '08:00-18:00']],
    ['08:00-18:00', ['08:00-18:00']],
    ['Mo-Fr 08:30-12:00,14:00-18:00', ['Mo-Fr', '08:30-12:00', '14:00-18:00']],
    ['Mo-We 08:00-10:00 "salut"', ['Mo-We', '08:00-10:00', '"salut"']],
    ['24/7', ['24/7']],
    ['PH off', %w[PH off]],
    ['2017-2018 Mo 08:00-10:00', ['2017-2018', 'Mo', '08:00-10:00']],
    ['2017 Jun-Jul Sa 10:00-12:00', ['2017 Jun-Jul', 'Sa', '10:00-12:00']],
    ['Nov 11-12 10:00-23:00', ['Nov 11-12', '10:00-23:00']],
    ['week 1 off', ['week 1', 'off']],
    ['We[1] 05:00-12:00', ['We[1]', '05:00-12:00']],
    ['', []]
  ].freeze

  describe '#tokens' do
    cases.each do |opening_hours, tokens|
      it "tokenizes #{opening_hours.inspect}" do
        expect(described_class.new(opening_hours).tokens).to eql(tokens)
      end
    end

    it 'exposes the token values as strings' do
      expect(described_class.new('2017 Jun-Jul Sa 10:00-12:00').tokens).to all(be_a(String))
    end
  end

  describe 'token values built character by character' do
    # Ruby 3.4 chills the string literals of a file carrying no
    # frozen_string_literal comment: mutating one warns. The tokenizer
    # accumulates a token value character by character, so it has to start from a
    # string of its own rather than from a literal. Below 3.4 there is no warning
    # to observe and any assertion here would hold either way, hence the guard.
    it 'warns about nothing in the tokenizer' do
      skip 'chilled string literals arrived in Ruby 3.4' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('3.4')

      warnings = capture_deprecation_warnings do
        described_class.new('2017 Jun-Jul Sa 10:00-12:00 "salut"')
      end

      expect(warnings).not_to match(/tokenizer\.rb/)
    end

    # Matches on the file a warning points at rather than on its wording, which
    # is not part of any contract, and lets an unrelated deprecation go by.
    def capture_deprecation_warnings
      was_deprecated = Warning[:deprecated]
      real_stderr = $stderr
      captured = StringIO.new

      Warning[:deprecated] = true
      $stderr = captured
      yield

      captured.string
    ensure
      $stderr = real_stderr
      Warning[:deprecated] = was_deprecated
    end
  end
end
