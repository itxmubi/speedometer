# ADR 0002: Local tracking, activities and fuel records

Date: 2026-10-22
Status: Accepted; hardware acceptance remains pending

This extends the milestone-one scope in ADR 0001. Trips, points and a cumulative
calendar-distance ledger are stored in Drift. Only explicit Start begins the
Android location foreground service. Its notification offers Stop; a retained
Flutter engine keeps one writer alive behind other apps. A paused/recovered
trip never starts GPS by itself. Optional overlay/widget output uses filtered
Dart state. No background-location permission, account or network maps are used.
See `docs/android_platform.md` for native behavior and acceptance checks.

Speed stays based on device Doppler measurements. A short adaptive filter damps
only consecutive changes of at most 0.75 m/s, with a 350 ms time constant. First
fixes, stops, starts, significant changes and gaps bypass smoothing; rejected
fixes reset it. This tuning has deterministic tests and still needs reference
measurements on hardware. Trip duration/moving time exclude pause and GPS gaps.

Activity selection remembers unit, gauge and dial range per mode in settings.
Mode and optional weight are fixed until the current trip is finished/reset,
including paused or recovered trips, so changing settings cannot reclassify an
existing trip. The app does not infer an activity from location or upload weight.

Calorie estimates use representative moderate-effort MET values: cycling 7.0,
walking 3.8 and running 8.5. Total energy is MET × kilograms × accepted moving
hours; pauses and signal gaps add no time. This is an approximate total-energy
estimate, not an individualized measurement; no speed, terrain, fitness, heart
rate or power adjustment is inferred. Car and boating have no calorie estimate.
Primary references: [MET definition](https://pacompendium.com/),
[cycling](https://pacompendium.com/bicycling/),
[walking](https://pacompendium.com/walking/),
[running](https://pacompendium.com/running/).

Fuel entries explicitly pair consumed fuel with its matching distance. They do
not infer a full-tank interval, alter GPS totals or require vehicle identifiers.
Maintenance-only entries have zero fuel/distance and a positive non-fuel cost.
Storage uses meters/liters and an explicit three-letter currency label. Weighted
consumption aggregates fuel/distance, and costs remain separated by currency;
no exchange conversion or cross-currency total is implied. Entry text and notes
stay local. Version 2 of the database adds fuel records, with a v1 migration and
migration tests preserving existing trip/point/ledger data.

The local backup format advances to v2 with fuel/cost records while accepting v1.
Restore replaces structured data transactionally after validating the document;
settings use compensation across the preference/database boundary. A v1 document
contains no fuel entries. Global deletion clears fuel alongside trips/totals and
settings. Exported files are never silently deleted or uploaded.

No new runtime dependency was added for these activity/fuel features. Production
identity, signing, privacy-policy hosting/linking, crash reporting and publishing
were excluded from this implementation session.
