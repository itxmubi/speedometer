// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TripRecordsTable extends TripRecords
    with TableInfo<$TripRecordsTable, TripRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMsMeta = const VerificationMeta(
    'startedAtMs',
  );
  @override
  late final GeneratedColumn<int> startedAtMs = GeneratedColumn<int>(
    'started_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMsMeta = const VerificationMeta(
    'endedAtMs',
  );
  @override
  late final GeneratedColumn<int> endedAtMs = GeneratedColumn<int>(
    'ended_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxSpeedMeta = const VerificationMeta(
    'maxSpeed',
  );
  @override
  late final GeneratedColumn<double> maxSpeed = GeneratedColumn<double>(
    'max_speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _elapsedUsMeta = const VerificationMeta(
    'elapsedUs',
  );
  @override
  late final GeneratedColumn<int> elapsedUs = GeneratedColumn<int>(
    'elapsed_us',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _movingUsMeta = const VerificationMeta(
    'movingUs',
  );
  @override
  late final GeneratedColumn<int> movingUs = GeneratedColumn<int>(
    'moving_us',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
    'paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paused" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _segmentMeta = const VerificationMeta(
    'segment',
  );
  @override
  late final GeneratedColumn<int> segment = GeneratedColumn<int>(
    'segment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPointMsMeta = const VerificationMeta(
    'lastPointMs',
  );
  @override
  late final GeneratedColumn<int> lastPointMs = GeneratedColumn<int>(
    'last_point_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAtMs,
    endedAtMs,
    distanceMeters,
    maxSpeed,
    elapsedUs,
    movingUs,
    paused,
    segment,
    lastPointMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at_ms')) {
      context.handle(
        _startedAtMsMeta,
        startedAtMs.isAcceptableOrUnknown(
          data['started_at_ms']!,
          _startedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtMsMeta);
    }
    if (data.containsKey('ended_at_ms')) {
      context.handle(
        _endedAtMsMeta,
        endedAtMs.isAcceptableOrUnknown(data['ended_at_ms']!, _endedAtMsMeta),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('max_speed')) {
      context.handle(
        _maxSpeedMeta,
        maxSpeed.isAcceptableOrUnknown(data['max_speed']!, _maxSpeedMeta),
      );
    }
    if (data.containsKey('elapsed_us')) {
      context.handle(
        _elapsedUsMeta,
        elapsedUs.isAcceptableOrUnknown(data['elapsed_us']!, _elapsedUsMeta),
      );
    }
    if (data.containsKey('moving_us')) {
      context.handle(
        _movingUsMeta,
        movingUs.isAcceptableOrUnknown(data['moving_us']!, _movingUsMeta),
      );
    }
    if (data.containsKey('paused')) {
      context.handle(
        _pausedMeta,
        paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta),
      );
    }
    if (data.containsKey('segment')) {
      context.handle(
        _segmentMeta,
        segment.isAcceptableOrUnknown(data['segment']!, _segmentMeta),
      );
    }
    if (data.containsKey('last_point_ms')) {
      context.handle(
        _lastPointMsMeta,
        lastPointMs.isAcceptableOrUnknown(
          data['last_point_ms']!,
          _lastPointMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_ms'],
      )!,
      endedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at_ms'],
      ),
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      )!,
      maxSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed'],
      )!,
      elapsedUs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_us'],
      )!,
      movingUs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moving_us'],
      )!,
      paused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paused'],
      )!,
      segment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}segment'],
      )!,
      lastPointMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_point_ms'],
      ),
    );
  }

  @override
  $TripRecordsTable createAlias(String alias) {
    return $TripRecordsTable(attachedDatabase, alias);
  }
}

