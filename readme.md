# opening_hour_converter
gem install opening_hours_converter

```ruby
require 'opening_hours_converter'
parsed = OpeningHoursConverter::OpeningHoursParser.new.parse(‘Mo 10:10-12:12’)
OpeningHoursConverter::OpeningHoursBuilder.new.build(parsed)
```

# test
rspec spec --format=documentation
