import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends ChangeNotifier {
  static const _addKompressoPrefixKey = 'add_kompresso_prefix';
  static const _showOverheatWarningKey = 'show_overheat_warning';
  static const _preserveMetadataKey = 'preserve_metadata';
  static const _saveVideosToAlbumKey = 'save_videos_to_album';
  static const _languageCodeKey = 'language_code';
  static const appPrefix = 'minimo_';
  static const albumName = 'Minimo';

  static final instance = AppSettingsService._();

  AppSettingsService._();

  late SharedPreferences _preferences;
  bool addKompressoPrefix = true;
  bool showOverheatWarning = true;
  bool preserveMetadata = true;
  bool saveVideosToAlbum = false;
  String? languageCode;

  Locale? get locale => languageCode == null ? null : Locale(languageCode!);

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
    addKompressoPrefix =
        _preferences.getBool(_addKompressoPrefixKey) ?? addKompressoPrefix;
    showOverheatWarning =
        _preferences.getBool(_showOverheatWarningKey) ?? showOverheatWarning;
    preserveMetadata =
        _preferences.getBool(_preserveMetadataKey) ?? preserveMetadata;
    saveVideosToAlbum =
        _preferences.getBool(_saveVideosToAlbumKey) ?? saveVideosToAlbum;
    languageCode = _preferences.getString(_languageCodeKey);
  }

  Future<void> setAddKompressoPrefix(bool value) =>
      _setBool(_addKompressoPrefixKey, value, (v) => addKompressoPrefix = v);

  Future<void> setShowOverheatWarning(bool value) =>
      _setBool(_showOverheatWarningKey, value, (v) => showOverheatWarning = v);

  Future<void> setPreserveMetadata(bool value) =>
      _setBool(_preserveMetadataKey, value, (v) => preserveMetadata = v);

  Future<void> setSaveVideosToAlbum(bool value) =>
      _setBool(_saveVideosToAlbumKey, value, (v) => saveVideosToAlbum = v);

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
