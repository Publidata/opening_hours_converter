require 'opening_hours_converter'
RSpec.describe OpeningHoursConverter::WeekIndex, '#week_from_index' do # (index, year = Time.now.year)
  it 'raises with out of range index' do
    expect { OpeningHoursConverter::WeekIndex.week_from_index(0, 2019) }.to raise_error
    expect { OpeningHoursConverter::WeekIndex.week_from_index(53, 2019) }.to raise_error
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
  end
end
# RSpec.describe OpeningHoursConverter::WeekIndex, '#index_from_week' do # (week, year = Time.now.year)

# end
# RSpec.describe OpeningHoursConverter::WeekIndex, '#week_count' do # (year = Time.now.year)

# end
# RSpec.describe OpeningHoursConverter::WeekIndex, '#add_offset_to_week' do # (week, offset)

# end
# RSpec.describe OpeningHoursConverter::WeekIndex, '#first_week' do # (year = Time.now.year)

# end
# RSpec.describe OpeningHoursConverter::WeekIndex, '#last_week' do # (year = Time.now.year)

# end
# RSpec.describe OpeningHoursConverter::WeekIndex, '#last_day_of_last_week' do # (year = Time.now.year)

# end
# RSpec.describe OpeningHoursConverter::WeekIndex, '#first_day_of_first_week' do # (year = Time.now.year)

# end
