
require 'opening_hour_converter'

RSpec.describe OpeningHoursParser, '#parse' do
  it "void" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse(''))).to eql('')
  end
  it "Mo 08:00-10:00" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('Mo 08:00-10:00'))).to eql('Mo 08:00-10:00')
  end
  it "Mo,We 08:00-10:00" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('Mo,We 08:00-10:00'))).to eql('Mo,We 08:00-10:00')
  end
  it "Mo-We 08:00-10:00" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('Mo-We 08:00-10:00'))).to eql('Mo-We 08:00-10:00')
  end
  it "Mo-We 08:00-10:00; Sa,Su 07:00-13:00" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('Mo-We 08:00-10:00; Sa,Su 07:00-13:00'))).to eql('Mo-We 08:00-10:00; Sa,Su 07:00-13:00')
  end
  it "Mo 08:00-24:00; Tu 00:00-09:00" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('Mo 08:00-24:00; Tu 00:00-09:00'))).to eql('Mo 08:00-24:00; Tu 00:00-09:00')
  end
  it "08:00-18:00" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('08:00-18:00'))).to eql('08:00-18:00')
  end
  it "24/7 continuous" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('24/7'))).to eql('24/7')
  end
  it "24/7; Jun: 08:00-18:00" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('24/7; Jun: 08:00-18:00'))).to eql('24/7; Jun 08:00-18:00')
  end
  it "24/7; Jun: 08:00-18:00; Jun: We off" do
    expect(OpeningHoursBuilder.new.build(OpeningHoursParser.new.parse('24/7; Jun: 08:00-18:00; Jun: We off'))).to eql('24/7; Jun 08:00-18:00; Jun We off')
  end
end


