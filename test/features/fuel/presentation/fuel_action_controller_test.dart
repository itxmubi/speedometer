import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/failure.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/fuel/domain/entities/fuel_entry.dart';
import 'package:speedometer/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:speedometer/features/fuel/presentation/providers/fuel_providers.dart';

void main() {
  test(
    'saves through loading and success while preventing duplicate writes',
    () async {
      final repository = _Repository();
      final container = ProviderContainer.test(
        overrides: [fuelRepositoryProvider.overrideWithValue(repository)],
      );
      container.listen(fuelActionControllerProvider, (previous, next) {});
      await container.read(fuelActionControllerProvider.future);
      final controller = container.read(fuelActionControllerProvider.notifier);
      final saved = controller.save(entry());
      expect(container.read(fuelActionControllerProvider).isLoading, isTrue);
      expect(await controller.save(entry()), isFalse);
      expect(repository.saves, 1);
      repository.pending.complete(const Success(null));
      expect(await saved, isTrue);
      expect(container.read(fuelActionControllerProvider).hasError, isFalse);
    },
  );

  test('expected failures become observable action errors', () async {
    final repository = _Repository();
    final container = ProviderContainer.test(
      overrides: [fuelRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(fuelActionControllerProvider, (previous, next) {});
    await container.read(fuelActionControllerProvider.future);
    final controller = container.read(fuelActionControllerProvider.notifier);
    final saved = controller.save(entry());
    repository.pending.complete(const Error(Failure(FailureKind.storage)));
    expect(await saved, isFalse);
    expect(
      container.read(fuelActionControllerProvider).error,
      const Failure(FailureKind.storage),
    );
    expect(await controller.delete('id'), isTrue);
    expect(repository.deleted, 'id');
  });

  test('disposal during a write does not access a disposed Ref', () async {
    final repository = _Repository();
    final container = ProviderContainer(
      overrides: [fuelRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(fuelActionControllerProvider, (previous, next) {});
    await container.read(fuelActionControllerProvider.future);
    final pending = container
        .read(fuelActionControllerProvider.notifier)
        .save(entry());
    container.dispose();
    repository.pending.complete(const Success(null));
    expect(await pending, isFalse);
  });
}

FuelEntry entry() => FuelEntry(
  occurredAt: DateTime.utc(2026, 10, 22),
  distanceMeters: 100000,
  fuelLiters: 5,
  fuelCost: 20,
  otherCost: 0,
  currencyCode: 'USD',
);

final class _Repository implements FuelRepository {
  final pending = Completer<Result<void>>();
  var saves = 0;
  String? deleted;

  @override
  Future<Result<void>> saveEntry(FuelEntry entry) {
    saves++;
    return pending.future;
  }

  @override
  Future<Result<void>> deleteEntry(String id) async {
    deleted = id;
    return const Success(null);
  }

  @override
  Stream<Result<List<FuelEntry>>> watchEntries() => const Stream.empty();
}
