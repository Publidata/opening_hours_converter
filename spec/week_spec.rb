require 'opening_hours_converter/week'

RSpec.describe OpeningHoursConverter::Week, '#initialize' do
  it "initialize" do
    expect { OpeningHoursConverter::Week.new }.to_not raise_error
  end
end
RSpec.describe OpeningHoursConverter::Week, '#get_as_minute_array' do
  it "has the right length" do
    d = OpeningHoursConverter::Week.new
    minutes = d.get_as_minute_array
    expect(minutes.length).to eql(7)
    expect(minutes[0].length).to eql(24*60+1)
  end

  it "has the right values" do
    d = OpeningHoursConverter::Week.new
    d.add_interval(OpeningHoursConverter::Interval.new(0, 60, 0, 120))
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

RSpec.describe OpeningHoursConverter::Week, 'intervals' do
  it "raw" do
    d = OpeningHoursConverter::Week.new
    it1 = OpeningHoursConverter::Interval.new(0, 60, 0, 120)
    it2 = OpeningHoursConverter::Interval.new(0, 360, 0, 420)
    it3 = OpeningHoursConverter::Interval.new(0, 660, 0, 720)

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
    d = OpeningHoursConverter::Week.new
    it1 = OpeningHoursConverter::Interval.new(0, 60, 0, 120)
    it2 = OpeningHoursConverter::Interval.new(0, 120, 0, 300)
    it3 = OpeningHoursConverter::Interval.new(0, 660, 0, 720)

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
    d = OpeningHoursConverter::Week.new
    it1 = OpeningHoursConverter::Interval.new(0, 60, 0, 120)
    it2 = OpeningHoursConverter::Interval.new(0, 240, 0, 300)
    it3 = OpeningHoursConverter::Interval.new(0, 660, 0, 720)

    itId1 = d.add_interval(it1)
    itId2 = d.add_interval(it2)

    d.edit_interval(itId2, it3)

    intervals = d.get_intervals
    expect(intervals[itId1]).to eql(it1)
    expect(intervals[itId2]).to eql(it3)
  end

  it "copy" do
    d1 = OpeningHoursConverter::Week.new
    it1 = OpeningHoursConverter::Interval.new(0, 60, 0, 120)
    it2 = OpeningHoursConverter::Interval.new(0, 240, 0, 300)

    itId1 = d1.add_interval(it1)
    itId2 = d1.add_interval(it2)

    d2 = OpeningHoursConverter::Week.new
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
    d = OpeningHoursConverter::Week.new
    it1 = OpeningHoursConverter::Interval.new(0, 60, 0, 120)
    it2 = OpeningHoursConverter::Interval.new(0, 120, 0, 300)
    it3 = OpeningHoursConverter::Interval.new(0, 660, 0, 720)

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
    d = OpeningHoursConverter::Week.new
    d1 = OpeningHoursConverter::Week.new
    it1 = OpeningHoursConverter::Interval.new(0, 60, 0, 120)
    it2 = OpeningHoursConverter::Interval.new(1, 120, 2, 300)
    it3 = OpeningHoursConverter::Interval.new(3, 660, 3, 720)

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

  it "gets interval diff simple" do
    w = OpeningHoursConverter::Week.new
    w1 = OpeningHoursConverter::Week.new

    it1 = OpeningHoursConverter::Interval.new(0, 0, 6, 24*60)
    w.add_interval(it1)

    it2 = OpeningHoursConverter::Interval.new(0, 0, 3, 24*60)
    it3 = OpeningHoursConverter::Interval.new(5, 0, 6, 24*60)
    it4 = OpeningHoursConverter::Interval.new(4, 8*60, 4, 18*60)

    w1.add_interval(it2)
    w1.add_interval(it3)
    w1.add_interval(it4)

    result = w1.get_intervals_diff(w)
    expect(result[:open].length).to eql(1)
    expect(result[:closed].length).to eql(0)
    result2 = w.get_intervals_diff(w1)
    expect(result[:open].length).to eql(1)
    expect(result[:closed].length).to eql(0)

    expect(result[:open][0].day_start).to eql(4)
    expect(result[:open][0].day_end).to eql(4)
    expect(result[:open][0].start).to eql(8*60)
    expect(result[:open][0].end).to eql(18*60)
  end

  it "gets intervals diff day off" do
    w = OpeningHoursConverter::Week.new
    w1 = OpeningHoursConverter::Week.new

    it1 = OpeningHoursConverter::Interval.new(0, 0, 6, 24*60)
    w.add_interval(it1)

    it2 = OpeningHoursConverter::Interval.new(0, 0, 3, 24*60)
    it3 = OpeningHoursConverter::Interval.new(5, 0, 6, 24*60)
    w1.add_interval(it2)
    w1.add_interval(it3)

    result = w1.get_intervals_diff(w)
    expect(result[:open].length).to eql(0)
    expect(result[:closed].length).to eql(1)

    expect(result[:closed][0].day_start).to eql(4)
    expect(result[:closed][0].day_end).to eql(4)
    expect(result[:closed][0].start).to eql(0)
    expect(result[:closed][0].end).to eql(24*60)
  end

  it "gets intervals diff quasi closed" do
    w = OpeningHoursConverter::Week.new
    w1 = OpeningHoursConverter::Week.new

    it1 = OpeningHoursConverter::Interval.new(0, 0, 6, 24*60)
    w.add_interval(it1)

    it2 = OpeningHoursConverter::Interval.new(3, 18*60, 3, 23*60)

    w1.add_interval(it2)

    result = w1.get_intervals_diff(w)
    # puts result.inspect
    expect(result[:open].length).to eql(1)
    expect(result[:closed].length).to eql(2)

    expect(result[:open][0].day_start).to eql(3)
    expect(result[:open][0].day_end).to eql(3)
    expect(result[:open][0].start).to eql(18*60)
    expect(result[:open][0].end).to eql(23*60)

    expect(result[:closed][0].day_start).to eql(0)
    expect(result[:closed][0].day_end).to eql(2)
    expect(result[:closed][0].start).to eql(0)
    expect(result[:closed][0].end).to eql(24*60)

    expect(result[:closed][1].day_start).to eql(4)
    expect(result[:closed][1].day_end).to eql(6)
    expect(result[:closed][1].start).to eql(0)
    expect(result[:closed][1].end).to eql(24*60)
  end

  it "gets intervals diff 24/24" do
    w = OpeningHoursConverter::Week.new
    w1 = OpeningHoursConverter::Week.new

    it1 = OpeningHoursConverter::Interval.new(0, 0, 4, 24*60)
    w.add_interval(it1)

    it2 = OpeningHoursConverter::Interval.new(0, 0, 5, 24*60)
    w1.add_interval(it2)

    result = w1.get_intervals_diff(w)
    expect(result[:open].length).to eql(1)
    expect(result[:closed].length).to eql(0)

    expect(result[:open][0].day_start).to eql(5)
    expect(result[:open][0].day_end).to eql(5)
    expect(result[:open][0].start).to eql(0)
    expect(result[:open][0].end).to eql(24*60)
  end

  it "gets intervals diff many changes" do
    w = OpeningHoursConverter::Week.new
    w1 = OpeningHoursConverter::Week.new

    it1 = OpeningHoursConverter::Interval.new(0, 10*60, 0, 12*60)
    it2 = OpeningHoursConverter::Interval.new(0, 13*60, 0, 16*60)
    it3 = OpeningHoursConverter::Interval.new(1, 10*60, 1, 12*60)
    it4 = OpeningHoursConverter::Interval.new(1, 13*60, 1, 16*60)
    it5 = OpeningHoursConverter::Interval.new(2, 10*60, 2, 12*60)
    it6 = OpeningHoursConverter::Interval.new(2, 13*60, 2, 16*60)
    it7 = OpeningHoursConverter::Interval.new(3, 10*60, 3, 12*60)
    it8 = OpeningHoursConverter::Interval.new(3, 13*60, 3, 16*60)
    it9 = OpeningHoursConverter::Interval.new(4, 8*60, 4, 12*60)
    it10 = OpeningHoursConverter::Interval.new(4, 13*60, 4, 18*60)
    w.add_interval(it1)
    w.add_interval(it2)
    w.add_interval(it3)
    w.add_interval(it4)
    w.add_interval(it5)
    w.add_interval(it6)
    w.add_interval(it7)
    w.add_interval(it8)
    w.add_interval(it9)
    w.add_interval(it10)

    it11 = OpeningHoursConverter::Interval.new(0, 10*60, 0, 16*60)
    it12 = OpeningHoursConverter::Interval.new(1, 10*60, 1, 12*60)
    it13 = OpeningHoursConverter::Interval.new(1, 13*60, 1, 16*60)
    it14 = OpeningHoursConverter::Interval.new(3, 8*60, 3, 10*60)
    it15 = OpeningHoursConverter::Interval.new(3, 12*60, 3, 13*60)
    it16 = OpeningHoursConverter::Interval.new(4, 10*60, 4, 16*60)
    it17 = OpeningHoursConverter::Interval.new(5, 10*60, 5, 12*60)
    it18 = OpeningHoursConverter::Interval.new(5, 13*60, 5, 16*60)
    w1.add_interval(it11)
    w1.add_interval(it12)
    w1.add_interval(it13)
    w1.add_interval(it14)
    w1.add_interval(it15)
    w1.add_interval(it16)
    w1.add_interval(it17)
    w1.add_interval(it18)

    result = w1.get_intervals_diff(w)
    expect(result[:open].length).to eql(6)
    expect(result[:closed].length).to eql(1)

    expect(result[:open][0].day_start).to eql(0)
    expect(result[:open][0].day_end).to eql(0)
    expect(result[:open][0].start).to eql(10*60)
    expect(result[:open][0].end).to eql(16*60)

    expect(result[:open][1].day_start).to eql(3)
    expect(result[:open][1].day_end).to eql(3)
    expect(result[:open][1].start).to eql(8*60)
    expect(result[:open][1].end).to eql(10*60)

    expect(result[:open][2].day_start).to eql(3)
    expect(result[:open][2].day_end).to eql(3)
    expect(result[:open][2].start).to eql(12*60)
    expect(result[:open][2].end).to eql(13*60)

    expect(result[:open][3].day_start).to eql(4)
    expect(result[:open][3].day_end).to eql(4)
    expect(result[:open][3].start).to eql(10*60)
    expect(result[:open][3].end).to eql(16*60)

    expect(result[:open][4].day_start).to eql(5)
    expect(result[:open][4].day_end).to eql(5)
    expect(result[:open][4].start).to eql(10*60)
    expect(result[:open][4].end).to eql(12*60)

    expect(result[:open][5].day_start).to eql(5)
    expect(result[:open][5].day_end).to eql(5)
    expect(result[:open][5].start).to eql(13*60)
    expect(result[:open][5].end).to eql(16*60)

    expect(result[:closed][0].day_start).to eql(2)
    expect(result[:closed][0].day_end).to eql(2)
    expect(result[:closed][0].start).to eql(0)
    expect(result[:closed][0].end).to eql(24*60)
  end
end