class TripRecord extends DataClass implements Insertable<TripRecord> {
  final String id;
  final int startedAtMs;
  final int? endedAtMs;
  final double distanceMeters;
  final double maxSpeed;
  final int elapsedUs;
  final int movingUs;
  final bool paused;
  final int segment;
  final int? lastPointMs;
  const TripRecord({
    required this.id,
    required this.startedAtMs,
    this.endedAtMs,
    required this.distanceMeters,
    required this.maxSpeed,
    required this.elapsedUs,
    required this.movingUs,
    required this.paused,
    required this.segment,
    this.lastPointMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at_ms'] = Variable<int>(startedAtMs);
    if (!nullToAbsent || endedAtMs != null) {
      map['ended_at_ms'] = Variable<int>(endedAtMs);
    }
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['max_speed'] = Variable<double>(maxSpeed);
    map['elapsed_us'] = Variable<int>(elapsedUs);
    map['moving_us'] = Variable<int>(movingUs);
    map['paused'] = Variable<bool>(paused);
    map['segment'] = Variable<int>(segment);
    if (!nullToAbsent || lastPointMs != null) {
      map['last_point_ms'] = Variable<int>(lastPointMs);
    }
    return map;
  }

  TripRecordsCompanion toCompanion(bool nullToAbsent) {
    return TripRecordsCompanion(
      id: Value(id),
      startedAtMs: Value(startedAtMs),
      endedAtMs: endedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtMs),
      distanceMeters: Value(distanceMeters),
      maxSpeed: Value(maxSpeed),
      elapsedUs: Value(elapsedUs),
      movingUs: Value(movingUs),
      paused: Value(paused),
      segment: Value(segment),
      lastPointMs: lastPointMs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPointMs),
    );
  }

  factory TripRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripRecord(
      id: serializer.fromJson<String>(json['id']),
      startedAtMs: serializer.fromJson<int>(json['startedAtMs']),
      endedAtMs: serializer.fromJson<int?>(json['endedAtMs']),
      distanceMeters: serializer.fromJson<double>(json['distanceMeters']),
      maxSpeed: serializer.fromJson<double>(json['maxSpeed']),
      elapsedUs: serializer.fromJson<int>(json['elapsedUs']),
      movingUs: serializer.fromJson<int>(json['movingUs']),
      paused: serializer.fromJson<bool>(json['paused']),
      segment: serializer.fromJson<int>(json['segment']),
      lastPointMs: serializer.fromJson<int?>(json['lastPointMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAtMs': serializer.toJson<int>(startedAtMs),
      'endedAtMs': serializer.toJson<int?>(endedAtMs),
      'distanceMeters': serializer.toJson<double>(distanceMeters),
      'maxSpeed': serializer.toJson<double>(maxSpeed),
      'elapsedUs': serializer.toJson<int>(elapsedUs),
      'movingUs': serializer.toJson<int>(movingUs),
      'paused': serializer.toJson<bool>(paused),
      'segment': serializer.toJson<int>(segment),
      'lastPointMs': serializer.toJson<int?>(lastPointMs),
    };
  }

  TripRecord copyWith({
    String? id,
    int? startedAtMs,
    Value<int?> endedAtMs = const Value.absent(),
    double? distanceMeters,
    double? maxSpeed,
    int? elapsedUs,
    int? movingUs,
    bool? paused,
    int? segment,
    Value<int?> lastPointMs = const Value.absent(),
  }) => TripRecord(
    id: id ?? this.id,
    startedAtMs: startedAtMs ?? this.startedAtMs,
    endedAtMs: endedAtMs.present ? endedAtMs.value : this.endedAtMs,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    maxSpeed: maxSpeed ?? this.maxSpeed,
    elapsedUs: elapsedUs ?? this.elapsedUs,
    movingUs: movingUs ?? this.movingUs,
    paused: paused ?? this.paused,
    segment: segment ?? this.segment,
    lastPointMs: lastPointMs.present ? lastPointMs.value : this.lastPointMs,
  );
  TripRecord copyWithCompanion(TripRecordsCompanion data) {
    return TripRecord(
      id: data.id.present ? data.id.value : this.id,
      startedAtMs: data.startedAtMs.present
          ? data.startedAtMs.value
          : this.startedAtMs,
      endedAtMs: data.endedAtMs.present ? data.endedAtMs.value : this.endedAtMs,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      maxSpeed: data.maxSpeed.present ? data.maxSpeed.value : this.maxSpeed,
      elapsedUs: data.elapsedUs.present ? data.elapsedUs.value : this.elapsedUs,
      movingUs: data.movingUs.present ? data.movingUs.value : this.movingUs,
      paused: data.paused.present ? data.paused.value : this.paused,
      segment: data.segment.present ? data.segment.value : this.segment,
      lastPointMs: data.lastPointMs.present
          ? data.lastPointMs.value
          : this.lastPointMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripRecord(')
          ..write('id: $id, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('endedAtMs: $endedAtMs, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('elapsedUs: $elapsedUs, ')
          ..write('movingUs: $movingUs, ')
          ..write('paused: $paused, ')
          ..write('segment: $segment, ')
          ..write('lastPointMs: $lastPointMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAtMs,
    endedAtMs,
    distanceMeters,
    maxSpeed,
    elapsedUs,
    movingUs,
    paused,
    segment,
    lastPointMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripRecord &&
          other.id == this.id &&
          other.startedAtMs == this.startedAtMs &&
          other.endedAtMs == this.endedAtMs &&
          other.distanceMeters == this.distanceMeters &&
          other.maxSpeed == this.maxSpeed &&
          other.elapsedUs == this.elapsedUs &&
          other.movingUs == this.movingUs &&
          other.paused == this.paused &&
          other.segment == this.segment &&
          other.lastPointMs == this.lastPointMs);
}

class TripRecordsCompanion extends UpdateCompanion<TripRecord> {
  final Value<String> id;
  final Value<int> startedAtMs;
  final Value<int?> endedAtMs;
  final Value<double> distanceMeters;
  final Value<double> maxSpeed;
  final Value<int> elapsedUs;
  final Value<int> movingUs;
  final Value<bool> paused;
  final Value<int> segment;
  final Value<int?> lastPointMs;
  final Value<int> rowid;
  const TripRecordsCompanion({
    this.id = const Value.absent(),
    this.startedAtMs = const Value.absent(),
    this.endedAtMs = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.elapsedUs = const Value.absent(),
    this.movingUs = const Value.absent(),
    this.paused = const Value.absent(),
    this.segment = const Value.absent(),
    this.lastPointMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripRecordsCompanion.insert({
    required String id,
    required int startedAtMs,
    this.endedAtMs = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.elapsedUs = const Value.absent(),
    this.movingUs = const Value.absent(),
    this.paused = const Value.absent(),
    this.segment = const Value.absent(),
    this.lastPointMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAtMs = Value(startedAtMs);
  static Insertable<TripRecord> custom({
    Expression<String>? id,
    Expression<int>? startedAtMs,
    Expression<int>? endedAtMs,
    Expression<double>? distanceMeters,
    Expression<double>? maxSpeed,
    Expression<int>? elapsedUs,
    Expression<int>? movingUs,
    Expression<bool>? paused,
    Expression<int>? segment,
    Expression<int>? lastPointMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAtMs != null) 'started_at_ms': startedAtMs,
      if (endedAtMs != null) 'ended_at_ms': endedAtMs,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (maxSpeed != null) 'max_speed': maxSpeed,
      if (elapsedUs != null) 'elapsed_us': elapsedUs,
      if (movingUs != null) 'moving_us': movingUs,
      if (paused != null) 'paused': paused,
      if (segment != null) 'segment': segment,
      if (lastPointMs != null) 'last_point_ms': lastPointMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripRecordsCompanion copyWith({
    Value<String>? id,
    Value<int>? startedAtMs,
    Value<int?>? endedAtMs,
    Value<double>? distanceMeters,
    Value<double>? maxSpeed,
    Value<int>? elapsedUs,
    Value<int>? movingUs,
    Value<bool>? paused,
    Value<int>? segment,
    Value<int?>? lastPointMs,
    Value<int>? rowid,
  }) {
    return TripRecordsCompanion(
      id: id ?? this.id,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      endedAtMs: endedAtMs ?? this.endedAtMs,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      elapsedUs: elapsedUs ?? this.elapsedUs,
      movingUs: movingUs ?? this.movingUs,
      paused: paused ?? this.paused,
      segment: segment ?? this.segment,
      lastPointMs: lastPointMs ?? this.lastPointMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAtMs.present) {
      map['started_at_ms'] = Variable<int>(startedAtMs.value);
    }
    if (endedAtMs.present) {
      map['ended_at_ms'] = Variable<int>(endedAtMs.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (maxSpeed.present) {
      map['max_speed'] = Variable<double>(maxSpeed.value);
    }
    if (elapsedUs.present) {
      map['elapsed_us'] = Variable<int>(elapsedUs.value);
    }
    if (movingUs.present) {
      map['moving_us'] = Variable<int>(movingUs.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (segment.present) {
      map['segment'] = Variable<int>(segment.value);
    }
    if (lastPointMs.present) {
      map['last_point_ms'] = Variable<int>(lastPointMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripRecordsCompanion(')
          ..write('id: $id, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('endedAtMs: $endedAtMs, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('elapsedUs: $elapsedUs, ')
          ..write('movingUs: $movingUs, ')
          ..write('paused: $paused, ')
          ..write('segment: $segment, ')
          ..write('lastPointMs: $lastPointMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripPointsTable extends TripPoints
    with TableInfo<$TripPointsTable, TripPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trip_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _timestampMsMeta = const VerificationMeta(
    'timestampMs',
  );
  @override
  late final GeneratedColumn<int> timestampMs = GeneratedColumn<int>(
    'timestamp_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _segmentMeta = const VerificationMeta(
    'segment',
  );
  @override
  late final GeneratedColumn<int> segment = GeneratedColumn<int>(
    'segment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overLimitMeta = const VerificationMeta(
    'overLimit',
  );
  @override
  late final GeneratedColumn<bool> overLimit = GeneratedColumn<bool>(
    'over_limit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("over_limit" IN (0, 1))',
    ),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMeta = const VerificationMeta(
    'altitude',
  );
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
    'altitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headingMeta = const VerificationMeta(
    'heading',
  );
  @override
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
    'heading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tripId,
    timestampMs,
    speed,
    segment,
    overLimit,
    latitude,
    longitude,
    accuracy,
    altitude,
    heading,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('timestamp_ms')) {
      context.handle(
        _timestampMsMeta,
        timestampMs.isAcceptableOrUnknown(
          data['timestamp_ms']!,
          _timestampMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timestampMsMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('segment')) {
      context.handle(
        _segmentMeta,
        segment.isAcceptableOrUnknown(data['segment']!, _segmentMeta),
      );
    } else if (isInserting) {
      context.missing(_segmentMeta);
    }
    if (data.containsKey('over_limit')) {
      context.handle(
        _overLimitMeta,
        overLimit.isAcceptableOrUnknown(data['over_limit']!, _overLimitMeta),
      );
    } else if (isInserting) {
      context.missing(_overLimitMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    }
    if (data.containsKey('altitude')) {
      context.handle(
        _altitudeMeta,
        altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta),
      );
    }
    if (data.containsKey('heading')) {
      context.handle(
        _headingMeta,
        heading.isAcceptableOrUnknown(data['heading']!, _headingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tripId, timestampMs};
  @override
  TripPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripPoint(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      timestampMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp_ms'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      )!,
      segment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}segment'],
      )!,
      overLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}over_limit'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      ),
      altitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude'],
      ),
      heading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading'],
      ),
    );
  }

  @override
  $TripPointsTable createAlias(String alias) {
    return $TripPointsTable(attachedDatabase, alias);
  }
}

class TripPoint extends DataClass implements Insertable<TripPoint> {
  final String tripId;
  final int timestampMs;
  final double speed;
  final int segment;
  final bool overLimit;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final double? altitude;
  final double? heading;
  const TripPoint({
    required this.tripId,
    required this.timestampMs,
    required this.speed,
    required this.segment,
    required this.overLimit,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.altitude,
    this.heading,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<String>(tripId);
    map['timestamp_ms'] = Variable<int>(timestampMs);
    map['speed'] = Variable<double>(speed);
    map['segment'] = Variable<int>(segment);
    map['over_limit'] = Variable<bool>(overLimit);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<double>(heading);
    }
    return map;
  }

  TripPointsCompanion toCompanion(bool nullToAbsent) {
    return TripPointsCompanion(
      tripId: Value(tripId),
      timestampMs: Value(timestampMs),
      speed: Value(speed),
      segment: Value(segment),
      overLimit: Value(overLimit),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      heading: heading == null && nullToAbsent
          ? const Value.absent()
          : Value(heading),
    );
  }

  factory TripPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripPoint(
      tripId: serializer.fromJson<String>(json['tripId']),
      timestampMs: serializer.fromJson<int>(json['timestampMs']),
      speed: serializer.fromJson<double>(json['speed']),
      segment: serializer.fromJson<int>(json['segment']),
      overLimit: serializer.fromJson<bool>(json['overLimit']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      heading: serializer.fromJson<double?>(json['heading']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<String>(tripId),
      'timestampMs': serializer.toJson<int>(timestampMs),
      'speed': serializer.toJson<double>(speed),
      'segment': serializer.toJson<int>(segment),
      'overLimit': serializer.toJson<bool>(overLimit),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'accuracy': serializer.toJson<double?>(accuracy),
      'altitude': serializer.toJson<double?>(altitude),
      'heading': serializer.toJson<double?>(heading),
    };
  }

  TripPoint copyWith({
    String? tripId,
    int? timestampMs,
    double? speed,
    int? segment,
    bool? overLimit,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<double?> accuracy = const Value.absent(),
    Value<double?> altitude = const Value.absent(),
    Value<double?> heading = const Value.absent(),
  }) => TripPoint(
    tripId: tripId ?? this.tripId,
    timestampMs: timestampMs ?? this.timestampMs,
    speed: speed ?? this.speed,
    segment: segment ?? this.segment,
    overLimit: overLimit ?? this.overLimit,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    accuracy: accuracy.present ? accuracy.value : this.accuracy,
    altitude: altitude.present ? altitude.value : this.altitude,
    heading: heading.present ? heading.value : this.heading,
  );
  TripPoint copyWithCompanion(TripPointsCompanion data) {
    return TripPoint(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      timestampMs: data.timestampMs.present
          ? data.timestampMs.value
          : this.timestampMs,
      speed: data.speed.present ? data.speed.value : this.speed,
      segment: data.segment.present ? data.segment.value : this.segment,
      overLimit: data.overLimit.present ? data.overLimit.value : this.overLimit,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      heading: data.heading.present ? data.heading.value : this.heading,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripPoint(')
          ..write('tripId: $tripId, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('speed: $speed, ')
          ..write('segment: $segment, ')
          ..write('overLimit: $overLimit, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('heading: $heading')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tripId,
    timestampMs,
    speed,
    segment,
    overLimit,
    latitude,
    longitude,
    accuracy,
    altitude,
    heading,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripPoint &&
          other.tripId == this.tripId &&
          other.timestampMs == this.timestampMs &&
          other.speed == this.speed &&
          other.segment == this.segment &&
          other.overLimit == this.overLimit &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.altitude == this.altitude &&
          other.heading == this.heading);
}

class TripPointsCompanion extends UpdateCompanion<TripPoint> {
  final Value<String> tripId;
  final Value<int> timestampMs;
  final Value<double> speed;
  final Value<int> segment;
  final Value<bool> overLimit;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> accuracy;
  final Value<double?> altitude;
  final Value<double?> heading;
  final Value<int> rowid;
  const TripPointsCompanion({
    this.tripId = const Value.absent(),
    this.timestampMs = const Value.absent(),
    this.speed = const Value.absent(),
    this.segment = const Value.absent(),
    this.overLimit = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.heading = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripPointsCompanion.insert({
    required String tripId,
    required int timestampMs,
    required double speed,
    required int segment,
    required bool overLimit,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.heading = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tripId = Value(tripId),
       timestampMs = Value(timestampMs),
       speed = Value(speed),
       segment = Value(segment),
       overLimit = Value(overLimit);
  static Insertable<TripPoint> custom({
    Expression<String>? tripId,
    Expression<int>? timestampMs,
    Expression<double>? speed,
    Expression<int>? segment,
    Expression<bool>? overLimit,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<double>? altitude,
    Expression<double>? heading,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (timestampMs != null) 'timestamp_ms': timestampMs,
      if (speed != null) 'speed': speed,
      if (segment != null) 'segment': segment,
      if (overLimit != null) 'over_limit': overLimit,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (altitude != null) 'altitude': altitude,
      if (heading != null) 'heading': heading,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripPointsCompanion copyWith({
    Value<String>? tripId,
    Value<int>? timestampMs,
    Value<double>? speed,
    Value<int>? segment,
    Value<bool>? overLimit,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<double?>? accuracy,
    Value<double?>? altitude,
    Value<double?>? heading,
    Value<int>? rowid,
  }) {
    return TripPointsCompanion(
      tripId: tripId ?? this.tripId,
      timestampMs: timestampMs ?? this.timestampMs,
      speed: speed ?? this.speed,
      segment: segment ?? this.segment,
      overLimit: overLimit ?? this.overLimit,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (timestampMs.present) {
      map['timestamp_ms'] = Variable<int>(timestampMs.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (segment.present) {
      map['segment'] = Variable<int>(segment.value);
    }
    if (overLimit.present) {
      map['over_limit'] = Variable<bool>(overLimit.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripPointsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('speed: $speed, ')
          ..write('segment: $segment, ')
          ..write('overLimit: $overLimit, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('heading: $heading, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DistanceDaysTable extends DistanceDays
    with TableInfo<$DistanceDaysTable, DistanceDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DistanceDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localDayMeta = const VerificationMeta(
    'localDay',
  );
  @override
  late final GeneratedColumn<String> localDay = GeneratedColumn<String>(
    'local_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metersMeta = const VerificationMeta('meters');
  @override
  late final GeneratedColumn<double> meters = GeneratedColumn<double>(
    'meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [localDay, meters];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'distance_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<DistanceDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_day')) {
      context.handle(
        _localDayMeta,
        localDay.isAcceptableOrUnknown(data['local_day']!, _localDayMeta),
      );
    } else if (isInserting) {
      context.missing(_localDayMeta);
    }
    if (data.containsKey('meters')) {
      context.handle(
        _metersMeta,
        meters.isAcceptableOrUnknown(data['meters']!, _metersMeta),
      );
    } else if (isInserting) {
      context.missing(_metersMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localDay};
  @override
  DistanceDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DistanceDay(
      localDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_day'],
      )!,
      meters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}meters'],
      )!,
    );
  }

  @override
  $DistanceDaysTable createAlias(String alias) {
    return $DistanceDaysTable(attachedDatabase, alias);
  }
}

class DistanceDay extends DataClass implements Insertable<DistanceDay> {
  final String localDay;
  final double meters;
  const DistanceDay({required this.localDay, required this.meters});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_day'] = Variable<String>(localDay);
    map['meters'] = Variable<double>(meters);
    return map;
  }

  DistanceDaysCompanion toCompanion(bool nullToAbsent) {
    return DistanceDaysCompanion(
      localDay: Value(localDay),
      meters: Value(meters),
    );
  }

  factory DistanceDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DistanceDay(
      localDay: serializer.fromJson<String>(json['localDay']),
      meters: serializer.fromJson<double>(json['meters']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localDay': serializer.toJson<String>(localDay),
      'meters': serializer.toJson<double>(meters),
    };
  }

  DistanceDay copyWith({String? localDay, double? meters}) => DistanceDay(
    localDay: localDay ?? this.localDay,
    meters: meters ?? this.meters,
  );
  DistanceDay copyWithCompanion(DistanceDaysCompanion data) {
    return DistanceDay(
      localDay: data.localDay.present ? data.localDay.value : this.localDay,
      meters: data.meters.present ? data.meters.value : this.meters,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DistanceDay(')
          ..write('localDay: $localDay, ')
          ..write('meters: $meters')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localDay, meters);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DistanceDay &&
          other.localDay == this.localDay &&
          other.meters == this.meters);
}

class DistanceDaysCompanion extends UpdateCompanion<DistanceDay> {
  final Value<String> localDay;
  final Value<double> meters;
  final Value<int> rowid;
  const DistanceDaysCompanion({
    this.localDay = const Value.absent(),
    this.meters = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DistanceDaysCompanion.insert({
    required String localDay,
    required double meters,
    this.rowid = const Value.absent(),
  }) : localDay = Value(localDay),
       meters = Value(meters);
  static Insertable<DistanceDay> custom({
    Expression<String>? localDay,
    Expression<double>? meters,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localDay != null) 'local_day': localDay,
      if (meters != null) 'meters': meters,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DistanceDaysCompanion copyWith({
    Value<String>? localDay,
    Value<double>? meters,
    Value<int>? rowid,
  }) {
    return DistanceDaysCompanion(
      localDay: localDay ?? this.localDay,
      meters: meters ?? this.meters,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localDay.present) {
      map['local_day'] = Variable<String>(localDay.value);
    }
    if (meters.present) {
      map['meters'] = Variable<double>(meters.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DistanceDaysCompanion(')
          ..write('localDay: $localDay, ')
          ..write('meters: $meters, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FuelRecordsTable extends FuelRecords
    with TableInfo<$FuelRecordsTable, FuelRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMsMeta = const VerificationMeta(
    'occurredAtMs',
  );
  @override
  late final GeneratedColumn<int> occurredAtMs = GeneratedColumn<int>(
    'occurred_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelLitersMeta = const VerificationMeta(
    'fuelLiters',
  );
  @override
  late final GeneratedColumn<double> fuelLiters = GeneratedColumn<double>(
    'fuel_liters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelCostMeta = const VerificationMeta(
    'fuelCost',
  );
  @override
  late final GeneratedColumn<double> fuelCost = GeneratedColumn<double>(
    'fuel_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _otherCostMeta = const VerificationMeta(
    'otherCost',
  );
  @override
  late final GeneratedColumn<double> otherCost = GeneratedColumn<double>(
    'other_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occurredAtMs,
    distanceMeters,
    fuelLiters,
    fuelCost,
    otherCost,
    currencyCode,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuelRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurred_at_ms')) {
      context.handle(
        _occurredAtMsMeta,
        occurredAtMs.isAcceptableOrUnknown(
          data['occurred_at_ms']!,
          _occurredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMsMeta);
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceMetersMeta);
    }
    if (data.containsKey('fuel_liters')) {
      context.handle(
        _fuelLitersMeta,
        fuelLiters.isAcceptableOrUnknown(data['fuel_liters']!, _fuelLitersMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelLitersMeta);
    }
    if (data.containsKey('fuel_cost')) {
      context.handle(
        _fuelCostMeta,
        fuelCost.isAcceptableOrUnknown(data['fuel_cost']!, _fuelCostMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelCostMeta);
    }
    if (data.containsKey('other_cost')) {
      context.handle(
        _otherCostMeta,
        otherCost.isAcceptableOrUnknown(data['other_cost']!, _otherCostMeta),
      );
    } else if (isInserting) {
      context.missing(_otherCostMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FuelRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occurredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at_ms'],
      )!,
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      )!,
      fuelLiters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_liters'],
      )!,
      fuelCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_cost'],
      )!,
      otherCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}other_cost'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $FuelRecordsTable createAlias(String alias) {
    return $FuelRecordsTable(attachedDatabase, alias);
  }
}

class FuelRecord extends DataClass implements Insertable<FuelRecord> {
  final String id;
  final int occurredAtMs;
  final double distanceMeters;
  final double fuelLiters;
  final double fuelCost;
  final double otherCost;
  final String currencyCode;
  final String note;
  const FuelRecord({
    required this.id,
    required this.occurredAtMs,
    required this.distanceMeters,
    required this.fuelLiters,
    required this.fuelCost,
    required this.otherCost,
    required this.currencyCode,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurred_at_ms'] = Variable<int>(occurredAtMs);
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['fuel_liters'] = Variable<double>(fuelLiters);
    map['fuel_cost'] = Variable<double>(fuelCost);
    map['other_cost'] = Variable<double>(otherCost);
    map['currency_code'] = Variable<String>(currencyCode);
    map['note'] = Variable<String>(note);
    return map;
  }

  FuelRecordsCompanion toCompanion(bool nullToAbsent) {
    return FuelRecordsCompanion(
      id: Value(id),
      occurredAtMs: Value(occurredAtMs),
      distanceMeters: Value(distanceMeters),
      fuelLiters: Value(fuelLiters),
      fuelCost: Value(fuelCost),
      otherCost: Value(otherCost),
      currencyCode: Value(currencyCode),
      note: Value(note),
    );
  }

  factory FuelRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelRecord(
      id: serializer.fromJson<String>(json['id']),
      occurredAtMs: serializer.fromJson<int>(json['occurredAtMs']),
      distanceMeters: serializer.fromJson<double>(json['distanceMeters']),
      fuelLiters: serializer.fromJson<double>(json['fuelLiters']),
      fuelCost: serializer.fromJson<double>(json['fuelCost']),
      otherCost: serializer.fromJson<double>(json['otherCost']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurredAtMs': serializer.toJson<int>(occurredAtMs),
      'distanceMeters': serializer.toJson<double>(distanceMeters),
      'fuelLiters': serializer.toJson<double>(fuelLiters),
      'fuelCost': serializer.toJson<double>(fuelCost),
      'otherCost': serializer.toJson<double>(otherCost),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'note': serializer.toJson<String>(note),
    };
  }

  FuelRecord copyWith({
    String? id,
    int? occurredAtMs,
    double? distanceMeters,
    double? fuelLiters,
    double? fuelCost,
    double? otherCost,
    String? currencyCode,
    String? note,
  }) => FuelRecord(
    id: id ?? this.id,
    occurredAtMs: occurredAtMs ?? this.occurredAtMs,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    fuelLiters: fuelLiters ?? this.fuelLiters,
    fuelCost: fuelCost ?? this.fuelCost,
    otherCost: otherCost ?? this.otherCost,
    currencyCode: currencyCode ?? this.currencyCode,
    note: note ?? this.note,
  );
  FuelRecord copyWithCompanion(FuelRecordsCompanion data) {
    return FuelRecord(
      id: data.id.present ? data.id.value : this.id,
      occurredAtMs: data.occurredAtMs.present
          ? data.occurredAtMs.value
          : this.occurredAtMs,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      fuelLiters: data.fuelLiters.present
          ? data.fuelLiters.value
          : this.fuelLiters,
      fuelCost: data.fuelCost.present ? data.fuelCost.value : this.fuelCost,
      otherCost: data.otherCost.present ? data.otherCost.value : this.otherCost,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelRecord(')
          ..write('id: $id, ')
          ..write('occurredAtMs: $occurredAtMs, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('fuelLiters: $fuelLiters, ')
          ..write('fuelCost: $fuelCost, ')
          ..write('otherCost: $otherCost, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    occurredAtMs,
    distanceMeters,
    fuelLiters,
    fuelCost,
    otherCost,
    currencyCode,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelRecord &&
          other.id == this.id &&
          other.occurredAtMs == this.occurredAtMs &&
          other.distanceMeters == this.distanceMeters &&
          other.fuelLiters == this.fuelLiters &&
          other.fuelCost == this.fuelCost &&
          other.otherCost == this.otherCost &&
          other.currencyCode == this.currencyCode &&
          other.note == this.note);
}

class FuelRecordsCompanion extends UpdateCompanion<FuelRecord> {
  final Value<String> id;
  final Value<int> occurredAtMs;
  final Value<double> distanceMeters;
  final Value<double> fuelLiters;
  final Value<double> fuelCost;
  final Value<double> otherCost;
  final Value<String> currencyCode;
  final Value<String> note;
  final Value<int> rowid;
  const FuelRecordsCompanion({
    this.id = const Value.absent(),
    this.occurredAtMs = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.fuelLiters = const Value.absent(),
    this.fuelCost = const Value.absent(),
    this.otherCost = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FuelRecordsCompanion.insert({
    required String id,
    required int occurredAtMs,
    required double distanceMeters,
    required double fuelLiters,
    required double fuelCost,
    required double otherCost,
    required String currencyCode,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occurredAtMs = Value(occurredAtMs),
       distanceMeters = Value(distanceMeters),
       fuelLiters = Value(fuelLiters),
       fuelCost = Value(fuelCost),
       otherCost = Value(otherCost),
       currencyCode = Value(currencyCode);
  static Insertable<FuelRecord> custom({
    Expression<String>? id,
    Expression<int>? occurredAtMs,
    Expression<double>? distanceMeters,
    Expression<double>? fuelLiters,
    Expression<double>? fuelCost,
    Expression<double>? otherCost,
    Expression<String>? currencyCode,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAtMs != null) 'occurred_at_ms': occurredAtMs,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (fuelLiters != null) 'fuel_liters': fuelLiters,
      if (fuelCost != null) 'fuel_cost': fuelCost,
      if (otherCost != null) 'other_cost': otherCost,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FuelRecordsCompanion copyWith({
    Value<String>? id,
    Value<int>? occurredAtMs,
    Value<double>? distanceMeters,
    Value<double>? fuelLiters,
    Value<double>? fuelCost,
    Value<double>? otherCost,
    Value<String>? currencyCode,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return FuelRecordsCompanion(
      id: id ?? this.id,
      occurredAtMs: occurredAtMs ?? this.occurredAtMs,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      fuelLiters: fuelLiters ?? this.fuelLiters,
      fuelCost: fuelCost ?? this.fuelCost,
      otherCost: otherCost ?? this.otherCost,
      currencyCode: currencyCode ?? this.currencyCode,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occurredAtMs.present) {
      map['occurred_at_ms'] = Variable<int>(occurredAtMs.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (fuelLiters.present) {
      map['fuel_liters'] = Variable<double>(fuelLiters.value);
    }
    if (fuelCost.present) {
      map['fuel_cost'] = Variable<double>(fuelCost.value);
    }
    if (otherCost.present) {
      map['other_cost'] = Variable<double>(otherCost.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelRecordsCompanion(')
          ..write('id: $id, ')
          ..write('occurredAtMs: $occurredAtMs, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('fuelLiters: $fuelLiters, ')
          ..write('fuelCost: $fuelCost, ')
          ..write('otherCost: $otherCost, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripRecordsTable tripRecords = $TripRecordsTable(this);
  late final $TripPointsTable tripPoints = $TripPointsTable(this);
  late final $DistanceDaysTable distanceDays = $DistanceDaysTable(this);
  late final $FuelRecordsTable fuelRecords = $FuelRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tripRecords,
    tripPoints,
    distanceDays,
    fuelRecords,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trip_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trip_points', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TripRecordsTableCreateCompanionBuilder =
    TripRecordsCompanion Function({
      required String id,
      required int startedAtMs,
      Value<int?> endedAtMs,
      Value<double> distanceMeters,
      Value<double> maxSpeed,
      Value<int> elapsedUs,
      Value<int> movingUs,
      Value<bool> paused,
      Value<int> segment,
      Value<int?> lastPointMs,
      Value<int> rowid,
    });
typedef $$TripRecordsTableUpdateCompanionBuilder =
    TripRecordsCompanion Function({
      Value<String> id,
      Value<int> startedAtMs,
      Value<int?> endedAtMs,
      Value<double> distanceMeters,
      Value<double> maxSpeed,
      Value<int> elapsedUs,
      Value<int> movingUs,
      Value<bool> paused,
      Value<int> segment,
      Value<int?> lastPointMs,
      Value<int> rowid,
    });

final class $$TripRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $TripRecordsTable, TripRecord> {
  $$TripRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TripPointsTable, List<TripPoint>>
  _tripPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tripPoints,
    aliasName: 'trip_records__id__trip_points__trip_id',
  );

  $$TripPointsTableProcessedTableManager get tripPointsRefs {
    final manager = $$TripPointsTableTableManager(
      $_db,
      $_db.tripPoints,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TripRecordsTable> {
  $$TripRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAtMs => $composableBuilder(
    column: $table.endedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedUs => $composableBuilder(
    column: $table.elapsedUs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movingUs => $composableBuilder(
    column: $table.movingUs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPointMs => $composableBuilder(
    column: $table.lastPointMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tripPointsRefs(
    Expression<bool> Function($$TripPointsTableFilterComposer f) f,
  ) {
    final $$TripPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripPoints,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripPointsTableFilterComposer(
            $db: $db,
            $table: $db.tripPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripRecordsTable> {
  $$TripRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAtMs => $composableBuilder(
    column: $table.endedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedUs => $composableBuilder(
    column: $table.elapsedUs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movingUs => $composableBuilder(
    column: $table.movingUs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPointMs => $composableBuilder(
    column: $table.lastPointMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripRecordsTable> {
  $$TripRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endedAtMs =>
      $composableBuilder(column: $table.endedAtMs, builder: (column) => column);

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeed =>
      $composableBuilder(column: $table.maxSpeed, builder: (column) => column);

  GeneratedColumn<int> get elapsedUs =>
      $composableBuilder(column: $table.elapsedUs, builder: (column) => column);

  GeneratedColumn<int> get movingUs =>
      $composableBuilder(column: $table.movingUs, builder: (column) => column);

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<int> get segment =>
      $composableBuilder(column: $table.segment, builder: (column) => column);

  GeneratedColumn<int> get lastPointMs => $composableBuilder(
    column: $table.lastPointMs,
    builder: (column) => column,
  );

  Expression<T> tripPointsRefs<T extends Object>(
    Expression<T> Function($$TripPointsTableAnnotationComposer a) f,
  ) {
    final $$TripPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripPoints,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripRecordsTable,
          TripRecord,
          $$TripRecordsTableFilterComposer,
          $$TripRecordsTableOrderingComposer,
          $$TripRecordsTableAnnotationComposer,
          $$TripRecordsTableCreateCompanionBuilder,
          $$TripRecordsTableUpdateCompanionBuilder,
          (TripRecord, $$TripRecordsTableReferences),
          TripRecord,
          PrefetchHooks Function({bool tripPointsRefs})
        > {
  $$TripRecordsTableTableManager(_$AppDatabase db, $TripRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> startedAtMs = const Value.absent(),
                Value<int?> endedAtMs = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> maxSpeed = const Value.absent(),
                Value<int> elapsedUs = const Value.absent(),
                Value<int> movingUs = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<int> segment = const Value.absent(),
                Value<int?> lastPointMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripRecordsCompanion(
                id: id,
                startedAtMs: startedAtMs,
                endedAtMs: endedAtMs,
                distanceMeters: distanceMeters,
                maxSpeed: maxSpeed,
                elapsedUs: elapsedUs,
                movingUs: movingUs,
                paused: paused,
                segment: segment,
                lastPointMs: lastPointMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int startedAtMs,
                Value<int?> endedAtMs = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> maxSpeed = const Value.absent(),
                Value<int> elapsedUs = const Value.absent(),
                Value<int> movingUs = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<int> segment = const Value.absent(),
                Value<int?> lastPointMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripRecordsCompanion.insert(
                id: id,
                startedAtMs: startedAtMs,
                endedAtMs: endedAtMs,
                distanceMeters: distanceMeters,
                maxSpeed: maxSpeed,
                elapsedUs: elapsedUs,
                movingUs: movingUs,
                paused: paused,
                segment: segment,
                lastPointMs: lastPointMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TripRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripPointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tripPointsRefs) db.tripPoints],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tripPointsRefs)
                    await $_getPrefetchedData<
                      TripRecord,
                      $TripRecordsTable,
                      TripPoint
                    >(
                      currentTable: table,
                      referencedTable: $$TripRecordsTableReferences
                          ._tripPointsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TripRecordsTableReferences(
                            db,
                            table,
                            p0,
                          ).tripPointsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tripId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TripRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripRecordsTable,
      TripRecord,
      $$TripRecordsTableFilterComposer,
      $$TripRecordsTableOrderingComposer,
      $$TripRecordsTableAnnotationComposer,
      $$TripRecordsTableCreateCompanionBuilder,
      $$TripRecordsTableUpdateCompanionBuilder,
      (TripRecord, $$TripRecordsTableReferences),
      TripRecord,
      PrefetchHooks Function({bool tripPointsRefs})
    >;
typedef $$TripPointsTableCreateCompanionBuilder =
    TripPointsCompanion Function({
      required String tripId,
      required int timestampMs,
      required double speed,
      required int segment,
      required bool overLimit,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> accuracy,
      Value<double?> altitude,
      Value<double?> heading,
      Value<int> rowid,
    });
typedef $$TripPointsTableUpdateCompanionBuilder =
    TripPointsCompanion Function({
      Value<String> tripId,
      Value<int> timestampMs,
      Value<double> speed,
      Value<int> segment,
      Value<bool> overLimit,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> accuracy,
      Value<double?> altitude,
      Value<double?> heading,
      Value<int> rowid,
    });

final class $$TripPointsTableReferences
    extends BaseReferences<_$AppDatabase, $TripPointsTable, TripPoint> {
  $$TripPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripRecordsTable _tripIdTable(_$AppDatabase db) =>
      db.tripRecords.createAlias('trip_points__trip_id__trip_records__id');

  $$TripRecordsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripRecordsTableTableManager(
      $_db,
      $_db.tripRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TripPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TripPointsTable> {
  $$TripPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get timestampMs => $composableBuilder(
    column: $table.timestampMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get overLimit => $composableBuilder(
    column: $table.overLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnFilters(column),
  );

  $$TripRecordsTableFilterComposer get tripId {
    final $$TripRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripRecordsTableFilterComposer(
            $db: $db,
            $table: $db.tripRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripPointsTable> {
  $$TripPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get timestampMs => $composableBuilder(
    column: $table.timestampMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get overLimit => $composableBuilder(
    column: $table.overLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripRecordsTableOrderingComposer get tripId {
    final $$TripRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.tripRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripPointsTable> {
  $$TripPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get timestampMs => $composableBuilder(
    column: $table.timestampMs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<int> get segment =>
      $composableBuilder(column: $table.segment, builder: (column) => column);

  GeneratedColumn<bool> get overLimit =>
      $composableBuilder(column: $table.overLimit, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<double> get heading =>
      $composableBuilder(column: $table.heading, builder: (column) => column);

  $$TripRecordsTableAnnotationComposer get tripId {
    final $$TripRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.tripRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripPointsTable,
          TripPoint,
          $$TripPointsTableFilterComposer,
          $$TripPointsTableOrderingComposer,
          $$TripPointsTableAnnotationComposer,
          $$TripPointsTableCreateCompanionBuilder,
          $$TripPointsTableUpdateCompanionBuilder,
          (TripPoint, $$TripPointsTableReferences),
          TripPoint,
          PrefetchHooks Function({bool tripId})
        > {
  $$TripPointsTableTableManager(_$AppDatabase db, $TripPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tripId = const Value.absent(),
                Value<int> timestampMs = const Value.absent(),
                Value<double> speed = const Value.absent(),
                Value<int> segment = const Value.absent(),
                Value<bool> overLimit = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> heading = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripPointsCompanion(
                tripId: tripId,
                timestampMs: timestampMs,
                speed: speed,
                segment: segment,
                overLimit: overLimit,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                altitude: altitude,
                heading: heading,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tripId,
                required int timestampMs,
                required double speed,
                required int segment,
                required bool overLimit,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> heading = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripPointsCompanion.insert(
                tripId: tripId,
                timestampMs: timestampMs,
                speed: speed,
                segment: segment,
                overLimit: overLimit,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                altitude: altitude,
                heading: heading,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TripPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$TripPointsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$TripPointsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TripPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripPointsTable,
      TripPoint,
      $$TripPointsTableFilterComposer,
      $$TripPointsTableOrderingComposer,
      $$TripPointsTableAnnotationComposer,
      $$TripPointsTableCreateCompanionBuilder,
      $$TripPointsTableUpdateCompanionBuilder,
      (TripPoint, $$TripPointsTableReferences),
      TripPoint,
      PrefetchHooks Function({bool tripId})
    >;
typedef $$DistanceDaysTableCreateCompanionBuilder =
    DistanceDaysCompanion Function({
      required String localDay,
      required double meters,
      Value<int> rowid,
    });
typedef $$DistanceDaysTableUpdateCompanionBuilder =
    DistanceDaysCompanion Function({
      Value<String> localDay,
      Value<double> meters,
      Value<int> rowid,
    });

class $$DistanceDaysTableFilterComposer
    extends Composer<_$AppDatabase, $DistanceDaysTable> {
  $$DistanceDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDay => $composableBuilder(
    column: $table.localDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get meters => $composableBuilder(
    column: $table.meters,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DistanceDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $DistanceDaysTable> {
  $$DistanceDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDay => $composableBuilder(
    column: $table.localDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get meters => $composableBuilder(
    column: $table.meters,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DistanceDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $DistanceDaysTable> {
  $$DistanceDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDay =>
      $composableBuilder(column: $table.localDay, builder: (column) => column);

  GeneratedColumn<double> get meters =>
      $composableBuilder(column: $table.meters, builder: (column) => column);
}

class $$DistanceDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DistanceDaysTable,
          DistanceDay,
          $$DistanceDaysTableFilterComposer,
          $$DistanceDaysTableOrderingComposer,
          $$DistanceDaysTableAnnotationComposer,
          $$DistanceDaysTableCreateCompanionBuilder,
          $$DistanceDaysTableUpdateCompanionBuilder,
          (
            DistanceDay,
            BaseReferences<_$AppDatabase, $DistanceDaysTable, DistanceDay>,
          ),
          DistanceDay,
          PrefetchHooks Function()
        > {
  $$DistanceDaysTableTableManager(_$AppDatabase db, $DistanceDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DistanceDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DistanceDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DistanceDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localDay = const Value.absent(),
                Value<double> meters = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DistanceDaysCompanion(
                localDay: localDay,
                meters: meters,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localDay,
                required double meters,
                Value<int> rowid = const Value.absent(),
              }) => DistanceDaysCompanion.insert(
                localDay: localDay,
                meters: meters,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DistanceDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DistanceDaysTable,
      DistanceDay,
      $$DistanceDaysTableFilterComposer,
      $$DistanceDaysTableOrderingComposer,
      $$DistanceDaysTableAnnotationComposer,
      $$DistanceDaysTableCreateCompanionBuilder,
      $$DistanceDaysTableUpdateCompanionBuilder,
      (
        DistanceDay,
        BaseReferences<_$AppDatabase, $DistanceDaysTable, DistanceDay>,
      ),
      DistanceDay,
      PrefetchHooks Function()
    >;
typedef $$FuelRecordsTableCreateCompanionBuilder =
    FuelRecordsCompanion Function({
      required String id,
      required int occurredAtMs,
      required double distanceMeters,
      required double fuelLiters,
      required double fuelCost,
      required double otherCost,
      required String currencyCode,
      Value<String> note,
      Value<int> rowid,
    });
typedef $$FuelRecordsTableUpdateCompanionBuilder =
    FuelRecordsCompanion Function({
      Value<String> id,
      Value<int> occurredAtMs,
      Value<double> distanceMeters,
      Value<double> fuelLiters,
      Value<double> fuelCost,
      Value<double> otherCost,
      Value<String> currencyCode,
      Value<String> note,
      Value<int> rowid,
    });

class $$FuelRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelLiters => $composableBuilder(
    column: $table.fuelLiters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelCost => $composableBuilder(
    column: $table.fuelCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get otherCost => $composableBuilder(
    column: $table.otherCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FuelRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelLiters => $composableBuilder(
    column: $table.fuelLiters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelCost => $composableBuilder(
    column: $table.fuelCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get otherCost => $composableBuilder(
    column: $table.otherCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FuelRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get occurredAtMs => $composableBuilder(
    column: $table.occurredAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fuelLiters => $composableBuilder(
    column: $table.fuelLiters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fuelCost =>
      $composableBuilder(column: $table.fuelCost, builder: (column) => column);

  GeneratedColumn<double> get otherCost =>
      $composableBuilder(column: $table.otherCost, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$FuelRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelRecordsTable,
          FuelRecord,
          $$FuelRecordsTableFilterComposer,
          $$FuelRecordsTableOrderingComposer,
          $$FuelRecordsTableAnnotationComposer,
          $$FuelRecordsTableCreateCompanionBuilder,
          $$FuelRecordsTableUpdateCompanionBuilder,
          (
            FuelRecord,
            BaseReferences<_$AppDatabase, $FuelRecordsTable, FuelRecord>,
          ),
          FuelRecord,
          PrefetchHooks Function()
        > {
  $$FuelRecordsTableTableManager(_$AppDatabase db, $FuelRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> occurredAtMs = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<double> fuelLiters = const Value.absent(),
                Value<double> fuelCost = const Value.absent(),
                Value<double> otherCost = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FuelRecordsCompanion(
                id: id,
                occurredAtMs: occurredAtMs,
                distanceMeters: distanceMeters,
                fuelLiters: fuelLiters,
                fuelCost: fuelCost,
                otherCost: otherCost,
                currencyCode: currencyCode,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int occurredAtMs,
                required double distanceMeters,
                required double fuelLiters,
                required double fuelCost,
                required double otherCost,
                required String currencyCode,
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FuelRecordsCompanion.insert(
                id: id,
                occurredAtMs: occurredAtMs,
                distanceMeters: distanceMeters,
                fuelLiters: fuelLiters,
                fuelCost: fuelCost,
                otherCost: otherCost,
                currencyCode: currencyCode,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FuelRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelRecordsTable,
      FuelRecord,
      $$FuelRecordsTableFilterComposer,
      $$FuelRecordsTableOrderingComposer,
      $$FuelRecordsTableAnnotationComposer,
      $$FuelRecordsTableCreateCompanionBuilder,
      $$FuelRecordsTableUpdateCompanionBuilder,
      (
        FuelRecord,
        BaseReferences<_$AppDatabase, $FuelRecordsTable, FuelRecord>,
      ),
      FuelRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripRecordsTableTableManager get tripRecords =>
      $$TripRecordsTableTableManager(_db, _db.tripRecords);
  $$TripPointsTableTableManager get tripPoints =>
      $$TripPointsTableTableManager(_db, _db.tripPoints);
  $$DistanceDaysTableTableManager get distanceDays =>
      $$DistanceDaysTableTableManager(_db, _db.distanceDays);
  $$FuelRecordsTableTableManager get fuelRecords =>
      $$FuelRecordsTableTableManager(_db, _db.fuelRecords);
}
