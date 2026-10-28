import '../entities/activity_mode.dart';

/// Rough gross energy estimate, including resting energy during moving time.
final class EstimateActivityCaloriesUseCase {
  const EstimateActivityCaloriesUseCase();

  /// Supported weight range for user input, in kilograms.
  static const double minimumWeightKilograms = 20;
  static const double maximumWeightKilograms = 300;

  /// Returns null for missing/invalid input and for motorized activities.
  double? call({
    required ActivityMode mode,
    required double? weightKilograms,
    required Duration movingTime,
  }) {
    if (weightKilograms == null ||
        !weightKilograms.isFinite ||
        weightKilograms < minimumWeightKilograms ||
        weightKilograms > maximumWeightKilograms ||
        movingTime.isNegative) {
      return null;
    }
    // 2024 Adult Compendium: cycling moderate self-selected pace (01016),
    // walking moderate level ground (17190), running 5–5.2 mph (12030).
    // https://pacompendium.com/ defines 1 MET as 1 kcal/kg/hour.
    final met = switch (mode) {
      ActivityMode.cycling => 7.0,
      ActivityMode.walking => 3.8,
      ActivityMode.running => 8.5,
      ActivityMode.car || ActivityMode.boating => null,
    };
    if (met == null) return null;
    final movingHours =
        movingTime.inMicroseconds / Duration.microsecondsPerHour;
    return met * weightKilograms * movingHours;
  }
}
