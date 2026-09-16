// Pass 2 of the pipeline: pick, for every pattern, the short window the
// fixture compares interval by interval. It starts on the Monday on or before
// the pattern's first occurrence and lasts a fortnight, clamped to 2026.
const fs = require('fs');
const path = require('path');

const js = require('./results_js.json');
const master = require('./results_ruby.json');
const M = new Map(master.map((r) => [r.pattern, r]));

const YEAR_FROM = new Date(2026, 0, 1);
const YEAR_TO = new Date(2027, 0, 1);

function parseStamp(s) {
  const [d, t] = s.split(' ');
  const [y, mo, da] = d.split('-').map(Number);
  const [h, mi] = t.split(':').map(Number);
  return new Date(y, mo - 1, da, h, mi);
}

function pad(n) { return String(n).padStart(2, '0'); }
function fmt(d) {
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

const windows = js.map((j) => {
  // A pattern the reference rejects still gets a window, so the two runners
  // stay aligned on one list.
  const reference = j.status === 'ok' && j.intervals.length ? j.intervals :
    ((M.get(j.pattern).intervals || []).length ? M.get(j.pattern).intervals : null);

  let from = YEAR_FROM;
  if (reference) {
    const first = parseStamp(reference[0].start);
    const monday = new Date(first.getFullYear(), first.getMonth(), first.getDate());
    monday.setDate(monday.getDate() - ((monday.getDay() + 6) % 7));
    if (monday > YEAR_FROM) from = monday;
  }
  let to = new Date(from.getFullYear(), from.getMonth(), from.getDate() + 14);
  if (to > YEAR_TO) to = YEAR_TO;

  return { pattern: j.pattern, from: fmt(from), to: fmt(to) };
});

fs.writeFileSync(path.join(__dirname, 'windows.json'), JSON.stringify(windows, null, 2));
console.log('windows:', windows.length);
