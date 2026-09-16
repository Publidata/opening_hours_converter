require 'opening_hours_converter'
require 'yaml'

# Every selector of the OpenStreetMap opening_hours specification, in one place.
#
# Unlike production_patterns_spec.rb, which follows what a real dataset
# contains, this file follows what the grammar allows. Entries are never
# removed: a pattern the gem cannot read yet is an example marked pending, so
# the corpus is at once the list of what is missing, the proof of what works,
# and the guard against losing it again.
#
# Implementing a pattern turns its example green, and RSpec then fails it for
# passing while pending. Flipping its status to "supported" in
# spec/fixtures/osm_patterns.yml is the last step of the implementation.
#
# The expected intervals come from opening_hours.js, the reference
# implementation. tools/osm_reference/ regenerates the fixture.
OSM_PATTERNS = YAML.load_file(
  File.expand_path('fixtures/osm_patterns.yml', __dir__)
).freeze

RSpec.describe OpeningHoursConverter::Iterator, 'OSM opening_hours patterns' do
  # The window the reference run covers. A pattern is counted over the whole of
  # it, and compared interval by interval over the shorter probe window the
  # fixture carries, which is placed on the first occurrence of the pattern.
  YEAR_FROM = Time.new(2026, 1, 1).freeze
  YEAR_TO = Time.new(2027, 1, 1).freeze

  def stamp(text)
    year, month, day, hour, minute = text.scan(/\d+/).map(&:to_i)
    Time.new(year, month, day, hour, minute)
  end

  def render(intervals)
    intervals.map do |interval|
      "#{clock(interval[:start])} -> #{clock(interval[:end])}"
    end
  end

  def clock(time)
    format('%04d-%02d-%02d %02d:%02d', time.year, time.month, time.day, time.hour, time.min)
  end

  def open_intervals(pattern, from, to)
    described_class.new.get_open_intervals(pattern, from, to)
  end

  OSM_PATTERNS.group_by { |entry| entry['family'] }.each do |family, entries|
    describe family do
      entries.each do |entry|
        pattern = entry['pattern']

        if entry['status'] == 'invalid'
          it "rejects #{pattern.inspect}" do
            expect { open_intervals(pattern, YEAR_FROM, YEAR_TO) }
              .to raise_error(OpeningHoursConverter::ParseError)
          end
          next
        end

        it "reads #{pattern.inspect}" do
          pending(entry['reason']) if entry['status'] == 'pending'

          expect(open_intervals(pattern, YEAR_FROM, YEAR_TO).length)
            .to eq(entry['year_count'])

          expect(render(open_intervals(pattern,
                                       stamp(entry['probe_from']),
                                       stamp(entry['probe_to']))))
            .to eq(entry['probe_intervals'])
        end
      end
    end
  end
end
