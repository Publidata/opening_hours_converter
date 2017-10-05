require 'opening_hours_converter/wide_interval'

RSpec.describe OpeningHoursConverter::WideInterval, "#day" do
  before(:all) do
    @basic = OpeningHoursConverter::WideInterval.new.day(1, 1, 1)
    @basic_with_end = OpeningHoursConverter::WideInterval.new.day(1, 1, 1, 2, 2, 2)
    @basic_same = OpeningHoursConverter::WideInterval.new.day(1, 1, 1)
    @basic_with_end_same = OpeningHoursConverter::WideInterval.new.day(1, 1, 1, 2, 2, 2)
    @basic_not_first_day_or_month = OpeningHoursConverter::WideInterval.new.day(2, 2, 2)

    @basic_always = OpeningHoursConverter::WideInterval.new.always
    @basic_month = OpeningHoursConverter::WideInterval.new.month(1,1)

    @year_2017_in_days = OpeningHoursConverter::WideInterval.new.day(1, 1, 2017, 31, 12, 2017)
    @january_2017_in_day = OpeningHoursConverter::WideInterval.new.day(1, 1, 2017, 31, 1, 2017)

    @november_2017_in_day = OpeningHoursConverter::WideInterval.new.day(1, 11, 2017, 30, 11, 2017)
    @november_28_2017 = OpeningHoursConverter::WideInterval.new.day(28, 11, 2017)
    @november_28_to_november_29_2017 = OpeningHoursConverter::WideInterval.new.day(28, 11, 2017, 29, 11, 2017)
    @november_27_to_november_29_2017 = OpeningHoursConverter::WideInterval.new.day(27, 11, 2017, 29, 11, 2017)
    @november_28_to_december_3_2017 = OpeningHoursConverter::WideInterval.new.day(28, 11,2017, 3, 12,2017)
    @november_28_to_december_2_2017 = OpeningHoursConverter::WideInterval.new.day(28, 11,2017, 2, 12,2017)
    @november_29_to_december_3_2017 = OpeningHoursConverter::WideInterval.new.day(29, 11,2017, 3, 12,2017)
    @january_2017 = OpeningHoursConverter::WideInterval.new.month(1, 2017)

    @november_to_december_2017_in_day = OpeningHoursConverter::WideInterval.new.day(1, 11, 2017, 31, 12, 2017)
    @november_to_december_2017 = OpeningHoursConverter::WideInterval.new.month(11, 2017, 12, 2017)
  end

  it "initialize" do
    expect { wi = OpeningHoursConverter::WideInterval.new.day(1, 1, 1, 2, 2, 2) }.not_to raise_error
    expect { wi2 = OpeningHoursConverter::WideInterval.new.day(1, 1, 1) }.not_to raise_error
    expect { wi3 = OpeningHoursConverter::WideInterval.new.day() }.to raise_error ArgumentError
    expect { wi4 = OpeningHoursConverter::WideInterval.new.day(1) }.to raise_error ArgumentError
    expect { wi5 = OpeningHoursConverter::WideInterval.new.day(1, 1) }.to raise_error ArgumentError
  end

  it "type is day" do
    expect(@basic.type).to eql("day")
  end

  it "equals self" do
    expect(@basic.equals(@basic)).to be true
    expect(@basic_with_end.equals(@basic_with_end)).to be true
    expect(@basic_with_end.equals(@basic)).to be false
    expect(@basic.equals(@basic_with_end)).to be false
  end

  it "equals same day" do
    expect(@basic.equals(@basic_same)).to be true
    expect(@basic_same.equals(@basic)).to be true
  end

  it "not equals always" do
    expect(@basic.equals(@basic_always)).to be false
    expect(@basic_with_end.equals(@basic_always)).to be false
    expect(@basic.equals(@basic_always)).to be false
    expect(@basic_with_end.equals(@basic_always)).to be false
  end

  it "not equals different month" do
    expect(@basic.equals(@basic_month)).to be false
    expect(@basic_month.equals(@basic)).to be false
  end

  it "equals same several days" do
    expect(@basic_with_end_same.equals(@basic_with_end)).to be true
    expect(@basic_with_end.equals(@basic_with_end_same)).to be true
  end

  it "equals same month" do
    expect(@january_2017_in_day.equals(@january_2017)).to be true
    expect(@january_2017.equals(@january_2017_in_day)).to be true
  end

  it "equals same months" do
    expect(@november_to_december_2017_in_day.equals(@november_to_december_2017)).to be true
    expect(@november_to_december_2017.equals(@november_to_december_2017_in_day)).to be true
  end

  it "is full month" do
    expect(@january_2017_in_day.is_full_month?).to be true
    expect(@basic.is_full_month?).to be false
    expect(@november_2017_in_day.is_full_month?).to be true
    expect(@november_to_december_2017_in_day.is_full_month?).to be false
  end

  it "starts month" do
    expect(@basic.starts_month?).to be true
    expect(@basic_with_end.starts_month?).to be true
    expect(@january_2017_in_day.starts_month?).to be true
    expect(@november_2017_in_day.starts_month?).to be true
    expect(@november_to_december_2017_in_day.starts_month?).to be true
    expect(@basic_not_first_day_or_month.starts_month?).to be false
  end

  it "ends month" do
    expect(@basic.ends_month?).to be false
    expect(@basic_with_end.ends_month?).to be false
    expect(@january_2017_in_day.ends_month?).to be true
    expect(@november_2017_in_day.ends_month?).to be true
    expect(@november_to_december_2017_in_day.ends_month?).to be true
    expect(@basic_not_first_day_or_month.ends_month?).to be false
  end

  it "full year" do
    expect(@year_2017_in_days.is_full_year?).to be true
    expect(@basic_with_end.is_full_year?).to be false
    expect(@january_2017_in_day.is_full_year?).to be false
    expect(@november_2017_in_day.is_full_year?).to be false
    expect(@november_to_december_2017_in_day.is_full_year?).to be false
    expect(@basic_not_first_day_or_month.is_full_year?).to be false
  end

  it "starts year" do
    expect(@year_2017_in_days.starts_year?).to be true
    expect(@january_2017_in_day.starts_year?).to be true
    expect(@basic.starts_year?).to be true
    expect(@basic_with_end.starts_year?).to be true
    expect(@basic_not_first_day_or_month.starts_year?).to be false
    expect(@november_2017_in_day.starts_year?).to be false
    expect(@november_to_december_2017_in_day.starts_year?).to be false
  end

  it "ends year" do
    expect(@year_2017_in_days.ends_year?).to be true
    expect(@november_to_december_2017_in_day.ends_year?).to be true
    expect(@january_2017_in_day.ends_year?).to be false
    expect(@basic.ends_year?).to be false
    expect(@basic_not_first_day_or_month.ends_year?).to be false
  end

  context "single day" do
    it "get time selector" do
      expect(@november_28_2017.get_time_selector).to eql("2017 Nov 28")
    end
    it "contains nothing" do
      expect(@november_28_2017.contains?(@november_28_2017)).to be false
      expect(@november_28_2017.contains?(@november_28_to_november_29_2017)).to be false
      expect(@november_28_2017.contains?(@november_27_to_november_29_2017)).to be false
      expect(@november_28_2017.contains?(@basic_month)).to be false
      expect(@november_28_2017.contains?(@basic_always)).to be false
    end
  end
  context "several days" do
    it "get time selector" do
      expect(@november_28_to_december_3_2017.get_time_selector).to eql("2017 Nov 28-Dec 03")
    end

    it "contains some days" do
      expect(@november_28_to_december_3_2017.contains?(@november_28_to_december_3_2017)).to be false
      expect(@november_28_to_december_3_2017.contains?(@november_29_to_december_3_2017)).to be true
      expect(@november_28_to_december_3_2017.contains?(@november_28_to_december_2_2017)).to be true
      expect(@november_28_to_december_3_2017.contains?(@november_28_2017)).to be true
      expect(@november_28_to_december_3_2017.contains?(@basic)).to be false
      expect(@november_28_to_december_3_2017.contains?(@basic_month)).to be false
      expect(@november_28_to_december_3_2017.contains?(@basic_always)).to be false
    end
  end
