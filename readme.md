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

Done with [YoHours](https://framagit.org/PanierAvide/YoHours) as inspiration and with constant help from the [Evaluation tool](http://openingh.openstreetmap.de/evaluation_tool/)/[repository](https://github.com/opening-hours/opening_hours.js)
