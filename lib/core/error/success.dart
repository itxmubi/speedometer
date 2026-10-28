part of 'result.dart';

/// A successfully completed operation.
final class Success<T> extends Result<T> {
  /// Stores the successful result, including `null` for a void operation.
  const Success(this.value);

  /// The successful operation's value.
  final T value;
}
