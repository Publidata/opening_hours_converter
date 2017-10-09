require 'opening_hours_converter/opening_hours_rule'

RSpec.describe OpeningHoursConverter::OpeningHoursRule, '#initialize' do
  it "initialize" do
    expect { OpeningHoursConverter::OpeningHoursRule.new }.to_not raise_error
  end
end

RSpec.describe OpeningHoursConverter::OpeningHoursRule, '#get' do
  it "simple" do
    ohr = OpeningHoursConverter::OpeningHoursRule.new
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,2,4,5,6])
    ohr.add_date(ohd)
    oht = OpeningHoursConverter::OpeningHoursTime.new(10, 60)
    ohr.add_time(oht)
    expect(ohr.get).to eql("Apr 21-Aug 22 Fr-We 00:10-01:00")
  end
  it "several date/time" do
    ohr = OpeningHoursConverter::OpeningHoursRule.new

    ohr.add_date(OpeningHoursConverter::OpeningHoursDate.new("Mar", "month", [0,1,2,4,5,6]))
    ohr.add_date(OpeningHoursConverter::OpeningHoursDate.new("Jul-Oct", "month", [0,1,2,4,5,6]))

    ohr.add_time(OpeningHoursConverter::OpeningHoursTime.new(0, 60))
    ohr.add_time(OpeningHoursConverter::OpeningHoursTime.new(3*60, 4*60))
    expect(ohr.get).to eql("Mar,Jul-Oct Fr-We 00:00-01:00,03:00-04:00")
  end
  it "several date, nil time" do
    ohr = OpeningHoursConverter::OpeningHoursRule.new

    ohr.add_date(OpeningHoursConverter::OpeningHoursDate.new("Mar", "month", [0,1,2,4,5,6]))
    ohr.add_date(OpeningHoursConverter::OpeningHoursDate.new("Jul-Oct", "month", [0,1,2,4,5,6]))

    expect(ohr.get).to eql("Mar,Jul-Oct Fr-We off")
  end
  it "always, time" do
    ohr = OpeningHoursConverter::OpeningHoursRule.new

    ohr.add_date(OpeningHoursConverter::OpeningHoursDate.new("", "always", [0,1,2,4,5,6]))
    ohr.add_time(OpeningHoursConverter::OpeningHoursTime.new(0, 1*60))
    ohr.add_time(OpeningHoursConverter::OpeningHoursTime.new(3*60, 4*60))

    expect(ohr.get).to eql("Fr-We 00:00-01:00,03:00-04:00")
  end
end

RSpec.describe OpeningHoursConverter::OpeningHoursRule, '#same_time?' do
  it "same time" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    or2 = OpeningHoursConverter::OpeningHoursRule.new

    od1 = OpeningHoursConverter::OpeningHoursDate.new("", "always", [0,1,2,3,4,5,6])
    od2 = OpeningHoursConverter::OpeningHoursDate.new("Jun", "month", [3,4,5,6])

    or1.add_date(od1)
    or2.add_date(od2)

    ot = OpeningHoursConverter::OpeningHoursTime.new(0, 24*60)

    or1.add_time(ot)
    or2.add_time(ot)

    expect(or1.same_time?(or2)).to be true
    expect(or2.same_time?(or1)).to be true
  end
  it "different time" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    or2 = OpeningHoursConverter::OpeningHoursRule.new

    ot = OpeningHoursConverter::OpeningHoursTime.new(10*60, 12*60)
    ot2 = OpeningHoursConverter::OpeningHoursTime.new(14*60, 16*60)
    ot3 = OpeningHoursConverter::OpeningHoursTime.new(14*60, 17*60)

    or1.add_time(ot)
    or1.add_time(ot2)
    or2.add_time(ot)
    or2.add_time(ot3)

    expect(or1.same_time?(or2)).to be false
    expect(or2.same_time?(or1)).to be false
  end
end