end

RSpec.describe OpeningHoursConverter::WideInterval, "#month" do
  before(:all) do
    @basic_day = OpeningHoursConverter::WideInterval.new.day(1, 1, 1)
    @basic_always = OpeningHoursConverter::WideInterval.new.always
    @basic_month = OpeningHoursConverter::WideInterval.new.month(1,1)
    @year_2017 = OpeningHoursConverter::WideInterval.new.year(2017)

    @november_28_2017 = OpeningHoursConverter::WideInterval.new.day(28, 11, 2017)
    @november_28_to_november_29_2017 = OpeningHoursConverter::WideInterval.new.day(28, 11, 2017, 29, 11, 2017)
    @november_27_to_november_29_2017 = OpeningHoursConverter::WideInterval.new.day(27, 11, 2017, 29, 11, 2017)
    @november_28_to_december_3_2017 = OpeningHoursConverter::WideInterval.new.day(28, 11, 2017, 3, 12, 2017)
    @october_25_to_november_15_2017 = OpeningHoursConverter::WideInterval.new.day(25, 10, 2017, 15, 11, 2017)
    @november_15_to_december_25_2017 = OpeningHoursConverter::WideInterval.new.day(15, 11, 2017, 25, 12, 2017)

    @november_2017_in_day = OpeningHoursConverter::WideInterval.new.day(1, 11, 2017, 30, 11, 2017)
    @november_2017 = OpeningHoursConverter::WideInterval.new.month(11, 2017)
    @november_to_december_2017_in_day = OpeningHoursConverter::WideInterval.new.day(1, 11, 2017, 31, 12, 2017)
    @october_to_november_2017_in_day = OpeningHoursConverter::WideInterval.new.day(1, 10, 2017, 30, 11, 2017)
    @november_to_december_2017 = OpeningHoursConverter::WideInterval.new.month(11, 2017, 12, 2017)
    @october_to_november_2017 = OpeningHoursConverter::WideInterval.new.month(10, 2017, 11, 2017)
    @january_to_february_2017 = OpeningHoursConverter::WideInterval.new.month(1,2017, 2,2017)
    @january_to_february_2017_same = OpeningHoursConverter::WideInterval.new.month(1,2017, 2,2017)
    @january_2017 = OpeningHoursConverter::WideInterval.new.month(1,2017)
    @january_2017_same = OpeningHoursConverter::WideInterval.new.month(1,2017, 1,2017)

    @october_1_to_november_29_2017 = OpeningHoursConverter::WideInterval.new.day(1, 10, 2017, 29, 11, 2017)
    @october_10_to_december_25_2017 = OpeningHoursConverter::WideInterval.new.day(10, 10, 2017, 25, 12, 2017)
    @september_10_to_november_10_2017 = OpeningHoursConverter::WideInterval.new.day(10, 9, 2017, 10, 11, 2017)
    @october_2017 = OpeningHoursConverter::WideInterval.new.month(10, 2017)

    @october_to_december_2017 = OpeningHoursConverter::WideInterval.new.month(10, 2017, 12, 2017)
    @october_to_november_2017 = OpeningHoursConverter::WideInterval.new.month(10, 2017, 11, 2017)
    @september_to_october_2017 = OpeningHoursConverter::WideInterval.new.month(9, 2017, 10, 2017)
    @november_to_december_2017 = OpeningHoursConverter::WideInterval.new.month(11, 2017, 12, 2017)
  end

  it "initialize" do
    expect { wi = OpeningHoursConverter::WideInterval.new.month(1,2017, 3,2017) }.not_to raise_error
    expect { wi2 = OpeningHoursConverter::WideInterval.new.month(1,2017) }.not_to raise_error
    expect { wi2 = OpeningHoursConverter::WideInterval.new.month(1) }.to raise_error ArgumentError
    expect { wi3 = OpeningHoursConverter::WideInterval.new.month }.to raise_error ArgumentError
  end

  it "type is month" do
    expect(@january_to_february_2017.type).to eql("month")
    expect(@november_2017.type).to eql("month")
  end

  it "equals self" do
    expect(@january_to_february_2017.equals(@january_to_february_2017)).to be true
  end

  it "equals same month" do
    expect(@january_2017.equals(@january_2017_same)).to be true
    expect(@january_2017_same.equals(@january_2017)).to be true
  end

  it "equals same months" do
    expect(@january_to_february_2017.equals(@january_to_february_2017_same)).to be true
    expect(@january_to_february_2017_same.equals(@january_to_february_2017)).to be true
  end

  it "not equals always" do
    expect(@january_2017.equals(@basic_always)).to be false
    expect(@basic_always.equals(@january_2017)).to be false
  end

  it "not equals year" do
    expect(@january_2017.equals(@year_2017)).to be false
    expect(@year_2017.equals(@january_2017)).to be false
  end

  it "not equals day" do
    expect(@january_2017.equals(@basic_day)).to be false
    expect(@basic_day.equals(@january_2017)).to be false
  end

  it "equals same days" do
    expect(@november_2017.equals(@november_2017_in_day)).to be true
    expect(@november_2017_in_day.equals(@november_2017)).to be true
  end

  it "equals same days" do
    expect(@november_to_december_2017_in_day.equals(@november_to_december_2017)).to be true
    expect(@november_to_december_2017.equals(@november_to_december_2017_in_day)).to be true
  end

  it "starts month" do
    expect(@november_to_december_2017.starts_month?).to be true
    expect(@january_2017.starts_month?).to be true
  end

  it "ends month" do
    expect(@november_to_december_2017.ends_month?).to be true
    expect(@january_2017.ends_month?).to be true
  end


  context "single month" do
    it "get time selector" do
      expect(@november_2017.get_time_selector).to eql("2017 Nov")
    end

    it "is full month" do
      expect(@november_2017.is_full_month?).to be true
      expect(@january_2017.is_full_month?).to be true
      expect(@january_to_february_2017.is_full_month?).to be false
      expect(@november_to_december_2017.is_full_month?).to be false
    end

    it "contains some days" do
      # expect(@november_2017.contains?(@november_28_2017)).to be true
      # expect(@november_2017.contains?(@november_28_to_november_29_2017)).to be true
      # expect(@november_2017.contains?(@october_25_to_november_15_2017)).to be false
      # expect(@november_2017.contains?(@november_15_to_december_25_2017)).to be false
      # expect(@november_2017.contains?(@november_2017)).to be false
      # expect(@november_2017.contains?(@november_to_december_2017)).to be false
      # expect(@november_2017.contains?(@basic_always)).to be false
      # expect(@november_2017.contains?(@year_2017)).to be false
    end
  end
  context "several months" do
    it "get time selector" do
      expect(@november_to_december_2017.get_time_selector).to eql("2017 Nov-Dec")
    end
    it "contains some days and months" do
      # expect(@october_to_november_2017.contains?(@october_to_november_2017_in_day)).to be false
      # expect(@october_to_november_2017.contains?(@november_28_2017)).to be true
      # expect(@october_to_november_2017.contains?(@october_1_to_november_29_2017)).to be true
      # expect(@october_to_november_2017.contains?(@october_10_to_december_25_2017)).to be false
      # expect(@october_to_november_2017.contains?(@september_10_to_november_10_2017)).to be false
      # expect(@october_to_november_2017.contains?(@october_2017)).to be true
      # expect(@october_to_november_2017.contains?(@november_2017)).to be true
      # expect(@october_to_november_2017.contains?(@october_to_december_2017)).to be false
      # expect(@october_to_november_2017.contains?(@october_to_november_2017)).to be false
      # expect(@october_to_november_2017.contains?(@september_to_october_2017)).to be false
      # expect(@october_to_november_2017.contains?(@november_to_december_2017)).to be false
      # expect(@october_to_november_2017.contains?(@year_2017)).to be false
      # expect(@october_to_november_2017.contains?(@basic_always)).to be false
    end
  end
