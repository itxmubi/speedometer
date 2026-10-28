import 'package:flutter/material.dart';

/// The dashboard's accessible neutral palette and bright instrument accent.
abstract final class AppColors {
  /// True black for the maximum-contrast night display.
  static const black = Color(0xFF000000);

  /// Bright instrument accents for dark surfaces; paired dark tones are below.
  static const darkAccents = <Color>[
    lime,
    Color(0xFFA9C7FF),
    Color(0xFF71D9EF),
    Color(0xFFFFD36C),
    Color(0xFFFFB1B7),
    Color(0xFFD4BBFF),
    Color(0xFF84DFC2),
    Color(0xFFFFBC88),
    white,
    Color(0xFFF4ADEB),
  ];

  /// Readable instrument accents on light surfaces.
  static const lightAccents = <Color>[
    forest,
    Color(0xFF174EA6),
    Color(0xFF006779),
    Color(0xFF795700),
    Color(0xFF9E2437),
    Color(0xFF6940A0),
    Color(0xFF006B50),
    Color(0xFF8F4200),
    ink,
    Color(0xFF8B357E),
  ];

  static const ink = Color(0xFF101315);
  static const charcoal = Color(0xFF191D20);
  static const darkRaised = Color(0xFF22272A);
  static const lime = Color(0xFFD3F36A);
  static const forest = Color(0xFF476600);
  static const paper = Color(0xFFF5F6F0);
  static const white = Color(0xFFFFFFFF);
  static const mutedLight = Color(0xFFABB2AD);
  static const mutedDark = Color(0xFF5C665D);
  static const darkLine = Color(0xFF353B37);
  static const lightLine = Color(0xFFDDE2D7);
  static const danger = Color(0xFFFFB4AB);
  static const darkDanger = Color(0xFFBA1A1A);
}
