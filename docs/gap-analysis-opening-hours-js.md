# What the gem does not read yet

A comparison of `opening_hours_converter` against
[opening_hours.js](https://github.com/opening-hours/opening_hours.js) 3.14.0,
the reference implementation of the OpenStreetMap
[opening_hours specification](https://wiki.openstreetmap.org/wiki/Key:opening_hours/specification).

Every claim below was produced by running both implementations, not by reading
either one. The corpus, the runners and the generator live in
`tools/osm_reference/`; the result is `spec/fixtures/osm_patterns.yml`, which
`spec/osm_patterns_spec.rb` turns into one example per pattern.

## How it was measured

107 patterns, one per production of the grammar, each evaluated twice by both
implementations: once over the whole of 2026, which catches a rule that goes
wrong anywhere in the year, and once over a fortnight placed on the pattern's
first occurrence, which pins the exact boundaries. `opening_hours.js` runs in
mode 2, so points in time count as valid, with nominatim `fr` /
Île-de-France at lat 48.8566, lon 2.3522.

Four patterns are in the corpus precisely because `opening_hours.js` rejects
them (`Xx 10:00-12:00`, `Jan 01 +1 day 10:00-12:00`, …). The gem rejects all
four as well, so it does not silently invent an answer for nonsense.

| | on `master` (1.16.0) | on `feat/osm-nth-weekday-and-extended-grammar` |
|---|---|---|
| matches the reference | 55 / 107 | 75 / 107 |
| raises where it should not | 45 | 22 |
| silently returns wrong intervals | 7 | 10 |

The branch in flight raises the silent count because it teaches the parser to
read `||` and `unknown`, which the evaluator then ignores: a string that used
to fail loudly now answers, incompletely. Findings 3 and 9 below.

The branch in flight closes 20 of the gaps on its own. The counts below, and
the `status` of each fixture entry, are stated against `master`, the base of
this branch; entries that branch already fixes carry a `fixed_by` field.

Two families are fully covered and stay that way: plain weekday and month
selectors, week selectors including `week 1-53/2`, wrapping weekday ranges
(`Fr-Mo`), month-day ranges across the new year (`Dec 25-Jan 05`), and rule
ordering with `;`.

## The gaps, worst first

Severity here is about what a caller sees. A raised `ParseError` is loud and
can be handled; wrong intervals returned with no error cannot.

### 1. A timed `off` rule inverts the day

**Severity: critical. Silent.**

```
Mo-Fr 08:00-18:00; Mo-Fr 12:00-13:00 off
```

The reference reads a lunch break: open 08:00-12:00 and 13:00-18:00, 522
intervals over 2026. The gem returns the lunch break itself as the opening
hours — 261 intervals of 12:00-13:00, and nothing else. `OpeningHoursBuilder`
rebuilds the string as `Mo-Fr 12:00-13:00; Sa,Su off`, which shows where it
goes: the `off` modifier is dropped, and the rule that was meant to subtract a
window becomes the only window.

This is the one finding that produces a plausible-looking wrong answer for a
very common shape. Present on both branches.

### 2. Public holidays are a fixed national list

**Severity: high. Silent.**

`PH` resolves through `OpeningHoursConverter::PublicHoliday.ph_for_year`, which
returns the same days everywhere. It includes four days that are not public
holidays in Île-de-France: Good Friday (2026-04-03) and St Stephen's
(2026-12-26), which are Alsace-Moselle only, and Easter Sunday (2026-04-05)
and Pentecost Sunday (2026-05-24), which are Sundays rather than holidays.

So `PH 10:00-12:00` opens on 15 days where the reference opens on 11, and
`Mo-Fr 08:00-12:00; PH off` closes a Friday that should stay open. Every
pattern touching `PH` inherits the difference.

Implementing this needs a product decision first: the gem currently has no
place to say which region it is computing for. The fixture records the
Île-de-France answer as the target, which presupposes that a region becomes
configurable (and what its default is).

### 3. Fallback rules are parsed and then ignored

**Severity: high. Silent on the branch in flight.**

```
Mo-Fr 08:00-12:00 || Sa 10:00-12:00
Jan-Mar Mo-Fr 08:00-12:00 || 10:00-11:00
```

On `master` the `||` separator raises. On the branch in flight it parses, and
`OpeningHoursBuilder` even round-trips the string unchanged — but the fallback
is never applied: all 52 Saturday intervals of the first pattern, and all 301
intervals of the second, are missing. A rule that parses and rebuilds
correctly while contributing nothing is the shape most likely to pass review
unnoticed.

### 4. Variable times

**Severity: medium. Loud.**

```
Mo sunrise-sunset          Mo-Fr dawn-dusk
Mo (sunrise+01:00)-sunset  Mo sunrise-(sunset-00:30)
Mo-Fr 08:00-sunset
```

None parse. All five are `ParseError`. This is the largest single family still
missing and the most expensive: it needs a solar calculation and coordinates,
which the gem's API has nowhere to accept today. The same API question as `PH`,
and worth answering once for both.

### 5. Points in time and repeating intervals

**Severity: medium. Loud.**

```
Mo 10:00              Mo-Fr 09:00,17:00
Mo-Fr 10:00-16:00/60  Mo-Fr 10:00-16:00/01:00  Mo 10:00-12:00/30
```

`Mo 10:00` fails with `NoMethodError: undefined method 'hyphen?' for nil` —
the tokens handler walks off the end of the token list instead of reporting
what it expected. Whether the gem should support points in time at all is a
scope decision (`opening_hours.js` gates them behind a mode); the crash is a
bug either way.

### 6. Holiday arithmetic and school holidays

**Severity: medium. Loud.**

```
PH -1 day 10:00-12:00   PH +1 day 10:00-12:00
easter +1 day 10:00-12:00   easter -2 days off
SH 10:00-12:00   SH Mo-Fr 08:00-12:00
```

`easter` alone works on the branch in flight; offsets from it, and from `PH`,
do not. `SH` is not recognised at all. `SH` also has no answer without a
regional calendar, so it shares the decision of finding 2.

### 7. Weekday-occurrence offsets

**Severity: low. Loud.**

```
Su[-1] +1 day 10:00-12:00   Sa[1] -1 day 10:00-12:00   Su[1] +2 days 10:00-12:00
```

`Su[-1]` itself lands with the branch in flight. The `+1 day` suffix after it
does not, and it is the natural next step from that work: the day offset is
the same grammar as in finding 6.

### 8. Three isolated selectors

**Severity: low. Loud.**

| Pattern | What happens |
|---|---|
| `Mo 10:00-26:00` | `ParseError: Unsupported selector`. Hours past 24 are how the spec writes a night that runs long; `20:00-03:00` works, so only the notation is missing. |
| `Mo 10:00-12:00+` | `ParseError`. Open end after a range. Plain `10:00+` works on the branch in flight. |
| `2020-2030/2 Mo-Fr 08:00-12:00` | `ParseError`. A step in a year range. `week 1-53/2` already works, so the step logic exists and only the year selector is missing. |

### 9. `unknown` contributes nothing

**Severity: low.**

```
Mo-Fr 08:00-12:00; Sa unknown
```

The reference reports Saturday as a flagged interval — open, but not certain.
The gem reads the rule and returns nothing for Saturday. Deciding this needs an
answer to what `get_open_intervals` should return for a maybe, which today it
has no way to express.

## Where the gem is right and the reference is wrong

One entry in the fixture is marked `divergence` rather than `pending`:

```
Su 23:00-01:00
```

On the night the clocks go forward, 2026-03-29, `opening_hours.js` ends the
interval at 00:00 instead of 01:00 — it advances by a fixed duration and loses
the hour. The gem builds `Time` from wall clock components and returns
23:00-01:00, which is what the string says. The fixture stores the gem's own
output here, as a regression guard.

This is the reason the corpus is not simply "whatever `opening_hours.js`
prints": the reference is a reference, not an oracle.

## Suggested order

1. **Finding 1**, the timed `off` rule. Small, self-contained, and the only
   one that hands a caller a wrong answer for an everyday string.
2. **Finding 3**, applying fallback rules, once the branch in flight has
   landed — the parsing is already there.
3. **Finding 8**, the three isolated selectors. Each is a small addition to
   grammar that already exists.
4. **Findings 2 and 4 together**, once the API question they share — where a
   region and a pair of coordinates are given to the gem — has an answer.
5. **Findings 5, 6, 7, 9**, in whatever order the callers' data argues for.

## What this analysis does not cover

- One window, 2026. A leap year, or a year where the nth weekday of a month
  falls differently, could expose more.
- One locale. Public holidays were compared against Île-de-France only; another
  region would move finding 2's numbers, not its conclusion.
- `get_open_intervals` only. The parser and the builder are exercised through
  it and their errors are recorded, but round-tripping a string through
  `OpeningHoursBuilder` is not asserted, except where it explained a result.
- Patterns the grammar allows but nobody writes are in the corpus on the same
  footing as common ones. `spec/production_patterns_spec.rb` is the file that
  weighs them by how often a real dataset uses them; this one weighs them by
  what the specification says.
