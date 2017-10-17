require 'opening_hours_converter'

RSpec.describe OpeningHoursConverter::Iterator, "state" do
  it "state" do
    expect(OpeningHoursConverter::Iterator.new.state("PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,1,16,00), end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("Su,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,1,16,00), end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("Mo,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,1,16,00), end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to eql({start: Time.new(2017,10,13,16,00), end: Time.new(2017,10,13,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to be false
  end
  it "next_state" do
    expect(OpeningHoursConverter::Iterator.new.next_state("PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("Su,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("Mo,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to eql({end: Time.new(2017,10,13,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to eql({start: Time.new(2017,10,20,16,00)})
  end
  it "next_period" do
    expect(OpeningHoursConverter::Iterator.new.next_period("PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,4,14,16,00), end: Time.new(2017,4,14,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_period("Su,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,8,16,00), end: Time.new(2017,1,8,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_period("Mo,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,2,16,00), end: Time.new(2017,1,2,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_period("Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to eql({start: Time.new(2017,10,20,16,00), end: Time.new(2017,10,20,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_period("Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to eql({start: Time.new(2017,10,20,16,00), end: Time.new(2017,10,20,17,00)})
  end
  it "is_opened" do
    expect(OpeningHoursConverter::Iterator.new.is_opened?("PH 16:00-17:00", Time.new(2017,10,13,16,30))).to be false
    expect(OpeningHoursConverter::Iterator.new.is_opened?("PH 16:00-17:00", Time.new(2017,1,1,16,30))).to be true
    expect(OpeningHoursConverter::Iterator.new.is_opened?("Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to be true
    expect(OpeningHoursConverter::Iterator.new.is_opened?("Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to be false
  end
end
