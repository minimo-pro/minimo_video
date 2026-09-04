// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(prefix) => "ajouter le préfixe \"${prefix}\"";

  static String m1(prefix) =>
      "ajoute \"${prefix}\" avant le nom d\'origine. la désactivation conserve le nom d\'origine";

  static String m2(version) => "nouveautés de ${version}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'environ 1 minute restante', other: 'environ ${count} minutes restantes')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'enregistrer 1 vidéo', other: 'enregistrer ${count} vidéos')}";

  static String m5(album) =>
      "enregistre les vidéos compressées dans l\'album ${album} plutôt que dans les ajouts récents";

  static String m6(error) =>
      "vidéos enregistrées, mais certains originaux n\'ont pas pu être supprimés : ${error}";

  static String m7(saved, deleted) =>
      "${saved} vidéo(s) enregistrée(s) et ${deleted} original(aux) supprimé(s)";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 vidéo enregistrée dans la galerie', other: '${count} vidéos enregistrées dans la galerie')}";

  static String m9(error) =>
      "vidéos enregistrées avec quelques problèmes : ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'environ 1 seconde restante', other: 'environ ${count} secondes restantes')}";

  static String m11(url) =>
      "essayez minimo (video), une app simple pour réduire les vidéos sur votre téléphone : ${url}";

  static String m12(current, total) => "vidéo ${current} sur ${total}";

  static String m13(completed, total) =>
      "${completed} vidéos sur ${total} compressées";

  static String m14(size) => "vous avez économisé ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("à propos"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) est né d\'une frustration toute simple.\n\nce projet offre à tous un moyen pratique et gratuit de compresser des vidéos directement sur un appareil mobile, d\'économiser de l\'espace et de conserver les moments importants.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("avancé"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage("déjà optimisée"),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "cette vidéo est déjà petite. essayez une qualité inférieure ou une autre vidéo.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("audio"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "conservez l\'audio d\'origine ou supprimez-le pour gagner plus d\'espace",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("auto"),
    "better": MessageLookupByLibrary.simpleMessage("meilleure"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "le débit sera réduit pour gagner de l\'espace",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "impossible de vider le cache",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("cache vidé"),
    "cancel": MessageLookupByLibrary.simpleMessage("annuler"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("compris"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "modifications des mises à jour que vous n\'avez pas encore vues",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("vider le cache"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "supprime les fichiers temporaires de l\'app. les vidéos enregistrées dans la galerie restent intactes",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("codec"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 fonctionne partout ; HEVC peut être plus compact mais revenir à H.264",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("comparer"),
    "compress": MessageLookupByLibrary.simpleMessage("compresser"),
    "compressed": MessageLookupByLibrary.simpleMessage("compressé"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("après"),
    "compressing": MessageLookupByLibrary.simpleMessage("compression..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "compression annulée",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "compression terminée",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "compression terminée",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "échec de la compression",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "nous n\'avons pas pu compresser cette vidéo. réessayez ou choisissez-en une autre.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("thème sombre"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "utiliser l\'apparence sombre",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage("e-mail copié"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "estimation du temps restant...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("échec"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "choisissez un fichier vidéo",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "impossible d\'enregistrer les vidéos. réessayez",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "impossible de partager les vidéos. réessayez",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("fréquence d\'images"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "limite le nombre d\'images par seconde en sortie ; les sources plus lentes restent inchangées",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("commencer"),
    "githubRepository": MessageLookupByLibrary.simpleMessage("dépôt github"),
    "good": MessageLookupByLibrary.simpleMessage("bonne"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC n\'était pas disponible, cette vidéo a donc été enregistrée en H.264",
    ),
    "high": MessageLookupByLibrary.simpleMessage("haute"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "maintenez le bouton pour annuler la compression",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "maintenez le bouton pour vider le cache",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "maintenez le bouton pour supprimer les originaux",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo crée une nouvelle copie de votre vidéo et la stocke plus efficacement. il peut réduire le débit, la taille de l\'image ou supprimer l\'audio selon votre choix.\n\nun débit plus faible conserve moins de petits détails difficiles à remarquer. une résolution plus faible signifie moins de pixels par image. les deux réduisent la taille du fichier.\n\nl\'original reste intact et la compression s\'effectue sur votre appareil.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "comment la vidéo devient plus petite",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "gardez minimo ouvert pendant la compression. si vous quittez l\'app, la vidéo en cours redémarrera à votre retour",
    ),
    "language": MessageLookupByLibrary.simpleMessage("langue"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "choisissez la langue de l\'app",
    ),
    "leave": MessageLookupByLibrary.simpleMessage("quitter"),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage(
      "quitter sans enregistrer",
    ),
    "loadingExitMessage": MessageLookupByLibrary.simpleMessage(
      "quitter pendant le chargement des vidéos sélectionnées ?",
    ),
    "loadingExitTitle": MessageLookupByLibrary.simpleMessage(
      "les vidéos sont encore en cours de chargement",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "le téléchargement depuis le cloud ou la copie de gros fichiers peut prendre plus de temps",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage(
      "importation des vidéos...",
    ),
    "low": MessageLookupByLibrary.simpleMessage("basse"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("par khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("moyenne"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "certaines métadonnées de la galerie n\'ont pas pu être copiées",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("mes autres apps"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("mon site"),
    "next": MessageLookupByLibrary.simpleMessage("suivant"),
    "noAudio": MessageLookupByLibrary.simpleMessage("sans audio"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "essayez un autre mode — celui-ci ne réduira pas la taille",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "choisissez une ou plusieurs vidéos. minimo utilise les fichiers locaux et ne modifie pas les originaux",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "choisissez des vidéos",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "choisissez un niveau de qualité ou réglez manuellement la résolution et l\'audio",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "choisissez les modifications",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "la compression s\'effectue sur votre appareil. les vidéos ne sont envoyées nulle part ; enregistrez la copie réduite si le résultat vous convient",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "privé par défaut",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) est open source. explorez le code, suivez le projet ou contactez-moi",
    ),
    "original": MessageLookupByLibrary.simpleMessage("original"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "certains originaux n\'ont pas pu être supprimés",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("avant"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "la compression peut ralentir si votre appareil chauffe",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage(
      "depuis les fichiers",
    ),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage(
      "depuis la galerie",
    ),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "garder l\'écran allumé",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "empêche l\'écran de s\'éteindre pendant la compression",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("site du projet"),
    "quality": MessageLookupByLibrary.simpleMessage("qualité"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("noter l\'app"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage(
      "remplacer l\'original",
    ),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "la vidéo compressée sera enregistrée, puis Photos demandera de confirmer la suppression de l\'original",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("résolution"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "réduisez les dimensions pour gagner le plus d\'espace",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "la résolution sera réduite en hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "la résolution sera réduite en sd",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("enregistrer"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage(
      "enregistrer comme nouvelle",
    ),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "conserver l\'original et enregistrer une nouvelle vidéo dans la galerie",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage(
      "enregistrer avec l\'original",
    ),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "conserver l\'original et copier sa date et ses métadonnées",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "méthode d\'enregistrement",
    ),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "enregistrer dans un album",
    ),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("enregistré"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("réglages"),
    "share": MessageLookupByLibrary.simpleMessage("partager"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage(
      "partager ou enregistrer dans…",
    ),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "partager avec des amis",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "afficher l\'avertissement de surchauffe",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "affiche une petite alerte pendant la compression si l\'appareil risque de ralentir",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("simple"),
    "skip": MessageLookupByLibrary.simpleMessage("passer"),
    "small": MessageLookupByLibrary.simpleMessage("petite"),
    "smaller": MessageLookupByLibrary.simpleMessage("plus petite"),
    "stay": MessageLookupByLibrary.simpleMessage("rester"),
    "stereo": MessageLookupByLibrary.simpleMessage("stéréo"),
    "system": MessageLookupByLibrary.simpleMessage("système"),
    "todo": MessageLookupByLibrary.simpleMessage("BIENTÔT"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("réessayer"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "quitter sans enregistrer les vidéos compressées ?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage(
      "vidéos non enregistrées",
    ),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("débit vidéo"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "définissez un débit cible ou laissez le niveau de qualité le choisir",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "aperçu indisponible",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("en attente"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
