import 'dart:convert';

import '../entities/recorded_trip.dart';
import '../entities/track_point.dart';
import '../entities/trip_export_format.dart';

/// Encodes portable SI-unit exports without inventing coordinates or joining pauses.
final class EncodeTripUseCase {
  const EncodeTripUseCase();

  String call(RecordedTrip trip, TripExportFormat format) => switch (format) {
    TripExportFormat.csv => _csv(trip),
    TripExportFormat.gpx => _gpx(trip),
  };

  String _csv(RecordedTrip trip) {
    final buffer = StringBuffer(
      'trip_id,timestamp_utc,speed_m_s,latitude,longitude,altitude_m,'
      'accuracy_m,heading_deg,segment,over_limit\r\n',
    );
    for (final point in trip.points) {
      buffer.writeln(
        [
          trip.id,
          point.timestamp.toUtc().toIso8601String(),
          point.speedMetersPerSecond,
          point.latitude,
          point.longitude,
          point.altitudeMeters,
          point.accuracyMeters,
          point.headingDegrees,
          point.segment,
          point.overLimit,
        ].map(_cell).join(','),
      );
    }
    return buffer.toString();
  }

  String _cell(Object? value) {
    if (value == null) return '';
    final text = value.toString();
    return '"${text.replaceAll('"', '""')}"';
  }

  String _gpx(RecordedTrip trip) {
    final buffer = StringBuffer(
      '<?xml version="1.0" encoding="UTF-8"?>\n'
      '<gpx version="1.1" creator="Speedometer" '
      'xmlns="http://www.topografix.com/GPX/1/1" '
      'xmlns:sp="https://speedometer.local/gpx/1">\n'
      '<metadata><time>${trip.startedAt.toUtc().toIso8601String()}</time></metadata>\n'
      '<trk><name>${_xml(trip.id)}</name>\n',
    );
    int? segment;
    for (final point in trip.points) {
      if (!point.hasCoordinates) {
        if (segment != null) buffer.writeln('</trkseg>');
        segment = null;
        continue;
      }
      if (segment != point.segment) {
        if (segment != null) buffer.writeln('</trkseg>');
        buffer.writeln('<trkseg>');
        segment = point.segment;
      }
      _writePoint(buffer, point);
    }
    if (segment != null) buffer.writeln('</trkseg>');
    buffer.writeln('</trk></gpx>');
    return buffer.toString();
  }

  void _writePoint(StringBuffer buffer, TrackPoint point) {
    buffer.writeln('<trkpt lat="${point.latitude}" lon="${point.longitude}">');
    if (point.altitudeMeters case final altitude?) {
      buffer.writeln('<ele>$altitude</ele>');
    }
    buffer.writeln('<time>${point.timestamp.toUtc().toIso8601String()}</time>');
    buffer.writeln(
      '<extensions><sp:speed>${point.speedMetersPerSecond}</sp:speed>'
      '<sp:overLimit>${point.overLimit}</sp:overLimit></extensions></trkpt>',
    );
  }

  String _xml(String value) => const HtmlEscape(
    HtmlEscapeMode.element,
  ).convert(value).replaceAll('"', '&quot;').replaceAll("'", '&apos;');
}
