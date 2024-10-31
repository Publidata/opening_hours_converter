# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'opening_hours_converter'
  s.version = '1.14.4'
  s.summary = 'Datetime range to opening hours, opening hours to datetime range'
  s.description = 'Datetime range to opening hours, opening hours to datetime range. Very strongly inspired by YoHours.'
  s.authors = ['Publidata']
  s.email = 'tech@publidata.io'
  s.add_runtime_dependency 'json'
  s.files = Dir['{lib}/**/*', 'README.md']
  s.homepage = 'https://github.com/Publidata/opening_hours_converter'
  s.license = 'AGPL-3.0'

  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
end
