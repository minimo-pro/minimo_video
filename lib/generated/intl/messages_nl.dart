// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
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
  String get localeName => 'nl';

  static String m0(prefix) => "voorvoegsel \"${prefix}\" toevoegen";

  static String m1(prefix) =>
      "voegt \"${prefix}\" toe voor de oorspronkelijke bestandsnaam. uitschakelen behoudt de oorspronkelijke naam";

  static String m2(version) => "nieuw in ${version}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'nog ongeveer 1 minuut', other: 'nog ongeveer ${count} minuten')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 video opslaan', other: '${count} video\'s opslaan')}";

  static String m5(album) =>
      "slaat gecomprimeerde video\'s op in het album ${album} in plaats van bij recent opgeslagen items";

  static String m6(error) =>
      "video\'s opgeslagen, maar sommige originelen konden niet worden verwijderd: ${error}";

  static String m7(saved, deleted) =>
      "${saved} video(\'s) opgeslagen en ${deleted} origineel/originelen verwijderd";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 video opgeslagen in galerij', other: '${count} video\'s opgeslagen in galerij')}";

  static String m9(error) =>
      "video\'s opgeslagen met enkele problemen: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'nog ongeveer 1 seconde', other: 'nog ongeveer ${count} seconden')}";

  static String m11(url) =>
      "probeer minimo (video), een eenvoudige app om video\'s op je telefoon kleiner te maken: ${url}";

  static String m12(current, total) => "video ${current} van ${total}";

  static String m13(completed, total) =>
      "${completed} van ${total} video\'s gecomprimeerd";

  static String m14(size) => "je hebt ${size} bespaard";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("over de app"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) ontstond uit een eenvoudige frustratie.\n\ndit project geeft iedereen een handige en gratis manier om video\'s rechtstreeks op een mobiel apparaat te comprimeren, opslagruimte te besparen en belangrijke momenten te bewaren.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("geavanceerd"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage(
      "al geoptimaliseerd",
    ),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "deze video is al klein. probeer een lagere kwaliteit of kies een andere video.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("audio"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "behoud de oorspronkelijke audio of verwijder deze om meer ruimte te besparen",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("auto"),
    "better": MessageLookupByLibrary.simpleMessage("beter"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "de bitrate wordt verlaagd om ruimte te besparen",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "cache kon niet worden gewist",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("cache gewist"),
    "cancel": MessageLookupByLibrary.simpleMessage("annuleren"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("begrepen"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "wijzigingen uit updates die je nog niet hebt gezien",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("cache wissen"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "verwijdert tijdelijke appbestanden. video\'s in je galerij blijven ongewijzigd",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("codec"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 werkt overal; HEVC kan kleiner zijn, maar kan terugvallen op H.264",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("vergelijken"),
    "compress": MessageLookupByLibrary.simpleMessage("comprimeren"),
    "compressed": MessageLookupByLibrary.simpleMessage("gecomprimeerd"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("na"),
    "compressing": MessageLookupByLibrary.simpleMessage("comprimeren..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "compressie geannuleerd",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "compressie voltooid",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "compressie voltooid",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "compressie mislukt",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "we konden deze video niet comprimeren. probeer het opnieuw of kies een andere video.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("donker thema"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "gebruik de donkere weergave",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage(
      "e-mailadres gekopieerd",
    ),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "resterende tijd schatten...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("mislukt"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "kies een videobestand",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "de video\'s konden niet worden opgeslagen. probeer het opnieuw",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "de video\'s konden niet worden gedeeld. probeer het opnieuw",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("framesnelheid"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "beperkt het aantal uitvoerframes per seconde; lagere bronwaarden blijven ongewijzigd",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("aan de slag"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "github-repository",
    ),
    "good": MessageLookupByLibrary.simpleMessage("goed"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC was niet beschikbaar, dus deze video is opgeslagen als H.264",
    ),
    "high": MessageLookupByLibrary.simpleMessage("hoog"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "houd de knop ingedrukt om de compressie te annuleren",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "houd de knop ingedrukt om de cache te wissen",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "houd de knop ingedrukt om originelen te verwijderen",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo maakt een nieuwe kopie van je video en slaat die efficiënter op. het kan de bitrate verlagen, de beeldgrootte verkleinen of audio verwijderen als je daarvoor kiest.\n\neen lagere bitrate bewaart minder kleine details die moeilijk opvallen. een lagere resolutie betekent minder pixels per frame. beide verkleinen het bestand.\n\nje originele video blijft ongewijzigd en de compressie gebeurt op je apparaat.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "hoe een video kleiner wordt",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "houd minimo open tijdens de compressie. als je de app verlaat, start de huidige video opnieuw wanneer je terugkomt",
    ),
    "language": MessageLookupByLibrary.simpleMessage("taal"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "kies de taal van de app",
    ),
    "leave": MessageLookupByLibrary.simpleMessage("verlaten"),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage(
      "verlaten zonder op te slaan",
    ),
    "loadingExitMessage": MessageLookupByLibrary.simpleMessage(
      "verlaten terwijl de geselecteerde video\'s nog worden geladen?",
    ),
    "loadingExitTitle": MessageLookupByLibrary.simpleMessage(
      "video\'s worden nog geladen",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "downloaden uit cloudopslag of kopiëren van grote bestanden kan langer duren",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage(
      "video\'s importeren...",
    ),
    "low": MessageLookupByLibrary.simpleMessage("laag"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("door khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("gemiddeld"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "sommige galerijmetadata kon niet worden gekopieerd",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("mijn andere apps"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("mijn website"),
    "next": MessageLookupByLibrary.simpleMessage("volgende"),
    "noAudio": MessageLookupByLibrary.simpleMessage("geen audio"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "probeer een andere modus — deze maakt het bestand niet kleiner",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "kies een of meer video\'s. minimo werkt met lokale bestanden en laat de originelen ongewijzigd",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "kies video\'s",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "kies een kwaliteitsinstelling of pas de resolutie en audio handmatig aan",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "kies wat er verandert",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "compressie gebeurt op je apparaat. video\'s worden nergens geüpload; bewaar de kleinere kopie wanneer je tevreden bent met het resultaat",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "standaard privé",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) is open source. bekijk de code, volg het project of neem contact op",
    ),
    "original": MessageLookupByLibrary.simpleMessage("origineel"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "sommige originelen konden niet worden verwijderd",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("voor"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "compressie kan trager worden als je apparaat warm wordt",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("uit bestanden"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("uit galerij"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "scherm ingeschakeld houden",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "voorkomt dat het scherm in slaapstand gaat terwijl video\'s worden gecomprimeerd",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("projectwebsite"),
    "quality": MessageLookupByLibrary.simpleMessage("kwaliteit"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("beoordeel de app"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage(
      "origineel vervangen",
    ),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "de gecomprimeerde video wordt opgeslagen; daarna vraagt Foto\'s om verwijdering van het origineel te bevestigen",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("resolutie"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "verlaag de afmetingen voor de grootste ruimtebesparing",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "de resolutie wordt verlaagd naar hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "de resolutie wordt verlaagd naar sd",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("opslaan"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("opslaan als nieuw"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "behoud het origineel en sla een nieuwe video op in de galerij",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage(
      "naast origineel opslaan",
    ),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "behoud het origineel en kopieer de datum en metadata",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "manier van opslaan",
    ),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "video\'s opslaan in album",
    ),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("opgeslagen"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("instellingen"),
    "share": MessageLookupByLibrary.simpleMessage("delen"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage("delen of opslaan in…"),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "delen met vrienden",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "waarschuwing voor oververhitting tonen",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "toont tijdens compressie een kleine melding wanneer het apparaat mogelijk trager wordt",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("eenvoudig"),
    "skip": MessageLookupByLibrary.simpleMessage("overslaan"),
    "small": MessageLookupByLibrary.simpleMessage("klein"),
    "smaller": MessageLookupByLibrary.simpleMessage("kleiner"),
    "stay": MessageLookupByLibrary.simpleMessage("blijven"),
    "stereo": MessageLookupByLibrary.simpleMessage("stereo"),
    "system": MessageLookupByLibrary.simpleMessage("systeem"),
    "todo": MessageLookupByLibrary.simpleMessage("BINNENKORT"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("opnieuw proberen"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "verlaten zonder de gecomprimeerde video\'s op te slaan?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage(
      "video\'s niet opgeslagen",
    ),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("videobitrate"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "stel een doelbitrate in of laat de kwaliteitsinstelling deze kiezen",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "voorbeeld niet beschikbaar",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("wachten"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
