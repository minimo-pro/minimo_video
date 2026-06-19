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
    "advancedOptions": MessageLookupByLibrary.simpleMessage(
      "расширенные настройки",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (видео)"),
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
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "оцениваем оставшееся время...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("ошибка"),
    "failedToSave": m1,
    "failedToShare": m2,
    "fast": MessageLookupByLibrary.simpleMessage("быстро"),
    "getStarted": MessageLookupByLibrary.simpleMessage("начать"),
    "good": MessageLookupByLibrary.simpleMessage("хорошее"),
    "high": MessageLookupByLibrary.simpleMessage("высокое"),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("загрузка видео..."),
    "low": MessageLookupByLibrary.simpleMessage("низкое"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("by khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("среднее"),
    "minutesRemaining": m3,
    "next": MessageLookupByLibrary.simpleMessage("далее"),
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
    "original": MessageLookupByLibrary.simpleMessage("оригинал"),
    "quality": MessageLookupByLibrary.simpleMessage("качество"),
    "resolution": MessageLookupByLibrary.simpleMessage("разрешение"),
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
    "simpleOptions": MessageLookupByLibrary.simpleMessage("простые настройки"),
    "skip": MessageLookupByLibrary.simpleMessage("пропустить"),
    "slow": MessageLookupByLibrary.simpleMessage("медленно"),
    "small": MessageLookupByLibrary.simpleMessage("маленький"),
    "smaller": MessageLookupByLibrary.simpleMessage("меньше"),
    "speed": MessageLookupByLibrary.simpleMessage("скорость"),
    "todo": MessageLookupByLibrary.simpleMessage("В разработке"),
    "ultraFast": MessageLookupByLibrary.simpleMessage("очень быстро"),
    "videoProgress": m9,
    "videosCompressed": m10,
    "youSavedSize": m11,
  };
}
