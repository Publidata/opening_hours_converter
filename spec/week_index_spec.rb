require 'opening_hours_converter'
RSpec.describe OpeningHoursConverter::WeekIndex, '#week_from_index' do # (index, year = Time.now.year)
  it 'raises with out of range index' do
    expect { OpeningHoursConverter::WeekIndex.week_from_index(0, 2019) }.to raise_error
  end

  it 'does not raise with good index' do
    expect { OpeningHoursConverter::WeekIndex.week_from_index(1, 2019) }.to_not raise_error
    expect { OpeningHoursConverter::WeekIndex.week_from_index(53, 2026) }.to_not raise_error
  end

  it 'gives the right week' do
    w1_2019 = OpeningHoursConverter::WeekIndex.week_from_index(1, 2019)
    expected_w1_2019 = { from: Date.new(2018, 12, 31), to: Date.new(2019, 1, 6) }
    expect(w1_2019).to eq(expected_w1_2019)

    w32_2019 = OpeningHoursConverter::WeekIndex.week_from_index(32, 2019)
    expected_w32_2019 = { from: Date.new(2019, 8, 5), to: Date.new(2019, 8, 11) }
    expect(w32_2019).to eq(expected_w32_2019)

    w42_2019 = OpeningHoursConverter::WeekIndex.week_from_index(42, 2019)
    expected_w42_2019 = { from: Date.new(2019, 10, 14), to: Date.new(2019, 10, 20) }
    expect(w42_2019).to eq(expected_w42_2019)
  end
end

RSpec.describe OpeningHoursConverter::WeekIndex, '#index_from_week' do # (week, year = Time.now.year)
  it 'gets the right index' do
    w1_2019 = { from: Date.new(2018, 12, 31), to: Date.new(2019, 1, 6) }
    w32_2019 = { from: Date.new(2019, 8, 5), to: Date.new(2019, 8, 11) }
    w42_2019 = { from: Date.new(2019, 10, 14), to: Date.new(2019, 10, 20) }
    expect(OpeningHoursConverter::WeekIndex.index_from_week(w1_2019)).to eq 1
    expect(OpeningHoursConverter::WeekIndex.index_from_week(w32_2019)).to eq 32
    expect(OpeningHoursConverter::WeekIndex.index_from_week(w42_2019)).to eq 42
  end
end

RSpec.describe OpeningHoursConverter::WeekIndex, '#week_count' do # (year = Time.now.year)
  it 'gets the right 53 weeks year' do
    next_53_weeks_years = [2004, 2009, 2015, 2020, 2026, 2032, 2037, 2043, 2048, 2054, 2060, 2065, 2071, 2076, 2082, 2088, 2093, 2099, 2105, 2111, 2116, 2122, 2128, 2133, 2139, 2144, 2150, 2156, 2161, 2167, 2172, 2178, 2184, 2189, 2195, 2201, 2207, 2212, 2218, 2224, 2229, 2235, 2240, 2246, 2252, 2257, 2263, 2268, 2274, 2280, 2285, 2291, 2296, 2303, 2308, 2314, 2320, 2325, 2331, 2336, 2342, 2348, 2353, 2359, 2364, 2370, 2376, 2381, 2387, 2392, 2398]
    (2000).upto(2400) do |year|
      expect(OpeningHoursConverter::WeekIndex.week_count(year)).to eq(next_53_weeks_years.include?(year) ? 53 : 52)
    end
  end
end

RSpec.describe OpeningHoursConverter::WeekIndex, '#add_offset_to_week' do # (week, offset)
  it 'adds offset to week' do
    w1_2019 = { from: Date.new(2018, 12, 31), to: Date.new(2019, 1, 6) }
    w32_2019 = { from: Date.new(2019, 8, 5), to: Date.new(2019, 8, 11) }
    w42_2019 = { from: Date.new(2019, 10, 14), to: Date.new(2019, 10, 20) }
    expect(OpeningHoursConverter::WeekIndex.add_offset_to_week(w1_2019, 31 * 7)).to eq(w32_2019)
    expect(OpeningHoursConverter::WeekIndex.add_offset_to_week(w32_2019, -31 * 7)).to eq(w1_2019)
    expect(OpeningHoursConverter::WeekIndex.add_offset_to_week(w32_2019, 10 * 7)).to eq(w42_2019)
  end
end

RSpec.describe OpeningHoursConverter::WeekIndex, '#first_week' do # (year = Time.now.year)
  it 'gets first year' do
    w1_2019 = { from: Date.new(2018, 12, 31), to: Date.new(2019, 1, 6) }
    expect(OpeningHoursConverter::WeekIndex.first_week(2019)).to eq(w1_2019)
  end
end

RSpec.describe OpeningHoursConverter::WeekIndex, '#last_week' do # (year = Time.now.year)
  it 'gets last year' do
    w52_2019 = w42_2019 = OpeningHoursConverter::WeekIndex.week_from_index(52, 2019)
    expect(OpeningHoursConverter::WeekIndex.last_week(2019)).to eq(w52_2019)
  end
end

# RSpec.describe OpeningHoursConverter::WeekIndex, '#last_day_of_last_week' do # (year = Time.now.year)

# end

# RSpec.describe OpeningHoursConverter::WeekIndex, '#first_day_of_first_week' do # (year = Time.now.year)

# end
