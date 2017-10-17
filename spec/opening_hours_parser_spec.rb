require 'opening_hours_converter'

RSpec.describe OpeningHoursConverter::OpeningHoursParser, '#parse' do
  it "PH,Su off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Su 10:00-11:00'))).to eql('PH,Su 10:00-11:00')
  end
  it "PH,Mo-Sa 10:00-11:00 \"salut\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo-Sa 10:00-11:00 "salut"'))).to eql('PH,Mo-Sa 10:00-11:00 "salut"')
  end
  it "2017 PH,Mo-Sa 10:00-11:00 \"salut\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 PH,Mo-Sa 10:00-11:00 "salut"'))).to eql('2017 PH,Mo-Sa 10:00-11:00 "salut"')
  end
  it "2017-2018 PH,Mo-Sa 10:00-11:00 \"salut\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017-2018 PH,Mo-Sa 10:00-11:00 "salut"'))).to eql('2017-2018 PH,Mo-Sa 10:00-11:00 "salut"')
  end
  it "PH,Mo-Sa 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo-Sa 10:00-11:00'))).to eql('PH,Mo-Sa 10:00-11:00')
  end
  it "PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH off'))).to eql('PH off')
  end
  it "PH 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 10:00-11:00'))).to eql('PH 10:00-11:00')
  end
  it "2017 PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 PH off'))).to eql('2017 PH off')
  end
  it "2017 PH 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 PH 10:00-11:00'))).to eql('2017 PH 10:00-11:00')
  end
  it "2017-2018 PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017-2018 PH off'))).to eql('2017-2018 PH off')
  end
  it "2017-2018 PH 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017-2018 PH 10:00-11:00'))).to eql('2017-2018 PH 10:00-11:00')
  end
  it "void" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse(''))).to eql('')
  end
  it "Mo 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-10:00'))).to eql('Mo 08:00-10:00')
  end
  it "2017 Jun-Jul Sa 10:00-12:00; Su 10:30-12:30" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Jun-Jul Sa 10:00-12:00; Su 10:30-12:30'))).to eql('2017 Jun-Jul Sa 10:00-12:00; Su 10:30-12:30')
  end
  it "2017 Jun-2020 Jul Sa 10:00-12:00; Su 10:30-12:30" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Jun-2020 Jul Sa 10:00-12:00; Su 10:30-12:30'))).to eql('2017 Jun-2020 Jul Sa 10:00-12:00; Su 10:30-12:30')
  end
  it "2017 Mo 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-10:00'))).to eql('2017 Mo 08:00-10:00')
  end
  it "2017-2018 Mo 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017-2018 Mo 08:00-10:00'))).to eql('2017-2018 Mo 08:00-10:00')
  end
  it "2017-2018 Mo 08:00-10:00 \"hehe\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017-2018 Mo 08:00-10:00 "hehe"'))).to eql('2017-2018 Mo 08:00-10:00 "hehe"')
  end
  it "Mo,We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We 08:00-10:00'))).to eql('Mo,We 08:00-10:00')
  end
  it "2017 Mo,We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo,We 08:00-10:00'))).to eql('2017 Mo,We 08:00-10:00')
  end
  it "1999-2017 Mo,We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('1999-2017 Mo,We 08:00-10:00'))).to eql('1999-2017 Mo,We 08:00-10:00')
  end
  it "1999-2017 Mo,We 08:00-10:00 \"huhu\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('1999-2017 Mo,We 08:00-10:00 "huhu"'))).to eql('1999-2017 Mo,We 08:00-10:00 "huhu"')
  end
  it "Mo-We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We 08:00-10:00'))).to eql('Mo-We 08:00-10:00')
  end
  it 'Mo-We 08:00-10:00 "haha"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We 08:00-10:00 "haha"'))).to eql('Mo-We 08:00-10:00 "haha"')
  end
  it "2001 Mo-We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2001 Mo-We 08:00-10:00'))).to eql('2001 Mo-We 08:00-10:00')
  end
  it "2001-3876 Mo-We 08:00-10:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2001-3876 Mo-We 08:00-10:00'))).to eql('2001-3876 Mo-We 08:00-10:00')
  end
  it "Mo-We 08:00-10:00; Sa,Su 07:00-13:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We 08:00-10:00; Sa,Su 07:00-13:00'))).to eql('Mo-We 08:00-10:00; Sa,Su 07:00-13:00')
  end
  it "Mo-We 08:00-10:00 \"salut\"; Sa,Su 07:00-13:00 \"bjr\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We 08:00-10:00 "salut"; Sa,Su 07:00-13:00 "bjr"'))).to eql('Mo-We 08:00-10:00 "salut"; Sa,Su 07:00-13:00 "bjr"')
  end
  it "Mo-We 08:00-10:00 \"salut\"; Sa,Su 07:00-13:00 \"salut\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We 08:00-10:00 "salut"; Sa,Su 07:00-13:00 "salut"'))).to eql('Mo-We 08:00-10:00 "salut"; Sa,Su 07:00-13:00 "salut"')
  end
  it "Mo 08:00-24:00; Tu 00:00-09:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-24:00; Tu 00:00-09:00'))).to eql('Mo 08:00-24:00; Tu 00:00-09:00')
  end
  it "2001 Mo 08:00-24:00; 2001 Tu 00:00-09:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2001 Mo 08:00-24:00; 2001 Tu 00:00-09:00'))).to eql('2001 Mo 08:00-24:00; 2001 Tu 00:00-09:00')
  end
  it "08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('08:00-18:00'))).to eql('08:00-18:00')
  end
  it "9876 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('9876 08:00-18:00'))).to eql('9876 08:00-18:00')
  end
  it "24/7 continuous" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7'))).to eql('24/7')
  end
  it "2002 24/7 continuous" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2002 24/7'))).to eql('2002 24/7')
  end
  it "2002 Jan-2003 Feb 24/7 continuous" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2002 Jan-2003 Feb 24/7'))).to eql('2002 Jan-2003 Feb 24/7')
  end
  it "24/7; Jun: 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun: 08:00-18:00'))).to eql('24/7; Jun 08:00-18:00')
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
  it "Mo 08:00-18:00 \"grouping\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-18:00 "grouping"; Jun: Mo 08:00-18:00 "grouping"'))).to eql('Mo 08:00-18:00 "grouping"')
  end
  it "Mo 08:00-18:00 \"not grouping\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-18:00 "not grouping"; Jun: Mo 08:00-18:00 "grouping"'))).to eql('Mo 08:00-18:00 "not grouping"; Jun Mo 08:00-18:00 "grouping"')
  end
  it "2017 Mo 08:00-18:00; 2017 Jun: Mo 08:00-18:00 grouping" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-18:00; 2017 Jun: Mo 08:00-18:00'))).to eql('2017 Mo 08:00-18:00')
  end
  it "2017 Mo 08:00-18:00 \"grouping\"; 2017 Jun: Mo 08:00-18:00 \"grouping\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-18:00 "grouping"; 2017 Jun: Mo 08:00-18:00 "grouping"'))).to eql('2017 Mo 08:00-18:00 "grouping"')
  end
  it "2017 Mo 08:00-18:00 \"not grouping :x\"; 2017 Jun: Mo 08:00-18:00 \"grouping\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-18:00; 2017 Jun: Mo 08:00-18:00'))).to eql('2017 Mo 08:00-18:00')
  end
  it "Mo 08:00-18:00 grouping with a year" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-18:00 "not grouping :x"; 2017 Jun: Mo 08:00-18:00 "grouping"'))).to eql('2017 Mo 08:00-18:00 "not grouping :x"; 2017 Jun Mo 08:00-18:00 "grouping"')
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
