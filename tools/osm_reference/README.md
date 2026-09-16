# OSM reference corpus

Regenerates `spec/fixtures/osm_patterns.yml`, the corpus behind
`spec/osm_patterns_spec.rb`. Expected values come from
[opening_hours.js](https://github.com/opening-hours/opening_hours.js), the
reference implementation.

Nothing here ships with the gem: the gemspec packages `lib` and the readme
only.

## Running it

```
cd tools/osm_reference
npm install
node run_js.js                                    # 2026, writes results_js.json
bundle exec ruby -I../../lib run_ruby.rb          # 2026, writes results_ruby.json
node make_windows.js                              # picks the probe windows
node run_js.js probe                              # probe windows, opening_hours.js
bundle exec ruby -I../../lib run_ruby.rb probe    # probe windows, the gem
node generate_fixture.js                          # writes osm_patterns.yml
cp osm_patterns.yml ../../spec/fixtures/
```

`run_ruby.rb` takes a second argument that suffixes its output file, so the
same corpus can be run against another branch:

```
git archive <branch> lib | tar -x -C /tmp/other
bundle exec ruby -I/tmp/other/lib run_ruby.rb "" _feat
```

`generate_fixture.js` reads `results_ruby_feat.json` to mark the entries a
branch in flight already fixes. Point it at the branch you are comparing
against, or regenerate that file from `master` to clear the annotations.

## What each pattern is worth

Two runs per pattern. The first covers the whole of 2026 and gives
`year_count`: it catches a rule that goes wrong anywhere in the year. The
second covers a fortnight starting on the Monday on or before the pattern's
first occurrence, and gives `probe_intervals`: it pins the exact boundaries
where they are easiest to read. Both windows are evaluated by both
implementations, so a truncation at the edge of a window is never mistaken for
a difference.

The reference runs in mode 2, which accepts points in time as well as time
ranges, with nominatim `fr` / Île-de-France at lat 48.8566, lon 2.3522. Change
those and the public holiday expectations change with them.

## Adding a pattern

Add it to `corpus.json` with its family, rerun the pipeline, commit the
regenerated fixture. An entry whose behaviour the gem gets wrong lands as
`pending`, which is the point.
