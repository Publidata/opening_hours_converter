// Last pass of the pipeline: turn the two runs into spec/fixtures/osm_patterns.yml.
const fs = require('fs');
const path = require('path');

const js = require('./results_js.json');
const master = require('./results_ruby.json');
const jsProbe = require('./results_js_probe.json');
const masterProbe = require('./results_ruby_probe.json');
const windows = require('./windows.json');

// Optional: a run of a branch in flight, which annotates the entries that
// branch already fixes. Absent once there is nothing in flight to compare to.
let feat = null;
try {
  feat = require('./results_ruby_feat.json');
} catch (e) {
  if (e.code !== 'MODULE_NOT_FOUND') throw e;
}

const M = new Map(master.map((r) => [r.pattern, r]));
const F = feat ? new Map(feat.map((r) => [r.pattern, r])) : null;
const JP = new Map(jsProbe.map((r) => [r.pattern, r]));
const MP = new Map(masterProbe.map((r) => [r.pattern, r]));
const W = new Map(windows.map((w) => [w.pattern, w]));

// Patterns where opening_hours.js is knowingly wrong and the gem is right. The
// fixture stores the gem's own output for these, as a regression guard.
const DIVERGENCE = {
  'Su 23:00-01:00':
    'opening_hours.js loses an hour on the spring-forward night (it ends the ' +
    '2026-03-29 interval at 00:00 instead of 01:00); the gem builds Time from ' +
    'wall clock components and stays right',
  'Sa[1] -1 day 10:00-12:00':
    'when the offset puts two occurrences in the same month, ' +
    'opening_hours.js enumerates only the later one: it drops 2026-07-03 ' +
    '(the day before the first Saturday of July) and keeps 2026-07-31 (the ' +
    'day before the first Saturday of August). Its own getState() answers ' +
    'true for 2026-07-03, so getOpenIntervals contradicts it; the gem ' +
    'returns all 12 days',
};

const FEAT_BRANCH = 'feat/osm-nth-weekday-and-extended-grammar';

function key(i) { return `${i.start} -> ${i.end}`; }
const same = (a, b) => a.length === b.length && a.every((v, k) => v === b[k]);

function verdict(j, r) {
  if (j.status !== 'ok' && r.status !== 'ok') return 'both_reject';
  if (j.status !== 'ok') return 'ruby_accepts_invalid';
  if (r.status !== 'ok') return 'ruby_error';
  const jsAll = j.intervals.map(key);
  const jsKnown = j.intervals.filter((i) => !i.unknown).map(key);
  const rbAll = r.intervals.map(key);
  if (same(jsAll, rbAll)) return 'match';
  if (same(jsKnown, rbAll)) return 'match_ignoring_unknown';
  return 'mismatch';
}

// Intervals joined where they touch. opening_hours.js cuts a run in two where
// the state turns "unknown"; the gem, which knows only open and closed, does
// not, and merging tells that difference apart from a rule going missing.
function merged(intervals) {
  const result = [];
  intervals.forEach((i) => {
    const last = result[result.length - 1];
    if (last && last.end >= i.start) {
      if (i.end > last.end) last.end = i.end;
    } else {
      result.push({ start: i.start, end: i.end });
    }
  });
  return result.map(key);
}

function yamlString(s) {
  return `"${s.replace(/\\/g, '\\\\').replace(/"/g, '\\"')}"`;
}

const lines = [
  '# Every selector of the OpenStreetMap opening_hours specification.',
  '#',
  '# Expected values come from opening_hours.js 3.14.0 in mode 2, with',
  '# nominatim fr / Île-de-France at lat 48.8566 lon 2.3522. year_count counts',
  '# the intervals of 2026; probe_intervals lists them one by one over the',
  '# shorter window, which starts on the Monday on or before the first',
  '# occurrence of the pattern.',
  '#',
  '# status:',
  '#   supported  - the gem returns the expected intervals',
  '#   pending    - it does not yet; reason says what happens instead',
  '#   invalid    - the string is not valid opening_hours; the gem must reject it',
  '#   divergence - the gem differs from opening_hours.js on purpose, and the',
  '#                expected values are its own',
  '#',
  '# fixed_by names a branch already in flight that turns the entry green.',
  '#',
  '# Entries are never removed. Implementing a pattern means flipping its',
  '# status to supported, which is what RSpec asks for as soon as a pending',
  '# example passes. tools/osm_reference/ regenerates this file.',
  '',
];

