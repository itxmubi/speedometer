# ADR 0003: Recoverable signal loss and bounded platform work

Date: 2026-10-27
Status: Accepted; hardware acceptance pending

## Context

The repository closed its location subscription after ten silent seconds. The
controller treated completion as a failed session and stopped the native service,
including when a receiver simply needed longer to acquire its first fix. Every
accepted sample also reapplied device settings, causing native GPS listener
registration to be replaced even when the requested cadence had not changed.
Coordinate-jump filtering protected trip totals but did not protect live readouts
or alerts.

## Decision

Keep an explicitly started session subscribed through silent signal loss. Emit an
unavailable reading at the existing ten-second deadline, clear smoothing and
segment anchors, and let new usable fixes recover without another Start. The
controller clears the trip anchor at the unavailable boundary, so no unknown
travel or time is accumulated. Permission/provider failures, explicit Pause/Stop,
and native service shutdown still terminate acquisition. There is no sticky,
boot-triggered or post-process-death restart.

Share the existing Doppler/accuracy-supported displacement policy between trip
accumulation and location admission. Apply it before live readout, alerts and
route recording. Keep a trustworthy admission anchor across coordinate spikes;
reset after quality failure or a long gap. Reject wall-clock fixes older than
five seconds in Dart, and cached/non-increasing elapsed-realtime fixes natively.
Do not infer displayed speed from coordinates or introduce unmeasured smoothing
or activity-specific sampling thresholds.

Apply window/GPS settings on lifecycle and preference changes, not each reading.
Native requests change only when cadence changes. Refresh native surfaces when
rounded speed or other visible content changes, protect stopped displays from
late speed updates, and use a single rescheduled stale deadline. Wait for pending
native startup during cancellation before allowing another controller session.

## Consequences and validation

Waiting for reception continues to use GPS until the user pauses or stops; the
foreground service remains visible according to Android notification permission.
No automatic idle shutdown is introduced that would unexpectedly end a trip.
Rejected samples and recovery boundaries conservatively omit unknown travel.

Regression tests cover recovery, spike rejection, cancellation ordering, settings
call counts and background preference changes. Builds validate Kotlin compilation.
These checks do not measure road accuracy, lock-screen/OEM service survival,
battery savings or frame times. Record those on hardware using
[the manual checklist](../manual_testing.md) before claiming device acceptance.
