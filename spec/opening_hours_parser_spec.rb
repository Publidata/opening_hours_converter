require 'opening_hours_converter'

RSpec.describe OpeningHoursConverter::OpeningHoursParser, '#parse' do
  it "merge tokens" do
    expect(OpeningHoursConverter::OpeningHoursParser.new.merge_groups([["2017", "Jan", "01", "Mo", "Tu", "Sa-Su"]])).to eql(["2017 Jan 01", "Mo,Tu,Sa-Su"])
  end
  it "off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('off'))).to eql('off')
  end
  # todo ?
  # it "2000 Jan 01,2001 Jan 01 13:30-17:35" do
  #   expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2000 Jan 01,2001 Jan 01 13:30-17:35'))).to eql('2000 Jan 01,2001 Jan 01 13:30-17:35')
  # end
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
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Jun 01-2017 Jul 31 Sa 10:00-12:00; Su 10:30-12:30'))).to eql('2017 Jun 01-2017 Jul 31 Sa 10:00-12:00; Su 10:30-12:30')
  end
  it "2017 Jun-2020 Jul Sa 10:00-12:00; Su 10:30-12:30" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Jun-2020 Jul Sa 10:00-12:00; Su 10:30-12:30'))).to eql('2017 Jun 01-2020 Jul 31 Sa 10:00-12:00; Su 10:30-12:30')
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
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2002 Jan-2003 Feb 24/7'))).to eql('2002 Jan 01-2003 Feb 28 24/7')
  end
  it "24/7; Jun 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun 08:00-18:00'))).to eql('24/7; Jun 08:00-18:00')
  end
  it "24/7; 2000 Jun 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; 2000 Jun 08:00-18:00'))).to eql('24/7; 2000 Jun 01-30 08:00-18:00')
  end
  it "24/7; 2000 Jun 21-22 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; 2000 Jun 21-22 08:00-18:00'))).to eql('24/7; 2000 Jun 21-22 08:00-18:00')
  end
  it "24/7; 2000 Jun 21-Jul 22 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; 2000 Jun 21-Jul 22 08:00-18:00'))).to eql('24/7; 2000 Jun 21-2000 Jul 22 08:00-18:00')
  end
  it "24/7; 2000 Jun 21-2002 Jul 22 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; 2000 Jun 21-2002 Jul 22 08:00-18:00'))).to eql('24/7; 2000 Jun 21-2002 Jul 22 08:00-18:00')
  end
  it "Tu-We 10:00-20:00;Tu off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Tu-We 10:00-20:00;Tu off'))).to eql('Tu off; We 10:00-20:00')
  end
  it "24/7; Jun 08:00-18:00; Jun We off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun 08:00-18:00; Jun We off'))).to eql('24/7; Jun 08:00-18:00; Jun We off')
  end
  it "24/7; Jun Mo-We 08:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun Mo-We 08:00-18:00'))).to eql('24/7; Jun Mo-We 08:00-18:00')
  end
  it "24/7; Jun-Aug Mo-We 08:00-18:00; Jun-Aug Th-Su off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jun-Aug Mo-We 08:00-18:00; Jun-Aug Th-Su off'))).to eql('24/7; Jun-Aug Mo-We 08:00-18:00; Jun-Aug Th-Su off')
  end
  it "Mo 08:00-18:00 grouping" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-18:00; Jun Mo 08:00-18:00'))).to eql('Mo 08:00-18:00')
  end
  it "Mo 08:00-18:00 \"grouping\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-18:00 "grouping"; Jun Mo 08:00-18:00 "grouping"'))).to eql('Mo 08:00-18:00 "grouping"')
  end
  it "Mo 08:00-18:00 \"not grouping\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-18:00 "not grouping"; Jun Mo 08:00-18:00 "grouping"'))).to eql('Mo 08:00-18:00 "not grouping"; Jun Mo 08:00-18:00 "grouping"')
  end
  it "2017 Mo 08:00-18:00; 2017 Jun Mo 08:00-18:00 grouping" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-18:00; 2017 Jun Mo 08:00-18:00'))).to eql('2017 Mo 08:00-18:00')
  end
  it "2017 Mo 08:00-18:00 \"grouping\"; 2017 Jun Mo 08:00-18:00 \"grouping\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-18:00 "grouping"; 2017 Jun Mo 08:00-18:00 "grouping"'))).to eql('2017 Mo 08:00-18:00 "grouping"')
  end
  it "2017 Mo 08:00-18:00 \"not grouping :x\"; 2017 Jun Mo 08:00-18:00 \"grouping\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-18:00; 2017 Jun Mo 08:00-18:00'))).to eql('2017 Mo 08:00-18:00')
  end
  it "Mo 08:00-18:00 grouping with a year" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Mo 08:00-18:00 "not grouping :x"; 2017 Jun Mo 08:00-18:00 "grouping"'))).to eql('2017 Mo 08:00-18:00 "not grouping :x"; 2017 Jun 01-30 Mo 08:00-18:00 "grouping"')
  end
  it "Mo 08:00-18:00; ; Tu 09:00-18:00 (empty rule)" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 08:00-18:00; ; Tu 09:00-18:00'))).to eql('Mo 08:00-18:00; Tu 09:00-18:00')
  end
  it "24/7; Jan Su 01:00-08:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('24/7; Jan Su 01:00-08:00'))).to eql('24/7; Jan Su 01:00-08:00')
  end
  it "01:00-02:00; Jun Th 02:00-03:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('01:00-02:00; Jun Th 02:00-03:00'))).to eql('01:00-02:00; Jun Th 02:00-03:00')
  end
  it "Su-Tu 12:00-14:00 (continous week-end)" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Su-Tu 12:00-14:00'))).to eql('Su-Tu 12:00-14:00')
  end
  it "2017 Nov 11 off (single off day)" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Nov 11 off'))).to eql('2017 Nov 11 off')
  end
  it "2017 Nov 11-12 10:00-23:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2017 Nov 11-12 10:00-23:00'))).to eql('2017 Nov 11-12 10:00-23:00')
  end
  it "Nov 11-12 10:00-23:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Nov 11-12 10:00-23:00'))).to eql('Nov 11-12 10:00-23:00')
  end
  it "Nov 11 00:00-23:59" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Nov 11 00:00-23:59'))).to eql('Nov 11 00:00-23:59')
  end
  it "Mo-We 00:00-01:00,18:00-24:00; Th 00:00-01:00,10:00-20:00; Fr 18:00-24:00; Sa,Su 00:00-04:00,18:00-24:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo-We 00:00-01:00,18:00-24:00; Th 00:00-01:00,10:00-20:00; Fr 18:00-24:00; Sa,Su 00:00-04:00,18:00-24:00"))).to eql("Mo-We 00:00-01:00,18:00-24:00; Th 00:00-01:00,10:00-20:00; Fr 18:00-24:00; Sa,Su 00:00-04:00,18:00-24:00")
  end
  it "Sa,Su 18:00-24:00; Jan Mo-Tu off,Fr 10:00-20:00,21:00-03:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Sa,Su 18:00-24:00; Jan Mo-Tu off,Fr 10:00-20:00,21:00-03:00"))).to eql("Sa,Su 18:00-24:00; Jan Mo,Tu off; Jan Fr 10:00-20:00,21:00-24:00; Jan Sa 00:00-03:00,18:00-24:00")
  end
  it "Sa,Su 00:00-04:00,18:00-24:00; Jan Mo-Tu off,Fr 10:00-20:00,21:00-03:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Sa,Su 00:00-04:00,18:00-24:00; Jan Mo-Tu off,Fr 10:00-20:00,21:00-24:00,Sa 00:00-03:00"))).to eql("Sa,Su 00:00-04:00,18:00-24:00; Jan Mo,Tu off; Jan Fr 10:00-20:00,21:00-24:00; Jan Sa 00:00-03:00")
  end
  it "Jan Mo-Tu off,Su 10:00-20:00,21:00-03:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Jan Mo-Tu off; Jan Su 10:00-20:00,21:00-03:00"))).to eql("Jan Mo 00:00-03:00; Jan Tu off; Jan Su 10:00-20:00,21:00-24:00")
  end
  it "Mo off; Tu 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo off; Tu 10:00-11:00"))).to eql("Mo off; Tu 10:00-11:00")
  end
  it "2017 Dec 15-2018 Jan 15 10:00-19:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2017 Dec 15-2018 Jan 15 10:00-19:00"))).to eql("2017 Dec 15-2018 Jan 15 10:00-19:00")
  end
  it "Mo,We off; Tu 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,We off; Tu 10:00-11:00"))).to eql("Mo,We off; Tu 10:00-11:00")
  end
  it "Mo,We off; Jan Mo 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,We off; Jan Mo 10:00-11:00"))).to eql("Mo,We off; Jan Mo 10:00-11:00")
  end
  it "Mo,We off; Jan Mo 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,We off; Jan Mo 10:00-11:00; Feb We 20:00-03:00"))).to eql("Mo,We off; Jan Mo 10:00-11:00; Feb We 20:00-24:00; Feb Th 00:00-03:00")
  end
  it "2017 10:00-11:00; Jan 11:00-12:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2017 10:00-11:00; Jan 11:00-12:00"))).to eql("2017 10:00-11:00; Jan 11:00-12:00")
  end
  it "2017 10:00-11:00 \"Salut\"; Jan 11:00-12:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2017 10:00-11:00 \"Salut\"; Jan 11:00-12:00"))).to eql("2017 10:00-11:00 \"Salut\"; Jan 11:00-12:00")
  end
  it "2017 PH 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2017 PH 10:00-11:00"))).to eql("2017 PH 10:00-11:00")
  end
  it "2017 10:00-11:00; PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2017 10:00-11:00; PH off"))).to eql("2017 10:00-11:00; PH off")
  end
  it "Mo,Tu,PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Tu,PH off"))).to eql("PH,Mo,Tu off")
  end
  it "Jan off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Jan off"))).to eql("Jan off")
  end
  it "Jan We 11:00-12:00,Mo 20:00-03:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Jan We 11:00-12:00,Mo 20:00-03:00"))).to eql("Jan Mo 20:00-24:00; Jan Tu 00:00-03:00; Jan We 11:00-12:00")
  end
  it "Jan We 11:00-12:00,Mo off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Jan We 11:00-12:00,Mo off"))).to eql("Jan Mo off; Jan We 11:00-12:00")
  end
  it "Jan Su off,Mo-Sa 11:00-12:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Jan Su off,Mo-Sa 11:00-12:00"))).to eql("Jan Mo-Sa 11:00-12:00; Jan Su off")
  end
  it "2017 10:00-11:00; Jan-Feb Mo off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2017 10:00-11:00; Jan-Feb Mo off"))).to eql("2017 10:00-11:00; Jan-Feb Mo off")
  end
  it "Mo,We 8:00-9:00; Jan Mo 10:00-11:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,We 8:00-9:00; Jan Mo 10:00-11:00"))).to eql("Mo,We 08:00-09:00; Jan Mo 10:00-11:00")
  end

  it "Mo,Th,Su off \"Espace Jeunesse\";Tu,Fr 16:00-18:00 \"Espace Jeunesse\";We 10:00-12:30,14:00-18:30 \"Espace Jeunesse\";Sa 10:00-12:30,14:00-18:00 \"Espace Jeunesse\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Th,Su off \"Espace Jeunesse\";Tu,Fr 16:00-18:00 \"Espace Jeunesse\";We 10:00-12:30,14:00-18:30 \"Espace Jeunesse\";Sa 10:00-12:30,14:00-18:00 \"Espace Jeunesse\";"))).to eql("Mo,Th,Su off \"Espace Jeunesse\"; Tu,Fr 16:00-18:00 \"Espace Jeunesse\"; We 10:00-12:30,14:00-18:30 \"Espace Jeunesse\"; Sa 10:00-12:30,14:00-18:00 \"Espace Jeunesse\"")
  end

  it "Mo,Th off;Tu,Fr 14:00-19:00;We 10:00-12:30,14:00-19:00;Sa 10:00-18:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Th off;Tu,Fr 14:00-19:00;We 10:00-12:30,14:00-19:00;Sa 10:00-18:00"))).to eql("Mo,Th off; Tu,Fr 14:00-19:00; We 10:00-12:30,14:00-19:00; Sa 10:00-18:00")
  end

  it "Mo,Su off;  Tu 9:00-12:30,14:00-17:00; We 9:00-12:30,14:00-18:00;Th 14:00-19:00;Fr 14:00-17:00;Sa 9:00-12:30,14:00-17:00;" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Su off;  Tu 9:00-12:30,14:00-17:00; We 9:00-12:30,14:00-18:00;Th 14:00-19:00;Fr 14:00-17:00;Sa 9:00-12:30,14:00-17:00;"))).to eql("Mo,Su off; Tu,Sa 09:00-12:30,14:00-17:00; We 09:00-12:30,14:00-18:00; Th 14:00-19:00; Fr 14:00-17:00")
  end

  it "Mo,Th,Su off \"Section adulte\";Tu 10:00-12:00,14:00-19:00 \"Section adulte\";We,Fr 10:00-12:00,14:00-18:30 \"Section adulte\";Sa 10:00-12:30,14:00-17:00 \"Section adulte\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Th,Su off \"Section adulte\";Tu 10:00-12:00,14:00-19:00 \"Section adulte\";We,Fr 10:00-12:00,14:00-18:30 \"Section adulte\";Sa 10:00-12:30,14:00-17:00 \"Section adulte\";"))).to eql("Mo,Th,Su off \"Section adulte\"; Tu 10:00-12:00,14:00-19:00 \"Section adulte\"; We,Fr 10:00-12:00,14:00-18:30 \"Section adulte\"; Sa 10:00-12:30,14:00-17:00 \"Section adulte\"")
  end

  it "Mo,Th,Su off \"Section jeunesse\";Tu 16:00-19:00 \"Section jeunesse\";We 10:00-12:00,14:00-18:30 \"Section jeunesse\";Fr 16:00-18:30 \"Section jeunesse\";Sa 10:00-12:30,14:00-17:00 \"Section jeunesse\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Th,Su off \"Section jeunesse\";Tu 16:00-19:00 \"Section jeunesse\";We 10:00-12:00,14:00-18:30 \"Section jeunesse\";Fr 16:00-18:30 \"Section jeunesse\";Sa 10:00-12:30,14:00-17:00 \"Section jeunesse\";"))).to eql("Mo,Th,Su off \"Section jeunesse\"; Tu 16:00-19:00 \"Section jeunesse\"; We 10:00-12:00,14:00-18:30 \"Section jeunesse\"; Fr 16:00-18:30 \"Section jeunesse\"; Sa 10:00-12:30,14:00-17:00 \"Section jeunesse\"")
  end

  it "Mo,Su off;Tu 14:00-18:00;We 10:00-19:00;Th 14:00-18:00;Fr 14:00-18:00;Sa 10:00-18:00;" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Su off;Tu 14:00-18:00;We 10:00-19:00;Th 14:00-18:00;Fr 14:00-18:00;Sa 10:00-18:00;"))).to eql("Mo,Su off; Tu,Th,Fr 14:00-18:00; We 10:00-19:00; Sa 10:00-18:00")
  end

  it "Mo,Tu,Th,Su off;We 14:30-17:30;Fr 16:30-18:00;Sa 10:00-12:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Tu,Th,Su off;We 14:30-17:30;Fr 16:30-18:00;Sa 10:00-12:00"))).to eql("Su-Tu,Th off; We 14:30-17:30; Fr 16:30-18:00; Sa 10:00-12:00")
  end

  it "Mo-Fr 14:30-17:00;Sa 09:00-11:30; Su off;" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo-Fr 14:30-17:00;Sa 09:00-11:30; Su off;"))).to eql("Mo-Fr 14:30-17:00; Sa 09:00-11:30; Su off")
  end

  it "Tu 15:30-18:00,We 9:30-11:45,14:00-18:00,Fr 16:45-18:00,Sa 10:00-12:00;Mo,Th,Su off;" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Tu 15:30-18:00,We 9:30-11:45,14:00-18:00,Fr 16:45-18:00,Sa 10:00-12:00;Mo,Th,Su off;"))).to eql("Mo,Th,Su off; Tu 15:30-18:00; We 09:30-11:45,14:00-18:00; Fr 16:45-18:00; Sa 10:00-12:00")
  end

  it "We 16:00-18:00;Fr 15:00-17:00;Sa 10:00-12:00;Mo,Tu,Th,Su off;Oct 21-Nov 06 Mo-Su off \"Vacances de la Toussaint\";Dec 23-Jan 08 Mo-Su off \"Vacances de Noël\";Feb 24-Mar 12 Mo-Su off \"Vacances d'hiver\";Apr 21-May 07 Mo-Su off \"Vacances de printemps\";Jul 07-Sep 04 Mo-Su off \"Vacances d'été\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("We 16:00-18:00;Fr 15:00-17:00;Sa 10:00-12:00;Mo,Tu,Th,Su off;Oct 21-Nov 06 Mo-Su off \"Vacances de la Toussaint\";Dec 23-Jan 08 Mo-Su off \"Vacances de Noël\";Feb 24-Mar 12 Mo-Su off \"Vacances d'hiver\";Apr 21-May 07 Mo-Su off \"Vacances de printemps\";Jul 07-Sep 04 Mo-Su off \"Vacances d'été\";"))).to eql("Su-Tu,Th off; We 16:00-18:00; Fr 15:00-17:00; Sa 10:00-12:00; Oct 21-Nov 06 off \"Vacances de la Toussaint\"; Dec 23-Jan 08 off \"Vacances de Noël\"; Feb 24-Mar 12 off \"Vacances d'hiver\"; Apr 21-May 07 off \"Vacances de printemps\"; Jul 07-Sep 04 off \"Vacances d'été\"")
  end

  it "We 16:00-18:00; Dec 23-Jan 08 Mo-Su off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("We 16:00-18:00; Dec 23-Jan 08 Mo-Su off"))).to eql("We 16:00-18:00; Dec 23-Jan 08 off")
  end

  it "Tu,Fr 13:30-18:30 \"Espaces Adultes, Musique & Cinéma\";We 10:00-12:30,14:00-18:30 \"Espaces Adultes, Musique & Cinéma\";Th 9:00-12:30 \"Espaces Adultes, Musique & Cinéma\";Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes, Musique & Cinéma\";Mo,Su off  \"Espaces Adultes, Musique & Cinéma\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Tu,Fr 13:30-18:30 \"Espaces Adultes, Musique & Cinéma\";We 10:00-12:30,14:00-18:30 \"Espaces Adultes, Musique & Cinéma\";Th 9:00-12:30 \"Espaces Adultes, Musique & Cinéma\";Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes, Musique & Cinéma\";Mo,Su off  \"Espaces Adultes, Musique & Cinéma\";"))).to eql("Mo,Su off \"Espaces Adultes, Musique & Cinéma\"; Tu,Fr 13:30-18:30 \"Espaces Adultes, Musique & Cinéma\"; We 10:00-12:30,14:00-18:30 \"Espaces Adultes, Musique & Cinéma\"; Th 09:00-12:30 \"Espaces Adultes, Musique & Cinéma\"; Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes, Musique & Cinéma\"")
  end

  it "Tu,Fr 14:00-19:00;We 13:00-18:00;Sa 10:00-18:00;Th,Su,Mo off;" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Tu,Fr 14:00-19:00;We 13:00-18:00;Sa 10:00-18:00;Th,Su,Mo off;"))).to eql("Mo,Th,Su off; Tu,Fr 14:00-19:00; We 13:00-18:00; Sa 10:00-18:00")
  end

  it "Th,Su,Mo off \"Espace Jeunesse\";Tu,Fr 16:00-18:30 \"Espace Jeunesse\";We 10:00-18:30 \"Espace Jeunesse\";Sa 10:00-18:00 \"Espace Jeunesse\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Th,Su,Mo off \"Espace Jeunesse\";Tu,Fr 16:00-18:30 \"Espace Jeunesse\";We 10:00-18:30 \"Espace Jeunesse\";Sa 10:00-18:00 \"Espace Jeunesse\";"))).to eql("Mo,Th,Su off \"Espace Jeunesse\"; Tu,Fr 16:00-18:30 \"Espace Jeunesse\"; We 10:00-18:30 \"Espace Jeunesse\"; Sa 10:00-18:00 \"Espace Jeunesse\"")
  end

  it "Mo,Th,Su off \"Espaces Adultes et Musique & Cinéma\";Tu,Fr 13:00-18:30 \"Espaces Adultes et Musique & Cinéma\";We 10:00-12:30,14:00-18:30 \"Espaces Adultes et Musique & Cinéma\";Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes et Musique & Cinéma\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Th,Su off \"Espaces Adultes et Musique & Cinéma\";Tu,Fr 13:00-18:30 \"Espaces Adultes et Musique & Cinéma\";We 10:00-12:30,14:00-18:30 \"Espaces Adultes et Musique & Cinéma\";Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes et Musique & Cinéma\";"))).to eql("Mo,Th,Su off \"Espaces Adultes et Musique & Cinéma\"; Tu,Fr 13:00-18:30 \"Espaces Adultes et Musique & Cinéma\"; We 10:00-12:30,14:00-18:30 \"Espaces Adultes et Musique & Cinéma\"; Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes et Musique & Cinéma\"")
  end

  it "We 14:30-18:00;Sa 10:00-12:00;Su-Tu off;Th,Fr off;Oct 21-Nov 06 Mo-Su off \"Vacances de la Toussaint\";Dec 23-Jan 08 Mo-Su off \"Vacances de Noël\";Feb 24-Mar 12 Mo-Su off \"Vacances d'hiver\";Apr 21-May 07 Mo-Su off \"Vacances de printemps\";Jul 07-Sep 04 Mo-Su off \"Vacances d'été\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("We 14:30-18:00;Sa 10:00-12:00;Su-Tu off;Th,Fr off;Oct 21-Nov 06 Mo-Su off \"Vacances de la Toussaint\";Dec 23-Jan 08 Mo-Su off \"Vacances de Noël\";Feb 24-Mar 12 Mo-Su off \"Vacances d'hiver\";Apr 21-May 07 Mo-Su off \"Vacances de printemps\";Jul 07-Sep 04 Mo-Su off \"Vacances d'été\";"))).to eql("Su-Tu,Th,Fr off; We 14:30-18:00; Sa 10:00-12:00; Oct 21-Nov 06 off \"Vacances de la Toussaint\"; Dec 23-Jan 08 off \"Vacances de Noël\"; Feb 24-Mar 12 off \"Vacances d'hiver\"; Apr 21-May 07 off \"Vacances de printemps\"; Jul 07-Sep 04 off \"Vacances d'été\"")
  end

  it "Mo,Th,Fr,Sa,Su off; Tu 16:00-19:00, We 14:30-18:30; Oct 21-Nov 03 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacances de la Toussaint\"; Feb 24-Mar 12 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacances d'hiver\"; Apr 21-May 07 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacances de printemps\"; Dec 23-Jan 08 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacancs de Noël\"; Jul 07-Sep 04 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacances d'été\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Th,Fr,Sa,Su off; Tu 16:00-19:00, We 14:30-18:30; Oct 21-Nov 03 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacances de la Toussaint\"; Feb 24-Mar 12 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacances d'hiver\"; Apr 21-May 07 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacances de printemps\"; Dec 23-Jan 08 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacancs de Noël\"; Jul 07-Sep 04 Tu 16:30-18:30,Mo,We,Th,Fr,Sa,Su off \"Vacances d'été\";"))).to eql("Th-Mo off; Tu 16:00-19:00; We 14:30-18:30; Oct 21-Nov 03 We-Mo off \"Vacances de la Toussaint\"; Oct 21-Nov 03 Tu 16:30-18:30 \"Vacances de la Toussaint\"; Feb 24-Mar 12 We-Mo off \"Vacances d'hiver\"; Feb 24-Mar 12 Tu 16:30-18:30 \"Vacances d'hiver\"; Apr 21-May 07 We-Mo off \"Vacances de printemps\"; Apr 21-May 07 Tu 16:30-18:30 \"Vacances de printemps\"; Dec 23-Jan 08 We-Mo off \"Vacancs de Noël\"; Dec 23-Jan 08 Tu 16:30-18:30 \"Vacancs de Noël\"; Jul 07-Sep 04 We-Mo off \"Vacances d'été\"; Jul 07-Sep 04 Tu 16:30-18:30 \"Vacances d'été\"")
  end

  it "Sa,Su off;Mo-Fr 16:00-18:00;Sa 10:00-12:00;Oct 21-Nov 06 We 16:00-18:00 \"Vacances de la Toussaint\"; Oct 21-Nov 06 Sa 10:00-12:00 \"Vacances de la Toussaint\"; Oct 21-Nov 06 Su,Mo,Tu,Th,Fr off \"Vacances de la Toussaint\";Dec 23-Jan 08 We 16:00-18:00 \"Vacances de Noël\"; Dec 23-Jan 08 Sa 10:00-12:00 \"Vacances de Noël\"; Dec 23-Jan 08 Su,Mo,Tu,Th,Fr off \"Vacances de Noël\";Feb 24-Mar 12 We 16:00-18:00 \"Vacances d'hiver\";Feb 24-Mar 12 Sa 10:00-12:00 \"Vacances d'hiver\";Feb 24-Mar 12 Su,Mo,Tu,Th,Fr off \"Vacances d'hiver\";Apr 21-May 07 We 16:00-18:00 \"Vacances de printemps\";Apr 21-May 07 Sa 10:00-12:00 \"Vacances de printemps\";Apr 21-May 07 Su,Mo,Tu,Th,Fr off  \"Vacances de printemps\"; Jul 07-Sep 04 We 16:00-18:00 \"Vacances d'été\";Jul 07-Sep 04 Sa 10:00-12:00 \"Vacances d'été\";Jul 07-Sep 04 Su,Mo,Tu,Th,Fr off \"Vacances d'été\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Sa,Su off;Mo-Fr 16:00-18:00;Sa 10:00-12:00;Oct 21-Nov 06 We 16:00-18:00 \"Vacances de la Toussaint\"; Oct 21-Nov 06 Sa 10:00-12:00 \"Vacances de la Toussaint\"; Oct 21-Nov 06 Su,Mo,Tu,Th,Fr off \"Vacances de la Toussaint\";Dec 23-Jan 08 We 16:00-18:00 \"Vacances de Noël\"; Dec 23-Jan 08 Sa 10:00-12:00 \"Vacances de Noël\"; Dec 23-Jan 08 Su,Mo,Tu,Th,Fr off \"Vacances de Noël\";Feb 24-Mar 12 We 16:00-18:00 \"Vacances d'hiver\";Feb 24-Mar 12 Sa 10:00-12:00 \"Vacances d'hiver\";Feb 24-Mar 12 Su,Mo,Tu,Th,Fr off \"Vacances d'hiver\";Apr 21-May 07 We 16:00-18:00 \"Vacances de printemps\";Apr 21-May 07 Sa 10:00-12:00 \"Vacances de printemps\";Apr 21-May 07 Su,Mo,Tu,Th,Fr off  \"Vacances de printemps\"; Jul 07-Sep 04 We 16:00-18:00 \"Vacances d'été\";Jul 07-Sep 04 Sa 10:00-12:00 \"Vacances d'été\";Jul 07-Sep 04 Su,Mo,Tu,Th,Fr off \"Vacances d'été\";"))).to eql("Mo-Fr 16:00-18:00; Sa 10:00-12:00; Su off; Oct 21-Nov 06 Su-Tu,Th,Fr off \"Vacances de la Toussaint\"; Oct 21-Nov 06 We 16:00-18:00 \"Vacances de la Toussaint\"; Oct 21-Nov 06 Sa 10:00-12:00 \"Vacances de la Toussaint\"; Dec 23-Jan 08 Su-Tu,Th,Fr off \"Vacances de Noël\"; Dec 23-Jan 08 We 16:00-18:00 \"Vacances de Noël\"; Dec 23-Jan 08 Sa 10:00-12:00 \"Vacances de Noël\"; Feb 24-Mar 12 Su-Tu,Th,Fr off \"Vacances d'hiver\"; Feb 24-Mar 12 We 16:00-18:00 \"Vacances d'hiver\"; Feb 24-Mar 12 Sa 10:00-12:00 \"Vacances d'hiver\"; Apr 21-May 07 Su-Tu,Th,Fr off \"Vacances de printemps\"; Apr 21-May 07 We 16:00-18:00 \"Vacances de printemps\"; Apr 21-May 07 Sa 10:00-12:00 \"Vacances de printemps\"; Jul 07-Sep 04 Su-Tu,Th,Fr off \"Vacances d'été\"; Jul 07-Sep 04 We 16:00-18:00 \"Vacances d'été\"; Jul 07-Sep 04 Sa 10:00-12:00 \"Vacances d'été\"")
  end

  it "Mo,Fr 14:00-18:00;Tu,Sa 10:00-13:00;We 10:00-13:00,14:00-18:00;Th,Su off;" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Fr 14:00-18:00;Tu,Sa 10:00-13:00;We 10:00-13:00,14:00-18:00;Th,Su off;"))).to eql("Mo,Fr 14:00-18:00; Tu,Sa 10:00-13:00; We 10:00-13:00,14:00-18:00; Th,Su off")
  end

  it "Tu 15:30-18:00;We 10:00-12:00,14:30-18:00;Fr 16:00-18:00;Sa 10:00-12:30;" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Tu 15:30-18:00;We 10:00-12:00,14:30-18:00;Fr 16:00-18:00;Sa 10:00-12:30;"))).to eql("Tu 15:30-18:00; We 10:00-12:00,14:30-18:00; Fr 16:00-18:00; Sa 10:00-12:30")
  end

  it "Su,Mo off  \"Espaces Adultes et Musique & Cinéma\";Tu,We 10:00-18:30  \"Espaces Adultes et Musique & Cinéma\";Th 9:00-13:00  \"Espaces Adultes et Musique & Cinéma\";Fr 13:00-18:30,Sa 10:00-18:00  \"Espaces Adultes et Musique & Cinéma\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Su,Mo off  \"Espaces Adultes et Musique & Cinéma\";Tu,We 10:00-18:30  \"Espaces Adultes et Musique & Cinéma\";Th 9:00-13:00  \"Espaces Adultes et Musique & Cinéma\";Fr 13:00-18:30,Sa 10:00-18:00  \"Espaces Adultes et Musique & Cinéma\";"))).to eql("Mo,Su off \"Espaces Adultes et Musique & Cinéma\"; Tu,We 10:00-18:30 \"Espaces Adultes et Musique & Cinéma\"; Th 09:00-13:00 \"Espaces Adultes et Musique & Cinéma\"; Fr 13:00-18:30 \"Espaces Adultes et Musique & Cinéma\"; Sa 10:00-18:00 \"Espaces Adultes et Musique & Cinéma\"")
  end

  it "Tu,Fr 16:00-18:30 \"Espace Jeunesse\";We 10:00-12:30,14:00-18:30 \"Espace Jeunesse\";Sa 10:00-12:30,14:00-18:00 \"Espace Jeunesse\";Th,Su,Mo off \"Espace Jeunesse\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Tu,Fr 16:00-18:30 \"Espace Jeunesse\";We 10:00-12:30,14:00-18:30 \"Espace Jeunesse\";Sa 10:00-12:30,14:00-18:00 \"Espace Jeunesse\";Th,Su,Mo off \"Espace Jeunesse\";"))).to eql("Mo,Th,Su off \"Espace Jeunesse\"; Tu,Fr 16:00-18:30 \"Espace Jeunesse\"; We 10:00-12:30,14:00-18:30 \"Espace Jeunesse\"; Sa 10:00-12:30,14:00-18:00 \"Espace Jeunesse\"")
  end

  it "Mo,Th,Su off;Tu,Fr 13:30-18:00 \"Espaces Adultes et Jeunesse\"; We 10:00-12:30,14:00-18:30 \"Espaces Adultes et Jeunesse\";Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes et Jeunesse\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo,Th,Su off;Tu,Fr 13:30-18:00 \"Espaces Adultes et Jeunesse\"; We 10:00-12:30,14:00-18:30 \"Espaces Adultes et Jeunesse\";Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes et Jeunesse\";"))).to eql("Mo,Th,Su off; Tu,Fr 13:30-18:00 \"Espaces Adultes et Jeunesse\"; We 10:00-12:30,14:00-18:30 \"Espaces Adultes et Jeunesse\"; Sa 10:00-12:30,14:00-18:00 \"Espaces Adultes et Jeunesse\"")
  end

  it "Th,Fr,Sa,Su off; Mo,Tu 16:30-18:00; We 10:00-12:30,14:30-18:00; Oct 21-Nov 06 We 14:30-18:00,Mo,Tu,Th,Fr,Sa,Su off \"Vacances de la Toussaint\"; Feb 24-Mar 12 We 14:30-18:00,Mo,Tu,Th,Fr,Sa,Su off  \"Vacances d'hiver\"; Apr 21-May 07 We 14:30-18:00,Mo,Tu,Th,Fr,Sa,Su off  \"Vacances de printemps\"; Dec 23-Jan 08 off \"Vacances de Noël\";Jul 07-Sep 04 off \"Vacances d'été\";" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Th,Fr,Sa,Su off; Mo,Tu 16:30-18:00; We 10:00-12:30,14:30-18:00; Oct 21-Nov 06 We 14:30-18:00,Mo,Tu,Th,Fr,Sa,Su off \"Vacances de la Toussaint\"; Feb 24-Mar 12 We 14:30-18:00,Mo,Tu,Th,Fr,Sa,Su off  \"Vacances d'hiver\"; Apr 21-May 07 We 14:30-18:00,Mo,Tu,Th,Fr,Sa,Su off  \"Vacances de printemps\"; Dec 23-Jan 08 off \"Vacances de Noël\";Jul 07-Sep 04 off \"Vacances d'été\";"))).to eql("Mo,Tu 16:30-18:00; We 10:00-12:30,14:30-18:00; Th-Su off; Oct 21-Nov 06 Th-Tu off \"Vacances de la Toussaint\"; Oct 21-Nov 06 We 14:30-18:00 \"Vacances de la Toussaint\"; Feb 24-Mar 12 Th-Tu off \"Vacances d'hiver\"; Feb 24-Mar 12 We 14:30-18:00 \"Vacances d'hiver\"; Apr 21-May 07 Th-Tu off \"Vacances de printemps\"; Apr 21-May 07 We 14:30-18:00 \"Vacances de printemps\"; Dec 23-Jan 08 off \"Vacances de Noël\"; Jul 07-Sep 04 off \"Vacances d'été\"")
  end

  it "Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; Sa 09:00-12:00; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"; 2017 Dec 24-25 Su 09:00-24:00 \"Pharmacie de garde\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; Sa 09:00-12:00; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"; 2017 Dec 24-25 Su 09:00-24:00 \"Pharmacie de garde\""))).to eql("Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; Sa 09:00-12:00; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"; 2017 Dec 24-25 Su 09:00-24:00 \"Pharmacie de garde\"")
  end

  it "Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; Sa 09:00-12:00; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\""))).to eql("Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; Sa 09:00-12:00; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"")
  end

  it "Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; Sa 09:00-12:00; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; Sa 09:00-12:00; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30"))).to eql("Mo 14:30-19:30; Tu-Fr 09:00-12:30,14:30-19:30; Sa 09:00-12:00; 2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30")
  end

  it "2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"; 2017 Dec 24-25 Su 09:00-24:00 \"Pharmacie de garde\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"; 2017 Dec 24-25 Su 09:00-24:00 \"Pharmacie de garde\""))).to eql("2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"; 2017 Dec 24-25 Su 09:00-24:00 \"Pharmacie de garde\"")
  end

  it "2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\""))).to eql("2017 Dec 24-25 Mo 00:00-09:00,14:30-19:30 \"Pharmacie de garde\"")
  end

  it "Su 09:00-12:30, 14:30-19:30, 2017 Dec 24-25 Su 00:00-09:00 \"Pharmacie de garde\"" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Su 09:00-12:30, 14:30-19:30; 2017 Dec 24-25 Su 00:00-09:00 \"Pharmacie de garde\""))).to eql("Su 09:00-12:30,14:30-19:30; 2017 Dec 24-25 Su 00:00-09:00 \"Pharmacie de garde\"")
  end

  it "Mo 10:00-20:00 \"Pharmacie de garde\"; Tu 11:00-20:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Mo 10:00-20:00 \"Pharmacie de garde\"; Tu 11:00-20:00"))).to eql("Mo 10:00-20:00 \"Pharmacie de garde\"; Tu 11:00-20:00")
  end

  it "09:00-12:30; PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("09:00-12:30; PH off"))).to eql("09:00-12:30; PH off")
  end

  it "PH off; Jan 09:00-12:30" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("PH off; Jan 09:00-12:30"))).to eql("PH off; Jan 09:00-12:30")
  end

  it "Dec 25 off; Dec 26 00:00-23:59;" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Dec 25 off; Dec 26 00:00-23:59;"))).to eql("Dec 25 off; Dec 26 00:00-23:59")
  end

  it "week 1 off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("week 1 off;"))).to eql("week 1 off")
  end

  it "week 1 PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("week 1 PH off;"))).to eql("week 1 PH off")
  end

  it "week 1,3 off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("week 1,3 off;"))).to eql("week 1,3 off")
  end

  it "week 1,3 PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("week 1,3 PH off;"))).to eql("week 1,3 PH off")
  end

  it "week 1-3 off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("week 1-3 off;"))).to eql("week 1-3 off")
  end

  it "week 1-3 PH off" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("week 1-3 PH off;"))).to eql("week 1-3 PH off")
  end

  it "2019 Jan 09,Jan 23,Feb 06,Feb 20,Mar 06,Mar 20,Apr 03,Apr 17,May 15,May 29,Jun 12,Jun 26,Jul 10,Jul 24,Aug 07,Aug 21,Sep 04,Sep 18,Oct 02,Oct 16,Oct 30,Nov 13,Nov 27,Dec 11,Dec 25 00:00-23:59" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("2019 Jan 09,Jan 23,Feb 06,Feb 20,Mar 06,Mar 20,Apr 03,Apr 17,May 15,May 29,Jun 12,Jun 26,Jul 10,Jul 24,Aug 07,Aug 21,Sep 04,Sep 18,Oct 02,Oct 16,Oct 30,Nov 13,Nov 27,Dec 11,Dec 25 00:00-23:59"))).to eql("2019 Jan 09,Jan 23,Feb 06,Feb 20,Mar 06,Mar 20,Apr 03,Apr 17,May 15,May 29,Jun 12,Jun 26,Jul 10,Jul 24,Aug 07,Aug 21,Sep 04,Sep 18,Oct 02,Oct 16,Oct 30,Nov 13,Nov 27,Dec 11,Dec 25 00:00-23:59")
  end
  it "Jul-Aug Mo,We,Th 10:00-19:00; Jul-Aug Tu 12:00-21:00; Jul-Aug Fr 11:00-13:30,17:00-21:00; Jul-Aug Sa 10:00-12:00; Jul-Aug Su 08:30-12:00" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Jul-Aug Mo,We,Th 10:00-19:00; Jul-Aug Tu 12:00-21:00; Jul-Aug Fr 11:00-13:30,17:00-21:00; Jul-Aug Sa 10:00-12:00; Jul-Aug Su 08:30-12:00"))).to eql("Jul-Aug Mo,We,Th 10:00-19:00; Jul-Aug Tu 12:00-21:00; Jul-Aug Fr 11:00-13:30,17:00-21:00; Jul-Aug Sa 10:00-12:00; Jul-Aug Su 08:30-12:00")
  end
  # it "Jul 07-Sep 04 PH,We-Mo 10:00-20:00 \"Vacances d'été\"; Jul 07-Sep 04 PH,Tu 10:00-21:00 \"Vacances d'été\"" do
  #   expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse("Jul 07-Sep 04 PH,We-Mo 10:00-20:00 \"Vacances d'été\"; Jul 07-Sep 04 PH,Tu 10:00-21:00 \"Vacances d'été\""))).to eql("Jul 07-Sep 04 PH,We-Mo 10:00-20:00 \"Vacances d'été\"; Jul 07-Sep 04 PH,Tu 10:00-21:00 \"Vacances d'été\"")
  # end
end
