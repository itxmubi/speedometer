part of 'result.dart';

/// An expected operation failure that presentation can handle exhaustively.
final class Error<T> extends Result<T> {
  /// Stores a privacy-safe reason for the failure.
  const Error(this.failure);

  /// The failure category, without a raw exception or stack trace.
  final Failure failure;
}
