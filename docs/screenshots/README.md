# README screenshots

The six gallery PNGs are rendered directly from the app's current Flutter widgets
at 430 × 960 logical pixels and 2× pixel density (860 × 1920 PNGs). They use English,
the dark theme, SDK-provided Roboto fonts and fixed synthetic readings/trips.
No GPS, permission prompt, device storage, personal route or network source is used.
These are host-rendered UI previews, without Android system bars; they do not
establish device accuracy or native-platform acceptance.

## Regenerate

From the project root, after the usual `flutter pub get` setup:

```sh
flutter test --no-pub tool/capture_readme_screenshots.dart
```

The utility loads fonts from the installed Flutter SDK via the project's package
configuration and writes only the six gallery files in this directory. It is
outside `test/` so ordinary test runs do not rewrite documentation assets. The
route view is scrolled to its map section and the dashboard statistics view to
its trip summary. Production widget/layout code is used without UI mockups.

| File | Content |
| --- | --- |
| `dashboard-digital.png` | Digital dashboard with a synthetic 66 km/h reading |
| `dashboard-hud.png` | Night HUD dashboard, with mirroring available but disabled |
| `trip-statistics.png` | Current trip statistics and cumulative distance totals |
| `trip-history.png` | Six synthetic saved trips and history filters |
| `trip-route.png` | Synthetic route, warning segments, offline attribution and replay |
| `settings.png` | Activity/display settings and category menu entry |

`onboarding.png` is the original October 21 hardware capture retained as historical
evidence. Its text describes an earlier implementation, so it is excluded from the
current README gallery. The analog gauge golden under `test/` is a widget-test
reference, rather than a full application screenshot, and is also excluded.
