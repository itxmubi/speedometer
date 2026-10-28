# Changelog

## Unreleased — 2026-10-28

- Preserve paused trips on failed completion/checkpoints; atomically discard
  history while retaining totals, and wait for pending trip creation on reset.
- Refresh calendar totals at local midnight and on foreground return.
- Add a focused instrument route with persistent Pause/Finish controls and a
  settings category menu.
- Filter history by date and recording status with bounded 20-record pages.
- Import attributed regional GeoJSON road lines locally for the open trip screen,
  with bounded input validation, isolate decoding and cached projection.
- Add storage/calendar/UI/import regressions and enforced handwritten coverage
  thresholds in CI. Hardware acceptance and production release work remain pending.

## Previous reliability improvements — 2026-10-27

- Keep user-started tracking alive through silent GPS loss, clearing stale speed
  and reanchoring statistics on reception recovery.
- Reject cached/reordered native fixes and coordinate spikes before display,
  alerts and route recording, sharing displacement checks with the odometer.
- Wait for pending native startup during cancellation; pause when background
  tracking is disabled while hidden.
- Stop reapplying display/GPS settings per fix; keep unchanged GPS requests
  registered, skip identical native redraws and replace stale polling with a
  single rescheduled deadline. Late display updates cannot revive stopped speed.
- Preserve typed GPS configuration failures. Added regression coverage and updated
  the device checklist; road accuracy and battery measurements remain pending.

## Previous implementation — 2026-10-22

- Added car, cycling, walking, running and boating modes with remembered units,
  gauge styles/ranges, optional local weight and rough moving-time calories.
- Added local fuel/vehicle-cost entries, editing/deletion, km/mi and L/US-gallon
  inputs, weighted consumption, currency-separated summaries and mileage access.
- Added Drift v2 migration preserving v1 trips/totals and version 2 backups with
  fuel records, backward-compatible v1 restore and comprehensive data deletion.
- Fixed controller startup/disposal races, localized map attribution, replay Play
  assertion, stale replay progress, hidden-route marker and route simplification gaps.
- Added light Doppler jitter smoothing with immediate starts/stops/large changes.
- Expanded tests for native-stream cancellation, alerts/background Stop, local
  restore, activity/fuel rules, migrations, localized entry and trip/map screens.
- Reconciled plan/README/device checklist with saved trips, native background
  service/notification, overlay/widget, compass, alerts, display controls, five
  languages and backup/restore already present in the expanded source.
- Production release preparation remains deferred; hardware acceptance still
  needs a connected Android device and reference/battery measurements.

## 0.1.0 — 2026-10-21

- Replaced Flutter counter starter with the first offline GPS speedometer core.
- Added clean architecture, Riverpod, GoRouter guards, localized Material 3
  display, foreground GPS adapters, quality filtering and session trip stats.
- Added four speed units, digital/analog/mirrored HUD, simple view, appearance
  settings, manual visual speed warnings and device-local display preferences.
- Added deterministic tests, responsive checks, Android target configuration,
  CI, architecture notes, manual device checklist and newest-first project memory.
- Background services, persistent trip storage and remaining release features
  are pending; this is a prototype milestone.
