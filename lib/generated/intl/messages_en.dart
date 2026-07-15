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

  static String m2(version) => "what\'s new in ${version}";

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

  static String m12(url) =>
      "try minimo (video) — a simple app for making videos smaller on your phone: ${url}";

  static String m13(current, total) => "video ${current} of ${total}";

  static String m14(completed, total) =>
      "${completed} of ${total} videos compressed";

  static String m15(size) => "you saved ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("about"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) was born from a simple frustration. i love sports and often watch short match clips shared by clubs and telegram channels. even a few seconds of video can take up far more space than they should.\n\nthis project gives everyone a convenient and free way to compress videos directly on a mobile device, save storage and keep the moments that matter.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("advanced"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage(
      "already optimized",
    ),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "this video is already small. try lower quality or choose another one.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("audio"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "keep the original audio or remove it to save more space",
    ),
    "better": MessageLookupByLibrary.simpleMessage("better"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "bitrate will be reduced to save space",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "failed to clear cache",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("cache cleared"),
    "cancel": MessageLookupByLibrary.simpleMessage("cancel"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("got it"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "changes from updates you have not seen yet",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("clear cache"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "removes temporary app files. videos saved to your gallery remain untouched",
    ),
    "compress": MessageLookupByLibrary.simpleMessage("compress"),
    "compressOtherVideos": MessageLookupByLibrary.simpleMessage(
      "compress other videos",
    ),
    "compressed": MessageLookupByLibrary.simpleMessage("compressed"),
    "compressing": MessageLookupByLibrary.simpleMessage("compressing..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "compression cancelled",
    ),
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
    "darkTheme": MessageLookupByLibrary.simpleMessage("dark theme"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "use the dark appearance",
    ),
    "deleteOriginal": MessageLookupByLibrary.simpleMessage("delete original"),
    "emailCopied": MessageLookupByLibrary.simpleMessage("email copied"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "estimating time remaining...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("failed"),
    "failedToSave": m3,
    "failedToShare": m4,
    "getStarted": MessageLookupByLibrary.simpleMessage("get started"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "github repository",
    ),
    "good": MessageLookupByLibrary.simpleMessage("good"),
    "high": MessageLookupByLibrary.simpleMessage("high"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "hold the button to cancel compression",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "hold the button to clear cache",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "hold the button to delete originals",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo makes a new copy of your video and stores it more efficiently. it can lower the bitrate, reduce the picture size, or remove audio if you choose that.\n\nlower bitrate means the video keeps fewer tiny details that are hard to notice. lower resolution means each frame has fewer pixels. both reduce file size.\n\nyour original video stays untouched, and compression happens on your device.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "how video gets smaller",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "keep minimo open during compression. if you leave, the current video restarts when you return",
    ),
    "language": MessageLookupByLibrary.simpleMessage("language"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "select the language for the app",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "large or numerous files may take longer to load",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("loading videos..."),
    "low": MessageLookupByLibrary.simpleMessage("low"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("by khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("medium"),
    "minutesRemaining": m5,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("my other apps"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("my website"),
    "next": MessageLookupByLibrary.simpleMessage("next"),
    "noAudio": MessageLookupByLibrary.simpleMessage("no audio"),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "choose one or several videos. minimo works with local files and keeps the originals untouched",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage("pick videos"),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "choose a quality preset or adjust resolution and audio manually",
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
    "original": MessageLookupByLibrary.simpleMessage("original"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "compression can slow down if your device gets hot",
    ),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "keep screen awake",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "prevents the screen from sleeping while videos are compressing",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("project website"),
    "quality": MessageLookupByLibrary.simpleMessage("quality"),
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
    "shareAppText": m12,
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "share with friends",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "show overheat warning",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "shows a small banner during compression when the device may slow down",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("simple"),
    "skip": MessageLookupByLibrary.simpleMessage("skip"),
    "small": MessageLookupByLibrary.simpleMessage("small"),
    "smaller": MessageLookupByLibrary.simpleMessage("smaller"),
    "stereo": MessageLookupByLibrary.simpleMessage("stereo"),
    "system": MessageLookupByLibrary.simpleMessage("system"),
    "telegram": MessageLookupByLibrary.simpleMessage("telegram"),
    "todo": MessageLookupByLibrary.simpleMessage("TODO"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("try again"),
    "videoProgress": m13,
    "videosCompressed": m14,
    "waiting": MessageLookupByLibrary.simpleMessage("waiting"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m15,
  };
}
