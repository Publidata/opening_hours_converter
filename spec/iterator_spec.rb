require 'opening_hours_converter/interval'

RSpec.describe OpeningHoursConverter::Interval, "state" do
  it "state" do
    expect(OpeningHoursConverter::Iterator.new.state("Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to eql({start: Time.new(2017,10,13,16,00), end: Time.new(2017,10,13,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to be false
  end
  it "next_state" do
    expect(OpeningHoursConverter::Iterator.new.next_state("Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to eql({end: Time.new(2017,10,13,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to eql({start: Time.new(2017,10,20,16,00)})
  end
  it "is_opened" do
    expect(OpeningHoursConverter::Iterator.new.is_opened?("Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to be true
    expect(OpeningHoursConverter::Iterator.new.is_opened?("Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to be false
  end
end
