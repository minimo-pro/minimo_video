// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(value) => "CRF ${value}";

  static String m1(error) => "не удалось сохранить: ${error}";

  static String m2(error) => "не удалось поделиться: ${error}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'осталась примерно 1 минута', few: 'осталось примерно ${count} минуты', many: 'осталось примерно ${count} минут', other: 'осталось примерно ${count} минуты')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'сохранить 1 видео', few: 'сохранить ${count} видео', many: 'сохранить ${count} видео', other: 'сохранить ${count} видео')}";

  static String m5(error) =>
      "видео сохранены, но некоторые оригиналы удалить не удалось: ${error}";

  static String m6(saved, deleted) =>
      "сохранено видео: ${saved}, удалено оригиналов: ${deleted}";

  static String m7(count) =>
      "${Intl.plural(count, one: '1 видео сохранено в галерею', few: '${count} видео сохранено в галерею', many: '${count} видео сохранено в галерею', other: '${count} видео сохранено в галерею')}";

  static String m8(count) =>
      "${Intl.plural(count, one: 'осталась примерно 1 секунда', few: 'осталось примерно ${count} секунды', many: 'осталось примерно ${count} секунд', other: 'осталось примерно ${count} секунды')}";

  static String m9(current, total) => "видео ${current} из ${total}";

  static String m10(completed, total) =>
      "сжато видео: ${completed} из ${total}";

  static String m11(size) => "экономия ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("о приложении"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (видео) появился из простой проблемы. я люблю спорт и часто смотрю короткие фрагменты матчей, которыми делятся клубы и telegram-каналы. даже несколько секунд видео иногда занимают неоправданно много места.\n\nэтот проект даёт каждому удобную и бесплатную возможность сжимать видео прямо на мобильном устройстве, экономить память и сохранять важные моменты.",
    ),
    "additionalOptions": MessageLookupByLibrary.simpleMessage(
      "дополнительные настройки",
    ),
    "advancedOptions": MessageLookupByLibrary.simpleMessage(
      "расширенные настройки",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (видео)"),
    "audio": MessageLookupByLibrary.simpleMessage("звук"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "стерео звучит лучше; моно или удаление звука экономит место",
    ),
    "better": MessageLookupByLibrary.simpleMessage("лучше"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "битрейт будет уменьшен для экономии места",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("отмена"),
    "compress": MessageLookupByLibrary.simpleMessage("сжать"),
    "compressOtherVideos": MessageLookupByLibrary.simpleMessage(
      "сжать другие видео",
    ),
    "compressed": MessageLookupByLibrary.simpleMessage("сжатое"),
    "compressing": MessageLookupByLibrary.simpleMessage("сжатие..."),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "сжатие завершено",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "сжатие завершено",
    ),
    "crfValue": m0,
    "deleteOriginal": MessageLookupByLibrary.simpleMessage("удалить оригинал"),
    "emailCopied": MessageLookupByLibrary.simpleMessage("почта скопирована"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "оцениваем оставшееся время...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("ошибка"),
    "failedToSave": m1,
    "failedToShare": m2,
    "fast": MessageLookupByLibrary.simpleMessage("быстро"),
    "frameRate": MessageLookupByLibrary.simpleMessage("частота кадров"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "меньшая частота уменьшает размер, но движение может стать менее плавным",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("начать"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "репозиторий github",
    ),
    "good": MessageLookupByLibrary.simpleMessage("хорошее"),
    "hardwareAcceleration": MessageLookupByLibrary.simpleMessage(
      "аппаратное ускорение",
    ),
    "hardwareAccelerationDescription": MessageLookupByLibrary.simpleMessage(
      "использует кодировщик устройства для быстрой обработки",
    ),
    "high": MessageLookupByLibrary.simpleMessage("высокое"),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("загрузка видео..."),
    "low": MessageLookupByLibrary.simpleMessage("низкое"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("by khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("среднее"),
    "minutesRemaining": m3,
    "mono": MessageLookupByLibrary.simpleMessage("моно"),
    "mostCompatible": MessageLookupByLibrary.simpleMessage(
      "максимальная совместимость",
    ),
    "myOtherApps": MessageLookupByLibrary.simpleMessage(
      "другие мои приложения",
    ),
    "myWebsite": MessageLookupByLibrary.simpleMessage("мой сайт"),
    "next": MessageLookupByLibrary.simpleMessage("далее"),
    "noAudio": MessageLookupByLibrary.simpleMessage("без звука"),
    "noiseReduction": MessageLookupByLibrary.simpleMessage("шумоподавление"),
    "noiseReductionDescription": MessageLookupByLibrary.simpleMessage(
      "сглаживает визуальный шум перед кодированием",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "выберите одно или несколько видео, размер которых хотите уменьшить.",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "выберите видео",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "используйте готовые варианты или настройте качество, скорость и разрешение.",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "настройте баланс",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "оцените будущий размер, сожмите видео и сохраните результат в галерею.",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "сожмите и сохраните",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (видео) — проект с открытым исходным кодом. посмотрите код, следите за проектом или свяжитесь со мной.",
    ),
    "optimizeForStreaming": MessageLookupByLibrary.simpleMessage(
      "оптимизация для стриминга",
    ),
    "optimizeForStreamingDescription": MessageLookupByLibrary.simpleMessage(
      "позволяет начать просмотр до полной загрузки файла",
    ),
    "original": MessageLookupByLibrary.simpleMessage("оригинал"),
    "preserveMetadata": MessageLookupByLibrary.simpleMessage(
      "сохранять метаданные",
    ),
    "preserveMetadataDescription": MessageLookupByLibrary.simpleMessage(
      "сохраняет доступные сведения о создании и видео",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("сайт проекта"),
    "quality": MessageLookupByLibrary.simpleMessage("качество"),
    "qualityDescription": MessageLookupByLibrary.simpleMessage(
      "низкий CRF сохраняет больше деталей, высокий создаёт меньший файл",
    ),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("оценить приложение"),
    "resolution": MessageLookupByLibrary.simpleMessage("разрешение"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "уменьшение разрешения сильнее всего сокращает размер",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "разрешение будет уменьшено до hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "разрешение будет уменьшено до sd",
    ),
    "save": MessageLookupByLibrary.simpleMessage("сохранить"),
    "saveVideos": m4,
    "savedButOriginalsNotDeleted": m5,
    "savedVideosAndDeletedOriginals": m6,
    "savedVideosToGallery": m7,
    "secondsRemaining": m8,
    "share": MessageLookupByLibrary.simpleMessage("поделиться"),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "поделиться с друзьями",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("простые настройки"),
    "skip": MessageLookupByLibrary.simpleMessage("пропустить"),
    "slow": MessageLookupByLibrary.simpleMessage("медленно"),
    "small": MessageLookupByLibrary.simpleMessage("маленький"),
    "smaller": MessageLookupByLibrary.simpleMessage("меньше"),
    "smallerNewerDevices": MessageLookupByLibrary.simpleMessage(
      "меньше размер, новые устройства",
    ),
    "speed": MessageLookupByLibrary.simpleMessage("скорость"),
    "speedDescription": MessageLookupByLibrary.simpleMessage(
      "медленное кодирование обычно создаёт меньший файл при том же качестве",
    ),
    "stereo": MessageLookupByLibrary.simpleMessage("стерео"),
    "telegram": MessageLookupByLibrary.simpleMessage("telegram"),
    "todo": MessageLookupByLibrary.simpleMessage("В разработке"),
    "twoPassEncoding": MessageLookupByLibrary.simpleMessage(
      "двухпроходное кодирование",
    ),
    "twoPassEncodingDescription": MessageLookupByLibrary.simpleMessage(
      "лучшее сжатие, но обработка займёт значительно больше времени",
    ),
    "ultraFast": MessageLookupByLibrary.simpleMessage("очень быстро"),
    "verySlow": MessageLookupByLibrary.simpleMessage("очень медленно"),
    "videoCodec": MessageLookupByLibrary.simpleMessage("видеокодек"),
    "videoCodecDescription": MessageLookupByLibrary.simpleMessage(
      "выберите совместимость или более эффективное сжатие",
    ),
    "videoProgress": m9,
    "videosCompressed": m10,
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m11,
  };
}