const counts = { supported: 0, pending: 0, invalid: 0, divergence: 0 };

js.forEach((j) => {
  const rm = M.get(j.pattern);
  const vm = verdict(j, rm);
  const vf = F ? verdict(j, F.get(j.pattern)) : vm;
  const window = W.get(j.pattern);

  let status;
  let reason = null;
  let probeSource;

  if (DIVERGENCE[j.pattern]) {
    status = 'divergence';
    reason = DIVERGENCE[j.pattern];
    probeSource = MP.get(j.pattern);
  } else if (vm === 'both_reject') {
    status = 'invalid';
    const detail = (j.error || '').split('<---')[1];
    reason = detail ? detail.replace(/^\s*\(|\)\s*$/g, '').trim()
                    : 'rejected by opening_hours.js';
  } else if (vm === 'match') {
    status = 'supported';
    probeSource = JP.get(j.pattern);
  } else {
    status = 'pending';
    probeSource = JP.get(j.pattern);
    if (vm === 'match_ignoring_unknown') {
      // The gem reads the rule but drops what an "unknown" modifier
      // contributes, where opening_hours.js reports it as a flagged interval.
      reason = 'the intervals an "unknown" rule contributes are missing';
    } else if (vm === 'mismatch' && j.intervals.some((i) => i.unknown) &&
               same(merged(j.intervals), merged(rm.intervals))) {
      // The gem covers the same minutes, in fewer intervals: it has one state
      // where the reference has two, so it cannot cut the run where the
      // reference does.
      reason = 'the same minutes are covered, but opening_hours.js splits them where the ' +
               'state turns "unknown", which get_open_intervals has no way to express';
    } else if (vm === 'ruby_error') {
      reason = rm.error.replace(/^OpeningHoursConverter::ParseError: /, 'ParseError: ');
    } else if (vm === 'ruby_accepts_invalid') {
      reason = 'the gem accepts a string opening_hours.js rejects';
    } else {
      const jsAll = j.intervals.map(key);
      const rbAll = rm.intervals.map(key);
      const jsSet = new Set(jsAll);
      const rbSet = new Set(rbAll);
      const missing = jsAll.filter((v) => !rbSet.has(v)).length;
      const extra = rbAll.filter((v) => !jsSet.has(v)).length;
      reason = `over 2026, ${missing} expected interval(s) missing and ${extra} unexpected`;
    }
  }

  counts[status] += 1;

  lines.push(`- family: ${j.family}`);
  lines.push(`  pattern: ${yamlString(j.pattern)}`);
  lines.push(`  status: ${status}`);
  if (reason) lines.push(`  reason: ${yamlString(reason)}`);
  if (status === 'pending' && vf !== vm &&
      (vf === 'match' || vf === 'match_ignoring_unknown')) {
    lines.push(`  fixed_by: ${yamlString(FEAT_BRANCH)}`);
  }

  if (status === 'invalid') {
    lines.push('');
    return;
  }

  const yearCount = status === 'divergence' ? rm.count : j.count;
  const probe = probeSource.intervals.map(key);

  lines.push(`  year_count: ${yearCount}`);
  lines.push(`  probe_from: ${yamlString(window.from)}`);
  lines.push(`  probe_to: ${yamlString(window.to)}`);
  if (probe.length === 0) {
    lines.push('  probe_intervals: []');
  } else {
    lines.push('  probe_intervals:');
    probe.forEach((i) => lines.push(`    - ${yamlString(i)}`));
  }
  lines.push('');
});

const out = path.join(__dirname, 'osm_patterns.yml');
fs.writeFileSync(out, lines.join('\n'));
console.log('written', out);
console.log(counts, 'total', js.length);
