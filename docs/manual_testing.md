# Android device validation

Automated tests cover logic and application wiring with synthetic coordinates.
They do not establish road accuracy or hardware behavior. No Android device was
connected for the 2026-10-22 session. On October 27, a Samsung SM-A536E was
initially visible to ADB but disconnected before the integration run started.
The hardware checks below remain pending; record actual outcomes rather than
checking them off from code inspection.

Use [the detailed native checklist](android_platform.md) for service, notification,
overlay, widget, compass, audio and display behavior. Do not publish personal
routes. A passenger should operate the phone during moving/reference tests.

## GPS, permissions and tracking

- [ ] Fresh installation: disclosure precedes any prompt; Continue alone starts no GPS.
- [ ] Deny, retry and permanently deny precise location; verify localized recovery.
- [ ] Try approximate permission, disabled location and weak reception. No stale nonzero speed.
- [ ] Compare stationary jitter and moving speed/distance with reference GPS/OBD2.
      Record device, Android version, conditions, sample cadence and deviations.
- [ ] Check light smoothing suppresses small fluctuations without delaying starts,
      stops or meaningful changes. Compare normal 1 s and economy 3 s updates.
- [ ] Evaluate calibration against a known odometer; it changes future distance only.
- [ ] Pause/move/resume and lose/recover GPS for more than ten seconds, including
      before the first fix and while hidden. The session waits and recovers without
      another Start; no stale speed or distance/time bridge across gaps.
- [ ] With background tracking enabled, minimize and lock for at least 10 minutes.
      Confirm samples persist and notification Stop ends GPS/overlay updates.
- [ ] With background tracking disabled, hiding pauses; returning never resumes GPS.
      Disable background tracking while already hidden and verify GPS stops.
- [ ] Swipe task, force-stop and reopen. Recover only committed statistics, paused;
      no boot restart, duplicate service or automatic location collection.
- [ ] Android notification grant/denial, revocation during tracking, rapid Start/Pause
      with no fixes, GPS off/on and rotation during permission UI.

## Display, sensors and alerts

- [ ] Small phone/tablet, portrait/both landscapes, 200% text and TalkBack.
- [ ] Four units, all gauges, range/limit markers, handed layout, ten accents,
      light/dark, mirrored/night HUD and selected time/compass/trip HUD fields.
- [ ] Keep-awake/brightness restore when hidden or stopped.
- [ ] Compass in all orientations, absent/unreliable sensor and reference heading.
- [ ] Sound/vibration/offline speech, warning offset/volume/cooldown, music playing,
      DND, absent vibration motor and missing installed speech voice.
- [ ] Overlay grant/deny/revoke, drag/resize/close; widget idle/active/lost-fix/Stop/reboot.
      Check touch targets and textual warnings, including when minimized.
- [ ] Low-end profile run of at least one hour: battery change, temperature, frame
      timing and responsiveness for normal/economy intervals.

## Trips, privacy and local documents

- [ ] Finish/save/history order/detail/endpoints/chart; replay play/pause/seek.
- [ ] Focused display in both orientations with 200% text/TalkBack: selected
      instrument/mirrored HUD, unavailable GPS, visible Pause/Finish before first fix,
      exit back to dashboard; settings category menu and All settings.
- [ ] History date/status filters and Previous/Next with over 40 trips, empty
      filtered pages, deletion on the last page and chosen-unit formatting.
- [ ] Leave idle across midnight/month/week boundaries; check totals refresh
      without a new trip, and after changing timezone while app is hidden.
- [ ] Map pan/pinch, coarse-basemap attribution and over-limit warning segments.
- [ ] Local regional GeoJSON picker: disclosure, cancel, attributed LineString and
      MultiLineString data, invalid/oversize files, remove, release after leaving
      detail; no network and no imported map in backups/GPX exports.
- [ ] Route privacy off/on and pause/GPS gaps never join hidden coordinates.
- [ ] GPX/CSV and summary through real Android share sheet; verify selected units.
- [ ] Restart preserves trips/totals; deleting history retains lifetime totals.
- [ ] Export/restore current backup, restore an old v1 backup, cancel file selection,
      reject corrupt documents; actual Android document picker/share destinations.
- [ ] Data deletion clears trips, routes, odometer, fuel/costs and settings.
      Exported files remain untouched. Airplane mode needs no map/voice downloads.

## Activity modes and fuel/costs

- [ ] All five modes remember unit/gauge/range after switching and app restart.
- [ ] Activity/weight remain locked during active, paused and recovered trips.
      Finish/reset permits changes; weight off and vehicle modes show no calories.
- [ ] Calories increase only with accepted moving time; no pause/GPS-gap calories.
- [ ] Fuel interval and maintenance-only entry, edit/delete/confirmation/date picker.
- [ ] km/mi, L/US gallons, weighted consumption, currency-separated costs and mileage link.
- [ ] Localized decimal entry and formatting in English/Spanish/French/German/Arabic,
      Arabic digits and RTL; reject malformed or negative inputs.
- [ ] Fuel/costs survive restart and backup/restore; older v1 restore has no fuel entries.

## Result record

For each run record: date, build, device/OS, permission state, scenario, duration,
expected/observed behavior, and pass/fail. Record reference deviations and battery
measurements as numbers. Keep exact routes out of shared evidence. Production
release preparation is tracked separately in the plan and was excluded here.
