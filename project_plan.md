# GPS Speedometer App: Project Plan (Flutter, Google Play)

**Prepared:** October 21, 2026
**Platform:** Android (Flutter), published on Google Play
**Current priority:** Free features first. Premium and rare features come later.

---

## Implementation Status — October 22, 2026

The source implements the core instruments, alerts/display controls, hardware
compass, Drift odometer/calendar totals, saved trips/history/charts/offline map
replay/export, native foreground service/notification, overlay/widget, five
languages, local backup/restore, activity modes/calorie estimates and fuel/cost
tracking. The bundled map has coarse land outlines; streets are not included.

Feature checkboxes below track implementation, with automated tests where
applicable. They do not certify road accuracy, hardware behavior or production
readiness. Device acceptance remains pending in
[docs/manual_testing.md](docs/manual_testing.md); current checks/limitations are
recorded in [PROJECT_MEMORY.md](PROJECT_MEMORY.md). Production release
preparation was explicitly excluded from the October 22 implementation session.
Premium and rare features remain deferred.

---

## 1. Goal and Positioning

Build a free, accurate, private GPS speedometer with HUD, floating overlay and trip history. It should have no intrusive ads and no account requirement, and it should work fully offline.

**Pitch:** "Accurate. Private. Free. A complete speedometer without the clutter."

**Why this can win:** many competing apps are ad-supported or lock basic features behind aggressive subscriptions. A complete free core with honest privacy practices is a real differentiator.

---

## 2. Research Summary: 20 Apps Reviewed

> Method note: 12 are Android listings and 8 are iOS apps used as feature benchmarks. Play Store pages could not be opened directly, so data came from Android Police's roundup, store-listing mirrors (BlueStacks, APKMirror) and App Store listings. Ratings and prices change often, so re-check live listings before business decisions.

| # | App | Platform | Standout features found |
|---|---|---|---|
| 1 | GPS Speedometer and Odometer (Cool Niks) | Android | Offline use, top/average/current speed, odometer, trip distance, compass, units mph/km/h/m/s/knots, text color options |
| 2 | Speedometer: GPS Speedometer (Simple Design) | Android | Speed limit alerts (vibration, voice, alarm), map trail recording, portrait and landscape, widgets, notification-bar display, theme colors, works on poor connection |
| 3 | GPS Speedometer: Odometer HUD (KTW Apps) | Android | HUD mode, floating window over navigation apps, trip odometer, fuel/mileage log, visual and audible limit alerts, no internet required, minimal data collection |
| 4 | DigiHUD Speedometer | Android | Ten color options, brightness control, compass, trip counters, Lite mode, HUD mode, widget |
| 5 | Speedometer GPS HUD Odometer (ForNextGen) | Android | Offline, HUD display, odometer calibration to match the car, dark and light themes |
| 6 | Speedometer PRO (Mobiem) | Android | Automatic average/max speed, distance and route recording, speed-vs-time graph, history sorted by date, tablet layout, widget |
| 7 | Bike Computer: Cycling Tool | Android | Current/max/average moving speed, saved routes, pause and resume, calorie counter |
| 8 | Waze | Android | Navigation with live traffic alerts and on-screen speed display |
| 9 | Ulysse Speedometer / Pro | Android | Analog or digital gauge, overlays on other apps, trip computer (today, week, month), HUD, average speed, speed-limit warnings, background status-bar mode. Known limitation: trip distance may deviate 2-3% from a car's odometer |
| 10 | GPS Speedometer: MPH Tracker | Android | Speed limit shown on analog and digital gauges, indicator changes color when over the limit, music can play in the background |
| 11 | GPS Speedometer: Speed Tracker | Android | Speed limit alerts via vibration, loud audible warning and danger alert |
| 12 | Speedometer for Wear OS | Android (watch) | Glanceable wrist speed readout for walking, running, cycling, driving; haptic speed alerts as an optional paid feature |
| 13 | Speedometer GPS: HUD Display | iOS | Altitude and direction per trip, HUD, custom limit alerts, interactive trip replay with over-limit segments marked |
| 14 | Speedometer GPS Speedmeter | iOS | Automatic road speed limit detection, Picture-in-Picture floating speedometer, adjustable scales, left/right-handed positioning, speed limit approach alerts |
| 15 | Simple Speedometer: Pure Speed | iOS | Widget-based dashboard (music, compass, altitude, odometer, start pointer, track recorder), PiP, Apple Watch companion, screen turns red when over limit |
| 16 | GPS Speedometer: MPH Tracker (dash cam) | iOS | Dash-cam mode, automatic accident detection that alerts emergency contacts, journey tracking |
| 17 | Speedometer HUD (Foobar Creative) | iOS | Speed camera locations on a map (paid upgrade), prevent screen lock, unit settings |
| 18 | Speedometer: Driving Tracker | iOS | Digital, analog and HUD views, CarPlay, OBD2 support |
| 19 | Mileage Tracker: Speed Limit | iOS | Historic trip data, localized speed limits, multilingual alerts |
| 20 | Digital Speedometer: Speed HUD | iOS | Multiple speedometer styles, HUD for night driving, custom alerts, no data collected |

