require 'opening_hour_converter'

RSpec.describe Week, '#initialize' do
  it "initialize" do
    expect { Week.new }.to_not raise_error
  end
end
RSpec.describe Week, '#get_as_minute_array' do
  it "has the right length" do
    d = Week.new
    minutes = d.get_as_minute_array
    expect(minutes.length).to eql(7)
    expect(minutes[0].length).to eql(24*60+1)
  end

  it "has the right values" do
    d = Week.new
    d.add_interval(Interval.new(0, 60, 0, 120))
    minutes = d.get_as_minute_array
    for d in 0..6
      for m in 0..(24*60)
        if d == 0 && m >= 60 && m <= 120
          expect(minutes[d][m]).to be true
        else
          expect(minutes[d][m]).to be false
        end
      end
    end
  end
end

RSpec.describe Week, 'intervals' do
  it "raw" do
    d = Week.new
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
    d = Week.new
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
    d = Week.new
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
    d1 = Week.new
    it1 = Interval.new(0, 60, 0, 120)
    it2 = Interval.new(0, 240, 0, 300)

    itId1 = d1.add_interval(it1)
    itId2 = d1.add_interval(it2)

    d2 = Week.new
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
    d = Week.new
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
    d = Week.new
    d1 = Week.new
    it1 = Interval.new(0, 60, 0, 120)
    it2 = Interval.new(1, 120, 2, 300)
    it3 = Interval.new(3, 660, 3, 720)

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

  it "gets interval diff" do
    w = Week.new
    w1 = Week.new

    it1 = Interval.new(0, 0, 6, 24*60)
    w.add_interval(it1)

    it2 = Interval.new(0, 0, 3, 24*60)
    it3 = Interval.new(5, 0, 6, 24*60)
    it4 = Interval.new(4, 8*60, 4, 18*60)

    w1.add_interval(it2)
    w1.add_interval(it3)
    w1.add_interval(it4)

    result = w1.get_intervals_diff(w)
    puts result.inspect
    expect(result[:open].length).to eql(1)
    expect(result[:closed].length).to eql(0)
  end
end
