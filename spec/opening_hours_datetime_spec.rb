require 'opening_hours_converter/opening_hours_datetime'
require 'opening_hours_converter/opening_hours_time'
require 'pry-byebug'

RSpec.describe OpeningHoursConverter::OpeningHoursDatetime, '#initialize' do
  it "initialize" do
    expect { OpeningHoursConverter::OpeningHoursDatetime.new("Apr 21-Aug 22", "day") }.to_not raise_error
  end
end
RSpec.describe OpeningHoursConverter::OpeningHoursDatetime, '#add_time_to_weekday' do

  it "basic" do
    time = OpeningHoursConverter::OpeningHoursTime.new
    datetime = OpeningHoursConverter::OpeningHoursDatetime.new("Apr 21-Aug 22", "day")
    datetime.add_time_to_weekday(1, time)

    expect(datetime.weekdays_with_time[[1]]).to eql([time])
  end

  it "add many times to one day" do
    time1 = OpeningHoursConverter::OpeningHoursTime.new(0, 60)
    time2 = OpeningHoursConverter::OpeningHoursTime.new(70, 900)
    datetime = OpeningHoursConverter::OpeningHoursDatetime.new("Apr 21-Aug 22", "day")
    datetime.add_time_to_weekday(1, time1)
    datetime.add_time_to_weekday(1, time2)

    expect(datetime.weekdays_with_time[[1]]).to eql([time1, time2])
  end

  it "create many day with one time" do

    time = OpeningHoursConverter::OpeningHoursTime.new(70, 900)
    datetime = OpeningHoursConverter::OpeningHoursDatetime.new("Apr 21-Aug 22", "day")
    datetime.add_time_to_weekday(1, time)
    datetime.add_time_to_weekday(2, time)

    expect(datetime.weekdays_with_time[[1, 2]]).to eql([time])
  end

  it "create many day with many times" do

    time1 = OpeningHoursConverter::OpeningHoursTime.new(1, 60)
    time2 = OpeningHoursConverter::OpeningHoursTime.new(70, 900)
    time3 = OpeningHoursConverter::OpeningHoursTime.new(970, 1000)
    datetime = OpeningHoursConverter::OpeningHoursDatetime.new("Apr 21-Aug 22", "day")
    datetime.add_time_to_weekday(1, time1)
    datetime.add_time_to_weekday(1, time3)
    datetime.add_time_to_weekday(2, time1)
    datetime.add_time_to_weekday(2, time2)
    datetime.add_time_to_weekday(3, time2)
    datetime.add_time_to_weekday(3, time1)

    expect(datetime.weekdays_with_time[[2, 3]]).to eql([time1, time2])
    expect(datetime.weekdays_with_time[[1]]).to eql([time1, time3])
  end

  it "create many day with many times and comment" do

    time1 = OpeningHoursConverter::OpeningHoursTime.new(1, 60, nil, true)
    time2 = OpeningHoursConverter::OpeningHoursTime.new(70, 900, '"couucou"')
    time3 = OpeningHoursConverter::OpeningHoursTime.new(970, 1000)
    datetime = OpeningHoursConverter::OpeningHoursDatetime.new("Apr 21-Aug 22", "day")
    datetime.add_time_to_weekday(1, time1)
    datetime.add_time_to_weekday(1, time3)
    datetime.add_time_to_weekday(2, time1)
    datetime.add_time_to_weekday(2, time2)
    datetime.add_time_to_weekday(3, time2)
    datetime.add_time_to_weekday(3, time1)

    binding.pry

    expect(datetime.weekdays_with_time[[2, 3]]).to eql([time1, time2])
    expect(datetime.weekdays_with_time[[1]]).to eql([time1, time3])
  end

  it "sort times" do
    time1 = OpeningHoursConverter::OpeningHoursTime.new(1, 60)
    time2 = OpeningHoursConverter::OpeningHoursTime.new(70, 900)
    datetime = OpeningHoursConverter::OpeningHoursDatetime.new("Apr 21-Aug 22", "day")

    datetime.add_time_to_weekdays([1, 2, 3], time2)
    datetime.add_time_to_weekdays([1, 2, 3], time1)

    expect(datetime.weekdays_with_time[[1, 2, 3]]).to eql([time1, time2])
  end

  it "merge times and days" do
    time1 = OpeningHoursConverter::OpeningHoursTime.new(1, 60)
    time2 = OpeningHoursConverter::OpeningHoursTime.new(70, 900)
    boomtime = OpeningHoursConverter::OpeningHoursTime.new(60, 70)

    merged_time = OpeningHoursConverter::OpeningHoursTime.new(1, 900)

    datetime = OpeningHoursConverter::OpeningHoursDatetime.new("Apr 21-Aug 22", "day")

    datetime.add_time_to_weekdays([1, 2, 3], time2)
    datetime.add_time_to_weekdays([1, 2, 3], time1)
    datetime.add_time_to_weekdays([1, 2, 3], boomtime)

    expect(datetime.weekdays_with_time[[1, 2, 3]][0].equals(merged_time)).to be true
  end

end
RSpec.describe OpeningHoursConverter::OpeningHoursTime, '#get' do

end
