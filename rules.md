# Flutter Engineering Rules

These rules apply to every line of code in this project. They are written for developers and for AI coding assistants. If a rule must be broken, leave a short comment explaining why.

**Core stack:** Flutter (stable), Dart (null-safe, strict analysis), Clean Architecture, Riverpod, Drift (SQLite), GoRouter.

> Package versions change. Check pub.dev for current versions and APIs before adding or upgrading a dependency.

---

## 1. Guiding Principles

1. **Separation of concerns:** UI shows state, state holders coordinate, use cases hold business rules, repositories hide data sources.
2. **Dependencies point inward:** `presentation -> domain <- data`. The domain layer knows nothing about Flutter, Riverpod, databases or HTTP.
3. **Immutable state:** state objects are immutable and replaced, never mutated.
4. **Testability first:** if code is hard to test, the design is wrong.
5. **Small and boring:** prefer simple, readable code over clever code.
6. **Fail loudly in development, gracefully in production.**
7. **Privacy by default:** collect the minimum data, keep it on the device where possible.

---

## 2. Project Structure (Feature-First Clean Architecture)

```
lib/
├── main.dart
├── app/
│   ├── app.dart                  # MaterialApp.router, theme, localization
│   ├── router/                   # GoRouter config, route names
│   └── bootstrap.dart            # init: error handling, ProviderScope, services
├── core/
│   ├── constants/
│   ├── error/                    # Failure classes, exceptions
│   ├── extensions/
│   ├── network/                  # only if the app uses HTTP
│   ├── platform/                 # platform channel wrappers
│   ├── theme/                    # colors, text styles, spacing tokens
│   ├── utils/
│   └── widgets/                  # shared, feature-agnostic widgets
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── datasources/      # local (Drift/prefs) and remote sources
│       │   ├── models/           # DTOs / DB rows, with toEntity / fromEntity
│       │   └── repositories/     # implementations of domain contracts
│       ├── domain/
│       │   ├── entities/         # pure Dart business objects
│       │   ├── repositories/     # abstract contracts
│       │   └── usecases/         # one class per business action
│       └── presentation/
│           ├── providers/        # Riverpod notifiers and providers
│           ├── screens/          # full pages
│           └── widgets/          # feature-specific widgets
├── l10n/                         # ARB files
└── generated/                    # generated code (never edit by hand)
test/                             # mirrors lib/ structure
integration_test/
```

**Rules**
- Each feature is self-contained. Features never import another feature's `data` or `presentation` folders. Share through `domain` contracts or `core`.
- `core` must not import from `features`.
- One public class per file. File name equals the class name in `snake_case`.
- Barrel files (`export`) are allowed only at feature boundaries and must stay small.

---

## 3. Layer Rules

### 3.1 Domain Layer (pure Dart)

- Allowed imports: `dart:*` and small utility packages (for example `equatable` or `fpdart` if the project chooses them). **No Flutter, Riverpod, Drift or platform packages.**
- **Entities:** immutable, no JSON or database annotations, contain business logic that belongs to the object.
- **Repository contracts:** abstract classes (or `abstract interface class`) that describe what the app needs, not how it is done.
- **Use cases:** one class, one action, one public method (`call`). Name them by intent: `StartTripUseCase`, `CalculateAverageSpeedUseCase`.
- Use cases receive repositories through the constructor.
- Return a typed result for expected failures instead of throwing (see Section 8).

### 3.2 Data Layer

- **Models/DTOs** map to and from entities. Keep mapping in the model (`toEntity()`, `fromEntity()`) or in dedicated mappers.
- **Data sources** do one job each: one for Drift, one for SharedPreferences, one for a platform channel, and so on.
- **Repository implementations** combine data sources, translate exceptions into `Failure` objects, and return entities.
- Never leak database rows, JSON maps or plugin types past the repository boundary.

### 3.3 Presentation Layer

