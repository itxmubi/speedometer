import 'dart:convert';

import '../../../fuel/domain/entities/fuel_entry.dart';
import '../../../speedometer/domain/entities/trip_stats.dart';
import '../../domain/entities/recorded_trip.dart';
import '../../domain/entities/track_point.dart';

/// Strict, versioned interchange model. No unvalidated file data reaches SQLite.
final class TripBackupModel {
  TripBackupModel({
    required this.trips,
    required this.days,
    this.fuelEntries = const [],
    this.settingsJson,
  });

  static const maxBytes = 32 * 1024 * 1024;
  static const maxTrips = 100000;
  static const maxPoints = 500000;
  static const maxSettingsBytes = 65536;
  static const maxFuelEntries = 100000;
  static const _maxTimestamp = 253402300799999;
  static const _maxDistance = 1e12;

  final List<RecordedTrip> trips;
  final Map<String, double> days;
  final String? settingsJson;
  final List<FuelEntry> fuelEntries;

  String encode() {
    final settings = settingsJson;
    final encoded = jsonEncode({
      'format': 'private-speedometer-backup',
      'version': 2,
      'databaseSchema': 2,
      'settings': settings == null ? null : _settings(settings),
      'trips': trips.map(_tripJson).toList(),
      'days': days,
      'fuelEntries': fuelEntries.map(_fuelJson).toList(),
    });
    // Match the import limit for multibyte notes and translated settings too.
    if (utf8.encode(encoded).length > maxBytes) _invalid();
    return encoded;
  }