RSpec.describe OpeningHoursConverter::OpeningHoursRule, '#add_date' do
  it "simple" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    od1 = OpeningHoursConverter::OpeningHoursDate.new("Mar", "month", [0,1,2,4,5,6])
    od2 = OpeningHoursConverter::OpeningHoursDate.new("Jul-Oct", "month", [0,1,2,4,5,6])

    or1.add_date(od1)
    or1.add_date(od2)

    expect(or1.date.length).to eql(2)
    expect(or1.date[0]).to eql(od1)
    expect(or1.date[1]).to eql(od2)
  end
  it "raise argument error if nil" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    expect { or1.add_date }.to raise_error ArgumentError
  end
  it "not same wide type" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new

    od1 = OpeningHoursConverter::OpeningHoursDate.new("Mar", "month", [0,1,2,4,5,6])
    od2 = OpeningHoursConverter::OpeningHoursDate.new("Apr 21", "day", [0,1,2,4,5,6])

    or1.add_date(od1)
    expect{ or1.add_date(od2) }.to raise_error ArgumentError
  end
  it "not same weekday" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new

    od1 = OpeningHoursConverter::OpeningHoursDate.new("Mar", "month", [0,1,2,4,5,6])
    od2 = OpeningHoursConverter::OpeningHoursDate.new("Jul-Oct", "month", [0,1])

    or1.add_date(od1)
    expect{ or1.add_date(od2) }.to raise_error ArgumentError
  end
  it "full year not same weekday" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new

    od1 = OpeningHoursConverter::OpeningHoursDate.new("Mar", "month", [0,1,2,4,5,6])
    od2 = OpeningHoursConverter::OpeningHoursDate.new("", "always", [0,1])

    or1.add_date(od1)
    expect{ or1.add_date(od2) }.to raise_error ArgumentError
  end
  it "full year" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new

    od1 = OpeningHoursConverter::OpeningHoursDate.new("", "always", [0,1,2,4,5,6])
    od2 = OpeningHoursConverter::OpeningHoursDate.new("Jul-Oct", "month", [0,1,2,4,5,6])

    or1.add_date(od1)
    or1.add_date(od2)
    expect(or1.date.length).to eql(1)
  end
end

RSpec.describe OpeningHoursConverter::OpeningHoursRule, '#add_time' do
  it "simple off" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    ot1 = OpeningHoursConverter::OpeningHoursTime.new
    or1.add_time(ot1)

    expect(or1.time.length).to eql(1)
  end
  it "several off" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    ot1 = OpeningHoursConverter::OpeningHoursTime.new
    ot2 = OpeningHoursConverter::OpeningHoursTime.new(0, 3)
    or1.add_time(ot1)

    expect{ or1.add_time(ot2) }.to raise_error ArgumentError
  end
  it "several" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    ot1 = OpeningHoursConverter::OpeningHoursTime.new(30, 40)
    ot2 = OpeningHoursConverter::OpeningHoursTime.new(0, 3)
    or1.add_time(ot1)
    or1.add_time(ot2)

    expect(or1.time.length).to eql(2)
    expect(or1.time[0]).to eql(ot1)
    expect(or1.time[1]).to eql(ot2)
  end
end

RSpec.describe OpeningHoursConverter::OpeningHoursRule, '#is_off?' do
  it "off" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    expect(or1.is_off?).to be true

    ot1 = OpeningHoursConverter::OpeningHoursTime.new
    or1.add_time(ot1)
    expect(or1.is_off?).to be true
  end
  it "not off" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    ot1 = OpeningHoursConverter::OpeningHoursTime.new(1, 2)
    or1.add_time(ot1)
    expect(or1.is_off?).to be false
  end
end

RSpec.describe OpeningHoursConverter::OpeningHoursRule, '#add_weekday' do
  it "simple" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    expect(or1.date.length).to eql(0)

    od1 = OpeningHoursConverter::OpeningHoursDate.new("Mar", "month", [0,1])
    od2 = OpeningHoursConverter::OpeningHoursDate.new("Jul-Oct", "month", [0,1])
    or1.add_date(od1)
    or1.add_date(od2)

    expect(or1.date.length).to eql(2)
    expect(or1.date[0]).to eql(od1)
    expect(or1.date[1]).to eql(od2)

    or1.add_weekday(5)
    expect(or1.date.length).to eql(2)
    expect(or1.date[0].get_weekdays).to eql("Mo,Tu,Sa")
    expect(or1.date[1].get_weekdays).to eql("Mo,Tu,Sa")
  end
  it "overwritten" do
    or1 = OpeningHoursConverter::OpeningHoursRule.new
    expect(or1.date.length).to eql(0)

    od1 = OpeningHoursConverter::OpeningHoursDate.new("Mar", "month", [0,1])
    od2 = OpeningHoursConverter::OpeningHoursDate.new("Jul-Oct", "month", [0,1])
    or1.add_date(od1)
    or1.add_date(od2)

    expect(or1.date.length).to eql(2)
    expect(or1.date[0]).to eql(od1)
    expect(or1.date[1]).to eql(od2)

    or1.add_overwritten_weekday(5)
    expect(or1.date.length).to eql(2)
    expect(or1.date[0].get_weekdays).to eql("Mo,Tu,Sa")
    expect(or1.date[1].get_weekdays).to eql("Mo,Tu,Sa")
  end
end