Additional items seen in the research: G-force meter, barometric altitude, moving vs. stopped time, left-handed layout, music controls, weather updates and left/right gauge scales.

---

## 3. Complete Feature List

Everything found in the research is listed below, ordered by priority. **Free features come first.**

### 3.1 FREE: Core Speedometer (P0, must ship in v1.0)

- [x] Live GPS speed (Doppler-based speed from the location API, not distance divided by time)
- [x] Current speed
- [x] Average speed
- [x] Maximum / top speed
- [x] Moving average speed (excludes stopped time)
- [x] Units: km/h, mph, m/s, knots
- [x] Digital gauge
- [x] Analog gauge
- [x] Simple view (speed only) and detailed view (extra stats)
- [x] GPS signal and accuracy indicator
- [x] Works fully offline
- [x] Portrait and landscape modes
- [x] Tablet-friendly layout
- [x] Keep-screen-awake option
- [x] Pause and resume
- [x] Reset trip

### 3.2 FREE: Odometer and Trip Stats (P0)

- [x] Odometer (total distance)
- [x] Trip meter (per-trip distance)
- [x] Trip duration and moving time
- [x] Altitude
- [x] Heading / direction
- [x] Digital compass
- [x] Start and end point of trip
- [x] Odometer calibration factor (to match the vehicle's odometer, addressing the 2-3% drift seen in other apps)
- [x] Today / this week / this month totals

### 3.3 FREE: Speed Limit Alerts (P0)

- [x] User-set custom speed limit
- [x] Alert by sound
- [x] Alert by vibration
- [x] Voice alert (text-to-speech)
- [x] Screen turns red / indicator changes color when over the limit
- [x] Speed limit marker shown on analog and digital gauges
- [x] Adjustable alert threshold / offset
- [x] Alert on/off toggle and volume control

### 3.4 FREE: HUD and Display (P0)

- [x] Head-Up Display mode (large readout for windshield use)
- [x] Mirrored HUD mode (for reflection on the windshield)
- [x] Maximum-contrast dark display for night driving
- [x] Brightness control
- [x] Dark and light themes
- [x] Multiple color themes (aim for 10 colors)
- [x] Multiple gauge styles
- [x] Left-handed / right-handed gauge positioning
- [x] Adjustable speedometer scale and range
- [x] Choice of what to show in HUD (speed, time, compass, etc.)

### 3.5 FREE: Trip Recording and History (P1)

- [x] Automatic trip recording with start/stop
- [x] Route recorded on a map (can be turned on/off)
- [x] Trip history list sorted by date
- [x] Trip detail screen: distance, duration, average speed, max speed, start and end points
- [x] Speed-versus-time graph
- [x] Trip replay on a map with over-limit segments highlighted
- [x] Delete trips
- [x] Export trips as GPX / CSV
- [x] Share a trip summary
- [x] All data stored on the device

### 3.6 FREE: Overlay, Widgets and Background Use (P1)

- [x] Floating window overlay that stays on top of navigation apps (Google Maps, Waze, etc.)
- [x] Resizable floating speedometer
- [x] Home-screen widget
- [x] Speed shown in the notification bar / status bar
- [x] Runs in the background through a user-started foreground service
- [x] Notification with live speed and stop button
- [x] Visual limit warning while minimized

### 3.7 FREE: Fuel and Cost Tracking (P1)

- [x] Trip mileage log
- [x] Simple fuel consumption tracker (enter fuel and distance)
- [x] Vehicle operating cost overview

### 3.8 FREE: Activity Modes (P1)

- [x] Car mode
- [x] Bike mode (current, max, average moving speed, pause/resume)
- [x] Walking / running mode
- [x] Boating mode (knots)
- [x] Calorie estimate for cycling and walking (user enters weight)
- [x] Per-activity default units and gauge

### 3.9 FREE: Settings, Privacy and Quality (P0/P1)

- [x] Language localization (start with English plus 3-5 major languages)
- [x] No account required
- [ ] No unnecessary data collection, with a clear privacy policy and in-app disclosure (local-only implementation/disclosure exist; published policy and link are deferred release work)
- [x] Music playing in the background without interruption
- [x] Battery-friendly GPS updates
- [x] Accessibility: large text, high contrast, screen-reader labels
- [x] Backup and restore of settings and trips (local file)
- [x] Onboarding that explains each permission before asking

### 3.10 Free Feature Priority Summary

| Priority | Scope | Release |
|---|---|---|
| P0 | Sections 3.1, 3.2, 3.3, 3.4, core of 3.9 | v1.0 |
| P1 | Sections 3.5, 3.6, 3.7, 3.8, rest of 3.9 | v1.1 - v1.2 |

---

## 4. LATER: Premium / Optional Features (not in the current phase)

These were found in competitors, often behind paywalls. Treat them as post-launch options.

- [ ] Extra gauge skins and themes
- [ ] Unlimited trip storage (if the free tier is capped)
- [ ] Advanced analytics (acceleration 0-100, braking, top-speed records)
- [ ] Cloud backup (optional, opt-in)
- [ ] Ad removal (only if ads are ever added)
- [ ] Music controls inside the app
- [ ] Weather information

---

## 5. RARE FEATURES (found in few apps, evaluate last)

Listed at the end on purpose. Each needs separate research, cost or legal review.

| Feature | Seen in | Notes and risks |
|---|---|---|
| Automatic road speed limit detection | Speedometer GPS Speedmeter, Mileage Tracker | Needs a map/limit data source. Check licensing and cost. OpenStreetMap data is free but coverage varies |
| Localized / regional speed limits | Mileage Tracker | Depends on the same data source |
| Speed camera locations and alerts | Speedometer HUD, Speed Trap-type apps | Restricted or illegal in some countries. Region-gate or skip |
| Wear OS companion | Speedometer for Wear OS | Flutter support on Wear OS is limited, so a native Kotlin companion is likely |
| Android Auto display | Waze-style apps, Driving Tracker (CarPlay on iOS) | Needs the native Car App Library, so it can't be built in Flutter alone |
| OBD2 over Bluetooth | Speedometer: Driving Tracker | Hardware testing needed. Real vehicle speed instead of GPS |
| Dash-cam mode | GPS Speedometer: MPH Tracker (iOS) | Camera and storage permissions, heavy battery use, review risk |
| Accident / crash detection with emergency contacts | GPS Speedometer: MPH Tracker (iOS) | High liability. Needs careful testing and wording. Likely skip |
| G-force meter | Speedometer GPS Speedmeter | Uses accelerometer. Easy to prototype |
| Barometric altitude | Speedometer GPS Speedmeter | Device-dependent sensor |
| Picture-in-Picture mode | Speedometer GPS Speedmeter, Simple Speedometer | Needs native Android work from Flutter. Overlay may already cover it |
| Fully customizable widget dashboard | Simple Speedometer | Complex UI, good post-launch idea |
| Live traffic and navigation alerts | Waze | Out of scope. Use a floating overlay over a navigation app instead |
| Trip sharing with live location | Not widely seen | Privacy implications. Skip for now |

---

## 6. Flutter Technical Plan

### 6.1 Architecture

- **Language and framework:** Dart, Flutter (stable channel), Android first.
- **State management:** Riverpod (or Bloc, pick one and stay consistent).
- **Structure:** feature-first folders (`speedometer`, `trips`, `settings`, `overlay`, `alerts`), repository pattern for location and storage.
- **Local storage:** Drift (SQLite) for trips and track points, `shared_preferences` for settings.
- **Backend:** none. Everything is on-device, which keeps privacy simple.

### 6.2 Suggested packages

> Check current versions and maintenance status on pub.dev before locking dependencies.

| Need | Package (suggestion) |
|---|---|
| GPS location and speed | `geolocator` |
| Permissions | `permission_handler` |
| Background / foreground service | `flutter_foreground_task` or `flutter_background_service` |
| Floating overlay | `flutter_overlay_window` |
| Home-screen widget | `home_widget` |
| Compass and sensors | `flutter_compass`, `sensors_plus` |
| Maps (no API key needed) | `flutter_map` with OpenStreetMap tiles (follow tile usage policy) |
| Charts | `fl_chart` |
| Text-to-speech alerts | `flutter_tts` |
| Vibration | `vibration` |
| Alert sounds | `audioplayers` |
| Keep screen awake | `wakelock_plus` |
| Database | `drift` + `sqlite3_flutter_libs` |
| Export / share | `share_plus`, `path_provider`, a GPX writer |
| Localization | `flutter_localizations`, `intl` |
| Crash reporting | `firebase_crashlytics` (or a privacy-friendlier alternative) |

### 6.3 Accuracy approach

- Use the Doppler speed reported by the location API, not distance divided by time.
- Discard fixes with poor accuracy and show a GPS-quality indicator.
- Apply light smoothing (moving average or simple Kalman filter), and don't let smoothing add visible lag.
- Treat speeds under a small threshold as zero to avoid jitter when stopped.
- Test against a vehicle's own speedometer and a reference GPS device or OBD2 reader.
- Offer an odometer calibration factor.

### 6.4 Android-specific requirements

- **Foreground service of type location** for background tracking, started by an explicit user action, with a persistent notification.
- Avoid the background-location permission unless truly needed. If a feature acts like background location, Google applies its background-location rules and requires a declaration and demo video.
- **Precise location** requires a Play Console declaration explaining why it is needed. A speedometer has a clear justification.
- **Overlay permission** ("draw over other apps") needs a clear in-app explanation before asking.
- Use **Kotlin platform channels** where Flutter packages fall short (overlay quirks, Picture-in-Picture, widget updates).
- **Target API 36 (Android 16)**: new apps and updates must target it from 31 August 2026.

### 6.5 Battery and performance

- Tune location update interval and distance filter by mode (car vs. walking).
- Stop updates when the app is idle and no trip is running.
- Keep the UI lightweight (use `RepaintBoundary` for the gauge, avoid rebuilding the whole tree on each fix).
- Test on a low-end device.

---

## 7. Project Timeline (about 10-12 weeks, solo developer)

| Week | Work |
|---|---|
| 1 | Finalize scope, app name and branding, Play Console account, privacy policy draft, wireframes, Flutter project setup |
| 2 | Location service, permissions flow, live speed, units, accuracy filtering |
| 3 | Digital and analog gauges, average/max, odometer, trip meter, compass, altitude |
| 4 | Speed limit alerts (sound, vibration, voice, color), HUD and mirrored HUD, themes |
| 5 | Foreground service, notification, keep-awake, settings screen, onboarding, localization setup |
| 6 | **Upload to closed testing and start the 14-day clock.** Begin trip recording and history |
| 7 | Floating overlay, home widget, trip detail and graph, GPX/CSV export |
| 8 | Fuel tracker, activity modes, calorie estimate, backup/restore |
| 9 | Fix issues from tester feedback, battery and device testing, store listing and screenshots |
| 10 | Apply for production access, then staged rollout (10-20%) |
| 11-12 | Monitor crashes and reviews, ship v1.1 with fixes |

> The 14-day closed test runs in parallel with development, so keep shipping test builds during weeks 6-9. Get a working core into testers' hands by week 6.

---

## 8. Google Play Launch Checklist

- [ ] Developer account created and identity verified
- [ ] **Closed testing:** personal accounts created after 13 November 2023 need at least 12 testers opted in for 14 continuous days before applying for production access. Internal testing does not count. Recruit 15-20 testers to cover dropouts. Organization accounts are exempt
- [ ] Target API level 36
- [ ] App bundle (.aab) signed with Play App Signing
- [ ] Privacy policy URL (live, clearly labeled, mentions location use) in the app and the store listing
- [ ] Data safety form completed accurately
- [ ] Location permission declaration completed
- [ ] Content rating questionnaire
- [ ] Ads declaration (even if "no ads")
- [ ] Store listing: title, short description, full description, icon, feature graphic, 4-8 screenshots
- [ ] Safety wording: don't use the phone while driving, and GPS speed is not a legal substitute for the vehicle's speedometer
- [ ] Pre-launch report reviewed and critical issues fixed
- [ ] Staged rollout and crash monitoring enabled

---

## 9. Monetization (later, not now)

The current focus is a fully free, high-quality app. When you decide to monetize, consider:

- Keep the core speedometer, alerts, HUD, trip history and overlay free.
- Offer an optional one-time "Supporter" or premium unlock for extras (skins, advanced analytics, cloud backup).
- Avoid weekly subscriptions and full-screen ads, which are common complaints about competitors.
- Test pricing in the market before committing.

---

## 10. Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Inaccurate speed readings | Doppler speed, filtering, reference testing, GPS quality indicator |
| Crowded category | Own "accurate, private, free" and keep the listing honest |
| Closed-test dropouts | Recruit extra testers and keep them engaged with updates |
| Permission rejection | Foreground location only, clear in-app disclosures, accurate declarations |
| Flutter plugin limits (overlay, widget, PiP) | Budget time for Kotlin platform-channel code |
| Battery complaints | Tune intervals, test on low-end devices, stop updates when idle |
| Legal exposure (speed cameras, distracted driving) | Skip speed cameras at launch, add disclaimers |
| Free app with no revenue | Keep costs near zero (no backend), decide on optional premium later |

---

## 11. Success Metrics (first 90 days)

- Crash-free users above 99%
- Rating of 4.3 or higher
- Day-7 retention of 20% or higher (adjust after real data)
- Positive reviews mentioning accuracy and no ads

---

## October 27 reliability improvements

Implemented recoverable GPS signal loss, shared coordinate-spike checks before
live display/alerts/trip recording, five-second fix freshness, monotonic native
cached/reordered delivery rejection, cancellation that waits for pending startup,
and pausing when background tracking is disabled while hidden. Removed per-reading
device-setting application and duplicate GPS registration; native displays skip
identical rendered content and stale detection uses one deadline instead of polling.
Reference accuracy, OEM lock-screen behavior, power use and frame timing remain
hardware acceptance work. These changes do not establish measured battery savings.

## 12. Current Next Steps

1. Complete and record the real-device checks in `docs/manual_testing.md`, including
   reference GPS/odometer accuracy, native background/Stop behavior, actual alert
   output, accessibility and low-end battery/performance.
2. Resolve issues revealed by those measurements; keep automated checks clean.
3. Resume the Google Play launch checklist when production preparation is authorized.
4. Keep premium/rare scope deferred until after the free app has device acceptance.


## October 28 completion and usability improvements

Implemented durable Finish/reset/discard with retryable storage errors and pending
startup coordination; local-midnight/foreground calendar refresh; a focused display
route with persistent controls; settings category navigation; date/status history
filters with 20-record database pages; optional explicitly imported regional
GeoJSON line context held only for the open trip screen; and enforced CI coverage
thresholds for instrumented handwritten Dart. No new dependencies or schema change.
See ADR 0004 for behavior, coverage scope and import limits. These additions do not
complete physical-device accuracy/battery acceptance or deferred production work.
