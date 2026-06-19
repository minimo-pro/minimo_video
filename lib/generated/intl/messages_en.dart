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

  static String m2(error) => "failed to share: ${error}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'about 1 minute left', other: 'about ${count} minutes left')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'save 1 video', other: 'save ${count} videos')}";

  static String m5(error) =>
      "videos saved, but some originals could not be deleted: ${error}";

  static String m6(saved, deleted) =>
      "saved ${saved} video(s) and deleted ${deleted} original(s)";

  static String m7(count) =>
      "${Intl.plural(count, one: 'saved 1 video to gallery', other: 'saved ${count} videos to gallery')}";

  static String m8(count) =>
      "${Intl.plural(count, one: 'about 1 second left', other: 'about ${count} seconds left')}";

  static String m9(current, total) => "video ${current} of ${total}";

  static String m10(completed, total) =>
      "${completed} of ${total} videos compressed";

  static String m11(size) => "you saved ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "additionalOptions": MessageLookupByLibrary.simpleMessage(
      "additional options",
    ),
    "advancedOptions": MessageLookupByLibrary.simpleMessage("advanced options"),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("audio"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "stereo sounds best; mono or no audio saves more space",
    ),
    "better": MessageLookupByLibrary.simpleMessage("better"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "bitrate will be reduced to save space",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("cancel"),
    "compress": MessageLookupByLibrary.simpleMessage("compress"),
    "compressOtherVideos": MessageLookupByLibrary.simpleMessage(
      "compress other videos",
    ),
    "compressed": MessageLookupByLibrary.simpleMessage("compressed"),
    "compressing": MessageLookupByLibrary.simpleMessage("compressing..."),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "compression complete",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "compression completed",
    ),
    "crfValue": m0,
    "deleteOriginal": MessageLookupByLibrary.simpleMessage("delete original"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "estimating time remaining...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("failed"),
    "failedToSave": m1,
    "failedToShare": m2,
    "fast": MessageLookupByLibrary.simpleMessage("fast"),
    "frameRate": MessageLookupByLibrary.simpleMessage("frame rate"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "lower frame rate reduces size but can make motion less smooth",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("get started"),
    "good": MessageLookupByLibrary.simpleMessage("good"),
    "hardwareAcceleration": MessageLookupByLibrary.simpleMessage(
      "hardware acceleration",
    ),
    "hardwareAccelerationDescription": MessageLookupByLibrary.simpleMessage(
      "uses the device encoder for faster processing",
    ),
    "high": MessageLookupByLibrary.simpleMessage("high"),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("loading videos..."),
    "low": MessageLookupByLibrary.simpleMessage("low"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("by khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("medium"),
    "minutesRemaining": m3,
    "mono": MessageLookupByLibrary.simpleMessage("mono"),
    "mostCompatible": MessageLookupByLibrary.simpleMessage("most compatible"),
    "next": MessageLookupByLibrary.simpleMessage("next"),
    "noAudio": MessageLookupByLibrary.simpleMessage("no audio"),
    "noiseReduction": MessageLookupByLibrary.simpleMessage("noise reduction"),
    "noiseReductionDescription": MessageLookupByLibrary.simpleMessage(
      "smooths visual noise before encoding",
    ),
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
    "optimizeForStreaming": MessageLookupByLibrary.simpleMessage(
      "optimize for streaming",
    ),
    "optimizeForStreamingDescription": MessageLookupByLibrary.simpleMessage(
      "allows playback to start before the file fully downloads",
    ),
    "original": MessageLookupByLibrary.simpleMessage("original"),
    "preserveMetadata": MessageLookupByLibrary.simpleMessage(
      "preserve metadata",
    ),
    "preserveMetadataDescription": MessageLookupByLibrary.simpleMessage(
      "keeps available creation and video information",
    ),
    "quality": MessageLookupByLibrary.simpleMessage("quality"),
    "qualityDescription": MessageLookupByLibrary.simpleMessage(
      "lower CRF keeps more detail, higher CRF creates a smaller file",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("resolution"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "reduce dimensions for the biggest size savings",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "resolution will be reduced to hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "resolution will be reduced to sd",
    ),
    "save": MessageLookupByLibrary.simpleMessage("save"),
    "saveVideos": m4,
    "savedButOriginalsNotDeleted": m5,
    "savedVideosAndDeletedOriginals": m6,
    "savedVideosToGallery": m7,
    "secondsRemaining": m8,
    "share": MessageLookupByLibrary.simpleMessage("share"),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("simple options"),
    "skip": MessageLookupByLibrary.simpleMessage("skip"),
    "slow": MessageLookupByLibrary.simpleMessage("slow"),
    "small": MessageLookupByLibrary.simpleMessage("small"),
    "smaller": MessageLookupByLibrary.simpleMessage("smaller"),
    "smallerNewerDevices": MessageLookupByLibrary.simpleMessage(
      "smaller, newer devices",
    ),
    "speed": MessageLookupByLibrary.simpleMessage("speed"),
    "speedDescription": MessageLookupByLibrary.simpleMessage(
      "slower encoding usually produces a smaller file at the same quality",
    ),
    "stereo": MessageLookupByLibrary.simpleMessage("stereo"),
    "todo": MessageLookupByLibrary.simpleMessage("TODO"),
    "twoPassEncoding": MessageLookupByLibrary.simpleMessage(
      "two-pass encoding",
    ),
    "twoPassEncodingDescription": MessageLookupByLibrary.simpleMessage(
      "better compression, but takes significantly longer",
    ),
    "ultraFast": MessageLookupByLibrary.simpleMessage("ultra fast"),
    "verySlow": MessageLookupByLibrary.simpleMessage("very slow"),
    "videoCodec": MessageLookupByLibrary.simpleMessage("video codec"),
    "videoCodecDescription": MessageLookupByLibrary.simpleMessage(
      "choose compatibility or better compression",
    ),
    "videoProgress": m9,
    "videosCompressed": m10,
    "youSavedSize": m11,
  };
}
