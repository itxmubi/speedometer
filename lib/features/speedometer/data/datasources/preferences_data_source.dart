import 'package:shared_preferences/shared_preferences.dart';

import '../models/display_preferences_model.dart';

/// Stores one namespaced settings document through the asynchronous prefs API.
class PreferencesDataSource {
  /// Wraps an injected plugin instance so tests never require real storage.
  const PreferencesDataSource(this._preferences);

  /// Changing the document shape requires an explicit migration to a new key.
  static const String storageKey = 'speedometer.preferences.v1';

  final SharedPreferencesAsync _preferences;

  /// Reads the complete preferences document, or null for first launch.
  Future<DisplayPreferencesModel?> read() async {
    final document = await _preferences.getString(storageKey);
    return document == null ? null : DisplayPreferencesModel.fromJson(document);
  }

  /// Writes only the settings key, preserving unrelated local data.
  Future<void> write(DisplayPreferencesModel preferences) =>
      _preferences.setString(storageKey, preferences.toJson());
}
