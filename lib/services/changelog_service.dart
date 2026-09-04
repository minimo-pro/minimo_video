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
  it('it'),
  tr('tr');

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
    'tr' => Language.tr,
    _ => Language.en,
  };
}

typedef Changelog = Map<String, Map<Language, List<String>>>;

const Changelog _changelog = {
  '1.0.4': {
    Language.en: [
      'keep compression size estimates updating for batches over 100 videos, with a loading indicator while recalculating.',
      'see a clearer explanation before Photos asks to delete original videos during replacement.',
      'leave an active video import after confirmation, without flashing empty settings when the picker is cancelled.',
    ],
    Language.ru: [
      'оценка размера теперь обновляется и для пакетов больше 100 видео, а во время пересчёта показывается индикатор загрузки.',
      'перед запросом Фото на удаление оригиналов теперь яснее указано, что удаляются именно исходные видео.',
      'из активной загрузки видео теперь можно выйти после подтверждения, а отмена выбора больше не показывает пустые настройки.',
    ],
    Language.es: [
      'la estimación de tamaño sigue actualizándose en lotes de más de 100 videos y muestra un indicador durante el recálculo.',
      'se muestra una explicación más clara antes de que Fotos pida eliminar los videos originales al reemplazarlos.',
      'sal de una importación activa tras confirmarlo, sin que aparezcan ajustes vacíos al cancelar el selector.',
    ],
    Language.pt: [
      'a estimativa de tamanho continua atualizando em lotes com mais de 100 vídeos e mostra um indicador durante o recálculo.',
      'veja uma explicação mais clara antes que o Fotos peça para excluir os vídeos originais durante a substituição.',
      'saia de uma importação ativa após confirmar, sem mostrar configurações vazias ao cancelar o seletor.',
    ],
    Language.de: [
      'die geschätzte Größe wird auch bei Stapeln mit über 100 Videos aktualisiert; während der Neuberechnung erscheint eine Ladeanzeige.',
      'vor der Löschabfrage von Fotos wird klarer erklärt, dass beim Ersetzen die Originalvideos gelöscht werden.',
      'verlasse einen laufenden Videoimport nach Bestätigung, ohne dass beim Abbrechen des Pickers leere Einstellungen aufblitzen.',
    ],
    Language.fr: [
      'l’estimation de la taille continue de se mettre à jour pour les lots de plus de 100 vidéos, avec un indicateur pendant le recalcul.',
      'une explication plus claire apparaît avant que Photos demande de supprimer les vidéos originales lors du remplacement.',
      'quittez un import vidéo actif après confirmation, sans afficher brièvement des réglages vides si le sélecteur est annulé.',
    ],
    Language.zh: [
      '超过 100 个视频的批量任务也会持续更新预计大小，重新计算时会显示加载指示。',
      '替换视频时，在图库请求删除原视频前会显示更清晰的说明。',
      '确认后可退出正在进行的视频导入，取消选择器时也不会短暂显示空设置。',
    ],
    Language.hi: [
      '100 से अधिक वीडियो वाले बैच में भी अनुमानित आकार अपडेट होता है और दोबारा गणना के दौरान लोडिंग संकेत दिखता है।',
      'बदलने के दौरान फ़ोटो द्वारा मूल वीडियो हटाने की पुष्टि मांगने से पहले अब साफ़ जानकारी दिखती है।',
      'पुष्टि के बाद चल रहे वीडियो इंपोर्ट से बाहर निकलें; पिकर रद्द करने पर खाली सेटिंग्स नहीं दिखेंगी।',
    ],
    Language.nl: [
      "de geschatte grootte blijft ook bij batches van meer dan 100 video's bijgewerkt, met een laadindicator tijdens het herberekenen.",
      "voor Foto's vraagt om de originele video's te verwijderen, verschijnt een duidelijkere uitleg.",
      "verlaat na bevestiging een actieve video-import, zonder dat lege instellingen opflitsen wanneer de picker wordt geannuleerd.",
    ],
    Language.ko: [
      '100개가 넘는 동영상 묶음에서도 예상 크기가 계속 업데이트되며 다시 계산하는 동안 로딩 표시가 나타납니다.',
      '교체할 때 사진 앱이 원본 동영상 삭제를 요청하기 전에 더 명확한 설명이 표시됩니다.',
      '확인 후 진행 중인 동영상 가져오기를 나갈 수 있으며 선택기를 취소해도 빈 설정이 잠깐 표시되지 않습니다.',
    ],
    Language.ja: [
      '100本を超える動画の一括処理でも推定サイズが更新され、再計算中は読み込み表示が出ます。',
      '置き換え時に写真アプリが元の動画の削除を求める前に、より分かりやすい説明が表示されます。',
      '確認後に進行中の動画読み込みを終了でき、選択をキャンセルしても空の設定画面が一瞬表示されません。',
    ],
    Language.it: [
      'la stima delle dimensioni continua ad aggiornarsi anche per gruppi di oltre 100 video, con un indicatore durante il ricalcolo.',
      'prima che Foto chieda di eliminare i video originali durante la sostituzione viene mostrata una spiegazione più chiara.',
      'esci da un’importazione video attiva dopo la conferma, senza mostrare impostazioni vuote quando annulli il selettore.',
    ],
    Language.tr: [
      "100'den fazla videolu gruplarda da tahmini boyut güncellenir ve yeniden hesaplama sırasında yükleme göstergesi görünür.",
      'değiştirme sırasında Fotoğraflar orijinal videoları silmek için izin istemeden önce daha açık bir açıklama gösterilir.',
      'onaydan sonra etkin video içe aktarımından çıkın; seçici iptal edildiğinde boş ayarlar kısa süreliğine görünmez.',
    ],
  },
  '1.0.3': {
    Language.en: [
      'use minimo in Spanish, Brazilian Portuguese, German, French, Simplified Chinese, Hindi, Dutch, Korean, Japanese, Italian, and Turkish.',
      'switch between Simple and Advanced compression with a clearer, more accessible control and reduced-motion support.',
    ],
    Language.ru: [
      'можно пользоваться minimo на испанском, бразильском португальском, немецком, французском, упрощённом китайском, хинди, нидерландском, корейском, японском, итальянском и турецком.',
      'переключатель простого и расширенного режимов стал понятнее, доступнее и учитывает настройку уменьшения движения.',
    ],
    Language.es: [
      'usa minimo en español, portugués de Brasil, alemán, francés, chino simplificado, hindi, neerlandés, coreano, japonés, italiano y turco.',
      'cambia entre la compresión simple y avanzada con un control más claro, accesible y compatible con movimiento reducido.',
    ],
    Language.pt: [
      'use o minimo em espanhol, português do Brasil, alemão, francês, chinês simplificado, hindi, neerlandês, coreano, japonês, italiano e turco.',
      'alterne entre compressão simples e avançada com um controle mais claro, acessível e compatível com movimento reduzido.',
    ],
    Language.de: [
      'nutze minimo auf Spanisch, brasilianischem Portugiesisch, Deutsch, Französisch, vereinfachtem Chinesisch, Hindi, Niederländisch, Koreanisch, Japanisch, Italienisch und Türkisch.',
      'wechsle mit einer klareren, barrierefreien Steuerung und Unterstützung für reduzierte Bewegung zwischen einfacher und erweiterter Komprimierung.',
    ],
    Language.fr: [
      'utilisez minimo en espagnol, portugais brésilien, allemand, français, chinois simplifié, hindi, néerlandais, coréen, japonais, italien et turc.',
      'basculez entre la compression simple et avancée avec une commande plus claire, accessible et compatible avec la réduction des animations.',
    ],
    Language.zh: [
      '现可使用西班牙语、巴西葡萄牙语、德语、法语、简体中文、印地语、荷兰语、韩语、日语、意大利语和土耳其语使用 minimo。',
      '使用更清晰、更无障碍且支持减少动效的控件，在简单和高级压缩之间切换。',
    ],
    Language.hi: [
      'अब minimo का इस्तेमाल स्पेनिश, ब्राज़ीलियाई पुर्तगाली, जर्मन, फ़्रेंच, सरलीकृत चीनी, हिंदी, डच, कोरियाई, जापानी, इतालवी और तुर्की में करें।',
      'सरल और उन्नत कंप्रेशन के बीच अब एक साफ़, सुलभ और कम मोशन का समर्थन करने वाले कंट्रोल से बदलें।',
    ],
    Language.nl: [
      'gebruik minimo in het Spaans, Braziliaans Portugees, Duits, Frans, vereenvoudigd Chinees, Hindi, Nederlands, Koreaans, Japans, Italiaans en Turks.',
      'wissel tussen eenvoudige en geavanceerde compressie met een duidelijkere, toegankelijke bediening en ondersteuning voor minder beweging.',
    ],
    Language.ko: [
      'minimo를 스페인어, 브라질 포르투갈어, 독일어, 프랑스어, 중국어 간체, 힌디어, 네덜란드어, 한국어, 일본어, 이탈리아어, 튀르키예어로 사용하세요.',
      '더 명확하고 접근성이 높으며 모션 줄이기를 지원하는 컨트롤로 간단 압축과 고급 압축을 전환하세요.',
    ],
    Language.ja: [
      'minimoをスペイン語、ブラジルポルトガル語、ドイツ語、フランス語、簡体中国語、ヒンディー語、オランダ語、韓国語、日本語、イタリア語、トルコ語で利用できます。',
      'より分かりやすくアクセシブで、動きを減らす設定にも対応したコントロールで、シンプル圧縮と詳細圧縮を切り替えられます。',
    ],
    Language.it: [
      'usa minimo in spagnolo, portoghese brasiliano, tedesco, francese, cinese semplificato, hindi, olandese, coreano, giapponese, italiano e turco.',
      'passa dalla compressione semplice a quella avanzata con un controllo più chiaro, accessibile e compatibile con la riduzione del movimento.',
    ],
    Language.tr: [
      "minimo'yu İspanyolca, Brezilya Portekizcesi, Almanca, Fransızca, Basitleştirilmiş Çince, Hintçe, Felemenkçe, Korece, Japonca, İtalyanca ve Türkçe kullanın.",
      'daha net, erişilebilir ve azaltılmış hareket desteği sunan denetimle basit ve gelişmiş sıkıştırma arasında geçiş yapın.',
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
