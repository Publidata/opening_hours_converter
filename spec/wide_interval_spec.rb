require 'opening_hours_converter/wide_interval'

RSpec.describe OpeningHoursConverter::WideInterval, "#day" do
  it "initialize" do
    expect { wi = OpeningHoursConverter::WideInterval.new.day(1, 1, 2, 2) }.not_to raise_error
    expect { wi2 = OpeningHoursConverter::WideInterval.new.day(1, 1) }.not_to raise_error
    expect { wi3 = OpeningHoursConverter::WideInterval.new.day() }.to raise_error ArgumentError
  end

  it "type is day" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 2)
    expect(wi.type).to eql("day")
  end

  it "equals self" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 2)
    expect(wi.equals(wi)).to be true
  end

  it "equals same day" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 2, 3, 4)
    wi1 = OpeningHoursConverter::WideInterval.new.day(1, 2, 3, 4)
    expect(wi.equals(wi1)).to be true
    expect(wi1.equals(wi)).to be true
  end

  it "not equals always" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 2, 3, 4)
    wi1 = OpeningHoursConverter::WideInterval.new.always
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  it "not equals week" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 2, 3, 4)
    wi1 = OpeningHoursConverter::WideInterval.new.week(1)
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  it "not equals different month" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 2, 3, 4)
    wi1 = OpeningHoursConverter::WideInterval.new.month(1)
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  it "equals same several days" do
    wi = OpeningHoursConverter::WideInterval.new.day(28, 11, 3, 11)
    wi1 = OpeningHoursConverter::WideInterval.new.day(28, 11, 3, 11)
    expect(wi.equals(wi1)).to be true
    expect(wi1.equals(wi)).to be true
  end

  it "equals same month" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 11, 30, 11)
    wi2 = OpeningHoursConverter::WideInterval.new.month(11)
    expect(wi.equals(wi2)).to be true
    expect(wi2.equals(wi)).to be true
  end

  it "equals same months" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 11, 31, 12)
    wi2 = OpeningHoursConverter::WideInterval.new.month(11, 12)
    expect(wi.equals(wi2)).to be true
    expect(wi2.equals(wi)).to be true
  end

  it "is full month" do
    expect(OpeningHoursConverter::WideInterval.new.day(1,10,31,10).is_full_month?).to be true
    expect(OpeningHoursConverter::WideInterval.new.day(1,10,30,10).is_full_month?).to be false
    expect(OpeningHoursConverter::WideInterval.new.day(1,11,30,11).is_full_month?).to be true
    expect(OpeningHoursConverter::WideInterval.new.day(1,10,30,11).is_full_month?).to be false
  end

  it "starts month" do
    expect(OpeningHoursConverter::WideInterval.new.day(1,10).starts_month?).to be true
    expect(OpeningHoursConverter::WideInterval.new.day(1,11,15,12).starts_month?).to be true

    expect(OpeningHoursConverter::WideInterval.new.day(2,10,30,10).starts_month?).to be false
    expect(OpeningHoursConverter::WideInterval.new.day(3,10,30,11).starts_month?).to be false
  end

  it "ends month" do
    expect(OpeningHoursConverter::WideInterval.new.day(15,10,31,12).ends_month?).to be true

    expect(OpeningHoursConverter::WideInterval.new.day(2,10,12,10).ends_month?).to be false
    expect(OpeningHoursConverter::WideInterval.new.day(3,10,28,11).ends_month?).to be false
  end

  context "single day" do
    it "get time selector" do
      wi = OpeningHoursConverter::WideInterval.new.day(28, 11)
      expect(wi.get_time_selector).to eql("Nov 28")
    end
    it "contains nothing" do
      wi = OpeningHoursConverter::WideInterval.new.day(28, 11)
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11, 29, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(27, 11, 29, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(10))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.always)).to be false
    end
  end
  context "several days" do
    it "get time selector" do
      wi = OpeningHoursConverter::WideInterval.new.day(28, 11, 3, 12)
      expect(wi.get_time_selector).to eql("Nov 28-Dec 03")
    end

    it "contains some days" do
      wi = OpeningHoursConverter::WideInterval.new.day(28, 11, 3, 12)
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11, 3, 12))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(29, 11, 3, 12))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(29, 11, 2, 12))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(29, 11, 30, 11))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(29, 11))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11, 25, 12))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(27, 11, 29, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(10))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.always)).to be false
    end
  end
