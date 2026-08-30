import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_launch_service.dart';

enum Language {
  en('en'),
  ru('ru'),
  es('es'),
  pt('pt'),
  de('de'),
  fr('fr'),
  zh('zh'),
  hi('hi'),
  nl('nl'),
  ko('ko'),
  ja('ja'),
  it('it');

  final String code;

  const Language(this.code);

  static Language fromCode(String? code) => switch (code) {
    'ru' => Language.ru,
    'es' => Language.es,
    'pt' => Language.pt,
    'de' => Language.de,
    'fr' => Language.fr,
    'zh' => Language.zh,
    'hi' => Language.hi,
    'nl' => Language.nl,
    'ko' => Language.ko,
    'ja' => Language.ja,
    'it' => Language.it,
    _ => Language.en,
  };
}

typedef Changelog = Map<String, Map<Language, List<String>>>;

const Changelog _changelog = {
  '1.0.3': {
    Language.en: [
      'use minimo in Spanish, Brazilian Portuguese, German, French, Simplified Chinese, Hindi, Dutch, Korean, Japanese, and Italian.',
      'switch between Simple and Advanced compression with a clearer, more accessible control and reduced-motion support.',
    ],
    Language.ru: [
      'можно пользоваться minimo на испанском, бразильском португальском, немецком, французском, упрощённом китайском, хинди, нидерландском, корейском, японском и итальянском.',
      'переключатель простого и расширенного режимов стал понятнее, доступнее и учитывает настройку уменьшения движения.',
    ],
    Language.es: [
      'usa minimo en español, portugués de Brasil, alemán, francés, chino simplificado, hindi, neerlandés, coreano, japonés e italiano.',
      'cambia entre la compresión simple y avanzada con un control más claro, accesible y compatible con movimiento reducido.',
    ],
    Language.pt: [
      'use o minimo em espanhol, português do Brasil, alemão, francês, chinês simplificado, hindi, neerlandês, coreano, japonês e italiano.',
      'alterne entre compressão simples e avançada com um controle mais claro, acessível e compatível com movimento reduzido.',
    ],
    Language.de: [
      'nutze minimo auf Spanisch, brasilianischem Portugiesisch, Deutsch, Französisch, vereinfachtem Chinesisch, Hindi, Niederländisch, Koreanisch, Japanisch und Italienisch.',
      'wechsle mit einer klareren, barrierefreien Steuerung und Unterstützung für reduzierte Bewegung zwischen einfacher und erweiterter Komprimierung.',
    ],
    Language.fr: [
      'utilisez minimo en espagnol, portugais brésilien, allemand, français, chinois simplifié, hindi, néerlandais, coréen, japonais et italien.',
      'basculez entre la compression simple et avancée avec une commande plus claire, accessible et compatible avec la réduction des animations.',
    ],
    Language.zh: [
      '现可使用西班牙语、巴西葡萄牙语、德语、法语、简体中文、印地语、荷兰语、韩语、日语和意大利语使用 minimo。',
      '使用更清晰、更无障碍且支持减少动效的控件，在简单和高级压缩之间切换。',
    ],
    Language.hi: [
      'अब minimo का इस्तेमाल स्पेनिश, ब्राज़ीलियाई पुर्तगाली, जर्मन, फ़्रेंच, सरलीकृत चीनी, हिंदी, डच, कोरियाई, जापानी और इतालवी में करें।',
      'सरल और उन्नत कंप्रेशन के बीच अब एक साफ़, सुलभ और कम मोशन का समर्थन करने वाले कंट्रोल से बदलें।',
    ],
    Language.nl: [
      'gebruik minimo in het Spaans, Braziliaans Portugees, Duits, Frans, vereenvoudigd Chinees, Hindi, Nederlands, Koreaans, Japans en Italiaans.',
      'wissel tussen eenvoudige en geavanceerde compressie met een duidelijkere, toegankelijke bediening en ondersteuning voor minder beweging.',
    ],
    Language.ko: [
      'minimo를 스페인어, 브라질 포르투갈어, 독일어, 프랑스어, 중국어 간체, 힌디어, 네덜란드어, 한국어, 일본어, 이탈리아어로 사용하세요.',
      '더 명확하고 접근성이 높으며 모션 줄이기를 지원하는 컨트롤로 간단 압축과 고급 압축을 전환하세요.',
    ],
    Language.ja: [
      'minimoをスペイン語、ブラジルポルトガル語、ドイツ語、フランス語、簡体中国語、ヒンディー語、オランダ語、韓国語、日本語、イタリア語で利用できます。',
      'より分かりやすくアクセシブで、動きを減らす設定にも対応したコントロールで、シンプル圧縮と詳細圧縮を切り替えられます。',
    ],
    Language.it: [
      'usa minimo in spagnolo, portoghese brasiliano, tedesco, francese, cinese semplificato, hindi, olandese, coreano, giapponese e italiano.',
      'passa dalla compressione semplice a quella avanzata con un controllo più chiaro, accessibile e compatibile con la riduzione del movimento.',
    ],
  },
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
