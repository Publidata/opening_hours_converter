# opening_hour_converter
gem install opening_hours_converter

```ruby
require 'opening_hours_converter'
parsed = OpeningHoursConverter::OpeningHoursParser.new.parse(‘Mo 10:10-12:12’)
OpeningHoursConverter::OpeningHoursBuilder.new.build(parsed)
```

## example data migration
In a rails application, previously, opening hours were stored in a schedule table, with monday_morning_opening_hour, monday_morning_closing_hour, monday_afternoon_opening_hour, monday_afternoon_closing_hour for each days of the week and with a starting/ending date.
So to convert those data in opening hours format, here is the method I used.

```ruby
builder = OpeningHoursConverter::OpeningHoursBuilder.new
Schedule.find_each do |s|
  dr = OpeningHoursConverter::DateRange.new
  dr.wide_interval = OpeningHoursConverter::WideInterval.new.day(s.starting_date.day, s.starting_date.month, s.starting_date.year, s.ending_date.day, s.ending_date.month, s.ending_date.year)

  days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

  days.each_with_index do |day, index|
    ["morning", "afternoon"].each do |dp|
      oh = s.send("#{day}_#{dp}_opening_hour")
      ch = s.send("#{day}_#{dp}_closing_hour")
      if oh < ch
        dr.typical.add_interval(OpeningHoursConverter::Interval.new(index, oh.hour*60+oh.min, index, ch.hour*60+ch.min))
      elsif oh > ch
        dr.typical.add_interval(OpeningHoursConverter::Interval.new(index, oh.hour*60+oh.min, index+1, ch.hour*60+ch.min))
      end
    end
  end

  s.opening_hours = builder.build([dr])
  s.save
end
```


# test
rspec spec --format=documentation
