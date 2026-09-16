// Runs opening_hours.js over the corpus. Without an argument it evaluates
// every pattern over 2026 and writes results_js.json; with "probe" it uses the
// per-pattern windows of windows.json and writes results_js_probe.json.
const fs = require('fs');
const path = require('path');
const opening_hours = require('opening_hours');

const PROBE = process.argv[2] === 'probe';

const NOMINATIM = {
  lat: 48.8566,
  lon: 2.3522,
  address: { country_code: 'fr', state: 'Île-de-France' },
};

function pad(n) { return String(n).padStart(2, '0'); }

function fmt(d) {
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ` +
         `${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function parseStamp(s) {
  const [d, t] = s.split(' ');
  const [y, mo, da] = d.split('-').map(Number);
  const [h, mi] = t.split(':').map(Number);
  return new Date(y, mo - 1, da, h, mi);
}

const jobs = PROBE
  ? JSON.parse(fs.readFileSync(path.join(__dirname, 'windows.json'), 'utf8'))
      .map((w) => ({ pattern: w.pattern, from: parseStamp(w.from), to: parseStamp(w.to) }))
  : JSON.parse(fs.readFileSync(path.join(__dirname, 'corpus.json'), 'utf8'))
      .map((e) => ({ family: e.family, pattern: e.pattern,
                     from: new Date(2026, 0, 1), to: new Date(2027, 0, 1) }));

const results = jobs.map((job) => {
  const out = { family: job.family, pattern: job.pattern };
  let oh;
  try {
    oh = new opening_hours(job.pattern, NOMINATIM, { mode: 2 });
  } catch (e) {
    out.status = 'parse_error';
    out.error = String(e.message || e);
    return out;
  }
  try {
    const raw = oh.getOpenIntervals(job.from, job.to);
    out.status = 'ok';
    out.count = raw.length;
    out.intervals = raw.map(([start, end, unknown, comment]) => ({
      start: fmt(start),
      end: fmt(end),
      unknown: !!unknown,
      comment: comment === undefined ? null : comment,
    }));
  } catch (e) {
    out.status = 'eval_error';
    out.error = String(e.message || e);
  }
  return out;
});

const file = PROBE ? 'results_js_probe.json' : 'results_js.json';
fs.writeFileSync(path.join(__dirname, file), JSON.stringify(results, null, 2));
console.log(`js${PROBE ? ' probe' : ''}: ${results.length} patterns, ` +
            `${results.filter((r) => r.status !== 'ok').length} non-ok -> ${file}`);
