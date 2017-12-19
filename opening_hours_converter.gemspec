Gem::Specification.new do |s|
  s.name = 'opening_hours_converter'
  s.version = '1.7.0'
  s.summary = "Datetime range to openinghours, openinghours to datetime range"
  s.description = "Datetime range to openinghours, openinghours to datetime range. Very strongly inspired by yohours."
  s.authors = ["Ziserman Martin"]
  s.email = 'tech@publidata.io'
  s.add_runtime_dependency "json"
  s.files = [
    "lib/opening_hours_converter.rb",
    "lib/opening_hours_converter/constants.rb",
    "lib/opening_hours_converter/date_range.rb",
    "lib/opening_hours_converter/interval.rb",
    "lib/opening_hours_converter/opening_hours_builder.rb",
    "lib/opening_hours_converter/opening_hours_date.rb",
    "lib/opening_hours_converter/opening_hours_parser.rb",
    "lib/opening_hours_converter/opening_hours_rule.rb",
    "lib/opening_hours_converter/opening_hours_time.rb",
    "lib/opening_hours_converter/day.rb",
    "lib/opening_hours_converter/week.rb",
    "lib/opening_hours_converter/year.rb",
    "lib/opening_hours_converter/iterator.rb",
    "lib/opening_hours_converter/public_holiday.rb",
    "lib/opening_hours_converter/wide_interval.rb"
  ]
  s.homepage ='https://github.com/Publidata/opening_hours_converter'
  s.license = 'AGPL-3.0'
end
