import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:file_picker/file_picker.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/regional_map.dart';
import '../../domain/repositories/regional_map_repository.dart';
import '../models/regional_map_model.dart';

/// Local picker uses bounded reads; parsing runs off the UI isolate.
final class LocalRegionalMapRepository implements RegionalMapRepository {
  const LocalRegionalMapRepository();
  @override
  Future<Result<RegionalMap?>> pick() async {
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json', 'geojson'],
      );
      if (picked == null) return const Success(null);
      final path = picked.path;
      if (path == null) throw const FormatException('File unavailable');
      final bytes = <int>[];
      await for (final chunk in File(path).openRead()) {
        if (bytes.length + chunk.length > RegionalMapModel.maxBytes) {
          throw const FormatException('File too large');
        }
        bytes.addAll(chunk);
      }
      return Success(
        await Isolate.run(() => RegionalMapModel.decode(utf8.decode(bytes))),
      );
    } on Object {
      const Logger().error('regional_map_import_failed');
      return const Error(Failure(FailureKind.storage));
    }
  }
}