- **Screens and widgets** contain layout and user interaction only. No business logic, no direct database or platform calls.
- Widgets read state through Riverpod and call notifier methods. They never call repositories or use cases directly.
- Keep `build()` cheap and free of side effects.

---

## 4. Riverpod Rules

1. **Wrap the app in `ProviderScope`** in `main.dart`.
2. **Use `Notifier` / `AsyncNotifier`** for state with behavior. Use plain `Provider` for dependency injection and simple derived values. Avoid legacy `StateNotifier` and `ChangeNotifier` in new code.
3. **Code generation is optional but consistent.** If using `riverpod_generator` and `@riverpod`, use it everywhere. Do not mix styles within one feature.
4. **Providers are declared at top level**, named `<thing>Provider`, and live in the feature's `presentation/providers/` (or `data/` for infrastructure providers).
5. **Dependency injection through providers:** data sources, repositories and use cases are exposed as providers and wired with `ref.watch`. Override them in tests.
6. **`ref.watch` in `build`, `ref.read` in callbacks.** Never call `ref.read` inside `build` to get values that should rebuild the widget.
7. **Use `ref.listen` for side effects** (snackbars, navigation, dialogs), never inside `build` logic via `watch`.
8. **Select narrowly:** use `select` to rebuild only when the needed field changes (important for a fast-updating speed gauge).
9. **Use `autoDispose`** for screen-scoped state. Keep `keepAlive` only for truly app-wide state, and document why.
10. **Never store `BuildContext`, `Ref` or widgets in state.**
11. **State classes are immutable** (`copyWith`, `freezed` or hand-written). Replace state: `state = state.copyWith(...)`.
12. **Model async state with `AsyncValue`:** handle `data`, `loading` and `error` explicitly in the UI (`when` / pattern matching).
13. **Notifiers call use cases.** They do not talk to data sources.
14. **No providers that read from global singletons.** Everything comes through other providers.
15. **High-frequency streams** (GPS updates): expose as `StreamProvider` or a notifier that throttles updates. Rebuild only the widgets that need the value.
16. **Cancel subscriptions** in `ref.onDispose`.

**Example shape**

```dart
// domain
abstract interface class TripRepository {
  Future<Result<Trip>> startTrip();
  Stream<SpeedReading> watchSpeed();
}

class StartTripUseCase {
  const StartTripUseCase(this._repository);
  final TripRepository _repository;
  Future<Result<Trip>> call() => _repository.startTrip();
}

// presentation
final startTripUseCaseProvider = Provider<StartTripUseCase>(
  (ref) => StartTripUseCase(ref.watch(tripRepositoryProvider)),
);

class TripNotifier extends AsyncNotifier<Trip?> {
  @override
  Future<Trip?> build() async => null;

  Future<void> start() async {
    state = const AsyncLoading();
    final result = await ref.read(startTripUseCaseProvider)();
    state = result.when(
      success: AsyncData.new,
      failure: (f) => AsyncError(f, StackTrace.current),
    );
  }
}

final tripNotifierProvider =
    AsyncNotifierProvider<TripNotifier, Trip?>(TripNotifier.new);
```

---

## 5. Code Style and Dart Rules

- **Use `flutter_lints` or stricter** (`very_good_analysis` is a good option). **Zero analyzer warnings** allowed in `main`.
- Enable strict analysis in `analysis_options.yaml`: `strict-casts`, `strict-inference`, `strict-raw-types`.
- Format with `dart format` (default line length). Run it before every commit.
- Naming: `UpperCamelCase` types, `lowerCamelCase` members, `snake_case` files, `SCREAMING_CAPS` avoided (use `lowerCamelCase` constants).
- Prefer `final` and `const`. Use `const` constructors wherever possible.
- **Avoid `dynamic`.** If unavoidable, isolate it at the boundary and convert immediately.
- **No `!` (bang) operator** unless the value is provably non-null, with a comment.
- Prefer **pattern matching, `sealed` classes and `switch` expressions** for exhaustive handling.
- Prefer `enum` with fields over magic strings or numbers.
- No magic numbers. Put them in named constants.
- Functions should do one thing and stay short. Split `build` methods before they exceed roughly 80 lines.
- Comments explain **why**, not what. Public APIs get `///` doc comments.
- Remove dead code and unused imports. Do not commit commented-out code.
- Use `async`/`await` over raw `.then` chains. Always handle errors.
- Use trailing commas to get clean formatting.

