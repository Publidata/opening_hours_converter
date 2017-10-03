require 'opening_hours_converter/interval'

RSpec.describe Interval, "#initialize" do
  it "initialize" do
    interval = Interval.new(1, 2, 3, 4)
    expect(interval.day_start).to eql(1)
    expect(interval.day_end).to eql(3)
    expect(interval.start).to eql(2)
    expect(interval.end).to eql(4)
  end
  it "initialize" do
    interval = Interval.new(5, 60, 0, 0)
    expect(interval.day_start).to eql(5)
    expect(interval.day_end).to eql(6)
    expect(interval.start).to eql(60)
    expect(interval.end).to eql(24*60)
  end
end
