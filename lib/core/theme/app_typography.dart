import 'package:flutter/material.dart';

/// Numeric faces use tabular figures so a moving readout stays steady.
abstract final class AppTypography {
  static const speed = TextStyle(
    fontSize: 120,
    height: 1.05,
    fontWeight: FontWeight.w600,
    letterSpacing: -7,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const hudSpeed = TextStyle(
    fontSize: 156,
    height: 1.05,
    fontWeight: FontWeight.w600,
    letterSpacing: -7,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const analogSpeed = TextStyle(
    fontSize: 64,
    height: 1.05,
    fontWeight: FontWeight.w600,
    letterSpacing: -3,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const dialLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const eyebrow = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
  );
}
