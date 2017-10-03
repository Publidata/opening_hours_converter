require 'opening_hours_converter/day'

RSpec.describe Day, '#initialize' do
  it "initialize" do
    expect { Day.new }.to_not raise_error
  end
end
RSpec.describe Day, '#get_as_minute_array' do
  it "has the right length" do
    d = Day.new
    minutes = d.get_as_minute_array
    expect(minutes.length).to eql(24*60+1)
  end
  it "has the right values" do
    d = Day.new
    d.add_interval(Interval.new(0, 60, 0, 120))
    minutes = d.get_as_minute_array
    for m in 0..(24*60)
      if m >= 60 && m <= 120
        expect(minutes[m]).to be true
      else
        expect(minutes[m]).to be false
      end
    end
  end
end

RSpec.describe Day, 'intervals' do
  it "raw" do
    d = Day.new
    it1 = Interval.new(0, 60, 0, 120)
    it2 = Interval.new(0, 360, 0, 420)
    it3 = Interval.new(0, 660, 0, 720)

    itId1 = d.add_interval(it1)
    itId2 = d.add_interval(it2)
    itId3 = d.add_interval(it3)

    intervals = d.get_intervals
    expect(intervals[itId1]).to eql(it1)
    expect(intervals[itId2]).to eql(it2)
    expect(intervals[itId3]).to eql(it3)

    d.remove_interval(itId2)
    intervals = d.get_intervals
    expect(intervals[itId1]).to eql(it1)
    expect(intervals[itId2]).to be nil
    expect(intervals[itId3]).to eql(it3)
  end

  it "cleaned" do
    d = Day.new
    it1 = Interval.new(0, 60, 0, 120)
    it2 = Interval.new(0, 120, 0, 300)
    it3 = Interval.new(0, 660, 0, 720)

    itId1 = d.add_interval(it1)
    itId2 = d.add_interval(it2)
    itId3 = d.add_interval(it3)

    intervals = d.get_intervals(true)

    expect(intervals.length).to eql(2)
    expect(intervals[0].day_start).to eql(0)
    expect(intervals[0].day_end).to eql(0)
    expect(intervals[0].start).to eql(60)
    expect(intervals[0].end).to eql(300)

    expect(intervals[1].day_start).to eql(0)
    expect(intervals[1].day_end).to eql(0)
    expect(intervals[1].start).to eql(660)
    expect(intervals[1].end).to eql(720)

    d.remove_interval(itId2)

    intervals = d.get_intervals(true)

    expect(intervals.length).to eql(2)
    expect(intervals[0].day_start).to eql(0)
    expect(intervals[0].day_end).to eql(0)
    expect(intervals[0].start).to eql(60)
    expect(intervals[0].end).to eql(120)

    expect(intervals[1].day_start).to eql(0)
    expect(intervals[1].day_end).to eql(0)
    expect(intervals[1].start).to eql(660)
    expect(intervals[1].end).to eql(720)
  end

  it "edit" do
    d = Day.new
    it1 = Interval.new(0, 60, 0, 120)
    it2 = Interval.new(0, 240, 0, 300)
    it3 = Interval.new(0, 660, 0, 720)

    itId1 = d.add_interval(it1)
    itId2 = d.add_interval(it2)

    d.edit_interval(itId2, it3)

    intervals = d.get_intervals
    expect(intervals[itId1]).to eql(it1)
    expect(intervals[itId2]).to eql(it3)
  end

  it "copy" do
    d1 = Day.new
    it1 = Interval.new(0, 60, 0, 120)
    it2 = Interval.new(0, 240, 0, 300)

    itId1 = d1.add_interval(it1)
    itId2 = d1.add_interval(it2)

    d2 = Day.new
    d2.copy_intervals(d1.get_intervals)
    intervals = d2.get_intervals
    expect(intervals.length).to eql(2)
    expect(intervals[0].day_start).to eql(0)
    expect(intervals[0].day_end).to eql(0)
    expect(intervals[0].start).to eql(60)
    expect(intervals[0].end).to eql(120)

    expect(intervals[1].day_start).to eql(0)
    expect(intervals[1].day_end).to eql(0)
    expect(intervals[1].start).to eql(240)
    expect(intervals[1].end).to eql(300)
  end

  it "clear" do
    d = Day.new
    it1 = Interval.new(0, 60, 0, 120)
    it2 = Interval.new(0, 120, 0, 300)
    it3 = Interval.new(0, 660, 0, 720)

    itId1 = d.add_interval(it1)
    itId2 = d.add_interval(it2)
    itId3 = d.add_interval(it3)

    intervals = d.get_intervals
    expect(intervals.length).to eql(3)
    d.clear_intervals
    intervals = d.get_intervals
    expect(intervals.length).to eql(0)
  end

  it "same as" do
    d = Day.new
    d1 = Day.new
    it1 = Interval.new(0, 60, 0, 120)
    it2 = Interval.new(0, 120, 0, 300)
    it3 = Interval.new(0, 660, 0, 720)

    d.add_interval(it1)
    d1.add_interval(it1)
    d.add_interval(it2)
    d1.add_interval(it2)
    d.add_interval(it3)
    d1.add_interval(it3)

    expect(d.same_as?(d1)).to be true
    expect(d1.same_as?(d)).to be true

    d1.remove_interval(0)
    expect(d.same_as?(d1)).to be false
    expect(d1.same_as?(d)).to be false
  end
end
