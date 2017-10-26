# opening_hour_converter
gem install opening_hours_converter

```ruby
require 'opening_hours_converter'
parsed = OpeningHoursConverter::OpeningHoursParser.new.parse(‘Mo 10:10-12:12’)
OpeningHoursConverter::OpeningHoursBuilder.new.build(parsed)
```

## example data migration
This gem was made to make data migration from date range to opening hours easy. For example, imagine you have a schedule table with a start_date and end_date to define the validity period and many opening_hours with start, end, day_start, day_end. Here is how you would convert this format in opening_hours format.

```ruby
builder = OpeningHoursConverter::OpeningHoursBuilder.new
Schedule.find_each do |s|
  dr = OpeningHoursConverter::DateRange.new
  dr.wide_interval = OpeningHoursConverter::WideInterval.new.day(s.starting_date.day, s.starting_date.month,
    s.starting_date.year, s.ending_date.day, s.ending_date.month, s.ending_date.year)

  s.opening_hours.find_each do |oh|
    dr.typical.add_interval(day_start, start, day_end, end)
  end
  s.opening_hours = builder.build([dr])
  s.save
end
```
And you can now remove start_date, end_date from schedule and drop the opening_hours table. To get your opening hours in a ruby object, you can now do :
```ruby
parser = OpeningHoursConverter::OpeningHoursParser.new
oh = parser.parse(Schedule.first.opening_hours)
```

# test
rspec spec --format=documentation
