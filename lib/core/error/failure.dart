import 'failure_kind.dart';

/// An expected, exhaustively typed failure without sensitive platform payloads.
sealed class Failure {
  /// Creates a kind-only failure that presentation can translate safely.
  const factory Failure(FailureKind kind) = _KindFailure;

  const Failure._();

  /// The action the user may need to take to recover.
  FailureKind get kind;

  @override
  bool operator ==(Object other) => other is Failure && other.kind == kind;

  @override
  int get hashCode => kind.hashCode;
}

final class _KindFailure extends Failure {
  const _KindFailure(this.kind) : super._();

  @override
  final FailureKind kind;
}
