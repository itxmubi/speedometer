import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/theme/app_colors.dart';
import 'package:speedometer/core/theme/app_theme.dart';

void main() {
  test(
    'all ten instrument palettes provide readable light and dark accents',
    () {
      for (var index = 0; index < 10; index++) {
        for (final dark in [false, true]) {
          final theme = AppTheme.forPreferences(
            dark: dark,
            accentIndex: index,
            nightHud: false,
          );
          final accent = theme.colorScheme.primary.computeLuminance();
          final surface = theme.colorScheme.surface.computeLuminance();
          final contrast =
              (math.max(accent, surface) + 0.05) /
              (math.min(accent, surface) + 0.05);
          expect(
            contrast,
            greaterThanOrEqualTo(4.5),
            reason: 'Palette $index, dark $dark',
          );
        }
      }
    },
  );

  test(
    'maximum contrast HUD uses true black with a bright instrument accent',
    () {
      final theme = AppTheme.forPreferences(
        dark: true,
        accentIndex: 0,
        nightHud: true,
      );
      expect(theme.colorScheme.surface, AppColors.black);
      expect(theme.scaffoldBackgroundColor, AppColors.black);
      expect(theme.colorScheme.primary, AppColors.lime);
    },
  );

  test('invalid palette indices are contained at the theme boundary', () {
    expect(
      AppTheme.forPreferences(
        dark: true,
        accentIndex: -2,
        nightHud: false,
      ).colorScheme.primary,
      AppColors.darkAccents.first,
    );
    expect(
      AppTheme.forPreferences(
        dark: false,
        accentIndex: 100,
        nightHud: false,
      ).colorScheme.primary,
      AppColors.lightAccents.last,
    );
  });

  test('normal palettes preserve the selected Material brightness', () {
    expect(AppTheme.light.brightness, Brightness.light);
    expect(AppTheme.dark.brightness, Brightness.dark);
  });
}
