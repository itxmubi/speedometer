/// Evaluates an optional manual limit without platform or display dependencies.
final class EvaluateSpeedLimitUseCase {
  const EvaluateSpeedLimitUseCase();

  /// Warns only for valid speeds strictly above an enabled, valid limit.
  bool call({
    required double speedMetersPerSecond,
    required double limitMetersPerSecond,
    required bool enabled,
  }) =>
      enabled &&
      speedMetersPerSecond.isFinite &&
      limitMetersPerSecond.isFinite &&
      limitMetersPerSecond > 0 &&
      speedMetersPerSecond > limitMetersPerSecond;
}
