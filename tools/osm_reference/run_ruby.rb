# Runs the gem over the corpus. Without an argument it evaluates every pattern
# over 2026 and writes results_ruby.json; with "probe" it uses the per-pattern
# windows of windows.json and writes results_ruby_probe.json. A second argument
# renames the output, so the same corpus can be run against several branches.
require 'json'
require 'time'
require 'opening_hours_converter'

HERE = File.dirname(File.expand_path(__FILE__))
PROBE = ARGV[0] == 'probe'
SUFFIX = ARGV[1].to_s

def stamp(text)
  year, month, day, hour, minute = text.scan(/\d+/).map(&:to_i)
  Time.new(year, month, day, hour, minute)
end

def clock(time)
  format('%04d-%02d-%02d %02d:%02d', time.year, time.month, time.day, time.hour, time.min)
end

jobs =
  if PROBE
    JSON.parse(File.read(File.join(HERE, 'windows.json'))).map do |window|
      { 'pattern' => window['pattern'],
        'from' => stamp(window['from']), 'to' => stamp(window['to']) }
    end
  else
    JSON.parse(File.read(File.join(HERE, 'corpus.json'))).map do |entry|
      { 'family' => entry['family'], 'pattern' => entry['pattern'],
        'from' => Time.new(2026, 1, 1), 'to' => Time.new(2027, 1, 1) }
    end
  end

results = jobs.map do |job|
  out = { 'family' => job['family'], 'pattern' => job['pattern'] }

  begin
    parsed = OpeningHoursConverter::OpeningHoursParser.new.parse(job['pattern'])
    out['parse'] = 'ok'
    begin
      out['rebuilt'] = OpeningHoursConverter::OpeningHoursBuilder.new.build(parsed)
    rescue StandardError, SyntaxError => e
      out['build_error'] = "#{e.class}: #{e.message}"
    end
  rescue StandardError, SyntaxError => e
    out['parse'] = 'error'
    out['parse_error'] = "#{e.class}: #{e.message}"
  end

  begin
    raw = OpeningHoursConverter::Iterator.new.get_open_intervals(job['pattern'], job['from'], job['to'])
    out['status'] = 'ok'
    out['count'] = raw.length
    out['intervals'] = raw.map { |i| { 'start' => clock(i[:start]), 'end' => clock(i[:end]) } }
  rescue StandardError, SyntaxError => e
    out['status'] = 'eval_error'
    out['error'] = "#{e.class}: #{e.message}"
  end

  out
end

file = "results_ruby#{PROBE ? '_probe' : ''}#{SUFFIX}.json"
File.write(File.join(HERE, file), JSON.pretty_generate(results))
puts "ruby#{PROBE ? ' probe' : ''}: #{results.length} patterns, " \
     "#{results.count { |r| r['status'] != 'ok' }} non-ok -> #{file}"
