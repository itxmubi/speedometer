# ADR 0001: Foreground GPS prototype before background tracking

Date: 2026-10-21
Status: Accepted for milestone 1; extended by [ADR 0002](0002-local-tracking-activities-fuel.md)

The lifecycle and in-memory limitations below describe the historical first
milestone. ADR 0002 records the current durable/background implementation.

The roadmap spans multiple releases. Start with a working, testable GPS core.
Use feature-first Clean Architecture, manually declared Riverpod Notifier/providers,
a typed Result/Failure boundary, GoRouter disclosure guards, generated ARB text,
and SI units in domain objects. Choose Riverpod consistently; do not add Bloc.

Use platform-reported speed, never distance/time as a substitute for unavailable
speed. Reject inaccurate, stale, missing, or impossible measurements; stop jitter
below 0.5 m/s. Calculate distance from positions, using fix timestamps for sampled
elapsed/moving time. Pauses and GPS gaps break the distance anchor. No fix means
no displayed speed. The trip duration excludes pauses and lost-fix intervals.

User consent to the explanation is separate from OS permission. Only Start opens
the OS location prompt. Pause/cancel on app background, stream failure, or reset;
never start automatically after returning. No background-location permission,
notification, overlay, foreground-service configuration, or internet dependency
is needed for this milestone. Foreground services require a later dedicated
implementation with visible stop controls and real-device battery checks.

Use SharedPreferencesAsync only for noncritical display settings and disclosure
consent. Keep the active trip in memory and describe that clearly in the UI.
Do not store structured trips in preferences. Introduce Drift with typed schema,
versioned migrations, and migration tests alongside persistent history/odometer.

The installed stable SDK is Flutter 3.41.4 / Dart 3.11.1. Resolve compatible
Riverpod/GoRouter/intl versions with this SDK rather than upgrading the machine's
SDK. Check package publisher docs, API availability, and licenses before adding
plugins. Resolved versions live in pubspec.lock.

Use privacy-safe event identifiers for local logs. Remote crash reporting is a
production prerequisite to decide with an accurate privacy policy, not enabled
implicitly in a private prototype. Application ID, branding, release signing,
Play declarations, and GPS accuracy testing remain explicit release tasks.
