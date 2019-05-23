# opening_hour_converter
gem install opening_hours_converter

```ruby
require 'opening_hours_converter'
parsed = OpeningHoursConverter::OpeningHoursParser.new.parse(‘Mo 10:10-12:12’)
OpeningHoursConverter::OpeningHoursBuilder.new.build(parsed)
```

## Example data migration
This gem was made to make data migration from date range to opening hours easy. For example, imagine you have a schedule table with a start_date and end_date to define the validity period and many opening_hours with time_start, time_end, day_start, day_end. Here is how you would convert this format in opening_hours format.

```ruby
builder = OpeningHoursConverter::OpeningHoursBuilder.new
Schedule.find_each do |schedule|
  date_range = OpeningHoursConverter::DateRange.new
  # Assuming dates are instance of Date.
  date_range.wide_interval = OpeningHoursConverter::WideInterval.new.day(
    schedule.starting_date.day,
    schedule.starting_date.month,
    schedule.starting_date.year,
    schedule.ending_date.day,
    schedule.ending_date.month,
    schedule.ending_date.year
  )

  # Assuming days are weekdays and week start is monday (0 is monday, 6 is sunday).
  # Assuming times are expressed in minutes from midnight (600 is 10:00, 1200 is 20:00)
  schedule.opening_hours.find_each do |opening_hours|
    date_range.typical.add_interval(
      opening_hours.day_start, 
      opening_hours.time_start, 
      opening_hours.day_end, 
      opening_hours.time_end
    )
  end
  schedule.opening_hours_string = builder.build([date_range])
  schedule.save
end
```
And you can now remove start_date, end_date from schedule and drop the opening_hours table. To get your opening hours in a ruby object, you can now do :
```ruby
parser = OpeningHoursConverter::OpeningHoursParser.new
oh = parser.parse(Schedule.first.opening_hours_string)
```

## Test

Install the dependencies with:

    bundle install

Then run all the tests with:

    rspec spec --format=documentation

## References
Done with [yohours](https://framagit.org/PanierAvide/YoHours) as inspiration and with constant help from the [evaluation tool](http://openingh.openstreetmap.de/evaluation_tool/)/[repository](https://github.com/opening-hours/opening_hours.js)