---

## 6. Widget and UI Rules

1. **Prefer small `StatelessWidget` classes over helper methods** that return widgets. Classes give better rebuild optimization.
2. Use `const` widgets wherever possible.
3. Use `ConsumerWidget` / `ConsumerStatefulWidget` only where Riverpod is needed. Presentational widgets receive plain data via constructor parameters.
4. No business logic, no network or database calls inside widgets.
5. **Theming:** all colors, text styles, spacing and radii come from the theme or design tokens in `core/theme`. No hardcoded colors or font sizes in feature widgets.
6. Support **light and dark themes** and Material 3.
7. **Responsive layouts:** use `LayoutBuilder`, `MediaQuery` and flexible widgets. Test portrait, landscape, small phones and tablets. No fixed pixel widths for main layouts.
8. **Accessibility:** semantic labels on icons and gauges, minimum 48x48 dp touch targets, sufficient contrast, support system font scaling, never rely on color alone for alerts.
9. Use `ListView.builder` for long lists. Use `RepaintBoundary` around frequently-updating custom painters (such as a speed gauge).
10. Keep animations at 60 fps. Dispose controllers in `dispose`.
11. Every screen handles **loading, empty, error and data** states.
12. No hardcoded user-facing strings. See Section 13.
13. Do not use `BuildContext` after an `await` without checking `context.mounted`.

---

## 7. Navigation

- Use **GoRouter** (or one chosen router) with typed routes or named route constants. No string literals scattered through the code.
- Route configuration lives in `app/router/`.
- Guard routes (onboarding, permissions) with redirects, not with logic inside screens.
- Pass IDs between screens, not large objects. Load data inside the destination via providers.

---

## 8. Error Handling

1. **Domain defines `Failure` types** (sealed class): `LocationFailure`, `PermissionFailure`, `StorageFailure`, `UnknownFailure`, and so on.
2. **Data layer catches exceptions** and converts them to `Failure`. Nothing below the repository throws into the UI.
3. Use a `Result<T>` type (sealed class or a package such as `fpdart`/`multiple_result`) for expected failures. Pick one approach project-wide.
4. UI shows **user-friendly messages**, never raw exceptions or stack traces.
5. Global handlers set up in `bootstrap.dart`: `FlutterError.onError`, `PlatformDispatcher.instance.onError`, and a `runZonedGuarded` equivalent where needed. Send errors to crash reporting.
6. Never swallow errors silently. At minimum log them.
7. Never log personal data or precise location in crash reports or analytics.

---

## 9. Data, Storage and Offline

- **Single source of truth:** the local database. The UI observes streams from the repository.
- Use **Drift** for structured data (trips, track points) with typed queries and migrations.
- Use **SharedPreferences / DataStore-like wrappers** only for small settings, behind a settings repository.
- Store **secrets and tokens** (if ever needed) in secure storage, never in plain preferences or source code.
- **Database migrations are mandatory:** every schema change has a versioned migration and a migration test.
- Keep large writes (track points) batched and off the UI isolate when heavy. Use isolates for CPU-heavy work (parsing, exporting).
- The app must work **fully offline** unless a feature truly requires the network.

---

## 10. Platform, Permissions and Background Work

