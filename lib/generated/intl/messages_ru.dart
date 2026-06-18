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

  static String m2(count) =>
      "${Intl.plural(count, one: 'сохранить 1 видео', few: 'сохранить ${count} видео', many: 'сохранить ${count} видео', other: 'сохранить ${count} видео')}";

  static String m3(count) =>
      "${Intl.plural(count, one: '1 видео сохранено в галерею', few: '${count} видео сохранено в галерею', many: '${count} видео сохранено в галерею', other: '${count} видео сохранено в галерею')}";

  static String m4(current, total) => "видео ${current} из ${total}";

  static String m5(completed, total) => "сжато видео: ${completed} из ${total}";

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
    "compress": MessageLookupByLibrary.simpleMessage("сжать"),
    "compressOtherVideos": MessageLookupByLibrary.simpleMessage(
      "сжать другие видео",
    ),
    "compressed": MessageLookupByLibrary.simpleMessage("сжатое"),
    "compressing": MessageLookupByLibrary.simpleMessage("сжатие..."),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "сжатие завершено",
    ),
    "crfValue": m0,
    "failed": MessageLookupByLibrary.simpleMessage("ошибка"),
    "failedToSave": m1,
    "fast": MessageLookupByLibrary.simpleMessage("быстро"),
    "good": MessageLookupByLibrary.simpleMessage("хорошее"),
    "high": MessageLookupByLibrary.simpleMessage("высокое"),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("загрузка видео..."),
    "low": MessageLookupByLibrary.simpleMessage("низкое"),
    "medium": MessageLookupByLibrary.simpleMessage("среднее"),
    "original": MessageLookupByLibrary.simpleMessage("оригинал"),
    "quality": MessageLookupByLibrary.simpleMessage("качество"),
    "resolution": MessageLookupByLibrary.simpleMessage("разрешение"),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "разрешение будет уменьшено до hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "разрешение будет уменьшено до sd",
    ),
    "saveVideos": m2,
    "savedVideosToGallery": m3,
    "simpleOptions": MessageLookupByLibrary.simpleMessage("простые настройки"),
    "slow": MessageLookupByLibrary.simpleMessage("медленно"),
    "small": MessageLookupByLibrary.simpleMessage("маленький"),
    "smaller": MessageLookupByLibrary.simpleMessage("меньше"),
    "speed": MessageLookupByLibrary.simpleMessage("скорость"),
    "todo": MessageLookupByLibrary.simpleMessage("В разработке"),
    "ultraFast": MessageLookupByLibrary.simpleMessage("очень быстро"),
    "videoProgress": m4,
    "videosCompressed": m5,
  };
}
