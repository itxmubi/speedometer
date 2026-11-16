# 0004: Durable completion, calendar rollover and focused trip review

Date: 2026-10-28

## Decisions

- Finish/reset stop acquisition, wait for pending session creation and writes,
  and commit the final paused statistics before completing. A typed storage
  failure preserves the paused session for retry. Discard deletes the trip and
  its cascading samples in one SQLite transaction, retaining the distance ledger.
  Controls remain busy until completion; Start cannot race a discard. Trips may
  be finished before the first GPS fix.
- Totals combine the database ledger with a cancellable local-midnight timer.
  Re-subscription on app resume accounts for clock/timezone changes while hidden.
  Local dates use calendar constructors so DST days are not assumed to be 24 hours.
- History filters by local date range and active/completed state in SQLite before
  applying bounded 20-record pages, fetching one extra record for Next. Ordering
  uses start time and ID for ties. The repository retains an unbounded query for
  existing internal consumers; the history screen always supplies a bounded query.
  Activity and user labels are not persisted in the current schema, so no activity
  filter or label search is offered. Concurrent deletions/insertions can shift
  offset pages; this is a live local history, not a frozen export snapshot.
- A separate focused-display route reuses the selected instrument, units, warning
  state, HUD mirroring and optional HUD fields. Pause/Finish remain outside the
  scrolling instrument. Leaving the display does not start or stop tracking.
  A settings category menu offers direct access and an All settings view.
- Regional map detail is an explicit local GeoJSON import, with mandatory source
  attribution, a 5 MiB byte limit, 2,000 feature limit and 50,000 coordinate limit.
  Only LineString/MultiLineString features are accepted. File reads are bounded;
  parsing runs on an isolate and projected paths are cached independently of replay.
  Each trip screen owns its imported layer in memory. Closing the screen releases
  it; it is not copied into the database, backups or GPX exports. No network source,
  download, automatic upload or new permission is introduced. A cancelled picker
  keeps the existing layer; invalid imports show a localized error.
- CI enforces instrumented handwritten line coverage: overall 85%, domain 90%,
  data 85%, main session controller 80%. Generated Dart is excluded. This measures
  lines present in LCOV, not native Kotlin or uninstrumented Dart files. Gate tests
  verify exclusion, duplicate records, missing groups and passing/failing results.

## Acceptance limits

No schema or dependency changes. Native hardware/reference accuracy, OEM endurance,
real document-picker selection, physical alerts, battery/frame measurements and
production release preparation require separate recorded acceptance. Existing
synthetic flows and widget tests do not establish those hardware outcomes.
