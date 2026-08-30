// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(prefix) => "präfix \"${prefix}\" hinzufügen";

  static String m1(prefix) =>
      "fügt \"${prefix}\" vor dem ursprünglichen dateinamen ein. deaktivieren behält den originalnamen";

  static String m2(version) => "neu in ${version}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'noch etwa 1 minute', other: 'noch etwa ${count} minuten')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 video speichern', other: '${count} videos speichern')}";

  static String m5(album) =>
      "speichert komprimierte videos im album ${album} statt unter den zuletzt gespeicherten";

  static String m6(error) =>
      "videos gespeichert, aber einige originale konnten nicht gelöscht werden: ${error}";

  static String m7(saved, deleted) =>
      "${saved} video(s) gespeichert und ${deleted} original(e) gelöscht";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 video in galerie gespeichert', other: '${count} videos in galerie gespeichert')}";

  static String m9(error) =>
      "videos mit einigen problemen gespeichert: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'noch etwa 1 sekunde', other: 'noch etwa ${count} sekunden')}";

  static String m11(url) =>
      "probiere minimo (video) – eine einfache app, die videos auf deinem handy verkleinert: ${url}";

  static String m12(current, total) => "video ${current} von ${total}";

  static String m13(completed, total) =>
      "${completed} von ${total} videos komprimiert";

  static String m14(size) => "du hast ${size} gespart";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("über die app"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) entstand aus einer einfachen frustration.\n\ndieses projekt bietet allen eine bequeme und kostenlose möglichkeit, videos direkt auf einem mobilgerät zu komprimieren, speicherplatz zu sparen und wichtige momente zu bewahren.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("erweitert"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage(
      "bereits optimiert",
    ),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "dieses video ist bereits klein. versuche eine niedrigere qualität oder ein anderes video.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("audio"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "originalton behalten oder für mehr ersparnis entfernen",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("auto"),
    "better": MessageLookupByLibrary.simpleMessage("besser"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "die bitrate wird reduziert, um platz zu sparen",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "cache konnte nicht geleert werden",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("cache geleert"),
    "cancel": MessageLookupByLibrary.simpleMessage("abbrechen"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("verstanden"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "änderungen aus updates, die du noch nicht gesehen hast",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("cache leeren"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "entfernt temporäre app-dateien. gespeicherte galerievideos bleiben erhalten",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("codec"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 funktioniert überall; HEVC kann kleiner sein, aber auf H.264 zurückfallen",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("vergleichen"),
    "compress": MessageLookupByLibrary.simpleMessage("komprimieren"),
    "compressed": MessageLookupByLibrary.simpleMessage("komprimiert"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("nachher"),
    "compressing": MessageLookupByLibrary.simpleMessage("wird komprimiert..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "komprimierung abgebrochen",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "komprimierung abgeschlossen",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "komprimierung abgeschlossen",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "komprimierung fehlgeschlagen",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "dieses video konnte nicht komprimiert werden. versuche es erneut oder wähle ein anderes.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("dunkles design"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "dunkle darstellung verwenden",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage("e-mail kopiert"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "restzeit wird geschätzt...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("fehlgeschlagen"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "videodatei auswählen",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "videos konnten nicht gespeichert werden. versuche es erneut",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "videos konnten nicht geteilt werden. versuche es erneut",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("bildrate"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "begrenzt ausgabebilder pro sekunde; niedrigere quellraten bleiben unverändert",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("loslegen"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "github-repository",
    ),
    "good": MessageLookupByLibrary.simpleMessage("gut"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC war nicht verfügbar, daher wurde dieses video als H.264 gespeichert",
    ),
    "high": MessageLookupByLibrary.simpleMessage("hoch"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "taste halten, um die komprimierung abzubrechen",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "taste halten, um den cache zu leeren",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "taste halten, um originale zu löschen",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo erstellt eine neue kopie deines videos und speichert sie effizienter. bitrate und bildgröße können reduziert oder der ton entfernt werden.\n\neine niedrigere bitrate behält weniger kleine, kaum sichtbare details. eine niedrigere auflösung bedeutet weniger pixel pro bild. beides reduziert die dateigröße.\n\ndas original bleibt unverändert und die komprimierung erfolgt auf deinem gerät.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "wie videos kleiner werden",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "minimo während der komprimierung geöffnet lassen. beim verlassen startet das aktuelle video nach der rückkehr neu",
    ),
    "language": MessageLookupByLibrary.simpleMessage("sprache"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "sprache der app auswählen",
    ),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage(
      "ohne speichern verlassen",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "downloads aus cloudspeichern oder das kopieren großer dateien können länger dauern",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage(
      "videos werden importiert...",
    ),
    "low": MessageLookupByLibrary.simpleMessage("niedrig"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("von khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("mittel"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "einige galeriemetadaten konnten nicht kopiert werden",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("meine anderen apps"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("meine website"),
    "next": MessageLookupByLibrary.simpleMessage("weiter"),
    "noAudio": MessageLookupByLibrary.simpleMessage("ohne audio"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "versuche einen anderen modus – dieser verkleinert die datei nicht",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "wähle ein oder mehrere videos. minimo arbeitet mit lokalen dateien und lässt die originale unverändert",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "videos auswählen",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "wähle eine qualitätsstufe oder passe auflösung und audio manuell an",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "änderungen auswählen",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "die komprimierung erfolgt auf deinem gerät. videos werden nirgendwo hochgeladen; speichere die kleinere kopie, wenn dir das ergebnis gefällt",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "standardmäßig privat",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) ist open source. entdecke den code, folge dem projekt oder nimm kontakt auf",
    ),
    "original": MessageLookupByLibrary.simpleMessage("original"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "einige originale konnten nicht gelöscht werden",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("vorher"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "die komprimierung kann langsamer werden, wenn dein gerät heiß wird",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("aus dateien"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("aus galerie"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "bildschirm aktiv halten",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "verhindert den ruhezustand des bildschirms, während videos komprimiert werden",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("projektwebsite"),
    "quality": MessageLookupByLibrary.simpleMessage("qualität"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("app bewerten"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage(
      "original ersetzen",
    ),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "mit originalmetadaten speichern und danach um löschung des originals bitten",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("auflösung"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "abmessungen für die größte platzersparnis reduzieren",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "die auflösung wird auf hd reduziert",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "die auflösung wird auf sd reduziert",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("speichern"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("als neu speichern"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "original behalten und ein neues galerievideo speichern",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage(
      "neben original speichern",
    ),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "original behalten und datum sowie metadaten kopieren",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage("speicherart"),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "videos in album speichern",
    ),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("gespeichert"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("einstellungen"),
    "share": MessageLookupByLibrary.simpleMessage("teilen"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage(
      "teilen oder speichern unter…",
    ),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "mit freunden teilen",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "überhitzungswarnung anzeigen",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "zeigt während der komprimierung einen kleinen hinweis, wenn das gerät langsamer werden kann",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("einfach"),
    "skip": MessageLookupByLibrary.simpleMessage("überspringen"),
    "small": MessageLookupByLibrary.simpleMessage("klein"),
    "smaller": MessageLookupByLibrary.simpleMessage("kleiner"),
    "stay": MessageLookupByLibrary.simpleMessage("bleiben"),
    "stereo": MessageLookupByLibrary.simpleMessage("stereo"),
    "system": MessageLookupByLibrary.simpleMessage("system"),
    "todo": MessageLookupByLibrary.simpleMessage("DEMNÄCHST"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("erneut versuchen"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "ohne speichern der komprimierten videos verlassen?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage(
      "videos nicht gespeichert",
    ),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("video-bitrate"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "ziel-bitrate festlegen oder von der qualitätsstufe wählen lassen",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "vorschau nicht verfügbar",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("wartet"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
