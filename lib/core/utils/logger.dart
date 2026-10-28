import 'dart:developer' as developer;

/// Logs only fixed event identifiers, never raw errors or location data.
class Logger {
  /// Creates the application logger.
  const Logger();

  /// Records an operational failure without potentially private payloads.
  void error(String event) {
    developer.log(event, name: 'speedometer', level: 1000);
  }
}
