# Dependency decisions

Package metadata was reviewed for the original core on 2026-10-21. The installed
lockfile and direct-package LICENSE files were checked on 2026-10-22 while
reconciling the expanded implementation. No dependency was added or upgraded
for activity modes, calories or fuel/cost tracking. `pubspec.lock` is authoritative
for exact versions; SDK upgrades remain separate work.

| Direct runtime package | Resolved | License | Purpose and source |
| --- | --- | --- | --- |
| flutter_riverpod | 3.3.2 | MIT | [State/DI](https://pub.dev/packages/flutter_riverpod) |
| go_router | 16.3.0 | BSD-3-Clause | [Named routes and startup guards](https://pub.dev/packages/go_router) |
| geolocator | 14.1.2 | MIT | [Foreground permission/service checks](https://pub.dev/packages/geolocator) |
| shared_preferences | 2.5.6 | BSD-3-Clause | [Small display/activity settings](https://pub.dev/packages/shared_preferences) |
| intl | 0.20.2 | BSD-3-Clause | [Localized numbers/dates](https://pub.dev/packages/intl) |
| cupertino_icons | 1.0.9 | MIT | [Icon font used by framework controls](https://pub.dev/packages/cupertino_icons) |
| drift | 2.34.0 | MIT | [Typed trip/fuel SQLite storage and migrations](https://pub.dev/packages/drift) |
| sqlite3 | 3.5.2 | MIT | [Local SQLite runtime](https://pub.dev/packages/sqlite3) |
| path_provider | 2.1.6 | BSD-3-Clause | [App-private database directory](https://pub.dev/packages/path_provider) |
| share_plus | 13.3.1 | BSD-3-Clause | [Explicit document/summary sharing](https://pub.dev/packages/share_plus) |
| file_picker | 13.1.0 | MIT | [Explicit local backup selection](https://pub.dev/packages/file_picker) |

Flutter/localizations/test/integration_test come from the SDK. flutter_lints
provides static rules. drift_dev 2.34.0 (MIT) and build_runner 2.15.1
(BSD-3-Clause) generate database code and historical migration fixtures. Drift
runtime/dev patches are kept aligned. Generated historical fixtures are excluded
from static analysis because drift_dev emits raw TableInfo types; migration tests
still compile and execute them. Never hand-edit generated Dart.

Native Android adapters provide foreground GPS, persistent notification/Stop,
overlay, widget, compass, brightness/keep-awake, tone/vibration and offline TTS.
No background-service, overlay, compass, audio, map, analytics or remote crash
reporter package is added. No permission_handler is needed: geolocator supplies
foreground location permission checks. Speech uses installed offline voices and
does not initiate voice downloads. See [native behavior](android_platform.md).

The geographic map bundles public-domain Natural Earth 5.1.2 land GeoJSON;
see [attribution and limitations](offline_maps.md). It uses no tile server, API key
or network map package. HTTP packages appearing transitively are not invoked by
app code. Fuel and calorie calculations need no external service or dependency.

Use `flutter pub outdated` when planning dependency/SDK upgrades. Check publisher
APIs, maintenance and licenses before adding/upgrading packages; do not upgrade
major router/state APIs without analyzing and testing the result.
