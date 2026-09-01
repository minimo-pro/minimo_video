// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hi locale. All the
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
  String get localeName => 'hi';

  static String m0(prefix) => "\"${prefix}\" प्रीफ़िक्स जोड़ें";

  static String m1(prefix) =>
      "मूल फ़ाइल नाम से पहले \"${prefix}\" जोड़ता है। बंद करने पर मूल नाम रहता है";

  static String m2(version) => "${version} में नया";

  static String m3(count) =>
      "${Intl.plural(count, one: 'लगभग 1 मिनट बाक़ी', other: 'लगभग ${count} मिनट बाक़ी')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 वीडियो सेव करें', other: '${count} वीडियो सेव करें')}";

  static String m5(album) =>
      "कंप्रेस्ड वीडियो को ${album} एल्बम में सेव करता है";

  static String m6(error) => "वीडियो सेव हुए, पर कुछ मूल नहीं हटे: ${error}";

  static String m7(saved, deleted) =>
      "${saved} वीडियो सेव, ${deleted} मूल हटाए";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 वीडियो गैलरी में सेव', other: '${count} वीडियो गैलरी में सेव')}";

  static String m9(error) => "वीडियो कुछ समस्याओं के साथ सेव हुए: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'लगभग 1 सेकंड बाक़ी', other: 'लगभग ${count} सेकंड बाक़ी')}";

  static String m11(url) =>
      "minimo (video) आज़माएँ — फ़ोन पर वीडियो छोटे करने का आसान ऐप: ${url}";

  static String m12(current, total) => "वीडियो ${current} / ${total}";

  static String m13(completed, total) =>
      "${total} में से ${completed} वीडियो कंप्रेस्ड";

  static String m14(size) => "आपने ${size} बचाया";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("ऐप के बारे में"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) एक साधारण परेशानी से बना।\n\nयह प्रोजेक्ट सभी को मोबाइल पर वीडियो कंप्रेस करने, स्टोरेज बचाने और ज़रूरी पल सहेजने का आसान और मुफ़्त तरीक़ा देता है।",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("उन्नत"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage(
      "पहले से ऑप्टिमाइज़्ड",
    ),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "यह वीडियो पहले से छोटा है। कम क्वालिटी या दूसरा वीडियो चुनें।",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("ऑडियो"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "मूल ऑडियो रखें या स्पेस बचाने के लिए हटाएँ",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("ऑटो"),
    "better": MessageLookupByLibrary.simpleMessage("बेहतर"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "स्पेस बचाने के लिए बिटरेट घटेगा",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "कैश साफ़ नहीं हुआ",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("कैश साफ़"),
    "cancel": MessageLookupByLibrary.simpleMessage("रद्द करें"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("समझ गया"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "अनदेखे अपडेट के बदलाव",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("कैश साफ़ करें"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "अस्थायी ऐप फ़ाइलें हटाता है। गैलरी वीडियो सुरक्षित रहते हैं",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("कोडेक"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 हर जगह चलता है; HEVC छोटा हो सकता है पर H.264 पर लौट सकता है",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("तुलना"),
    "compress": MessageLookupByLibrary.simpleMessage("कंप्रेस करें"),
    "compressed": MessageLookupByLibrary.simpleMessage("कंप्रेस्ड"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("बाद में"),
    "compressing": MessageLookupByLibrary.simpleMessage("कंप्रेस हो रहा है..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "कंप्रेशन रद्द",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "कंप्रेशन पूरा",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "कंप्रेशन पूरा हुआ",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage("कंप्रेशन असफल"),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "यह वीडियो कंप्रेस नहीं हुआ। फिर कोशिश करें या दूसरा चुनें।",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("डार्क थीम"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "गहरा रूप इस्तेमाल करें",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage("ईमेल कॉपी हुआ"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "बचा समय आँक रहे हैं...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("असफल"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "वीडियो फ़ाइल चुनें",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "वीडियो सेव नहीं हुए। फिर कोशिश करें",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "वीडियो शेयर नहीं हुए। फिर कोशिश करें",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("फ़्रेम रेट"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "आउटपुट फ़्रेम प्रति सेकंड सीमित करता है; कम सोर्स रेट नहीं बदलते",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("शुरू करें"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "github रिपॉज़िटरी",
    ),
    "good": MessageLookupByLibrary.simpleMessage("अच्छी"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC नहीं मिला, इसलिए वीडियो H.264 में सेव हुआ",
    ),
    "high": MessageLookupByLibrary.simpleMessage("उच्च"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "कंप्रेशन रोकने के लिए बटन दबाए रखें",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "कैश साफ़ करने के लिए बटन दबाए रखें",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "मूल हटाने के लिए बटन दबाए रखें",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo वीडियो की नई कॉपी बनाकर उसे बेहतर तरीके से स्टोर करता है। यह बिटरेट, रिज़ॉल्यूशन घटा सकता है या ऑडियो हटा सकता है।\n\nकम बिटरेट और रिज़ॉल्यूशन फ़ाइल को छोटा करते हैं।\n\nमूल वीडियो नहीं बदलता और कंप्रेशन आपके डिवाइस पर होता है।",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "वीडियो छोटा कैसे होता है",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "कंप्रेशन के दौरान minimo खुला रखें। बाहर जाने पर वर्तमान वीडियो फिर शुरू होगा",
    ),
    "language": MessageLookupByLibrary.simpleMessage("भाषा"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "ऐप की भाषा चुनें",
    ),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage("बिना सेव जाएँ"),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "क्लाउड से डाउनलोड या बड़ी फ़ाइल कॉपी होने में समय लग सकता है",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage(
      "वीडियो इंपोर्ट हो रहे हैं...",
    ),
    "low": MessageLookupByLibrary.simpleMessage("कम"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("khlebobul द्वारा"),
    "medium": MessageLookupByLibrary.simpleMessage("मध्यम"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "कुछ गैलरी मेटाडेटा कॉपी नहीं हुआ",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("मेरे अन्य ऐप"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("मेरी वेबसाइट"),
    "next": MessageLookupByLibrary.simpleMessage("अगला"),
    "noAudio": MessageLookupByLibrary.simpleMessage("बिना ऑडियो"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "दूसरा मोड आज़माएँ — यह छोटा नहीं करेगा",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "एक या कई वीडियो चुनें। minimo लोकल फ़ाइलों के साथ काम करता है और मूल वीडियो नहीं बदलता",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage("वीडियो चुनें"),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "क्वालिटी प्रीसेट चुनें या रिज़ॉल्यूशन और ऑडियो खुद सेट करें",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "क्या बदलना है चुनें",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "कंप्रेशन आपके डिवाइस पर होता है। वीडियो कहीं अपलोड नहीं होते; परिणाम पसंद आने पर छोटी कॉपी सेव करें",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "डिफ़ॉल्ट रूप से निजी",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) ओपन सोर्स है। कोड देखें, प्रोजेक्ट फ़ॉलो करें या संपर्क करें",
    ),
    "original": MessageLookupByLibrary.simpleMessage("मूल"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "कुछ मूल नहीं हटे",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("पहले"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "डिवाइस गरम होने पर कंप्रेशन धीमा हो सकता है",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("फ़ाइलों से"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("गैलरी से"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "स्क्रीन चालू रखें",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "कंप्रेशन के दौरान स्क्रीन को सोने नहीं देता",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("प्रोजेक्ट वेबसाइट"),
    "quality": MessageLookupByLibrary.simpleMessage("क्वालिटी"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("ऐप को रेट करें"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage("मूल बदलें"),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "मूल मेटाडेटा के साथ सेव करके मूल हटाने को पूछें",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("रिज़ॉल्यूशन"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "सबसे ज़्यादा स्पेस बचाने के लिए आकार घटाएँ",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "रिज़ॉल्यूशन hd होगा",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "रिज़ॉल्यूशन sd होगा",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("सेव"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("नया सेव करें"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "मूल रखें और गैलरी में नया वीडियो सेव करें",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage(
      "मूल के पास सेव करें",
    ),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "मूल रखें और उसकी तारीख व मेटाडेटा कॉपी करें",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage("कैसे सेव करें"),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "वीडियो एल्बम में सेव करें",
    ),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("सेव हुआ"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("सेटिंग्स"),
    "share": MessageLookupByLibrary.simpleMessage("शेयर"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage("शेयर या सेव…"),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "दोस्तों के साथ शेयर करें",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "ओवरहीट चेतावनी दिखाएँ",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "डिवाइस धीमा हो सकने पर कंप्रेशन के दौरान छोटा बैनर दिखाता है",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("सरल"),
    "skip": MessageLookupByLibrary.simpleMessage("छोड़ें"),
    "small": MessageLookupByLibrary.simpleMessage("छोटा"),
    "smaller": MessageLookupByLibrary.simpleMessage("छोटा"),
    "stay": MessageLookupByLibrary.simpleMessage("रुकें"),
    "stereo": MessageLookupByLibrary.simpleMessage("स्टीरियो"),
    "system": MessageLookupByLibrary.simpleMessage("सिस्टम"),
    "todo": MessageLookupByLibrary.simpleMessage("जल्द आ रहा है"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("फिर कोशिश करें"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "कंप्रेस्ड वीडियो सेव किए बिना जाएँ?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage(
      "वीडियो सेव नहीं हुए",
    ),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("वीडियो बिटरेट"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "लक्ष्य बिटरेट सेट करें या प्रीसेट को चुनने दें",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "प्रीव्यू उपलब्ध नहीं",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("इंतज़ार"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
