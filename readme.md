# Opening Hours Converter

![](https://github.com/Publidata/opening_hours_converter/workflows/CI/badge.svg)

OpenStreetMap Opening Hours to Date & Date to Opening Hours

See [Wiki](https://wiki.openstreetmap.org/wiki/Key:opening_hours/specification) for OpenStreetMap Opening Hours specification.

# Installation

```
gem install opening_hours_converter
```

## Usage

```ruby
require 'opening_hours_converter'

parsed_oh = OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 10:00-12:00')
oh_string = OpeningHoursConverter::OpeningHoursBuilder.new.build(parsed_oh)
```

### Open intervals over a period

`get_open_intervals` returns the concrete opening periods of an opening hours
string inside a window, as `[{ start: Time, end: Time }]`, sorted by start and
clamped to `[from, to]`. It is the equivalent of `getOpenIntervals` in
[opening_hours.js](https://github.com/opening-hours/opening_hours.js).

```ruby
OpeningHoursConverter::Iterator.new.get_open_intervals(
  'Mo-Fr 08:00-12:00; Tu off',
  Time.new(2026, 6, 1),
  Time.new(2026, 6, 8)
)
# => [{ start: 2026-06-01 08:00, end: 2026-06-01 12:00 },
#     { start: 2026-06-03 08:00, end: 2026-06-03 12:00 },
#     { start: 2026-06-04 08:00, end: 2026-06-04 12:00 },
#     { start: 2026-06-05 08:00, end: 2026-06-05 12:00 }]
```

Rules are applied in the order they were written, so a later one overrides an
earlier one: `Jul-Aug off; Mo-Fr 09:00-17:00` is open in July, while
`Mo-Fr 09:00-17:00; Jul-Aug off` is closed. Intervals crossing midnight end on
the following day, and `Time` values are built from wall clock components, so a
daylight saving change does not shift the time of day.

Unlike `get_time_iterator`, it applies `off` rules, handles midnight crossings
and covers every year the window touches rather than the current one.

## Test

Install the dependencies with:

```
bundle install
```

Then run all the tests with:

```
rspec spec --format=documentation
```

## Credits

Done with [YoHours](https://framagit.org/PanierAvide/YoHours) as inspiration and with constant help from the [Evaluation tool](http://openingh.openstreetmap.de/evaluation_tool/)/[repository](https://github.com/opening-hours/opening_hours.js).
