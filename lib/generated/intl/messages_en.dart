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

  static String m0(prefix) => "add \"${prefix}\" prefix";

  static String m1(prefix) =>
      "adds \"${prefix}\" before the original file name. disabling keeps the original file name";

  static String m2(value) => "CRF ${value}";

  static String m3(error) => "failed to save: ${error}";

  static String m4(error) => "failed to share: ${error}";

  static String m5(count) =>
      "${Intl.plural(count, one: 'about 1 minute left', other: 'about ${count} minutes left')}";

  static String m6(count) =>
      "${Intl.plural(count, one: 'save 1 video', other: 'save ${count} videos')}";

  static String m7(album) =>
      "saves compressed videos to the ${album} album instead of recently saved";

  static String m8(error) =>
      "videos saved, but some originals could not be deleted: ${error}";

  static String m9(saved, deleted) =>
      "saved ${saved} video(s) and deleted ${deleted} original(s)";

  static String m10(count) =>
      "${Intl.plural(count, one: 'saved 1 video to gallery', other: 'saved ${count} videos to gallery')}";

  static String m11(count) =>
      "${Intl.plural(count, one: 'about 1 second left', other: 'about ${count} seconds left')}";

  static String m12(current, total) => "video ${current} of ${total}";

  static String m13(completed, total) =>
      "${completed} of ${total} videos compressed";

  static String m14(size) => "you saved ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("about"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) was born from a simple frustration. i love sports and often watch short match clips shared by clubs and telegram channels. even a few seconds of video can take up far more space than they should.\n\nthis project gives everyone a convenient and free way to compress videos directly on a mobile device, save storage and keep the moments that matter.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "additionalOptions": MessageLookupByLibrary.simpleMessage(
      "additional options",
    ),
    "advancedOptions": MessageLookupByLibrary.simpleMessage("advanced options"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage(
      "already optimized",
    ),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "this video is already small. try lower quality or choose another one.",
    ),
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
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "compression failed",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "we couldn\'t compress this video. try again or choose another one.",
    ),
    "crfValue": m2,
    "deleteOriginal": MessageLookupByLibrary.simpleMessage("delete original"),
    "emailCopied": MessageLookupByLibrary.simpleMessage("email copied"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "estimating time remaining...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("failed"),
    "failedToSave": m3,
    "failedToShare": m4,
    "fast": MessageLookupByLibrary.simpleMessage("fast"),
    "frameRate": MessageLookupByLibrary.simpleMessage("frame rate"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "lower frame rate reduces size but can make motion less smooth",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("get started"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "github repository",
    ),
    "good": MessageLookupByLibrary.simpleMessage("good"),
    "hardwareAcceleration": MessageLookupByLibrary.simpleMessage(
      "hardware acceleration",
    ),
    "hardwareAccelerationDescription": MessageLookupByLibrary.simpleMessage(
      "uses the device encoder for faster processing",
    ),
    "high": MessageLookupByLibrary.simpleMessage("high"),
    "language": MessageLookupByLibrary.simpleMessage("language"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "select the language for the app",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("loading videos..."),
    "low": MessageLookupByLibrary.simpleMessage("low"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("by khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("medium"),
    "minutesRemaining": m5,
    "mono": MessageLookupByLibrary.simpleMessage("mono"),
    "mostCompatible": MessageLookupByLibrary.simpleMessage("most compatible"),
    "myOtherApps": MessageLookupByLibrary.simpleMessage("my other apps"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("my website"),
    "next": MessageLookupByLibrary.simpleMessage("next"),
    "noAudio": MessageLookupByLibrary.simpleMessage("no audio"),
    "noiseReduction": MessageLookupByLibrary.simpleMessage("noise reduction"),
    "noiseReductionDescription": MessageLookupByLibrary.simpleMessage(
      "smooths visual noise before encoding",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "choose one or several videos. minimo works with local files and keeps the originals untouched",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage("pick videos"),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "reduce bitrate, resolution, frame rate or audio. simple presets do it for you, advanced controls stay available",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "choose what changes",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "compression happens on your device. videos are not uploaded anywhere; save the smaller copy when you like the result",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "private by default",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) is open source. explore the code, follow the project or get in touch",
    ),
    "optimizeForStreaming": MessageLookupByLibrary.simpleMessage(
      "optimize for streaming",
    ),
    "optimizeForStreamingDescription": MessageLookupByLibrary.simpleMessage(
      "allows playback to start before the file fully downloads",
    ),
    "original": MessageLookupByLibrary.simpleMessage("original"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "compression can slow down if your device gets hot",
    ),
    "preserveMetadata": MessageLookupByLibrary.simpleMessage(
      "preserve metadata",
    ),
    "preserveMetadataDescription": MessageLookupByLibrary.simpleMessage(
      "keeps available creation and video information",
    ),
    "preserveMetadataSettingDescription": MessageLookupByLibrary.simpleMessage(
      "keeps the original media metadata in compressed videos. this can increase output size",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("project website"),
    "quality": MessageLookupByLibrary.simpleMessage("quality"),
    "qualityDescription": MessageLookupByLibrary.simpleMessage(
      "lower CRF keeps more detail, higher CRF creates a smaller file",
    ),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("rate the app"),
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
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("save"),
    "saveVideos": m6,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "save videos to album",
    ),
    "saveVideosToAlbumDescription": m7,
    "savedButOriginalsNotDeleted": m8,
    "savedVideosAndDeletedOriginals": m9,
    "savedVideosToGallery": m10,
    "secondsRemaining": m11,
    "settings": MessageLookupByLibrary.simpleMessage("settings"),
    "share": MessageLookupByLibrary.simpleMessage("share"),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "share with friends",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "show overheat warning",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "shows a small banner during compression when the device may slow down",
    ),
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
    "system": MessageLookupByLibrary.simpleMessage("system"),
    "telegram": MessageLookupByLibrary.simpleMessage("telegram"),
    "todo": MessageLookupByLibrary.simpleMessage("TODO"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("try again"),
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
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("waiting"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