end

RSpec.describe OpeningHoursConverter::WideInterval, "#week" do
  it "initialize" do
    expect { wi = OpeningHoursConverter::WideInterval.new.week(1, 2) }.not_to raise_error
    expect { wi3 = OpeningHoursConverter::WideInterval.new.week }.to raise_error ArgumentError
  end

  it "type is week" do
    wi = OpeningHoursConverter::WideInterval.new.week(1, 2)
    expect(wi.type).to eql("week")
  end

  it "equals self" do
    wi = OpeningHoursConverter::WideInterval.new.week(1, 2)
    expect(wi.equals(wi)).to be true
  end

  it "equals same week" do
    wi = OpeningHoursConverter::WideInterval.new.week(1, 1)
    wi1 = OpeningHoursConverter::WideInterval.new.week(1)
    expect(wi.equals(wi1)).to be true
    expect(wi1.equals(wi)).to be true
  end

  it "equals same weeks" do
    wi = OpeningHoursConverter::WideInterval.new.week(1, 20)
    wi1 = OpeningHoursConverter::WideInterval.new.week(1, 20)
    expect(wi.equals(wi1)).to be true
    expect(wi1.equals(wi)).to be true
  end

  it "not equals always" do
    wi = OpeningHoursConverter::WideInterval.new.week(1, 2)
    wi1 = OpeningHoursConverter::WideInterval.new.always
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  it "not equals day" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 2, 3, 4)
    wi1 = OpeningHoursConverter::WideInterval.new.week(1)
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  it "not equals month" do
    wi = OpeningHoursConverter::WideInterval.new.week(1, 2)
    wi1 = OpeningHoursConverter::WideInterval.new.month(1)
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  context "single week" do
    it "get time selector" do
      wi = OpeningHoursConverter::WideInterval.new.week(28)
      expect(wi.get_time_selector).to eql("week 28")
    end
    it "contains nothing" do
      wi = OpeningHoursConverter::WideInterval.new.week(28)
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11, 29, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(27, 11, 29, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(10))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.always)).to be false
    end
  end
  context "several weeks" do
    it "get time selector" do
      wi = OpeningHoursConverter::WideInterval.new.week(5, 15)
      expect(wi.get_time_selector).to eql("week 05-15")
    end

    it "contains some weeks" do
      wi = OpeningHoursConverter::WideInterval.new.week(28, 50)
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11, 29, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(27, 11, 29, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(10))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(29))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(29, 50))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(28, 49))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(28, 50))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(27, 30))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(45, 51))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.always)).to be false
    end
  end
end