- Wrap every plugin and platform channel behind an **abstraction in `core/platform` or a data source**, so it can be faked in tests.
- Request permissions **just in time**, with an explanation screen before the system dialog. Handle denied, permanently denied and restricted states.
- Request only the **minimum permissions** needed. Use foreground location only; avoid background location unless a feature requires it and Play policy is satisfied.
- Long-running work (GPS tracking) runs in a **foreground service** started by an explicit user action, with a visible notification and a clear stop control.
- Keep Kotlin/Swift platform code small, documented and covered by manual test notes.
- Always handle platform exceptions and unsupported-device cases.

---

## 11. Performance Rules

1. Profile in **profile mode** on a real, low-end device before optimizing.
2. Avoid rebuilding large trees: use `const`, `select`, and small widgets.
3. Throttle or debounce high-frequency inputs (location, sensors) before they reach the UI.
4. Never do heavy work in `build`. Never block the UI isolate.
5. Use `compute` / `Isolate.run` for heavy computation.
6. Cache and dispose resources (streams, controllers, listeners, timers).
7. Keep image and asset sizes small. Prefer vector (SVG) or properly scaled assets.
8. Monitor battery use for any feature that uses GPS, sensors or wakelocks.
9. Keep release build size in check. Review with `--analyze-size` periodically.

---

## 12. Testing Rules

**Required test types**

| Layer | Test type | Minimum expectation |
|---|---|---|
| Domain (entities, use cases) | Unit tests | High coverage (aim 90%+), no mocks of Flutter |
| Data (repositories, mappers, data sources) | Unit tests with fakes/mocks, Drift in-memory DB | Mapping, error translation, migrations |
| Presentation (notifiers) | Unit tests with `ProviderContainer` and overrides | State transitions and side effects |
| Widgets | Widget tests with provider overrides | Key states: loading, error, empty, data |
| Critical flows | Integration tests | Permission flow, start/stop trip, alert trigger |

**Rules**
- Test names describe behavior: `returns Failure when GPS permission is denied`.
- Arrange-Act-Assert structure.
- Use `mocktail` (or one chosen mocking library) and hand-written fakes for simple cases.
- Override providers in tests, never use real plugins in unit tests.
- Tests are deterministic: no real time, no real network. Inject a clock.
- Add a **golden test** for key custom-painted widgets (gauges) where stable.
- Every bug fix comes with a regression test.
- CI fails if tests fail or analysis reports warnings.

---

## 13. Localization and Accessibility Text

- All user-facing strings live in **ARB files** under `l10n/` and are accessed via generated localizations. No hardcoded strings in widgets.
- Support RTL layouts. Use `Directionality`-aware widgets and `EdgeInsetsDirectional`.
- Format numbers, units, dates and distances with `intl`, using the user's locale and chosen unit system.
- Provide semantic labels for gauges, alerts and icon buttons.

---

## 14. Security and Privacy

1. Request the minimum data. Keep user data on the device by default.
2. No hardcoded API keys or secrets. Use build-time configuration (`--dart-define`) and keep secrets out of version control.
3. Do not log personal data, precise locations or tokens.
4. Obfuscate release builds (`--obfuscate --split-debug-info`) and store symbol files securely.
5. Keep dependencies up to date and audit them. Prefer well-maintained packages with recent releases.
6. Provide a clear, accurate privacy policy, an in-app disclosure for location use, and match the Play Data Safety form to real behavior.
7. Allow users to delete their data (trips, settings) from within the app.
8. Validate all external input (imports, deep links, files).

---

## 15. Dependency Rules

- Add a package only if it saves meaningful effort and is **actively maintained, widely used, null-safe and compatible with the current stable Flutter**.
- Prefer a small number of strong dependencies over many tiny ones.
- Pin versions with caret ranges, commit `pubspec.lock` for the app.
- Wrap third-party packages behind your own interfaces so they can be swapped.
- Remove unused dependencies.
- Review licenses before adding a package.
- Run `flutter pub outdated` regularly.

---

## 16. Git and Workflow