end
RSpec.describe OpeningHoursConverter::WideInterval, "#year" do
  before(:all) do
    @basic_always = OpeningHoursConverter::WideInterval.new.always
    @basic_month = OpeningHoursConverter::WideInterval.new.month(1,1)
    @basic_day = OpeningHoursConverter::WideInterval.new.day(1, 1, 1)
    @basic_day = OpeningHoursConverter::WideInterval.new.day(1, 1, 1)
    @year_2017 = OpeningHoursConverter::WideInterval.new.year(2017)
    @year_2017_same = OpeningHoursConverter::WideInterval.new.year(2017)
    @year_2017_to_2018 = OpeningHoursConverter::WideInterval.new.year(2017, 2018)
    @year_2017_to_2018_in_day = OpeningHoursConverter::WideInterval.new.day(1,1,2017,31,12,2018)
    @year_2017_to_2018_same = OpeningHoursConverter::WideInterval.new.year(2017, 2018)
    @year_2017_in_day = OpeningHoursConverter::WideInterval.new.day(1,1,2017,31,12,2017)
    @year_2017_in_month = OpeningHoursConverter::WideInterval.new.month(1,2017,12,2017)
    @year_2017_to_2018_in_month = OpeningHoursConverter::WideInterval.new.month(1,2017,12,2018)

    @november_28_2017 = OpeningHoursConverter::WideInterval.new.day(28,11,2017)
    @november_28_to_november_29_2017 = OpeningHoursConverter::WideInterval.new.day(28,11,2017,29,11,2017)
    @october_25_to_november_15_2017 = OpeningHoursConverter::WideInterval.new.day(25,10,2017,15,11,2017)
    @january_2017 = OpeningHoursConverter::WideInterval.new.month(1,2017)
    @november_2017 = OpeningHoursConverter::WideInterval.new.month(11,2017)
    @november_to_december_2017 = OpeningHoursConverter::WideInterval.new.month(11,2017,12,2017)

    @november_28_2018 = OpeningHoursConverter::WideInterval.new.day(28,11,2018)
    @november_28_2017_to_january_29_2018 = OpeningHoursConverter::WideInterval.new.day(28,11,2017,29,1,2018)
    @october_25_2016_to_november_15_2017 = OpeningHoursConverter::WideInterval.new.day(25,10,2016,15,11,2017)
    @november_2018 = OpeningHoursConverter::WideInterval.new.month(11,2018)
    @november_to_december_2018 = OpeningHoursConverter::WideInterval.new.month(11,2018,12,2018)
  end
  it "initialize" do
    expect { wi = OpeningHoursConverter::WideInterval.new.year(2017) }.not_to raise_error
    expect { wi2 = OpeningHoursConverter::WideInterval.new.year(2017, 2018) }.not_to raise_error
    expect { wi3 = OpeningHoursConverter::WideInterval.new.year }.to raise_error ArgumentError
  end

  it "type is year" do
    expect(@year_2017.type).to eql("year")
    expect(@year_2017_to_2018.type).to eql("year")
  end

  it "equals self" do
    expect(@year_2017.equals(@year_2017)).to be true
  end

  it "equals same year" do
    expect(@year_2017.equals(@year_2017_same)).to be true
    expect(@year_2017_same.equals(@year_2017)).to be true
  end

  it "equals same years" do
    expect(@year_2017_to_2018.equals(@year_2017_to_2018_same)).to be true
    expect(@year_2017_to_2018_same.equals(@year_2017_to_2018)).to be true
  end

  it "not equals always" do
    expect(@year_2017.equals(@basic_always)).to be false
    expect(@basic_always.equals(@year_2017)).to be false
  end

  it "not equals month" do
    expect(@january_2017.equals(@year_2017)).to be false
    expect(@year_2017.equals(@january_2017)).to be false
  end

  it "not equals day" do
    expect(@year_2017.equals(@basic_day)).to be false
    expect(@basic_day.equals(@year_2017)).to be false
  end

  it "equals same days" do
    expect(@year_2017.equals(@year_2017_in_day)).to be true
    expect(@year_2017_in_day.equals(@year_2017)).to be true
  end

  it "equals same days" do
    expect(@year_2017_to_2018_in_day.equals(@year_2017_to_2018)).to be true
    expect(@year_2017_to_2018.equals(@year_2017_to_2018_in_day)).to be true
  end

  it "equals same months" do
    expect(@year_2017.equals(@year_2017_in_month)).to be true
    expect(@year_2017_in_month.equals(@year_2017)).to be true
  end

  it "equals same months" do
    expect(@year_2017_to_2018_in_month.equals(@year_2017_to_2018)).to be true
    expect(@year_2017_to_2018.equals(@year_2017_to_2018_in_month)).to be true
  end

  it "starts month" do
    expect(@year_2017.starts_month?).to be true
    expect(@year_2017_to_2018.starts_month?).to be true
  end

  it "ends month" do
    expect(@year_2017.ends_month?).to be true
    expect(@year_2017_to_2018.ends_month?).to be true
  end

  it "is full month" do
    expect(@year_2017.is_full_month?).to be false
    expect(@year_2017_to_2018.is_full_month?).to be false
  end

  it "starts year" do
    expect(@year_2017.starts_year?).to be true
    expect(@year_2017_to_2018.starts_year?).to be true
  end

  it "ends year" do
    expect(@year_2017.ends_year?).to be true
    expect(@year_2017_to_2018.ends_year?).to be true
  end

  it "is full year" do
    expect(@year_2017.is_full_year?).to be true
    expect(@year_2017_to_2018.is_full_year?).to be false
  end
  context "single year" do
    it "get time selector" do
      expect(@year_2017.get_time_selector).to eql("2017")
    end
    it "contains days, and month" do
      expect(@year_2017.contains?(@november_28_2017)).to be true
      expect(@year_2017.contains?(@november_28_to_november_29_2017)).to be true
      expect(@year_2017.contains?(@october_25_to_november_15_2017)).to be true
      expect(@year_2017.contains?(@november_2017)).to be true
      expect(@year_2017.contains?(@november_to_december_2017)).to be true

      expect(@year_2017.contains?(@november_28_2018)).to be false
      expect(@year_2017.contains?(@november_28_2017_to_january_29_2018)).to be false
      expect(@year_2017.contains?(@october_25_2016_to_november_15_2017)).to be false
      expect(@year_2017.contains?(@november_2018)).to be false
      expect(@year_2017.contains?(@november_to_december_2018)).to be false
      expect(@year_2017.contains?(@basic_always)).to be false
      expect(@year_2017.contains?(@year_2017)).to be false
    end
  end
  context "several years" do
    it "get time selector" do
      expect(@year_2017_to_2018.get_time_selector).to eql("2017-2018")
    end
    it "contains some days and months" do
      expect(@year_2017_to_2018.contains?(@november_28_2017)).to be true
      expect(@year_2017_to_2018.contains?(@november_28_to_november_29_2017)).to be true
      expect(@year_2017_to_2018.contains?(@october_25_to_november_15_2017)).to be true
      expect(@year_2017_to_2018.contains?(@november_2017)).to be true
      expect(@year_2017_to_2018.contains?(@november_to_december_2017)).to be true

      expect(@year_2017_to_2018.contains?(@november_28_2018)).to be true
      expect(@year_2017_to_2018.contains?(@november_28_2017_to_january_29_2018)).to be true
      expect(@year_2017_to_2018.contains?(@october_25_2016_to_november_15_2017)).to be false
      expect(@year_2017_to_2018.contains?(@november_2018)).to be true
      expect(@year_2017_to_2018.contains?(@november_to_december_2018)).to be true
      expect(@year_2017_to_2018.contains?(@basic_always)).to be false
      expect(@year_2017_to_2018.contains?(@year_2017)).to be true
      expect(@year_2017_to_2018.contains?(@year_2017_to_2018)).to be false
    end
  end

