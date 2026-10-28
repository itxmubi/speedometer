import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_metrics.dart';
import 'app_radii.dart';
import 'app_spacing.dart';

/// Material 3 instrument themes with restrained surfaces and a clear accent.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  /// Applies a validated user palette while keeping light/dark contrast pairs.
  static ThemeData forPreferences({
    required bool dark,
    required int accentIndex,
    required bool nightHud,
  }) => _build(
    dark ? Brightness.dark : Brightness.light,
    accentIndex: accentIndex,
    nightHud: nightHud,
  );

  static ThemeData _build(
    Brightness brightness, {
    int accentIndex = 0,
    bool nightHud = false,
  }) {
    final dark = brightness == Brightness.dark;
    final palette = dark ? AppColors.darkAccents : AppColors.lightAccents;
    final accent = palette[accentIndex.clamp(0, palette.length - 1)];
    final maximumContrast = dark && nightHud;
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      primary: accent,
      onPrimary: dark ? AppColors.ink : AppColors.white,
      surface: maximumContrast
          ? AppColors.black
          : dark
          ? AppColors.charcoal
          : AppColors.white,
      onSurface: dark ? AppColors.paper : AppColors.ink,
      onSurfaceVariant: dark ? AppColors.mutedLight : AppColors.mutedDark,
      outlineVariant: dark ? AppColors.darkLine : AppColors.lightLine,
      surfaceContainerHighest: dark
          ? AppColors.darkRaised
          : AppColors.lightLine,
      error: dark ? AppColors.danger : AppColors.darkDanger,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: maximumContrast
          ? AppColors.black
          : dark
          ? AppColors.ink
          : AppColors.paper,
      visualDensity: VisualDensity.standard,
    );
    return base.copyWith(
      textTheme: base.textTheme
          .copyWith(
            headlineLarge: const TextStyle(
              fontSize: 36,
              height: 1.15,
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
            ),
            headlineMedium: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            titleLarge: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
            titleMedium: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: const TextStyle(fontSize: 16, height: 1.5),
            bodyMedium: const TextStyle(fontSize: 14, height: 1.5),
            labelLarge: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            labelSmall: const TextStyle(fontSize: 11, letterSpacing: 0.5),
          )
          .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: base.scaffoldBackgroundColor,
        foregroundColor: scheme.onSurface,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: AppSpacing.xl,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.large),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(
            AppMetrics.touchTarget,
            AppMetrics.actionHeight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          textStyle: base.textTheme.titleMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            AppMetrics.touchTarget,
            AppMetrics.touchTarget,
          ),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.small),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppMetrics.touchTarget),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.standard,
          minimumSize: const WidgetStatePropertyAll(
            Size(AppMetrics.touchTarget, AppMetrics.touchTarget),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: scheme.outlineVariant),
          ),
          textStyle: WidgetStatePropertyAll(base.textTheme.labelLarge),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbIcon: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? const Icon(Icons.check, size: AppMetrics.smallIconSize)
              : null;
        }),
      ),
    );
  }
}