- **Branching:** `main` is always releasable. Work happens in short-lived feature branches (`feature/<name>`, `fix/<name>`).
- **Commits:** small and focused, using Conventional Commits (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`).
- **Pull requests:** small, with a description, screenshots for UI changes and a checklist (see Section 20).
- **Code review:** at least one review before merging. Reviewers check architecture rules, tests and readability.
- Never commit generated secrets, keystores, `local.properties` or `.env` files.
- Use semantic versioning and keep a `CHANGELOG.md`.

---

## 17. CI/CD

CI runs on every pull request:

1. `flutter pub get`
2. `dart format --set-exit-if-changed .`
3. `flutter analyze` (fail on warnings)
4. `flutter test --coverage` (fail under the agreed threshold)
5. Build check: `flutter build appbundle --release`

CD (on tags or release branches):
- Build a signed App Bundle, upload to the Play Console internal/closed track (fastlane or GitHub Actions).
- Keep the upload keystore and credentials in CI secrets.

---

## 18. Logging, Monitoring and Analytics

- Use a single logger wrapper (`core/utils/logger.dart`) with levels. No stray `print` calls.
- Log in debug, minimal and privacy-safe in release.
- Crash reporting is required for production builds.
- Analytics are optional and opt-in-friendly. Track only what answers a product question, and never track precise location.

---

## 19. Documentation

- `README.md`: purpose, setup steps, how to run, how to test, architecture overview.
- Keep an `ARCHITECTURE.md` or this rules file up to date when decisions change.
- Record significant decisions in short ADRs (Architecture Decision Records) under `docs/adr/`.
- Public classes and methods have doc comments. Complex logic gets a short explanation of why.

---

## 20. Definition of Done and PR Checklist

A change is done only when all of these are true:

- [ ] Follows the folder structure and layer rules (no layer violations)
- [ ] Business logic lives in domain use cases, not in widgets or notifiers
- [ ] State is immutable and managed with Riverpod per Section 4
- [ ] No hardcoded colors, sizes, or strings
- [ ] Loading, empty, error and data states handled
- [ ] Permissions handled for granted, denied and permanently denied
- [ ] `dart format`, `flutter analyze` clean with zero warnings
- [ ] Unit and widget tests added or updated; all tests pass
- [ ] Tested on a real device (low-end if the change affects performance or battery)
- [ ] Accessibility checked (labels, contrast, text scaling)
- [ ] No sensitive data logged or hardcoded
- [ ] Docs, changelog and comments updated where needed
- [ ] PR description and screenshots added

---

## 21. Do and Don't Summary

**Do**
- Keep the domain layer pure Dart.
- Inject everything through Riverpod providers.
- Use immutable state, sealed types and exhaustive `switch`.
- Handle every async state and every failure.
- Write tests alongside code.
- Keep widgets small, `const` and theme-driven.
- Request permissions with context and handle denial.

**Don't**
- Don't put business logic in widgets.
- Don't call repositories, databases or plugins from the UI.
- Don't import Flutter or Riverpod in the domain layer.
- Don't mutate state objects.
- Don't use `BuildContext` across async gaps without `mounted` checks.
- Don't hardcode strings, colors, keys or secrets.
- Don't swallow exceptions or log personal data.
- Don't add a dependency without checking maintenance, license and necessity.

---

## 22. Project-Specific Notes (GPS Speedometer)

- **Location stream:** expose GPS speed as a stream from the repository. Throttle and filter low-accuracy fixes in the data/domain layer, so the UI only receives clean readings.
- **Gauge widget:** a `CustomPainter` wrapped in `RepaintBoundary`, driven by a narrow `select` on the current speed.
- **Alerts:** limit-checking logic is a domain use case. Sound, vibration and TTS are platform services behind interfaces.
- **Background tracking:** foreground service started by the user, with a persistent notification and a stop action. Avoid the background-location permission.
- **Units:** store speed internally in one unit (for example m/s) and convert only for display.
- **Offline-first:** trips and settings live in the local database. No account and no backend.
- **Target API 36** on Android and keep the Play Data Safety form in sync with real behavior.