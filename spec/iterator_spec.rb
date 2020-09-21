require 'opening_hours_converter'

RSpec.describe OpeningHoursConverter::Iterator, "state" do
  it "off" do
    expect(OpeningHoursConverter::Iterator.new.get_time_iterator(OpeningHoursConverter::OpeningHoursParser.new.parse "off")).to eql([])
  end
  it "31 dec 2019" do
    expect(OpeningHoursConverter::Iterator.new.get_time_iterator(OpeningHoursConverter::OpeningHoursParser.new.parse "2018 Dec 31 10:00-11:00")).not_to eql([])
  end
  it 'week 02-52/2 We 13:00-20:00' do
    expect(OpeningHoursConverter::Iterator.new.get_time_iterator(OpeningHoursConverter::OpeningHoursParser.new.parse('week 02-52/2 We 13:00-20:00'))).not_to eql([])
  end

  it "state" do
    expect(OpeningHoursConverter::Iterator.new.state("off")).to be false
    expect(OpeningHoursConverter::Iterator.new.state("2017 PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,1,16,00), end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("2017 Su,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,1,16,00), end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("2017 Mo,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,1,16,00), end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("2017 Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to eql({start: Time.new(2017,10,13,16,00), end: Time.new(2017,10,13,17,00)})
    expect(OpeningHoursConverter::Iterator.new.state("2017 Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to be false
  end
  it "next_state" do
    expect(OpeningHoursConverter::Iterator.new.next_state("off")).to be false
    expect(OpeningHoursConverter::Iterator.new.next_state("2017 PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("2017 Su,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("2017 Mo,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({end: Time.new(2017,1,1,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("2017 Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to eql({end: Time.new(2017,10,13,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_state("2017 Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to eql({start: Time.new(2017,10,20,16,00)})
  end
  it "next_period" do
    expect(OpeningHoursConverter::Iterator.new.next_period("off")).to be false
    expect(OpeningHoursConverter::Iterator.new.next_period("2017 PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,4,14,16,00), end: Time.new(2017,4,14,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_period("2017 Su,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,8,16,00), end: Time.new(2017,1,8,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_period("2017 Mo,PH 16:00-17:00", Time.new(2017,1,1,16,30))).to eql({start: Time.new(2017,1,2,16,00), end: Time.new(2017,1,2,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_period("2017 Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to eql({start: Time.new(2017,10,20,16,00), end: Time.new(2017,10,20,17,00)})
    expect(OpeningHoursConverter::Iterator.new.next_period("2017 Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to eql({start: Time.new(2017,10,20,16,00), end: Time.new(2017,10,20,17,00)})
  end
  it "is_opened" do
    expect(OpeningHoursConverter::Iterator.new.is_opened?("off")).to be false
    expect(OpeningHoursConverter::Iterator.new.is_opened?("2017 PH 16:00-17:00", Time.new(2017,10,13,16,30))).to be false
    expect(OpeningHoursConverter::Iterator.new.is_opened?("2017 PH 16:00-17:00", Time.new(2017,1,1,16,30))).to be true
    expect(OpeningHoursConverter::Iterator.new.is_opened?("2017 Fr 16:00-17:00", Time.new(2017,10,13,16,30))).to be true
    expect(OpeningHoursConverter::Iterator.new.is_opened?("2017 Fr 16:00-17:00", Time.new(2017,10,13,17,30))).to be false
  end
end
