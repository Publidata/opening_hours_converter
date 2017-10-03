require 'opening_hours_converter/opening_hours_time'

RSpec.describe OpeningHoursTime, '#initialize' do
  it "initialize" do
    expect { OpeningHoursTime.new(0, 60) }.to_not raise_error
    expect { OpeningHoursTime.new(0) }.to_not raise_error
  end
end
RSpec.describe OpeningHoursTime, '#get' do
  it "void" do
    expect(OpeningHoursTime.new.get).to eql("off")
  end
  it "without end" do
    expect(OpeningHoursTime.new(0).get).to eql("00:00")
  end
  it "start == end" do
    expect(OpeningHoursTime.new(10, 10).get).to eql("00:10")
  end
  it "start and end" do
    expect(OpeningHoursTime.new(10, 60).get).to eql("00:10-01:00")
  end
end
RSpec.describe OpeningHoursTime, '#equals' do
  it "void" do
    expect(OpeningHoursTime.new.equals(OpeningHoursTime.new)).to be true
  end
  it "same" do
    expect(OpeningHoursTime.new(10).equals(OpeningHoursTime.new(10))).to be true
    expect(OpeningHoursTime.new(10, 100).equals(OpeningHoursTime.new(10, 100))).to be true
  end
  it "different" do
    expect(OpeningHoursTime.new(10).equals(OpeningHoursTime.new(20))).to be false
    expect(OpeningHoursTime.new(10, 100).equals(OpeningHoursTime.new(20, 100))).to be false
    expect(OpeningHoursTime.new(10, 100).equals(OpeningHoursTime.new(10, 110))).to be false
  end
end
