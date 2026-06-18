// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(value) => "CRF ${value}";

  static String m1(error) => "failed to save: ${error}";

  static String m2(count) =>
      "${Intl.plural(count, one: 'save 1 video', other: 'save ${count} videos')}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'saved 1 video to gallery', other: 'saved ${count} videos to gallery')}";

  static String m4(current, total) => "video ${current} of ${total}";

  static String m5(completed, total) =>
      "${completed} of ${total} videos compressed";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "advancedOptions": MessageLookupByLibrary.simpleMessage("advanced options"),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "better": MessageLookupByLibrary.simpleMessage("better"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "bitrate will be reduced to save space",
    ),
    "compress": MessageLookupByLibrary.simpleMessage("compress"),
    "compressOtherVideos": MessageLookupByLibrary.simpleMessage(
      "compress other videos",
    ),
    "compressed": MessageLookupByLibrary.simpleMessage("compressed"),
    "compressing": MessageLookupByLibrary.simpleMessage("compressing..."),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "compression complete",
    ),
    "crfValue": m0,
    "failed": MessageLookupByLibrary.simpleMessage("failed"),
    "failedToSave": m1,
    "fast": MessageLookupByLibrary.simpleMessage("fast"),
    "getStarted": MessageLookupByLibrary.simpleMessage("get started"),
    "good": MessageLookupByLibrary.simpleMessage("good"),
    "high": MessageLookupByLibrary.simpleMessage("high"),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("loading videos..."),
    "low": MessageLookupByLibrary.simpleMessage("low"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("by khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("medium"),
    "next": MessageLookupByLibrary.simpleMessage("next"),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "choose one or several videos you want to make smaller.",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "pick your videos",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "use simple presets or fine-tune quality, speed and resolution.",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "choose the balance",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "preview the estimated size, compress, then save the result to your gallery.",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "compress and save",
    ),
    "original": MessageLookupByLibrary.simpleMessage("original"),
    "quality": MessageLookupByLibrary.simpleMessage("quality"),
    "resolution": MessageLookupByLibrary.simpleMessage("resolution"),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "resolution will be reduced to hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "resolution will be reduced to sd",
    ),
    "saveVideos": m2,
    "savedVideosToGallery": m3,
    "simpleOptions": MessageLookupByLibrary.simpleMessage("simple options"),
    "skip": MessageLookupByLibrary.simpleMessage("skip"),
    "slow": MessageLookupByLibrary.simpleMessage("slow"),
    "small": MessageLookupByLibrary.simpleMessage("small"),
    "smaller": MessageLookupByLibrary.simpleMessage("smaller"),
    "speed": MessageLookupByLibrary.simpleMessage("speed"),
    "todo": MessageLookupByLibrary.simpleMessage("TODO"),
    "ultraFast": MessageLookupByLibrary.simpleMessage("ultra fast"),
    "videoProgress": m4,
    "videosCompressed": m5,
  };
}