RSpec.describe OpeningHoursConverter::WideInterval, "#month" do
  it "initialize" do
    expect { wi = OpeningHoursConverter::WideInterval.new.month(1, 3) }.not_to raise_error
    expect { wi2 = OpeningHoursConverter::WideInterval.new.month(1) }.not_to raise_error
    expect { wi3 = OpeningHoursConverter::WideInterval.new.month }.to raise_error ArgumentError
  end

  it "type is month" do
    wi = OpeningHoursConverter::WideInterval.new.month(1, 2)
    expect(wi.type).to eql("month")
    wi1 = OpeningHoursConverter::WideInterval.new.month(1)
    expect(wi1.type).to eql("month")
  end

  it "equals self" do
    wi = OpeningHoursConverter::WideInterval.new.month(1, 2)
    expect(wi.equals(wi)).to be true
  end

  it "equals same month" do
    wi = OpeningHoursConverter::WideInterval.new.month(1, 1)
    wi1 = OpeningHoursConverter::WideInterval.new.month(1)
    expect(wi.equals(wi1)).to be true
    expect(wi1.equals(wi)).to be true
  end

  it "equals same months" do
    wi = OpeningHoursConverter::WideInterval.new.month(1, 11)
    wi1 = OpeningHoursConverter::WideInterval.new.month(1, 11)
    expect(wi.equals(wi1)).to be true
    expect(wi1.equals(wi)).to be true
  end

  it "not equals always" do
    wi = OpeningHoursConverter::WideInterval.new.month(1, 2)
    wi1 = OpeningHoursConverter::WideInterval.new.always
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  it "not equals day" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 2, 3, 4)
    wi1 = OpeningHoursConverter::WideInterval.new.month(1)
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  it "not equals week" do
    wi = OpeningHoursConverter::WideInterval.new.week(1, 2)
    wi1 = OpeningHoursConverter::WideInterval.new.month(1)
    expect(wi.equals(wi1)).to be false
    expect(wi1.equals(wi)).to be false
  end

  it "equals same days" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 11, 30, 11)
    wi2 = OpeningHoursConverter::WideInterval.new.month(11)
    expect(wi.equals(wi2)).to be true
    expect(wi2.equals(wi)).to be true
  end

  it "equals same days" do
    wi = OpeningHoursConverter::WideInterval.new.day(1, 11, 31, 12)
    wi2 = OpeningHoursConverter::WideInterval.new.month(11, 12)
    expect(wi.equals(wi2)).to be true
    expect(wi2.equals(wi)).to be true
  end

  it "starts month" do
    expect(OpeningHoursConverter::WideInterval.new.month(1,10).starts_month?).to be true
    expect(OpeningHoursConverter::WideInterval.new.month(11).starts_month?).to be true
  end

  it "ends month" do
    expect(OpeningHoursConverter::WideInterval.new.month(1,10).ends_month?).to be true
    expect(OpeningHoursConverter::WideInterval.new.month(11).ends_month?).to be true
  end


  context "single month" do
    it "get time selector" do
      wi = OpeningHoursConverter::WideInterval.new.month(11)
      expect(wi.get_time_selector).to eql("Nov")
    end

    it "is full month" do
      expect(OpeningHoursConverter::WideInterval.new.month(1,1).is_full_month?).to be true
      expect(OpeningHoursConverter::WideInterval.new.month(1,2).is_full_month?).to be false
      expect(OpeningHoursConverter::WideInterval.new.month(1).is_full_month?).to be true
    end

    it "contains some days" do
      wi = OpeningHoursConverter::WideInterval.new.month(11)
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(28, 11))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(11, 11, 28, 11))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(11, 10, 28, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11, 12))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(27, 29))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.always)).to be false
    end
  end
  context "several months" do
    it "get time selector" do
      wi = OpeningHoursConverter::WideInterval.new.month(11, 12)
      expect(wi.get_time_selector).to eql("Nov-Dec")
    end
    it "contains some days and months" do
      wi = OpeningHoursConverter::WideInterval.new.month(10, 11)
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(1, 10, 30, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(10, 11))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(1, 10, 29, 11))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(11, 10, 28, 12))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(29, 9, 1, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10))).to be true
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10, 12))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(9, 11))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11, 12))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(27, 29))).to be false
      expect(wi.contains?(OpeningHoursConverter::WideInterval.new.always)).to be false
    end
  end
end
RSpec.describe OpeningHoursConverter::WideInterval, "#always" do
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
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(1, 10, 30, 11))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(10, 11))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(1, 10, 29, 11))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(11, 10, 28, 12))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.day(29, 9, 1, 11))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10, 12))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(10, 11))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(9, 11))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.month(11, 12))).to be true
    expect(wi.contains?(OpeningHoursConverter::WideInterval.new.week(27, 29))).to be true
  end
end
