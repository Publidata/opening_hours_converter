# opening_hour_converter
gem install opening_hours_converter

```ruby
require 'opening_hours_converter'
parsed = OpeningHoursConverter::OpeningHoursParser.new.parse(‘Mo 10:10-12:12’)
OpeningHoursConverter::OpeningHoursBuilder.new.build(parsed)
```

## example data migration
This gem was made to make data migration from date range to opening hours easy. For example, imagine you have a schedule table with a start_date and end_date to define the validity period and many opening_hours with time_start, time_end, day_start, day_end. Here is how you would convert this format in opening_hours format.

```ruby
builder = OpeningHoursConverter::OpeningHoursBuilder.new
Schedule.find_each do |s|
  dr = OpeningHoursConverter::DateRange.new
  # Assuming dates are instance of Date.
  dr.wide_interval = OpeningHoursConverter::WideInterval.new.day(
    s.starting_date.day,
    s.starting_date.month,
    s.starting_date.year,
    s.ending_date.day,
    s.ending_date.month,
    s.ending_date.year)

  # Assuming days are weekdays and week start is monday (0 is monday, 6 is sunday).
  # Assuming times are expressed in minutes from midnight (600 is 10:00, 1200 is 20:00)
  s.opening_hours.find_each do |oh|
    dr.typical.add_interval(oh.day_start, oh.time_start, oh.day_end, oh.time_end)
  end
  s.opening_hours_string = builder.build([dr])
  s.save
end
```
And you can now remove start_date, end_date from schedule and drop the opening_hours table. To get your opening hours in a ruby object, you can now do :
```ruby
parser = OpeningHoursConverter::OpeningHoursParser.new
oh = parser.parse(Schedule.first.opening_hours_string)
```

# test
rspec spec --format=documentation

# References
Done with [yohours](https://framagit.org/PanierAvide/YoHours) as inspiration and with constant help from the [evaluation tool](http://openingh.openstreetmap.de/evaluation_tool/)/[repository](https://github.com/opening-hours/opening_hours.js)
