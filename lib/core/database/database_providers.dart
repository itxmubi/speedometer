import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// App-wide connection keeps tracking writes alive through screen navigation.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.open();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});
