// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(prefix) => "añadir el prefijo \"${prefix}\"";

  static String m1(prefix) =>
      "añade \"${prefix}\" antes del nombre original. al desactivarlo se conserva el nombre original";

  static String m2(version) => "novedades de ${version}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'queda cerca de 1 minuto', other: 'quedan cerca de ${count} minutos')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'guardar 1 video', other: 'guardar ${count} videos')}";

  static String m5(album) =>
      "guarda los videos comprimidos en el álbum ${album} en vez de elementos recientes";

  static String m6(error) =>
      "los videos se guardaron, pero no se pudieron eliminar algunos originales: ${error}";

  static String m7(saved, deleted) =>
      "videos guardados: ${saved}; originales eliminados: ${deleted}";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 video guardado en la galería', other: '${count} videos guardados en la galería')}";

  static String m9(error) =>
      "los videos se guardaron con algunos problemas: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'queda cerca de 1 segundo', other: 'quedan cerca de ${count} segundos')}";

  static String m11(url) =>
      "prueba minimo (video), una app sencilla para reducir videos en tu teléfono: ${url}";

  static String m12(current, total) => "video ${current} de ${total}";

  static String m13(completed, total) =>
      "${completed} de ${total} videos comprimidos";

  static String m14(size) => "ahorraste ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("acerca de"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) nació de una simple frustración.\n\neste proyecto ofrece a todos una forma cómoda y gratuita de comprimir videos directamente en un dispositivo móvil, ahorrar espacio y conservar los momentos importantes.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("avanzado"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage(
      "ya está optimizado",
    ),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "este video ya es pequeño. prueba con menor calidad o elige otro.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("audio"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "conserva el audio original o elimínalo para ahorrar más espacio",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("auto"),
    "better": MessageLookupByLibrary.simpleMessage("mejor"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "la tasa de bits se reducirá para ahorrar espacio",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "no se pudo borrar la caché",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("caché borrada"),
    "cancel": MessageLookupByLibrary.simpleMessage("cancelar"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("entendido"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "cambios de actualizaciones que aún no has visto",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("borrar caché"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "elimina archivos temporales de la app. los videos guardados en la galería no se modifican",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("códec"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 funciona en todas partes; HEVC puede ocupar menos, pero puede cambiar a H.264",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("comparar"),
    "compress": MessageLookupByLibrary.simpleMessage("comprimir"),
    "compressed": MessageLookupByLibrary.simpleMessage("comprimido"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("después"),
    "compressing": MessageLookupByLibrary.simpleMessage("comprimiendo..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "compresión cancelada",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "compresión completa",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "compresión completada",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "falló la compresión",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "no pudimos comprimir este video. inténtalo de nuevo o elige otro.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("tema oscuro"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "usar apariencia oscura",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage("correo copiado"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "calculando el tiempo restante...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("fallido"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "elige un archivo de video",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "no se pudieron guardar los videos. inténtalo de nuevo",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "no se pudieron compartir los videos. inténtalo de nuevo",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("fotogramas por segundo"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "limita los fotogramas de salida por segundo; no aumenta frecuencias de origen menores",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("empezar"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "repositorio de github",
    ),
    "good": MessageLookupByLibrary.simpleMessage("buena"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC no estaba disponible, así que el video se guardó como H.264",
    ),
    "high": MessageLookupByLibrary.simpleMessage("alta"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "mantén pulsado el botón para cancelar la compresión",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "mantén pulsado el botón para borrar la caché",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "mantén pulsado el botón para eliminar los originales",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo crea una copia nueva de tu video y la almacena de forma más eficiente. puede reducir la tasa de bits, la resolución o eliminar el audio si así lo eliges.\n\nuna tasa de bits menor conserva menos detalles pequeños difíciles de notar. una resolución menor implica menos píxeles por fotograma. ambas reducen el tamaño del archivo.\n\nel video original no se modifica y la compresión ocurre en tu dispositivo.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "cómo se reduce el video",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "mantén minimo abierto durante la compresión. si sales, el video actual se reiniciará al volver",
    ),
    "language": MessageLookupByLibrary.simpleMessage("idioma"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "elige el idioma de la app",
    ),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage(
      "salir sin guardar",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "descargar desde la nube o copiar archivos grandes puede tardar más",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage(
      "importando videos...",
    ),
    "low": MessageLookupByLibrary.simpleMessage("baja"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("por khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("media"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "no se pudieron copiar algunos metadatos de la galería",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("mis otras apps"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("mi sitio web"),
    "next": MessageLookupByLibrary.simpleMessage("siguiente"),
    "noAudio": MessageLookupByLibrary.simpleMessage("sin audio"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "prueba otro modo: este no reducirá el tamaño",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "elige uno o varios videos. minimo trabaja con archivos locales y no modifica los originales",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage("elige videos"),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "elige un ajuste de calidad o configura manualmente la resolución y el audio",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "elige qué cambiar",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "la compresión ocurre en tu dispositivo. los videos no se suben a ningún sitio; guarda la copia más pequeña cuando te guste el resultado",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "privado por defecto",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) es de código abierto. explora el código, sigue el proyecto o ponte en contacto",
    ),
    "original": MessageLookupByLibrary.simpleMessage("original"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "no se pudieron eliminar algunos originales",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("antes"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "la compresión puede ralentizarse si el dispositivo se calienta",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("desde archivos"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("desde la galería"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "mantener la pantalla encendida",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "evita que la pantalla se apague mientras se comprimen videos",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage(
      "sitio web del proyecto",
    ),
    "quality": MessageLookupByLibrary.simpleMessage("calidad"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("valorar la app"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage(
      "reemplazar el original",
    ),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "guardar con los metadatos originales y pedir eliminar el original",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("resolución"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "reduce las dimensiones para ahorrar el máximo espacio",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "la resolución se reducirá a hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "la resolución se reducirá a sd",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("guardar"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("guardar como nuevo"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "conservar el original y guardar un video nuevo en la galería",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage(
      "guardar junto al original",
    ),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "conservar el original y copiar su fecha y metadatos",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage("cómo guardar"),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "guardar videos en un álbum",
    ),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("guardado"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("ajustes"),
    "share": MessageLookupByLibrary.simpleMessage("compartir"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage(
      "compartir o guardar en…",
    ),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "compartir con amigos",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "mostrar aviso de sobrecalentamiento",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "muestra un pequeño aviso durante la compresión si el dispositivo puede ralentizarse",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("simple"),
    "skip": MessageLookupByLibrary.simpleMessage("omitir"),
    "small": MessageLookupByLibrary.simpleMessage("pequeño"),
    "smaller": MessageLookupByLibrary.simpleMessage("menor"),
    "stay": MessageLookupByLibrary.simpleMessage("quedarse"),
    "stereo": MessageLookupByLibrary.simpleMessage("estéreo"),
    "system": MessageLookupByLibrary.simpleMessage("sistema"),
    "todo": MessageLookupByLibrary.simpleMessage("PRÓXIMAMENTE"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("intentar de nuevo"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "¿salir sin guardar los videos comprimidos?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage(
      "videos sin guardar",
    ),
    "videoBitrate": MessageLookupByLibrary.simpleMessage(
      "tasa de bits del video",
    ),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "define una tasa de bits objetivo o deja que el ajuste de calidad la elija",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "vista previa no disponible",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("esperando"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
