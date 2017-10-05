require 'opening_hours_converter/date_range'

RSpec.describe OpeningHoursConverter::DateRange, '#initialize' do
  it "initialize" do
    expect { OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always) }.to_not raise_error
    expect { OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(15, 16)) }.to_not raise_error
  end
end
RSpec.describe OpeningHoursConverter::DateRange, '#defines_typical' do
  it "defines_typical_day" do
    dr = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(28, 11))
    expect(dr.defines_typical_day?).to be true
    expect(dr.defines_typical_week?).to be false
    dr2 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(28, 11, nil, 29, 12))
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
    dr3 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(28, 11, nil, 28, 11))
    expect(dr3.defines_typical_day?).to be true
    expect(dr3.defines_typical_week?).to be false
  end

  it "defines_typical_week" do
    dr2 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(2))
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
    dr2 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(2, 3))
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
    dr2 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always)
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
  end
end
RSpec.describe OpeningHoursConverter::DateRange, '#update_range' do
  it "update_range" do
    dr = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(28, 11))

    st1 = dr.wide_interval.start
    expect(st1[:day]).to eql(28)
    expect(st1[:month]).to eql(11)
    end1 = dr.wide_interval.end
    expect(end1.nil?).to be true

    dr.update_range(OpeningHoursConverter::WideInterval.new.month(5, nil, 10))
    st2 = dr.wide_interval.start
    expect(st2[:month]).to eql(5)
    expect(st2[:day].nil?).to be true
    end2 = dr.wide_interval.end
    expect(end2[:month]).to eql(10)
  end
end

RSpec.describe OpeningHoursConverter::DateRange, '#is_general_for?' do
  before(:all) do
    @dr_november_28 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(28, 11))
    @dr_november_28_to_29 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(28, 11, nil, 29, 11))
    @dr_november_27_to_29 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(27, 11, nil, 29, 11))
    @dr_november_27_to_december_29 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(27, 11, nil, 29, 12))
    @dr_november = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(11))
    @dr_always = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always)

    @dr_2017 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.year(2017))

    @dr_october_15_to_november_15 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 10, nil, 15, 11))
    @dr_october_20_to_november_10 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(20, 10, nil, 10, 11))
    @dr_october_10_to_november_15 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(10, 10, nil, 15, 11))
    @dr_october_15_to_november_20 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 10, nil, 20, 11))

    @dr_october_15 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 10))
    @dr_october_20 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 10))
    @dr_november_15 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(15, 11))
    @dr_november_10 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.day(10, 11))

    @dr_september = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(9))
    @dr_october = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(10))
    @dr_november = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(11))
    @dr_september_to_november = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(9,nil,11))
    @dr_august_to_october = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(8,nil,10))
    @dr_october_to_december = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(10,nil,12))
    @dr_september_to_october = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(9,nil,10))
  end

  it "one day is general for nothing" do
    expect(@dr_november_28.is_general_for?(@dr_november_28)).to be false
    expect(@dr_november_28.is_general_for?(@dr_november_28_to_29)).to be false
    expect(@dr_november_28.is_general_for?(@dr_november_27_to_29)).to be false
    expect(@dr_november_28.is_general_for?(@dr_november)).to be false
    expect(@dr_november_28.is_general_for?(@dr_always)).to be false
    # TODO test with years
  end
  it "one month is general for some days" do
    expect(@dr_november.is_general_for?(@dr_november_28)).to be false
    expect(@dr_november.is_general_for?(@dr_november_28_to_29)).to be true
    expect(@dr_november.is_general_for?(@dr_november_27_to_december_29)).to be false
    expect(@dr_november.is_general_for?(@dr_november)).to be false
    expect(@dr_november.is_general_for?(@dr_always)).to be false
    # TODO test with years
  end

  it "several days are general for some days" do
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_october_15_to_november_15)).to be false
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_october_20_to_november_10)).to be true
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_october_15)).to be false
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_october_20)).to be false
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_november_15)).to be false
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_november_10)).to be false
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_october_10_to_november_15)).to be false
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_october_15_to_november_20)).to be false
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_november)).to be false
    expect(@dr_october_15_to_november_15.is_general_for?(@dr_always)).to be false
  end

  it "several months are general for some days and some months" do
    expect(@dr_september_to_november.is_general_for?(@dr_september_to_november)).to be false
    expect(@dr_september_to_november.is_general_for?(@dr_september)).to be true
    expect(@dr_september_to_november.is_general_for?(@dr_october)).to be true
    expect(@dr_september_to_november.is_general_for?(@dr_september_to_october)).to be true
    expect(@dr_september_to_november.is_general_for?(@dr_october_15_to_november_15)).to be true
    expect(@dr_september_to_november.is_general_for?(@dr_november_10)).to be false
    expect(@dr_september_to_november.is_general_for?(@dr_november_27_to_december_29)).to be false
    expect(@dr_september_to_november.is_general_for?(@dr_august_to_october)).to be false
    expect(@dr_september_to_november.is_general_for?(@dr_october_to_december)).to be false
    expect(@dr_september_to_november.is_general_for?(@dr_2017)).to be false
    expect(@dr_september_to_november.is_general_for?(@dr_always)).to be false
  end

  it "always contains everything" do
    expect(@dr_always.is_general_for?(@dr_october_15_to_november_15)).to be true
    expect(@dr_always.is_general_for?(@dr_november)).to be true
    expect(@dr_always.is_general_for?(@dr_october_to_december)).to be true
    expect(@dr_always.is_general_for?(@dr_2017)).to be true
    expect(@dr_always.is_general_for?(@dr_always)).to be false
  end
end
RSpec.describe OpeningHoursConverter::DateRange, '#has_same_typical?' do
  it "has same typical" do
    dr1 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.always)
    dr2 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(3))
    dr3 = OpeningHoursConverter::DateRange.new(OpeningHoursConverter::WideInterval.new.month(5))

    dr1.typical.add_interval(OpeningHoursConverter::Interval.new(0, 42, 1, 60))
    dr2.typical.add_interval(OpeningHoursConverter::Interval.new(0, 42, 1, 60))
    dr3.typical.add_interval(OpeningHoursConverter::Interval.new(0, 42, 1, 60))

    expect(dr1.has_same_typical?(dr2)).to be true
    expect(dr1.has_same_typical?(dr3)).to be true
  end
end
