import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_launch_service.dart';

enum Language {
  en('en'),
  ru('ru');

  final String code;

  const Language(this.code);

  static Language fromCode(String? code) => switch (code) {
    'ru' => Language.ru,
    _ => Language.en,
  };
}

typedef Changelog = Map<String, Map<Language, List<String>>>;

const Changelog _changelog = {
  '1.0.2': {
    Language.en: [
      'adjust compression settings while cloud-backed or large videos import; the Compress button shows progress until they are ready.',
      'see a loading screen instead of empty settings until video selection is confirmed.',
      'see when compressed videos are saved and avoid saving them twice.',
      'read long update notes with clear fading at the scroll edges.',
    ],
    Language.ru: [
      'можно менять настройки, пока видео загружается из облака или копируется; кнопка сжатия показывает прогресс до готовности.',
      'до подтверждения выбора видео показывается загрузка, а не пустой экран настроек.',
      'после сохранения сжатого видео кнопка показывает результат и не сохраняет его повторно.',
      'у длинного списка изменений теперь видны плавные края прокрутки.',
    ],
  },
  '1.0.1': {
    Language.en: [
      'share minimo with friends.',
      'rate the app from the about screen.',
      'get a gentle review prompt after successful conversions.',
      'see update prompts when a new store version is available.',
      'fine-tune bitrate, frame rate, and H.264 or HEVC codec.',
      'preview original and compressed videos side by side.',
      'get more accurate size estimates and smoother preview scrubbing.',
      'compress portrait screen recordings without squeezing.',
      'choose how saved videos handle originals while preserving gallery metadata where supported.',
      'save compressed videos directly as new gallery items.',
      'avoid replacing or deleting the same gallery video twice.',
      'see clear messages when saving, deleting, or sharing fails.',
    ],
    Language.ru: [
      'можно поделиться minimo с друзьями.',
      'можно оценить приложение из экрана о приложении.',
      'после успешных конвертаций появляется аккуратный запрос оценки.',
      'приложение подсказывает, когда в магазине доступно обновление.',
      'можно настроить битрейт, частоту кадров и кодек H.264 или HEVC.',
      'можно сравнить исходное и сжатое видео рядом.',
      'оценка размера стала точнее, а перемотка предпросмотра — плавнее.',
      'портретные записи экрана больше не сжимаются по ширине.',
      'можно выбрать способ сохранения оригинала с переносом метаданных галереи, где это поддерживается.',
      'сжатые видео сразу сохраняются как новые элементы галереи.',
      'приложение больше не заменяет и не удаляет одно видео повторно.',
      'ошибки сохранения, удаления и отправки теперь описаны понятнее.',
    ],
  },
};

List<String> unseenChanges({
  required String lastSeen,
  required String current,
  required Language language,
  Changelog changelog = _changelog,
}) {
  final lastSeenVersion = _tryParseVersion(lastSeen) ?? Version(0, 0, 0);
  final currentVersion = _tryParseVersion(current);
  if (currentVersion == null) return const [];

  final result = <String>[];
  final entries = <({Version version, Map<Language, List<String>> texts})>[];
  for (final entry in changelog.entries) {
    final entryVersion = _tryParseVersion(entry.key);
    if (entryVersion == null) continue;
    entries.add((version: entryVersion, texts: entry.value));
  }
  entries.sort((a, b) => a.version.compareTo(b.version));

  for (final entry in entries) {
    if (entry.version > lastSeenVersion && entry.version <= currentVersion) {
      result.addAll(entry.texts[language] ?? entry.texts[Language.en] ?? []);
    }
  }

  return result;
}

Version? _tryParseVersion(String value) {
  try {
    return Version.parse(value);
  } on FormatException {
    return null;
  }
}

class ChangelogUpdate {
  final String version;
  final List<String> changes;

  const ChangelogUpdate({required this.version, required this.changes});
}

class ChangelogService {
  static const _lastSeenVersionKey = 'last_seen_version';
  static final instance = ChangelogService();

  final Future<PackageInfo> Function() _packageInfo;
  final Future<SharedPreferences> Function() _preferences;

  String? _currentVersion;

  ChangelogService({
    Future<PackageInfo> Function()? packageInfo,
    Future<SharedPreferences> Function()? preferences,
  }) : _packageInfo = packageInfo ?? PackageInfo.fromPlatform,
       _preferences = preferences ?? SharedPreferences.getInstance;

  Future<ChangelogUpdate?> initialize({required Language language}) async {
    final current = (await _packageInfo()).version;
    _currentVersion = current;

    final prefs = await _preferences();
    final lastSeenRaw = prefs.getString(_lastSeenVersionKey);
    final lastSeen = lastSeenRaw == null
        ? null
        : (_tryParseVersion(lastSeenRaw) == null ? null : lastSeenRaw);

    if (lastSeenRaw != null && lastSeen == null) {
      await prefs.remove(_lastSeenVersionKey);
    }

    if (lastSeen == null && await FirstLaunchService.shouldShowOnboarding()) {
      await prefs.setString(_lastSeenVersionKey, current);
      return null;
    }

    if (lastSeen == current) return null;

    final changes = unseenChanges(
      lastSeen: lastSeen ?? '0.0.0',
      current: current,
      language: language,
    );

    if (changes.isEmpty) {
      await prefs.setString(_lastSeenVersionKey, current);
      return null;
    }

    return ChangelogUpdate(version: current, changes: changes);
  }

  Future<void> markCurrentVersionSeen() async {
    final version = _currentVersion ?? (await _packageInfo()).version;
    final prefs = await _preferences();
    await prefs.setString(_lastSeenVersionKey, version);
  }

  Future<void> dismiss() async {
    await markCurrentVersionSeen();
  }
}
