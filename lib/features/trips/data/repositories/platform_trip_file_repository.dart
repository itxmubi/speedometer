import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/trip_file_repository.dart';
import '../models/trip_backup_model.dart';

/// Plugin adapter. No broad filesystem permission or network access is needed.
final class PlatformTripFileRepository implements TripFileRepository {
  const PlatformTripFileRepository({Logger logger = const Logger()})
    : _logger = logger;
  final Logger _logger;

  @override
  Future<Result<String?>> pickBackup() => _guard(() async {
    final selected = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (selected == null) {
      return null;
    }
    final path = selected.path;
    if (path == null) {
      throw const FormatException('File unavailable');
    }
    final file = File(path);
    if (await file.length() > TripBackupModel.maxBytes) {
      throw const FormatException('File too large');
    }
    return utf8.decode(await file.readAsBytes());
  });

  @override
  Future<Result<void>> shareDocument({
    required String filename,
    required String mimeType,
    required String contents,
    required String subject,
  }) => _guard(() async {
    if (!RegExp(r'^[a-zA-Z0-9_.-]{1,160}$').hasMatch(filename)) {
      throw const FormatException('Invalid filename');
    }
    final bytes = Uint8List.fromList(utf8.encode(contents));
    if (bytes.length > TripBackupModel.maxBytes) {
      throw const FormatException('File too large');
    }
    await SharePlus.instance.share(
      ShareParams(
        subject: subject,
        files: [XFile.fromData(bytes, mimeType: mimeType)],
        fileNameOverrides: [filename],
      ),
    );
  });

  @override
  Future<Result<void>> shareText(String text) => _guard(() async {
    await SharePlus.instance.share(ShareParams(text: text));
  });

  Future<Result<T>> _guard<T>(Future<T> Function() operation) async {
    try {
      return Success(await operation());
    } on MissingPluginException {
      _logger.error('trip_document_unsupported');
      return const Error(Failure(FailureKind.unsupported));
    } on Object {
      _logger.error('trip_document_failed');
      return const Error(Failure(FailureKind.storage));
    }
  }
}
