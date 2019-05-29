require 'opening_hours_converter'

RSpec.describe OpeningHoursConverter::OpeningHoursBuilder, '#build' do
  it "void" do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build([])).to eql("")
  end
  it "Su 08:00-23:59" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 23*60+59))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Su 08:00-23:59")
  end

  it "Su 23:59-24:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 23*60+59, 6, 24*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Su 23:59-24:00")
  end
  it "Su 24:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 24*60, 6, 24*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Su 24:00")
  end
  it "Su 08:00-24:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 24*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Su 08:00-24:00")
  end
  it "Su 08:00-10:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 10*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Su 08:00-10:00")
  end
  it "Mo 08:00-10:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 10*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo 08:00-10:00")
  end
  it "Mo,We 08:00-10:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 10*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 10*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo,We 08:00-10:00")
  end
  it "Mo-We 08:00-10:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 10*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 10*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 10*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo-We 08:00-10:00")
  end
  it "Mo-We 08:00-10:00; Sa,Su 07:00-13:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 10*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 10*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 10*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 7*60, 5, 13*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 7*60, 6,  13*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo-We 08:00-10:00; Sa,Su 07:00-13:00")
  end
  it "Mo,Tu 23:00-03:00 continuous" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 23*60, 1, 3*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 23*60, 2, 3*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo 23:00-24:00; Tu 00:00-03:00,23:00-24:00; We 00:00-03:00")
  end
  it "Mo,Tu 23:00-03:00 following" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 23*60, 0, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 0, 1, 3*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 23*60, 1, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 0, 2, 3*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo 23:00-24:00; Tu 00:00-03:00,23:00-24:00; We 00:00-03:00")
  end
  it "Mo,Su 23:00-03:00 following" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 23*60, 0, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 0, 1, 3*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 23*60, 6, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 0, 3*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo 00:00-03:00,23:00-24:00; Tu 00:00-03:00; Su 23:00-24:00")
  end
  it "Mo 8:00-10:00 merging" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 10*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 9*60, 0, 10*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo 08:00-10:00")
  end
  it "Mo 08:00-24:00; Tu 00:00-09:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 1, 9*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo 08:00-24:00; Tu 00:00-09:00")
  end
  it "08:00-18:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 8*60, 3, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 8*60, 5, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("08:00-18:00")
  end
  it "24/7 continuous" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 6, 24*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("24/7")
  end
  it "24/7 following" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 0, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 0, 1, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 0, 2, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 0, 3, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 0, 4, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 0, 5, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 0, 6, 24*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("24/7")
  end
  it "24/7; Jun 08:00-18:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 6, 24*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(3, 8*60, 3, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(5, 8*60, 5, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("24/7; Jun 08:00-18:00")
  end
  it "24/7; Jun 08:00-18:00; We off" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 6, 24*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(3, 8*60, 3, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(5, 8*60, 5, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("24/7; Jun 08:00-18:00; Jun We off")
  end
  it "Th-Tu 08:00-18:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 8*60, 3, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 8*60, 5, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Th-Tu 08:00-18:00")
  end
  it "24/7; Jun Mo-We 08:00-18:00; Jun Th-Su off" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 6, 24*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 18*60))


    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("24/7; Jun Mo-We 08:00-18:00; Jun Th-Su off")
  end
  it "24/7; Jun-Aug Mo-We 08:00-18:00; Jun-Aug Th-Su off" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6, nil, 8)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 6, 24*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 18*60))


    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("24/7; Jun-Aug Mo-We 08:00-18:00; Jun-Aug Th-Su off")
  end
  it "Sa-We 05:00-07:00; Th,Fr 00:00-24:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 5*60, 0, 7*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 5*60, 1, 7*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 5*60, 2, 7*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 0, 3, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 0, 4, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 5*60, 5, 7*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 5*60, 6, 7*60))


    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Sa-We 05:00-07:00; Th,Fr 00:00-24:00")
  end
  it "Mo,Tu,Th,Fr 01:00-02:00; Jun We 02:00-03:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 1*60, 0, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 1*60, 1, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 1*60, 3, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 1*60, 4, 2*60))

    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 1*60, 0, 2*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 1*60, 1, 2*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(2, 2*60, 2, 3*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(3, 1*60, 3, 2*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(4, 1*60, 4, 2*60))


    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo,Tu,Th,Fr 01:00-02:00; Jun We 02:00-03:00")
  end
  it "01:00-02:00; Jun Th 02:00-03:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 1*60, 0, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 1*60, 1, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 1*60, 2, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 1*60, 3, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 1*60, 4, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 1*60, 5, 2*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 1*60, 6, 2*60))

    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 1*60, 0, 2*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 1*60, 1, 2*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(2, 1*60, 2, 2*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(3, 2*60, 3, 3*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(4, 1*60, 4, 2*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(5, 1*60, 5, 2*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(6, 1*60, 6, 2*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("01:00-02:00; Jun Th 02:00-03:00")
  end
  it "Tu,Su 23:00-01:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 23*60, 2, 1*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 23*60, 6, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 0, 1*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo,We 00:00-01:00; Tu,Su 23:00-24:00")
  end
  it "08:00-18:00; Aug off" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(8)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 8*60, 3, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 8*60, 5, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("08:00-18:00; Aug off")
  end
  it "2017 08:00-18:00; Aug off" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.year(2017)), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(8, 2017)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 8*60, 2, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 8*60, 3, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 8*60, 5, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 8*60, 6, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 08:00-18:00; 2017 Aug 01-31 off")
  end
  it "Mo-Fr 00:00-24:00; Aug-Sep Sa 00:00-24:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(8,nil,9)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 4, 24*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0, 5, 24*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo-Fr 00:00-24:00; Aug-Sep Sa 00:00-24:00")
  end
  it "May-Jun,Sep 14:00-18:00 (month factoring)" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(5,nil,6)), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(9)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 14*60, 1, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 14*60, 2, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 14*60, 3, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 14*60, 4, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 14*60, 5, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 14*60, 6, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 14*60, 1, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(2, 14*60, 2, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(3, 14*60, 3, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(4, 14*60, 4, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(5, 14*60, 5, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(6, 14*60, 6, 18*60))


    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("May-Jun,Sep 14:00-18:00")
  end
  it "Jan 01-May 01,May 15-Oct 12 Mo,Fr 08:00-18:00 (day factoring)" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(1,1,nil,1,5)),
      OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15,5,nil,12,10)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Jan 01-May 01,May 15-Oct 12 Mo,Fr 08:00-18:00")
  end
  it "Mo-We 03:00-05:00; Jan 01-10,Feb 01-10 Tu off (off day factoring)" do
    dr = [ OpeningHoursConverter::DateRange.new, OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(1,1,nil,10,1)), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(1,2,nil,10,2)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 3*60, 0, 5*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 3*60, 1, 5*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 3*60, 2, 5*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 3*60, 0, 5*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(2, 3*60, 2, 5*60))
    dr[2].typical.add_interval(OpeningHoursConverter::Interval.new(0, 3*60, 0, 5*60))
    dr[2].typical.add_interval(OpeningHoursConverter::Interval.new(2, 3*60, 2, 5*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo-We 03:00-05:00; Jan 01-10,Feb 01-10 Tu off")
  end
  it "Tu,Su 10:00-12:00; Jun Tu,Su off; Jun We,Sa 10:00-12:00 (off day factoring)" do
    dr = [ OpeningHoursConverter::DateRange.new, OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 10*60, 1, 12*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 10*60, 6, 12*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(2, 10*60, 2, 12*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(5, 10*60, 5, 12*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Tu,Su 10:00-12:00; Jun Tu,Su off; Jun We,Sa 10:00-12:00")
  end

  it "2017 Mo 14:00-18:00 (year general month & day factoring)" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.year(2017)), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6, 2017)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Mo 14:00-18:00")
  end

  it "2017 Mo 14:00-18:00 (year general month & day factoring)" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(6, 2017)), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.year(2017)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Mo 14:00-18:00")
  end
  ######################################
  it "May-Jun,Sep Mo,Tu 14:00-18:00 (month factoring)" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(5,nil,6)), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(9)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 14*60, 1, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 14*60, 1, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("May-Jun,Sep Mo,Tu 14:00-18:00")
  end
  it "May-Sep Mo,Tu 14:00-18:00 (month factoring)" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(5,nil,8)), OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(9)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 14*60, 1, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(0, 14*60, 0, 18*60))
    dr[1].typical.add_interval(OpeningHoursConverter::Interval.new(1, 14*60, 1, 18*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("May-Sep Mo,Tu 14:00-18:00")
  end
  it "2017 Dec 31 08:30-12:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(31,12,2017)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 510, 0, 720))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 510, 1, 720))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 510, 2, 720))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 510, 3, 720))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 510, 4, 720))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 510, 5, 720))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 510, 6, 720))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Dec 31 08:30-12:00")
  end
  it "Dec 31 08:30-12:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(31,12)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 510, 0, 720))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Dec 31 08:30-12:00")
  end
  it "Jan 01 08:30-12:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(1,1)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 510, 0, 720))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Jan 01 08:30-12:00")
  end
  it "Dec 10 08:30-12:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(10,12)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 510, 0, 720))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Dec 10 08:30-12:00")
  end


  it "12:00-14:00; We-Sa off (continuous week end)" do
    dr = [ OpeningHoursConverter::DateRange.new ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 12*60, 0, 14*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 12*60, 1, 14*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 12*60, 6, 14*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Su-Tu 12:00-14:00")
  end
  it "Tu 00:00-24:00" do
    dr = [ OpeningHoursConverter::DateRange.new ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 0, 1, 24*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Tu 00:00-24:00")
  end
  it "Tu,Th,Fr 08:00-12:00" do
    dr = [ OpeningHoursConverter::DateRange.new ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 8*60, 1, 12*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 8*60, 3, 12*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 8*60, 4, 12*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Tu,Th,Fr 08:00-12:00")
  end
  it "Tu-Fr 18:00-19:00; Sa 18:00-22:00; Th off" do
    dr = [ OpeningHoursConverter::DateRange.new ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 18*60, 1, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 18*60, 2, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 18*60, 4, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 18*60, 5, 22*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Tu,We,Fr 18:00-19:00; Sa 18:00-22:00")
  end
  it "over midnight override" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 0*60, 0, 1*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 18*60, 1, 1*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 18*60, 2, 1*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 18*60, 3, 1*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 18*60, 5, 4*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 18*60, 6, 4*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 18*60, 6, 24*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 10*60, 3, 20*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo-We 00:00-01:00,18:00-24:00; Th 00:00-01:00,10:00-20:00; Fr 18:00-24:00; Sa,Su 00:00-04:00,18:00-24:00")
  end
  it "two years dr" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 12, 2017, 15, 1, 2018)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 10*60, 0, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 10*60, 1, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 10*60, 2, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 10*60, 3, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 10*60, 4, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 10*60, 5, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 10*60, 6, 19*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Dec 15-2018 Jan 15 10:00-19:00")
  end
  it "two years dr" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 12, 2017, 15, 1, 2018)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 10*60, 0, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 10*60, 2, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 10*60, 3, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 10*60, 4, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(5, 10*60, 5, 19*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 10*60, 6, 19*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Dec 15-2018 Jan 15 We-Mo 10:00-19:00")
  end
  it "two years dr over night su-mo" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 12, 2017, 15, 1, 2018)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 10*60, 1, 3*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(6, 10*60, 0, 3*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Dec 15-2018 Jan 15 Mo 00:00-03:00,10:00-24:00; 2017 Dec 15-2018 Jan 15 Tu 00:00-03:00; 2017 Dec 15-2018 Jan 15 Su 10:00-24:00")
  end
  it "two years dr over night Tu-Fr" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 12, 2017, 15, 1, 2018)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 10*60, 2, 3*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 10*60, 3, 3*60))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(3, 10*60, 4, 3*60))
    # dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(4, 10*60, 0, 3*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Dec 15-2018 Jan 15 Tu 10:00-24:00; 2017 Dec 15-2018 Jan 15 We,Th 00:00-03:00,10:00-24:00; 2017 Dec 15-2018 Jan 15 Fr 00:00-03:00")
  end
  it "multiple years, same month" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 12, 2017, 18, 12, 2028)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 10*60, 1, 13*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Dec 15-2028 Dec 18 Tu 10:00-13:00")
  end
  it "multiple years, same month, start month and end month" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(1, 12, 2017, 31, 12, 2028)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 10*60, 1, 13*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Dec 01-2028 Dec 31 Tu 10:00-13:00")
  end
  it "multiple years, same month, start month and end month feb" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(1, 2, 2017, 28, 2, 2028)) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 10*60, 1, 13*60))

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Feb 01-2028 Feb 28 Tu 10:00-13:00")
  end
  it "multiple years, same month, start month and end month feb off" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(1, 2, 2017, 28, 2, 2028)) ]

    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("2017 Feb 01-2028 Feb 28 off")
  end

  it "Mo 08:00-23:59, Tu 00:00-23:59, We 00:00-10:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 23*60+59))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 0*60, 1, 23*60+59))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 0*60, 2, 10*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo 08:00-23:59; Tu 00:00-23:59; We 00:00-10:00")
  end

  it "Mo 08:00-23:59, Tu off, We 00:00-10:00" do
    dr = [ OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) ]
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(0, 8*60, 0, 23*60+59))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(1, 0*60, 1, 23*60+59, true))
    dr[0].typical.add_interval(OpeningHoursConverter::Interval.new(2, 0*60, 2, 10*60))
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(dr)).to eql("Mo 08:00-23:59; Tu off; We 00:00-10:00")
  end
end


