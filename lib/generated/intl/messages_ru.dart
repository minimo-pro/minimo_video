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

  static String m0(prefix) => "добавлять префикс \"${prefix}\"";

  static String m1(prefix) =>
      "добавляет \"${prefix}\" перед исходным именем файла. если выключить, имя останется исходным";

  static String m2(error) => "не удалось сохранить: ${error}";

  static String m3(error) => "не удалось поделиться: ${error}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'осталась примерно 1 минута', few: 'осталось примерно ${count} минуты', many: 'осталось примерно ${count} минут', other: 'осталось примерно ${count} минуты')}";

  static String m5(count) =>
      "${Intl.plural(count, one: 'сохранить 1 видео', few: 'сохранить ${count} видео', many: 'сохранить ${count} видео', other: 'сохранить ${count} видео')}";

  static String m6(album) =>
      "сохраняет сжатые видео в альбом ${album} вместо недавних сохранений";

  static String m7(error) =>
      "видео сохранены, но некоторые оригиналы удалить не удалось: ${error}";

  static String m8(saved, deleted) =>
      "сохранено видео: ${saved}, удалено оригиналов: ${deleted}";

  static String m9(count) =>
      "${Intl.plural(count, one: '1 видео сохранено в галерею', few: '${count} видео сохранено в галерею', many: '${count} видео сохранено в галерею', other: '${count} видео сохранено в галерею')}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'осталась примерно 1 секунда', few: 'осталось примерно ${count} секунды', many: 'осталось примерно ${count} секунд', other: 'осталось примерно ${count} секунды')}";

  static String m11(current, total) => "видео ${current} из ${total}";

  static String m12(completed, total) =>
      "сжато видео: ${completed} из ${total}";

  static String m13(size) => "экономия ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("о приложении"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) появился из простой проблемы. я люблю спорт и часто смотрю короткие фрагменты матчей, которыми делятся клубы и telegram-каналы. даже несколько секунд видео иногда занимают неоправданно много места.\n\nэтот проект даёт каждому удобную и бесплатную возможность сжимать видео прямо на мобильном устройстве, экономить память и сохранять важные моменты.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("расширенный"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage(
      "уже оптимизировано",
    ),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "это видео уже маленькое. попробуйте снизить качество или выберите другое видео.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("звук"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "сохраните исходный звук или удалите его для меньшего размера",
    ),
    "better": MessageLookupByLibrary.simpleMessage("лучше"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "битрейт будет уменьшен для экономии места",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "не удалось очистить кеш",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("кеш очищен"),
    "cancel": MessageLookupByLibrary.simpleMessage("отмена"),
    "clearCache": MessageLookupByLibrary.simpleMessage("очистка кеша"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "удаляет временные файлы приложения. видео в галерее останутся",
    ),
    "compress": MessageLookupByLibrary.simpleMessage("сжать"),
    "compressOtherVideos": MessageLookupByLibrary.simpleMessage(
      "сжать другие видео",
    ),
    "compressed": MessageLookupByLibrary.simpleMessage("сжатое"),
    "compressing": MessageLookupByLibrary.simpleMessage("сжатие..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "сжатие отменено",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "сжатие завершено",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "сжатие завершено",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "не удалось сжать видео",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "попробуйте ещё раз или выберите другое видео.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("темная тема"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "использовать темное оформление",
    ),
    "deleteOriginal": MessageLookupByLibrary.simpleMessage("удалить оригинал"),
    "emailCopied": MessageLookupByLibrary.simpleMessage("почта скопирована"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "оцениваем оставшееся время...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("ошибка"),
    "failedToSave": m2,
    "failedToShare": m3,
    "getStarted": MessageLookupByLibrary.simpleMessage("начать"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "репозиторий github",
    ),
    "good": MessageLookupByLibrary.simpleMessage("хорошее"),
    "high": MessageLookupByLibrary.simpleMessage("высокое"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "удерживайте кнопку, чтобы отменить сжатие",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "удерживайте кнопку, чтобы очистить кеш",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "удерживайте кнопку, чтобы удалить оригиналы",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo создаёт новую копию видео и сохраняет её компактнее. приложение может уменьшить битрейт, снизить размер картинки или убрать звук, если вы это выбрали.\n\nменьший битрейт значит, что в видео остаётся меньше мелких деталей, которые обычно сложно заметить. меньшее разрешение значит, что в каждом кадре меньше пикселей. так файл занимает меньше места.\n\nоригинал не меняется, а сжатие происходит на вашем устройстве.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "за счёт чего видео становится меньше",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "не сворачивайте minimo во время сжатия. иначе текущий ролик начнёт сжиматься заново после возвращения",
    ),
    "language": MessageLookupByLibrary.simpleMessage("язык"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "выберите язык приложения",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "загрузка большого количества или крупных файлов может занять больше времени",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("загрузка видео..."),
    "low": MessageLookupByLibrary.simpleMessage("низкое"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("by khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("среднее"),
    "minutesRemaining": m4,
    "myOtherApps": MessageLookupByLibrary.simpleMessage(
      "другие мои приложения",
    ),
    "myWebsite": MessageLookupByLibrary.simpleMessage("мой сайт"),
    "next": MessageLookupByLibrary.simpleMessage("далее"),
    "noAudio": MessageLookupByLibrary.simpleMessage("без звука"),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "выберите одно или несколько видео. minimo работает с локальными файлами и не трогает оригиналы",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "выберите видео",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "выберите готовый уровень качества или настройте разрешение и звук вручную",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "выберите, что менять",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "сжатие происходит на устройстве. видео никуда не загружаются; сохраните меньшую копию, когда результат устроит",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "приватно по умолчанию",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) — проект с открытым исходным кодом. посмотрите код, следите за проектом или свяжитесь со мной",
    ),
    "original": MessageLookupByLibrary.simpleMessage("оригинал"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "сжатие может замедлиться, если устройство нагреется",
    ),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "не выключать экран",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "не даёт экрану уснуть, пока видео сжимаются",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("сайт проекта"),
    "quality": MessageLookupByLibrary.simpleMessage("качество"),
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
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("сохранить"),
    "saveVideos": m5,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "сохранять видео в альбом",
    ),
    "saveVideosToAlbumDescription": m6,
    "savedButOriginalsNotDeleted": m7,
    "savedVideosAndDeletedOriginals": m8,
    "savedVideosToGallery": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("настройки"),
    "share": MessageLookupByLibrary.simpleMessage("поделиться"),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "поделиться с друзьями",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "показывать предупреждение о перегреве",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "показывает небольшой баннер во время сжатия, когда устройство может замедлиться",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("простой"),
    "skip": MessageLookupByLibrary.simpleMessage("пропустить"),
    "small": MessageLookupByLibrary.simpleMessage("маленький"),
    "smaller": MessageLookupByLibrary.simpleMessage("меньше"),
    "stereo": MessageLookupByLibrary.simpleMessage("стерео"),
    "system": MessageLookupByLibrary.simpleMessage("система"),
    "telegram": MessageLookupByLibrary.simpleMessage("telegram"),
    "todo": MessageLookupByLibrary.simpleMessage("В разработке"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("попробовать снова"),
    "videoProgress": m11,
    "videosCompressed": m12,
    "waiting": MessageLookupByLibrary.simpleMessage("ожидает"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m13,
  };
}
