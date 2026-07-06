import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends ChangeNotifier {
  static const _addKompressoPrefixKey = 'add_kompresso_prefix';
  static const _showOverheatWarningKey = 'show_overheat_warning';
  static const _saveVideosToAlbumKey = 'save_videos_to_album';
  static const _languageCodeKey = 'language_code';
  static const _darkThemeKey = 'dark_theme';
  static const appPrefix = 'minimo_';
  static const albumName = 'Minimo';

  static final instance = AppSettingsService._();

  AppSettingsService._();

  late SharedPreferences _preferences;
  bool addKompressoPrefix = true;
  bool showOverheatWarning = true;
  bool saveVideosToAlbum = false;
  String? languageCode;
  bool? darkTheme;

  Locale? get locale => languageCode == null ? null : Locale(languageCode!);
  ThemeMode get themeMode => switch (darkTheme) {
    true => ThemeMode.dark,
    false => ThemeMode.light,
    null => ThemeMode.system,
  };

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
    addKompressoPrefix =
        _preferences.getBool(_addKompressoPrefixKey) ?? addKompressoPrefix;
    showOverheatWarning =
        _preferences.getBool(_showOverheatWarningKey) ?? showOverheatWarning;
    saveVideosToAlbum =
        _preferences.getBool(_saveVideosToAlbumKey) ?? saveVideosToAlbum;
    languageCode = _preferences.getString(_languageCodeKey);
    darkTheme = _preferences.getBool(_darkThemeKey);
  }

  Future<void> setAddKompressoPrefix(bool value) =>
      _setBool(_addKompressoPrefixKey, value, (v) => addKompressoPrefix = v);

  Future<void> setShowOverheatWarning(bool value) =>
      _setBool(_showOverheatWarningKey, value, (v) => showOverheatWarning = v);

  Future<void> setSaveVideosToAlbum(bool value) =>
      _setBool(_saveVideosToAlbumKey, value, (v) => saveVideosToAlbum = v);

  Future<void> setDarkTheme(bool value) =>
      _setBool(_darkThemeKey, value, (v) => darkTheme = v);

  Future<void> setLanguageCode(String? value) async {
    languageCode = value;
    if (value == null) {
      await _preferences.remove(_languageCodeKey);
    } else {
      await _preferences.setString(_languageCodeKey, value);
    }
    notifyListeners();
  }

  Future<void> _setBool(
    String key,
    bool value,
    ValueChanged<bool> update,
  ) async {
    update(value);
    await _preferences.setBool(key, value);
    notifyListeners();
  }
}