end
RSpec.describe OpeningHoursConverter::WideInterval, "#always" do
  before(:all) do
    @basic_always = OpeningHoursConverter::WideInterval.new.always
    @basic_month = OpeningHoursConverter::WideInterval.new.month(1,1)
    @basic_day = OpeningHoursConverter::WideInterval.new.day(1, 1, 1)
  end
  it "initialize" do
    expect { wi = OpeningHoursConverter::WideInterval.new.always }.not_to raise_error
  end
  it "starts month" do
    expect(OpeningHoursConverter::WideInterval.new.always.starts_month?).to be true
  end
  it "ends month" do
    expect(OpeningHoursConverter::WideInterval.new.always.ends_month?).to be true
  end

  it "contains everything" do
    wi = OpeningHoursConverter::WideInterval.new.always
    expect(@basic_always.contains?(@basic_day)).to be true
    expect(@basic_always.contains?(OpeningHoursConverter::WideInterval.new.day(10, 11,2017))).to be true
    expect(@basic_always.contains?(OpeningHoursConverter::WideInterval.new.day(1, 10,2017, 29, 11,2017))).to be true
    expect(@basic_always.contains?(OpeningHoursConverter::WideInterval.new.day(11, 10,2017, 28, 12,2017))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(29, 9,2017, 1, 11,2017))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11,2017))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10,2017))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10,2017, 12,2017))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10,2017, 11,2017))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(9,2017, 11,2017))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11,2017, 12,2017))).to be true
  end
end
