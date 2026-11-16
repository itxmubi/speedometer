# Android platform behavior and validation

The Android bridge is `core/platform/DeviceServices`. Application policy stays
in Dart: speed quality filtering, alert cooldown/hysteresis, units, trip storage,
and translated alert/notification text. Native code receives no backend URL and
never logs or persists coordinates. Static Android widget and permission-screen
fallback strings have English, Spanish, French, German and Arabic resources.
Android automatic cloud backup and device transfer are excluded for all app data;
backup/restore is an explicit local-file action from the app.

## Lifecycle and permission design

- Only an explicit Start action can start `TrackingService`. It requires precise
  foreground location and GPS enabled. It declares the `location` service type,
  `FOREGROUND_SERVICE`, and `FOREGROUND_SERVICE_LOCATION`. There is no background
  location, boot receiver, automatic widget start, or sticky service restart.
- Android 13+ notification permission is requested once during explicit Start.
  Denial does not forbid a foreground service: Android retains its active-app
  control, but hides the normal notification. Stop remains available in the app.
- `MainActivity` retains one Flutter engine, so the existing Dart controller and
  database writer continue when another app is visible or the screen is off.
  A second isolate never opens a competing tracking session.
- Pause/Stop cancels LocationManager updates and awaits service destruction.
  Native notification Stop emits `false` on the tracking-status channel. Swiping
  the task stops the service; a persisted trip can reopen paused without
  silently restarting GPS. Android process termination can interrupt writes;
  checkpoint recovery belongs to the repository/controller. Cancellation waits
  for pending native startup as well as Stop, preventing a completion from an old
  session from stopping a newly started one. Disabling background tracking while
  hidden immediately pauses the session after the setting is saved.
- GPS uses receiver-reported `Location.speed` at a configurable 1–3 second
  interval and zero distance filter. Missing speed/accuracy flags are preserved.
  Cached fixes older than five seconds and non-increasing fix times are dropped
  using Android's monotonic elapsed-realtime clock. Native UI clears speed after
  ten seconds without a healthy fix using one rescheduled deadline, rather than
  periodic polling. Dart independently checks freshness, quality and coordinate
  displacement before live speed, alerts and trip accumulation. A silent signal
  loss clears the readout and trip anchor but keeps the user-started session
  subscribed, so reception can recover without another Start. Permission/service
  failures and explicit Stop still terminate acquisition. No distance/time speed
  is calculated natively.
- Notification text, numeric monochrome status-bar icon, widget and optional
  floating overlay use filtered Dart display state. The overlay requires a
  separate explained special grant and explicit enablement while tracking.
  Its number can be dragged; its arrow handle resizes; × closes it. Closing does
  not stop the trip. Widget taps only open the app. Sub-unit speed changes that
  render identically do not rebuild the whole-number native surfaces; status,
  warning, unit and translated-label changes always refresh them. Updates received
  after native Stop cannot restore an old speed or over-limit warning.
- Compass uses rotation-vector magnetic heading adjusted for screen rotation,
  throttled to 5 Hz, and unregisters while the activity is hidden. An absent
  sensor or unreliable sample produces a typed failure.
- Screen-awake and brightness are activity-window attributes. Brightness `-1`
  restores the system value; manual brightness is limited to 5–100%. Native
  stop/dispose/detach restores both. These settings are applied on lifecycle and
  preference changes, rather than on every speed sample. An unchanged GPS interval
  never unregisters/re-registers LocationManager. Interval-change exceptions are
  handled and repository configuration failures remain typed results. No global
  write-settings permission is used.
- ToneGenerator and TTS mix with music without requesting audio focus. Vibration
  uses the device motor if present. Speech selects an installed offline voice
  matching the language and never launches downloads; missing voice/hardware
  returns `unsupported`. Device volume, Do Not Disturb and hardware availability
  still govern actual alert output.

## Manual acceptance checks (requires hardware)

