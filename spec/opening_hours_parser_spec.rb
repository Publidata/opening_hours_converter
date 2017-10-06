require 'opening_hours_converter/opening_hours_parser'

RSpec.describe OpeningHoursConverter::OpeningHoursParser, '#parse' do
  it "void" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse(''))).to eql('')
  end
  it "Mo 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-10:00'))).to eql('Mo 08:00-10:00')
  end
  it "2017 Mo 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-10:00'))).to eql('2017 Mo 08:00-10:00')
  end
  it "2017-2018 Mo 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017-2018 Mo 08:00-10:00'))).to eql('2017-2018 Mo 08:00-10:00')
  end
  it "Mo,We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We 08:00-10:00'))).to eql('Mo,We 08:00-10:00')
  end
  it "2017 Mo,We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo,We 08:00-10:00'))).to eql('2017 Mo,We 08:00-10:00')
  end
  it "Mo-We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We 08:00-10:00'))).to eql('Mo-We 08:00-10:00')
  end
  it "Mo-We 08:00-10:00; Sa,Su 07:00-13:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We 08:00-10:00; Sa,Su 07:00-13:00'))).to eql('Mo-We 08:00-10:00; Sa,Su 07:00-13:00')
  end
  it "Mo 08:00-24:00; Tu 00:00-09:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-24:00; Tu 00:00-09:00'))).to eql('Mo 08:00-24:00; Tu 00:00-09:00')
  end
  it "08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('08:00-18:00'))).to eql('08:00-18:00')
  end
  it "24/7 continuous" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7'))).to eql('24/7')
  end
  it "24/7; Jun: 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun: 08:00-18:00'))).to eql('24/7; Jun 08:00-18:00')
  end
  it "2000 24/7; Jun: 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2000 24/7; Jun: 08:00-18:00'))).to eql('2000 24/7; Jun 08:00-18:00')
  end
  it "24/7; 2000 Jun: 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; 2000 Jun: 08:00-18:00'))).to eql('24/7; 2000 Jun 08:00-18:00')
  end
  it "24/7; 2000 Jun 21-22: 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; 2000 Jun 21-22: 08:00-18:00'))).to eql('24/7; 2000 Jun 21-22 08:00-18:00')
  end
  it "24/7; 2000 Jun 21-Jul 22: 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; 2000 Jun 21-Jul 22: 08:00-18:00'))).to eql('24/7; 2000 Jun 21-Jul 22 08:00-18:00')
  end
  it "24/7; 2000 Jun 21-2002 Jul 22: 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; 2000 Jun 21-2002 Jul 22: 08:00-18:00'))).to eql('24/7; 2000 Jun 21-2002 Jul 22 08:00-18:00')
  end
  it "24/7; Jun: 08:00-18:00; Jun: We off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun: 08:00-18:00; Jun: We off'))).to eql('24/7; Jun 08:00-18:00; Jun We off')
  end
  it "24/7; Jun: Mo-We 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun: Mo-We 08:00-18:00'))).to eql('24/7; Jun Mo-We 08:00-18:00')
  end
  it "24/7; Jun-Aug: Mo-We 08:00-18:00; Jun-Aug: Th-Su off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun-Aug: Mo-We 08:00-18:00; Jun-Aug: Th-Su off'))).to eql('24/7; Jun-Aug Mo-We 08:00-18:00; Jun-Aug Th-Su off')
  end
  it "Mo 08:00-18:00 grouping" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-18:00; Jun: Mo 08:00-18:00'))).to eql('Mo 08:00-18:00')
  end
  it "Mo 08:00-18:00; ; Tu 09:00-18:00 (empty rule)" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-18:00; ; Tu 09:00-18:00'))).to eql('Mo 08:00-18:00; Tu 09:00-18:00')
  end
  it "01:00-02:00; Jun: Th 02:00-03:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('01:00-02:00; Jun: Th 02:00-03:00'))).to eql('01:00-02:00; Jun Th 02:00-03:00')
  end
  it "24/7; Jan Su 01:00-08:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jan Su 01:00-08:00'))).to eql('24/7; Jan Su 01:00-08:00')
  end
  it "Su-Tu 12:00-14:00 (continous week-end)" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Su-Tu 12:00-14:00'))).to eql('12:00-14:00; We-Sa off')
  end
end
