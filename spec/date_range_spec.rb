require 'opening_hour_converter'

RSpec.describe DateRange, '#initialize' do
  it "initialize" do
    expect { DateRange.new(WideInterval.new.always) }.to_not raise_error
    expect { DateRange.new(WideInterval.new.week(15, 16)) }.to_not raise_error
  end
end
RSpec.describe DateRange, '#defines_typical' do
  it "defines_typical_day" do
    dr = DateRange.new(WideInterval.new.day(28, 11))
    expect(dr.defines_typical_day?).to be true
    expect(dr.defines_typical_week?).to be false
    dr2 = DateRange.new(WideInterval.new.day(28, 11, 29, 12))
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
    dr3 = DateRange.new(WideInterval.new.day(28, 11, 28, 11))
    expect(dr3.defines_typical_day?).to be true
    expect(dr3.defines_typical_week?).to be false
  end

  it "defines_typical_week" do
    dr = DateRange.new(WideInterval.new.week(28))
    expect(dr.defines_typical_day?).to be false
    expect(dr.defines_typical_week?).to be true
    dr2 = DateRange.new(WideInterval.new.week(28, 28))
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
    dr2 = DateRange.new(WideInterval.new.week(28, 52))
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
    dr2 = DateRange.new(WideInterval.new.month(2))
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
    dr2 = DateRange.new(WideInterval.new.month(2, 3))
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
    dr2 = DateRange.new(WideInterval.new.always)
    expect(dr2.defines_typical_day?).to be false
    expect(dr2.defines_typical_week?).to be true
  end
end
RSpec.describe DateRange, '#update_range' do
  it "update_range" do
    dr = DateRange.new(WideInterval.new.day(28, 11))

    st1 = dr.wide_interval.start
    expect(st1[:day]).to eql(28)
    expect(st1[:month]).to eql(11)
    end1 = dr.wide_interval.end
    expect(end1.nil?).to be true

    dr.update_range(WideInterval.new.week(5, 10))
    st2 = dr.wide_interval.start
    expect(st2[:week]).to eql(5)
    expect(st2[:day].nil?).to be true
    expect(st2[:month].nil?).to be true
    end2 = dr.wide_interval.end
    expect(end2[:week]).to eql(10)
  end
end

RSpec.describe DateRange, '#is_general_for?' do
  it "one day is general for nothing" do
    dr = DateRange.new(WideInterval.new.day(28, 11))

    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 29, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(27, 11, 29, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.always))).to be false
  end
  it "one week is general for nothing" do
    dr = DateRange.new(WideInterval.new.week(28))

    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 29, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(27, 11, 29, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.always))).to be false
  end
  it "one month is general for some days" do
    dr = DateRange.new(WideInterval.new.month(11))

    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 29, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(27, 11, 29, 12)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.always))).to be false
  end

  it "several days are general for some days" do
    dr = DateRange.new(WideInterval.new.day(28, 11, 3, 12))

    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 3, 12)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 29, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 30, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 2, 12)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(29, 11, 3, 12)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(27, 11, 29, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.always))).to be false
  end

  it "several weeks are general for some days" do
    dr = DateRange.new(WideInterval.new.week(28, 52))

    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 3, 12)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 29, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 30, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(27, 11, 29, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(29)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(28, 52)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(28, 51)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(29, 52)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(27, 30)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.always))).to be false
  end

  it "several months are general for some days and some months" do
    dr = DateRange.new(WideInterval.new.month(9, 11))

    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 3, 12)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 29, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 30, 12)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 1, 2, 11)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(27, 11, 29, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(29)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(28, 52)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(27, 30)))).to be false
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(10, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.always))).to be false
  end

  it "always contains everything" do
    dr = DateRange.new(WideInterval.new.always)
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 3, 12)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 29, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 11, 30, 12)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(28, 1, 2, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.day(27, 11, 29, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(29)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(28, 52)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.week(27, 30)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.month(10, 11)))).to be true
    expect(dr.is_general_for?(DateRange.new(WideInterval.new.always))).to be false
  end
end
RSpec.describe DateRange, '#has_same_typical?' do
  it "has same typical" do
    dr1 = DateRange.new(WideInterval.new.always)
    dr2 = DateRange.new(WideInterval.new.month(3))
    dr3 = DateRange.new(WideInterval.new.month(5))

    dr1.typical.add_interval(Interval.new(0, 42, 1, 60))
    dr2.typical.add_interval(Interval.new(0, 42, 1, 60))
    dr3.typical.add_interval(Interval.new(0, 42, 1, 60))

    expect(dr1.has_same_typical?(dr2)).to be true
    expect(dr1.has_same_typical?(dr3)).to be true
  end
end