The automated channel/DTO tests do not establish GPS accuracy, battery drain,
sensor accuracy, actual sound, or OEM background behavior. Record device, Android
version, permissions, duration, conditions, and outcome without publishing routes.

1. Fresh installation: read location disclosure, Start, deny location, retry,
   grant approximate only, then grant precise. Confirm no GPS collection before
   Start, and clear recovery for denied/permanent-denial/GPS-disabled cases.
2. Android 13/16: grant and deny notification permission independently. Grant:
   live speed and Stop are visible, icon shows speed. Deny: active-app control
   and in-app Stop work; no crash or repeated permission prompt on every start.
3. Start outdoors, open another app, lock screen for at least ten minutes,
   unlock, and compare saved samples/duration and notification speed. Stop from
   notification while hidden; confirm GPS indicator clears, overlay disappears,
   widget shows stopped, and returning UI reports paused.
4. Lose signal for more than ten seconds, including before the first fix. Confirm
   the readout clears, tracking remains active, and an outdoor fix recovers it
   without another Start or a distance/time bridge. Repeat while hidden.
   While waiting indoors with no GPS fixes, immediately Pause/Start repeatedly.
   Stop must complete without waiting for a location event or leaving an orphan
   service. Switch GPS off during a trip; restore and manually Start again.
5. Swipe the task, reopen, force-stop and reopen, and rotate while permission UI
   is open. No background restart, duplicate isolate, or stale active session is
   permitted. Recovered statistics must match the last committed checkpoint.
6. Overlay: decline the explanation, deny the special grant, grant it, enable
   while tracking, drag, resize, close, rotate, revoke permission in Android
   settings, then Stop. Check 48 dp controls and no residual floating window.
7. Add and resize a widget before tracking. Tap it: app opens without GPS.
   Track, exceed a test limit, lose signal, Stop, and reboot: speed/status must
   follow service state and idle must never retain a previous speed.
8. Compare compass with a known reference in portrait and both landscapes;
   test sensor-less hardware and an uncalibrated sensor. Check TalkBack labels.
9. With music playing, test each alert channel, zero/full app volume, device
   volume, DND, absent vibrator, and missing/offline TTS voice. Confirm alerts do
   not pause music. Verify requested language and repeated-alert policy.
10. Enable keep-awake/manual brightness; Pause, navigate away, resume, and Stop.
    System brightness and screen locking must be restored after tracking ends.
11. Profile normal and economy intervals on a low-end phone for at least an hour.
    Record battery change, thermal behavior and frame timing; compare reference
    vehicle/GPS speed outdoors with a passenger operating the phone.

## Platform references checked October 21, 2026

- [Foreground service types](https://developer.android.com/develop/background-work/services/fgs/service-types)
- [Foreground service start restrictions](https://developer.android.com/develop/background-work/services/fgs/restrictions-bg-start)
- [Notification runtime permission](https://developer.android.com/develop/ui/compose/notifications/notification-permission)
- [Retained Flutter engines](https://docs.flutter.dev/add-to-app/android/add-flutter-screen)
- [Offline TTS voice flag](https://developer.android.com/reference/android/speech/tts/Voice#isNetworkConnectionRequired())
- [AGP 8.12 compatibility](https://developer.android.com/build/releases/agp-8-12-0-release-notes)

AGP 8.12.1 is required by share_plus 13.3.1; it supports API 36 and the existing
Gradle 8.14/JDK 17 toolchain. Production signing and app identity remain separate
release work.

## October 27 reliability changes: acceptance limits

The code removes redundant registration, redraw and polling work; battery savings
and frame-rate improvements have not been measured. Compare normal and economy
cadences on the same device, route, brightness and duration. Record initial/final
battery level, temperature, sample count, reference speed/distance deviations and
profile-mode frame timing. Do not infer a battery percentage from unit tests.

Monotonic fix filtering follows the Android [Location reference](https://developer.android.com/reference/android/location/Location).
Recoverable stream inactivity follows Dart's [Stream.timeout contract](https://api.dart.dev/dart-async/Stream/timeout.html).
