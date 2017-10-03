require 'opening_hours_converter/opening_hours_date'

RSpec.describe OpeningHoursConverter::OpeningHoursDate, '#initialize' do
  it "initialize" do
    expect { OpeningHoursConverter::OpeningHoursDate.new() }.to raise_error ArgumentError
    expect { OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,3,5,6]) }.to_not raise_error
  end
end
RSpec.describe OpeningHoursConverter::OpeningHoursDate, '#get_weekdays' do
  it "sorted" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,3,5,6])
    expect(ohd.weekdays[0]).to eql(0)
    expect(ohd.weekdays[1]).to eql(1)
    expect(ohd.weekdays[2]).to eql(3)
    expect(ohd.weekdays[3]).to eql(5)
    expect(ohd.weekdays[4]).to eql(6)
  end
  it "unsorted" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [6,3,1,5,0])
    expect(ohd.weekdays[0]).to eql(0)
    expect(ohd.weekdays[1]).to eql(1)
    expect(ohd.weekdays[2]).to eql(3)
    expect(ohd.weekdays[3]).to eql(5)
    expect(ohd.weekdays[4]).to eql(6)
  end
end
RSpec.describe OpeningHoursConverter::OpeningHoursDate, '#same_weekdays?' do
  it "sorted" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,3,5,6])
    expect(ohd.same_weekdays?([0,1,3,5,6])).to be true
    expect(ohd.same_weekdays?([0,1,3])).to be false
  end
  it "unsorted" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [6,3,1,5,0])
    expect(ohd.same_weekdays?([0,1,3,5,6])).to be true
    expect(ohd.same_weekdays?([0,1,3])).to be false
  end
end
RSpec.describe OpeningHoursConverter::OpeningHoursDate, '#same_kind_as?' do
  it "ok" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,2,4,5,6])
    ohd1 = OpeningHoursConverter::OpeningHoursDate.new("Mar 01-Apr 02", "day", [0,1,2,4,5,6])
    expect(ohd.same_kind_as?(ohd1)).to be true
  end
  it "not ok" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,2,3,5,6])
    ohd1 = OpeningHoursConverter::OpeningHoursDate.new("Mar 01-Apr 02", "day", [0,1,4,5,6])
    expect(ohd.same_kind_as?(ohd1)).to be false
  end
end
RSpec.describe OpeningHoursConverter::OpeningHoursDate, '#equals?' do
  it "same" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,2,4,5,6])
    ohd1 = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,2,4,5,6])
    expect(ohd.equals(ohd1)).to be true
    expect(ohd1.equals(ohd1)).to be true
    expect(ohd1.equals(ohd)).to be true
    expect(ohd.equals(ohd)).to be true
  end
  it "not same" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,2,4,5,6])
    ohd1 = OpeningHoursConverter::OpeningHoursDate.new("", "always", [0,1,2,4,5,6])
    expect(ohd.equals(ohd1)).to be false
    expect(ohd1.equals(ohd1)).to be true
    expect(ohd1.equals(ohd)).to be false
    expect(ohd.equals(ohd)).to be true
  end
end
RSpec.describe OpeningHoursConverter::OpeningHoursDate, '#add_weekday' do
  it "new" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0])
    expect(ohd.weekdays.length).to eql(1)

    ohd.add_weekday(3)
    expect(ohd.weekdays.length).to eql(2)
    expect(ohd.weekdays[0]).to eql(0)
    expect(ohd.weekdays[1]).to eql(3)
  end
  it "existing" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0, 3])
    expect(ohd.weekdays.length).to eql(2)

    ohd.add_weekday(3)
    expect(ohd.weekdays.length).to eql(2)
    expect(ohd.weekdays[0]).to eql(0)
    expect(ohd.weekdays[1]).to eql(3)
  end
end
RSpec.describe OpeningHoursConverter::OpeningHoursDate, '#add_overwritten_weekday' do
  it "new" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0])
    expect(ohd.get_weekdays).to eql("Mo")

    ohd.add_overwritten_weekday(2)
    expect(ohd.get_weekdays).to eql("Mo,We")
  end
  it "existing" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0, 2])
    expect(ohd.get_weekdays).to eql("Mo,We")

    ohd.add_overwritten_weekday(2)
    expect(ohd.get_weekdays).to eql("Mo,We")
  end
  it "existing" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0, 2])
    expect(ohd.get_weekdays).to eql("Mo,We")

    ohd.add_overwritten_weekday(4)
    expect(ohd.get_weekdays).to eql("Mo,We,Fr")
    ohd.add_overwritten_weekday(4)
    expect(ohd.get_weekdays).to eql("Mo,We,Fr")
  end
end
RSpec.describe OpeningHoursConverter::OpeningHoursDate, '#get_weekdays' do
  it "1" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,3,5])
    expect(ohd.get_weekdays).to eql("Mo,Tu,Th,Sa")
  end
  it "2" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,4,3,2,5])
    expect(ohd.get_weekdays).to eql("Mo-Sa")
  end
  it "3" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,6])
    expect(ohd.get_weekdays).to eql("Mo,Su")
  end
  it "4-1" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [6,0,1])
    expect(ohd.get_weekdays).to eql("Su-Tu")
  end
  it "4-2" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [5,6,0,1,3])
    expect(ohd.get_weekdays).to eql("Sa-Tu,Th")
  end
  it "4-3" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0, 3, 6])
    expect(ohd.get_weekdays).to eql("Mo,Th,Su")
  end
  it "4-4" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,2,3,4,5,6])
    expect(ohd.get_weekdays).to eql("")
  end
  it "5" do
    ohd = OpeningHoursConverter::OpeningHoursDate.new("Apr 21-Aug 22", "day", [0,1,2,4,5,6])
    expect(ohd.get_weekdays).to eql("Fr-We")
  end
end
