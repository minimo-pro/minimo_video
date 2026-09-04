// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static String m0(prefix) => "aggiungi il prefisso \"${prefix}\"";

  static String m1(prefix) =>
      "aggiunge \"${prefix}\" prima del nome originale. disattivando l\'opzione, il nome originale viene mantenuto";

  static String m2(version) => "novità di ${version}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'circa 1 minuto rimanente', other: 'circa ${count} minuti rimanenti')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'salva 1 video', other: 'salva ${count} video')}";

  static String m5(album) =>
      "salva i video compressi nell\'album ${album} invece che tra gli elementi recenti";

  static String m6(error) =>
      "video salvati, ma alcuni originali non sono stati eliminati: ${error}";

  static String m7(saved, deleted) =>
      "video salvati: ${saved}; originali eliminati: ${deleted}";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 video salvato nella galleria', other: '${count} video salvati nella galleria')}";

  static String m9(error) => "video salvati con alcuni problemi: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'circa 1 secondo rimanente', other: 'circa ${count} secondi rimanenti')}";

  static String m11(url) =>
      "prova minimo (video), un\'app semplice per ridurre i video sul telefono: ${url}";

  static String m12(current, total) => "video ${current} di ${total}";

  static String m13(completed, total) =>
      "${completed} video su ${total} compressi";

  static String m14(size) => "hai risparmiato ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("informazioni"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) nasce da una semplice frustrazione.\n\nquesto progetto offre a tutti un modo comodo e gratuito per comprimere video direttamente su un dispositivo mobile, risparmiare spazio e conservare i momenti importanti.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("avanzato"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage("già ottimizzato"),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "questo video è già piccolo. prova una qualità inferiore o scegli un altro video.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("audio"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "mantieni l\'audio originale o rimuovilo per risparmiare più spazio",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("auto"),
    "better": MessageLookupByLibrary.simpleMessage("migliore"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "il bitrate verrà ridotto per risparmiare spazio",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "impossibile svuotare la cache",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("cache svuotata"),
    "cancel": MessageLookupByLibrary.simpleMessage("annulla"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("capito"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "modifiche degli aggiornamenti che non hai ancora visto",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("svuota cache"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "rimuove i file temporanei dell\'app. i video salvati nella galleria restano intatti",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("codec"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 funziona ovunque; HEVC può essere più piccolo, ma può tornare a H.264",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("confronta"),
    "compress": MessageLookupByLibrary.simpleMessage("comprimi"),
    "compressed": MessageLookupByLibrary.simpleMessage("compresso"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("dopo"),
    "compressing": MessageLookupByLibrary.simpleMessage("compressione..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "compressione annullata",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "compressione completata",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "compressione completata",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "compressione non riuscita",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "non è stato possibile comprimere questo video. riprova o scegline un altro.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("tema scuro"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "usa l\'aspetto scuro",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage("e-mail copiata"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "stima del tempo rimanente...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("non riuscito"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "scegli un file video",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "impossibile salvare i video. riprova",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "impossibile condividere i video. riprova",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("frequenza fotogrammi"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "limita i fotogrammi al secondo in uscita; frequenze sorgente inferiori restano invariate",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("inizia"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "repository github",
    ),
    "good": MessageLookupByLibrary.simpleMessage("buona"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC non era disponibile, quindi il video è stato salvato come H.264",
    ),
    "high": MessageLookupByLibrary.simpleMessage("alta"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "tieni premuto il pulsante per annullare la compressione",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "tieni premuto il pulsante per svuotare la cache",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "tieni premuto il pulsante per eliminare gli originali",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo crea una nuova copia del video e la memorizza in modo più efficiente. può ridurre il bitrate, diminuire le dimensioni dell\'immagine o rimuovere l\'audio.\n\nun bitrate più basso conserva meno piccoli dettagli difficili da notare. una risoluzione più bassa significa meno pixel per fotogramma. entrambi riducono le dimensioni del file.\n\nil video originale resta intatto e la compressione avviene sul dispositivo.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "come si riduce un video",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "mantieni minimo aperto durante la compressione. se esci, il video corrente ripartirà quando torni",
    ),
    "language": MessageLookupByLibrary.simpleMessage("lingua"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "scegli la lingua dell\'app",
    ),
    "leave": MessageLookupByLibrary.simpleMessage("esci"),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage(
      "esci senza salvare",
    ),
    "loadingExitMessage": MessageLookupByLibrary.simpleMessage(
      "uscire mentre i video selezionati sono ancora in caricamento?",
    ),
    "loadingExitTitle": MessageLookupByLibrary.simpleMessage(
      "i video sono ancora in caricamento",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "il download dal cloud o la copia di file grandi può richiedere più tempo",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage(
      "importazione video...",
    ),
    "low": MessageLookupByLibrary.simpleMessage("bassa"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("di khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("media"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "alcuni metadati della galleria non sono stati copiati",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("le mie altre app"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("il mio sito"),
    "next": MessageLookupByLibrary.simpleMessage("avanti"),
    "noAudio": MessageLookupByLibrary.simpleMessage("senza audio"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "prova un\'altra modalità — questa non ridurrà le dimensioni",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "scegli uno o più video. minimo usa file locali e lascia intatti gli originali",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "scegli i video",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "scegli un livello di qualità o regola manualmente risoluzione e audio",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "scegli cosa modificare",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "la compressione avviene sul dispositivo. i video non vengono caricati altrove; salva la copia più piccola quando il risultato ti soddisfa",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "privato per impostazione predefinita",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) è open source. esplora il codice, segui il progetto o contattami",
    ),
    "original": MessageLookupByLibrary.simpleMessage("originale"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "alcuni originali non sono stati eliminati",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("prima"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "la compressione può rallentare se il dispositivo si surriscalda",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("dai file"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("dalla galleria"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "mantieni lo schermo acceso",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "impedisce allo schermo di spegnersi durante la compressione",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("sito del progetto"),
    "quality": MessageLookupByLibrary.simpleMessage("qualità"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("valuta l\'app"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage(
      "sostituisci l\'originale",
    ),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "il video compresso verrà salvato, poi Foto chiederà di confermare l\'eliminazione dell\'originale",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("risoluzione"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "riduci le dimensioni per risparmiare più spazio",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "la risoluzione verrà ridotta a hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "la risoluzione verrà ridotta a sd",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("salva"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("salva come nuovo"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "mantieni l\'originale e salva un nuovo video nella galleria",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage(
      "salva accanto all\'originale",
    ),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "mantieni l\'originale e copia data e metadati",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage("come salvare"),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "salva i video in un album",
    ),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("salvato"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("impostazioni"),
    "share": MessageLookupByLibrary.simpleMessage("condividi"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage(
      "condividi o salva in…",
    ),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "condividi con gli amici",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "mostra avviso di surriscaldamento",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "mostra un piccolo avviso durante la compressione quando il dispositivo potrebbe rallentare",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("semplice"),
    "skip": MessageLookupByLibrary.simpleMessage("salta"),
    "small": MessageLookupByLibrary.simpleMessage("piccolo"),
    "smaller": MessageLookupByLibrary.simpleMessage("più piccolo"),
    "stay": MessageLookupByLibrary.simpleMessage("rimani"),
    "stereo": MessageLookupByLibrary.simpleMessage("stereo"),
    "system": MessageLookupByLibrary.simpleMessage("sistema"),
    "todo": MessageLookupByLibrary.simpleMessage("PROSSIMAMENTE"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("riprova"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "uscire senza salvare i video compressi?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage(
      "video non salvati",
    ),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("bitrate video"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "imposta un bitrate obiettivo o lascia che lo scelga il livello di qualità",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "anteprima non disponibile",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("in attesa"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