  factory TripBackupModel.decode(String source) {
    if (utf8.encode(source).length > maxBytes) _invalid();
    final root = _object(jsonDecode(source));
    final version = root['version'];
    if (root['format'] != 'private-speedometer-backup' ||
        (version != 1 && version != 2) ||
        root['databaseSchema'] != version) {
      _invalid();
    }
    final rawTrips = _list(root['trips']);
    if (rawTrips.length > maxTrips) _invalid();
    final ids = <String>{};
    final trips = <RecordedTrip>[];
    var count = 0;
    var active = 0;
    for (final raw in rawTrips) {
      final map = _object(raw);
      final id = map['id'];
      if (id is! String ||
          !RegExp(r'^[a-zA-Z0-9_-]{1,100}$').hasMatch(id) ||
          !ids.add(id)) {
        _invalid();
      }
      final start = _timestamp(map['start']);
      final endRaw = map['end'];
      final end = endRaw == null ? null : _timestamp(endRaw);
      if (end != null && end < start) _invalid();
      if (end == null && ++active > 1) _invalid();
      final elapsed = _integer(map['elapsedUs'], 0, 3155760000000000);
      final moving = _integer(map['movingUs'], 0, elapsed);
      final rawPoints = _list(map['points']);
      count += rawPoints.length;
      if (count > maxPoints) _invalid();
      final points = <TrackPoint>[];
      var previousTime = -1;
      var previousSegment = -1;
      for (final rawPoint in rawPoints) {
        final point = _object(rawPoint);
        final time = _timestamp(point['time']);
        final segment = _integer(point['segment'], 0, 1000000000);
        if (time < start ||
            (end != null && time > end) ||
            time <= previousTime ||
            segment < previousSegment) {
          _invalid();
        }
        previousTime = time;
        previousSegment = segment;
        final latitude = _nullableNumber(point['lat'], -90, 90);
        final longitude = _nullableNumber(point['lon'], -180, 180);
        if ((latitude == null) != (longitude == null)) _invalid();
        points.add(
          TrackPoint(
            timestamp: DateTime.fromMillisecondsSinceEpoch(time, isUtc: true),
            speedMetersPerSecond: _number(point['speed'], 0, 1000),
            segment: segment,
            overLimit: _boolean(point['over']),
            latitude: latitude,
            longitude: longitude,
            accuracyMeters: _nullableNumber(point['accuracy'], 0, 100000),
            altitudeMeters: _nullableNumber(point['altitude'], -20000, 100000),
            headingDegrees: _nullableNumber(point['heading'], 0, 360),
          ),
        );
      }
      trips.add(
        RecordedTrip(
          id: id,
          startedAt: DateTime.fromMillisecondsSinceEpoch(start, isUtc: true),
          endedAt: end == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(end, isUtc: true),
          isPaused: _boolean(map['paused']),
          stats: TripStats(
            distanceMeters: _number(map['distance'], 0, _maxDistance),
            maxSpeedMetersPerSecond: _number(map['maxSpeed'], 0, 1000),
            elapsed: Duration(microseconds: elapsed),
            movingTime: Duration(microseconds: moving),
          ),
          points: points,
        ),
      );
    }
    final rawDays = _object(root['days']);
    if (rawDays.length > 100000) _invalid();
    final days = <String, double>{};
    for (final entry in rawDays.entries) {
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(entry.key)) _invalid();
      final day = DateTime.tryParse(entry.key);
      if (day == null || day.toIso8601String().substring(0, 10) != entry.key) {
        _invalid();
      }
      days[entry.key] = _number(entry.value, 0, _maxDistance);
    }
    final ledgerTotal = days.values.fold(0.0, (sum, value) => sum + value);
    final tripTotal = trips.fold(
      0.0,
      (sum, trip) => sum + trip.stats.distanceMeters,
    );
    if (tripTotal > ledgerTotal + 0.01) _invalid();
    final rawSettings = root['settings'];
    final settings = rawSettings == null
        ? null
        : jsonEncode(_object(rawSettings));
    if (settings != null) _settings(settings);
    final fuelEntries = <FuelEntry>[];
    if (version == 2) {
      final rawFuel = _list(root['fuelEntries']);
      if (rawFuel.length > maxFuelEntries) _invalid();
      final fuelIds = <String>{};
      for (final raw in rawFuel) {
        final map = _object(raw);
        final id = map['id'];
        final currency = map['currency'];
        final note = map['note'];
        if (id is! String ||
            !fuelIds.add(id) ||
            currency is! String ||
            note is! String) {
          _invalid();
        }
        final entry = FuelEntry(
          id: id,
          occurredAt: DateTime.fromMillisecondsSinceEpoch(
            _timestamp(map['time']),
            isUtc: true,
          ),
          distanceMeters: _number(map['distance'], 0, _maxDistance),
          fuelLiters: _number(map['liters'], 0, 1e9),
          fuelCost: _number(map['fuelCost'], 0, 1e12),
          otherCost: _number(map['otherCost'], 0, 1e12),
          currencyCode: currency,
          note: note,
        );
        if (!entry.isValid) _invalid();
        fuelEntries.add(entry);
      }
    }
    return TripBackupModel(
      trips: trips,
      days: days,
      fuelEntries: fuelEntries,
      settingsJson: settings,
    );
  }

  static Map<String, Object?> _fuelJson(FuelEntry entry) => {
    'id': entry.id,
    'time': entry.occurredAt.millisecondsSinceEpoch,
    'distance': entry.distanceMeters,
    'liters': entry.fuelLiters,
    'fuelCost': entry.fuelCost,
    'otherCost': entry.otherCost,
    'currency': entry.currencyCode,
    'note': entry.note,
  };

  static Map<String, Object?> _tripJson(RecordedTrip trip) => {
    'id': trip.id,
    'start': trip.startedAt.millisecondsSinceEpoch,
    'end': trip.endedAt?.millisecondsSinceEpoch,
    'distance': trip.stats.distanceMeters,
    'maxSpeed': trip.stats.maxSpeedMetersPerSecond,
    'elapsedUs': trip.stats.elapsed.inMicroseconds,
    'movingUs': trip.stats.movingTime.inMicroseconds,
    'paused': trip.isPaused,
    'points': trip.points
        .map(
          (point) => {
            'time': point.timestamp.millisecondsSinceEpoch,
            'speed': point.speedMetersPerSecond,
            'segment': point.segment,
            'over': point.overLimit,
            'lat': point.latitude,
            'lon': point.longitude,
            'accuracy': point.accuracyMeters,
            'altitude': point.altitudeMeters,
            'heading': point.headingDegrees,
          },
        )
        .toList(),
  };

  static Map<String, Object?> _settings(String text) {
    if (utf8.encode(text).length > maxSettingsBytes) _invalid();
    return _object(jsonDecode(text));
  }

  static Map<String, Object?> _object(Object? value) {
    if (value is! Map<String, Object?>) _invalid();
    return value;
  }

  static List<Object?> _list(Object? value) {
    if (value is! List<Object?>) _invalid();
    return value;
  }

  static int _timestamp(Object? value) => _integer(value, 0, _maxTimestamp);
  static int _integer(Object? value, int min, int max) {
    if (value is! int || value < min || value > max) _invalid();
    return value;
  }

  static double _number(Object? value, double min, double max) {
    if (value is! num) _invalid();
    final number = value.toDouble();
    if (!number.isFinite || number < min || number > max) _invalid();
    return number;
  }

  static double? _nullableNumber(Object? value, double min, double max) =>
      value == null ? null : _number(value, min, max);

  static bool _boolean(Object? value) {
    if (value is! bool) _invalid();
    return value;
  }

  static Never _invalid() => throw const FormatException('Invalid backup');
}
