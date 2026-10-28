import 'failure.dart';

part 'success.dart';
part 'error.dart';

/// The exhaustive outcome of an operation that can fail in an expected way.
sealed class Result<T> {
  const Result();
}
