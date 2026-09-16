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

| | at 1.16.0 | since #59 | since a timed `off` rule subtracts (#62) | since fallback rules are applied |
|---|---|---|---|---|
| matches the reference | 55 / 107 | 75 / 107 | 76 / 107 | 78 / 107 |
| raises where it should not | 45 | 22 | 22 | 22 |
| silently returns wrong intervals | 7 | 10 | 9 | 7 |

The last column is what the counts below describe. #59 closed 20 gaps, and
raised the silent count while doing it: it taught the parser to read `||` and
`unknown`, which the evaluator then ignored, so three strings that used to fail
loudly answered incompletely instead. Applying the fallback rule takes two of
those three back. Findings 3 and 9.

#62 closed finding 1, the one that mattered most: it was the only everyday
string the gem answered wrongly without raising.

Closed findings keep their number and their section rather than leaving the
ones after them to shift, so what a commit or a pull request calls finding 3
stays finding 3.

Two families are fully covered and stay that way: plain weekday and month
selectors, week selectors including `week 1-53/2`, wrapping weekday ranges
(`Fr-Mo`), month-day ranges across the new year (`Dec 25-Jan 05`), and rule
ordering with `;`.

## The gaps, worst first

Severity here is about what a caller sees. A raised `ParseError` is loud and
can be handled; wrong intervals returned with no error cannot.

### 1. A timed `off` rule inverts the day — closed

**Severity: was critical. Was silent.**

```
Mo-Fr 08:00-18:00; Mo-Fr 12:00-13:00 off
```

The reference reads a lunch break: open 08:00-12:00 and 13:00-18:00, 522
intervals over 2026. The gem returned the lunch break itself as the opening
hours — 261 intervals of 12:00-13:00, and nothing else.

The parser read the `off` as if it stood alone. A rule modifier takes the
weekdays of the selector before it, and here that selector was a time, so the
modifier fell back to closing the whole week and the times it was meant to
close were added as the only opening. A modifier that follows a time selector
now belongs to those hours: they are cut out of what earlier rules left open,
and the day around them survives. `OpeningHoursBuilder` rebuilds the string as
`Mo-Fr 08:00-12:00,13:00-18:00`, which says the same thing without the `off`.

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

### 3. Fallback rules are applied, except where the fallback is a bare comment

**Severity: low, was high. Silent.**

```
Mo-Fr 08:00-12:00 || Sa 10:00-12:00
Jan-Mar Mo-Fr 08:00-12:00 || 10:00-11:00
```

Both are now what the reference returns. Since #59 the `||` separator parsed
and `OpeningHoursBuilder` round-tripped the string unchanged, but the rule
behind it was dropped before it reached the evaluator, so all 52 Saturday
intervals of the first pattern and all 301 intervals of the second were
missing. Both sides of the `||` are parsed now, and a fallback rule writes the
minutes the rules before it leave closed and none of the ones they open —
including minutes an explicit `off` closed, which is what the reference does
and what makes its own example, `Mo-Fr 12:00-14:00; PH off || "by
appointment"`, mean anything.

What is left of the finding is

```
Mo-Fr 08:00-12:00 || "call us"
```

where the fallback carries neither a time nor a modifier. The reference reports
every minute outside Mo-Fr 08:00-12:00 as open-but-unknown, 523 intervals
alternating between the two states. The gem covers exactly the same minutes,
but as plain open, so it returns them as one run per year. Splitting them is
finding 9, not this one.

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

`easter` alone works; offsets from it, and from `PH`, do not. `SH` is not recognised at all. `SH` also has no answer without a
regional calendar, so it shares the decision of finding 2.

### 7. Weekday-occurrence offsets

**Severity: low. Loud.**

```
Su[-1] +1 day 10:00-12:00   Sa[1] -1 day 10:00-12:00   Su[1] +2 days 10:00-12:00
```

`Su[-1]` itself landed with #59. The `+1 day` suffix after it did not, and it
is the natural next step from that work: the day offset is the same grammar as
in finding 6.

### 8. Three isolated selectors

**Severity: low. Loud.**

| Pattern | What happens |
|---|---|
| `Mo 10:00-26:00` | `ParseError: Unsupported selector`. Hours past 24 are how the spec writes a night that runs long; `20:00-03:00` works, so only the notation is missing. |
| `Mo 10:00-12:00+` | `ParseError`. Open end after a range. Plain `10:00+` works. |
| `2020-2030/2 Mo-Fr 08:00-12:00` | `ParseError`. A step in a year range. `week 1-53/2` already works, so the step logic exists and only the year selector is missing. |

### 9. `unknown` contributes nothing

**Severity: low.**

```
Mo-Fr 08:00-12:00; Sa unknown
Mo-Fr 08:00-12:00 || "call us"
```

The reference reports Saturday as a flagged interval — open, but not certain.
The gem reads the rule and returns nothing for Saturday. A comment with no
modifier is the same third state, so the second pattern is here too since
finding 3 closed: the gem covers the right minutes and calls all of them open.
Deciding this needs an answer to what `get_open_intervals` should return for a
maybe, which today it has no way to express.

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

<<<<<<< HEAD
1. **Finding 3**, applying fallback rules. The parsing is already there, and
   until the evaluator uses it the string parses and answers wrongly.
=======
1. **Finding 1**, the timed `off` rule. Small, self-contained, and the only
   one that hands a caller a wrong answer for an everyday string.
>>>>>>> 98bf2b6 (feat: apply the fallback rule behind ||)
2. **Finding 8**, the three isolated selectors. Each is a small addition to
   grammar that already exists.
3. **Findings 2 and 4 together**, once the API question they share — where a
   region and a pair of coordinates are given to the gem — has an answer.
4. **Findings 5, 6, 7, 9**, in whatever order the callers' data argues for.
<<<<<<< HEAD
=======
   Answering 9 is what closes the rest of 3.
>>>>>>> 98bf2b6 (feat: apply the fallback rule behind ||)

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
