// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a tr locale. All the
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
  String get localeName => 'tr';

  static String m0(prefix) => "\"${prefix}\" önekini ekle";

  static String m1(prefix) =>
      "orijinal dosya adının önüne \"${prefix}\" ekler. kapatıldığında orijinal ad korunur";

  static String m2(version) => "${version} sürümündeki yenilikler";

  static String m3(count) =>
      "${Intl.plural(count, one: 'yaklaşık 1 dakika kaldı', other: 'yaklaşık ${count} dakika kaldı')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 videoyu kaydet', other: '${count} videoyu kaydet')}";

  static String m5(album) =>
      "sıkıştırılmış videoları son kaydedilenler yerine ${album} albümüne kaydeder";

  static String m6(error) =>
      "videolar kaydedildi ancak bazı orijinaller silinemedi: ${error}";

  static String m7(saved, deleted) =>
      "${saved} video kaydedildi ve ${deleted} orijinal silindi";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 video galeriye kaydedildi', other: '${count} video galeriye kaydedildi')}";

  static String m9(error) => "videolar bazı sorunlarla kaydedildi: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'yaklaşık 1 saniye kaldı', other: 'yaklaşık ${count} saniye kaldı')}";

  static String m11(url) =>
      "telefonundaki videoları küçülten basit uygulama minimo (video)\'yu dene: ${url}";

  static String m12(current, total) => "video ${current}/${total}";

  static String m13(completed, total) =>
      "${total} videodan ${completed} tanesi sıkıştırıldı";

  static String m14(size) => "${size} tasarruf ettin";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("hakkında"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) basit bir sorundan doğdu.\n\nbu proje, herkesin videoları doğrudan mobil cihazında kolayca ve ücretsiz sıkıştırmasını, depolama alanından tasarruf etmesini ve önemli anları saklamasını sağlar.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("gelişmiş"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage(
      "zaten optimize edilmiş",
    ),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "bu video zaten küçük. daha düşük kaliteyi dene veya başka bir video seç.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("ses"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "orijinal sesi koru veya daha fazla alan kazanmak için kaldır",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("otomatik"),
    "better": MessageLookupByLibrary.simpleMessage("daha iyi"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "alan kazanmak için bit hızı azaltılacak",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "önbellek temizlenemedi",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("önbellek temizlendi"),
    "cancel": MessageLookupByLibrary.simpleMessage("iptal"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("anladım"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "henüz görmediğin güncellemelerdeki değişiklikler",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("önbelleği temizle"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "geçici uygulama dosyalarını kaldırır. galeriye kaydedilen videolar değişmez",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("kodek"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 her yerde çalışır; HEVC daha küçük olabilir ancak H.264\'e geri dönebilir",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("karşılaştır"),
    "compress": MessageLookupByLibrary.simpleMessage("sıkıştır"),
    "compressed": MessageLookupByLibrary.simpleMessage("sıkıştırılmış"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("sonra"),
    "compressing": MessageLookupByLibrary.simpleMessage("sıkıştırılıyor..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "sıkıştırma iptal edildi",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "sıkıştırma tamamlandı",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "sıkıştırma tamamlandı",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "sıkıştırma başarısız",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "bu video sıkıştırılamadı. tekrar dene veya başka bir video seç.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("koyu tema"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "koyu görünümü kullan",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage("e-posta kopyalandı"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "kalan süre hesaplanıyor...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("başarısız"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "bir video dosyası seç",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "videolar kaydedilemedi. tekrar dene",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "videolar paylaşılamadı. tekrar dene",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("kare hızı"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "çıkış kare sayısını sınırlar; daha düşük kaynak hızları değişmez",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("başla"),
    "githubRepository": MessageLookupByLibrary.simpleMessage("github deposu"),
    "good": MessageLookupByLibrary.simpleMessage("iyi"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC kullanılamadığı için bu video H.264 olarak kaydedildi",
    ),
    "high": MessageLookupByLibrary.simpleMessage("yüksek"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "sıkıştırmayı iptal etmek için düğmeyi basılı tut",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "önbelleği temizlemek için düğmeyi basılı tut",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "orijinalleri silmek için düğmeyi basılı tut",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo videonun yeni bir kopyasını oluşturur ve onu daha verimli saklar. bit hızını düşürebilir, görüntü boyutunu azaltabilir veya seçersen sesi kaldırabilir.\n\ndaha düşük bit hızı, fark edilmesi zor küçük ayrıntıları azaltır. daha düşük çözünürlük, her karede daha az piksel demektir. ikisi de dosya boyutunu azaltır.\n\norijinal video değişmez ve sıkıştırma cihazında gerçekleşir.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "video nasıl küçülür",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "sıkıştırma sırasında minimo\'yu açık tut. ayrılırsan geri döndüğünde mevcut video yeniden başlar",
    ),
    "language": MessageLookupByLibrary.simpleMessage("dil"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "uygulamanın dilini seç",
    ),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage(
      "kaydetmeden çık",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "bulut depolamadan indirme veya büyük dosyaları kopyalama daha uzun sürebilir",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage(
      "videolar içe aktarılıyor...",
    ),
    "low": MessageLookupByLibrary.simpleMessage("düşük"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage(
      "khlebobul tarafından",
    ),
    "medium": MessageLookupByLibrary.simpleMessage("orta"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "bazı galeri meta verileri kopyalanamadı",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("diğer uygulamalarım"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("web sitem"),
    "next": MessageLookupByLibrary.simpleMessage("ileri"),
    "noAudio": MessageLookupByLibrary.simpleMessage("sessiz"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "başka bir mod dene — bu seçenek boyutu küçültmeyecek",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "bir veya birden fazla video seç. minimo yerel dosyalarla çalışır ve orijinalleri değiştirmez",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "videoları seç",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "bir kalite ön ayarı seç veya çözünürlük ile sesi elle ayarla",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "neyin değişeceğini seç",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "sıkıştırma cihazında gerçekleşir. videolar hiçbir yere yüklenmez; sonucu beğendiğinde daha küçük kopyayı kaydet",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "varsayılan olarak gizli",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) açık kaynaklıdır. kodu incele, projeyi takip et veya iletişime geç",
    ),
    "original": MessageLookupByLibrary.simpleMessage("orijinal"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "bazı orijinaller silinemedi",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("önce"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "cihazın ısınırsa sıkıştırma yavaşlayabilir",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("dosyalardan"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("galeriden"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "ekranı açık tut",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "videolar sıkıştırılırken ekranın uykuya geçmesini engeller",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("proje web sitesi"),
    "quality": MessageLookupByLibrary.simpleMessage("kalite"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage(
      "uygulamayı değerlendir",
    ),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage(
      "orijinali değiştir",
    ),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "orijinal meta verilerle kaydet, ardından orijinali silmek için izin iste",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("çözünürlük"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "en fazla alan tasarrufu için boyutları azalt",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "çözünürlük hd\'ye düşürülecek",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "çözünürlük sd\'ye düşürülecek",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("kaydet"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("yeni olarak kaydet"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "orijinali koru ve galeriye yeni bir video kaydet",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage(
      "orijinalin yanına kaydet",
    ),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "orijinali koru, tarihini ve meta verilerini kopyala",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "nasıl kaydedilsin",
    ),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "videoları albüme kaydet",
    ),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("kaydedildi"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("ayarlar"),
    "share": MessageLookupByLibrary.simpleMessage("paylaş"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage(
      "paylaş veya şuraya kaydet…",
    ),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "arkadaşlarla paylaş",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "aşırı ısınma uyarısını göster",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "cihaz yavaşlayabileceğinde sıkıştırma sırasında küçük bir bildirim gösterir",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("basit"),
    "skip": MessageLookupByLibrary.simpleMessage("atla"),
    "small": MessageLookupByLibrary.simpleMessage("küçük"),
    "smaller": MessageLookupByLibrary.simpleMessage("daha küçük"),
    "stay": MessageLookupByLibrary.simpleMessage("kal"),
    "stereo": MessageLookupByLibrary.simpleMessage("stereo"),
    "system": MessageLookupByLibrary.simpleMessage("sistem"),
    "todo": MessageLookupByLibrary.simpleMessage("YAKINDA"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("tekrar dene"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "sıkıştırılmış videoları kaydetmeden çıkılsın mı?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage(
      "videolar kaydedilmedi",
    ),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("video bit hızı"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "hedef bit hızı belirle veya kalite ön ayarının seçmesine izin ver",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "önizleme kullanılamıyor",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("bekliyor"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
