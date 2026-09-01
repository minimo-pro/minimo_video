// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(prefix) => "\"${prefix}\"接頭辞を追加";

  static String m1(prefix) => "元のファイル名の前に\"${prefix}\"を追加します。オフにすると元の名前を保持します";

  static String m2(version) => "${version}の新機能";

  static String m3(count) =>
      "${Intl.plural(count, one: '残り約1分', other: '残り約${count}分')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1本の動画を保存', other: '${count}本の動画を保存')}";

  static String m5(album) => "圧縮した動画を最近の項目ではなく${album}アルバムに保存します";

  static String m6(error) => "動画は保存されましたが、一部の元動画を削除できませんでした: ${error}";

  static String m7(saved, deleted) => "${saved}本の動画を保存し、${deleted}本の元動画を削除しました";

  static String m8(count) =>
      "${Intl.plural(count, one: '1本の動画をギャラリーに保存しました', other: '${count}本の動画をギャラリーに保存しました')}";

  static String m9(error) => "問題がある状態で動画を保存しました: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: '残り約1秒', other: '残り約${count}秒')}";

  static String m11(url) => "スマホの動画を簡単に小さくできるminimo (video)を試してみてください: ${url}";

  static String m12(current, total) => "${total}本中${current}本目";

  static String m13(completed, total) => "${total}本中${completed}本を圧縮";

  static String m14(size) => "${size}節約しました";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("このアプリについて"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video)は、ちょっとした不満から生まれました。\n\nこのプロジェクトは、モバイルデバイス上で動画を簡単かつ無料で圧縮し、容量を節約しながら大切な瞬間を残せるようにします。",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("詳細"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage("最適化済み"),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "この動画はすでに小さいです。画質を下げるか別の動画を選択してください。",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("音声"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "元の音声を残すか、削除して容量を節約します",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("自動"),
    "better": MessageLookupByLibrary.simpleMessage("高品質"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "容量節約のためビットレートを下げます",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage("キャッシュを消去できません"),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("キャッシュを消去しました"),
    "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("了解"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage("まだ確認していない更新内容"),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("キャッシュを消去"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "アプリの一時ファイルを削除します。ギャラリーの動画は残ります",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("コーデック"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264は幅広く対応し、HEVCは小さくできますがH.264に切り替わることがあります",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("比較"),
    "compress": MessageLookupByLibrary.simpleMessage("圧縮"),
    "compressed": MessageLookupByLibrary.simpleMessage("圧縮済み"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("圧縮後"),
    "compressing": MessageLookupByLibrary.simpleMessage("圧縮中..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "圧縮をキャンセルしました",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage("圧縮完了"),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage("圧縮が完了しました"),
    "compressionFailed": MessageLookupByLibrary.simpleMessage("圧縮に失敗しました"),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "この動画を圧縮できませんでした。再試行するか別の動画を選択してください。",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("ダークテーマ"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage("暗い外観を使用"),
    "emailCopied": MessageLookupByLibrary.simpleMessage("メールアドレスをコピーしました"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "残り時間を計算中...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("失敗"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "動画ファイルを選択してください",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "動画を保存できません。再試行してください",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "動画を共有できません。再試行してください",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("フレームレート"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "出力の1秒あたりのフレーム数を制限し、低い元レートは変更しません",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("始める"),
    "githubRepository": MessageLookupByLibrary.simpleMessage("githubリポジトリ"),
    "good": MessageLookupByLibrary.simpleMessage("良好"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVCが使用できないため、この動画はH.264で保存されました",
    ),
    "high": MessageLookupByLibrary.simpleMessage("高"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "ボタンを長押しして圧縮をキャンセル",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "ボタンを長押ししてキャッシュを消去",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "ボタンを長押しして元の動画を削除",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimoは動画の新しいコピーを作成し、より効率的に保存します。ビットレートや画面サイズを下げたり、音声を削除できます。\n\nビットレートが低いと目立ちにくい細部が減り、解像度が低いとフレームごとの画素数が減ります。どちらもファイルを小さくします。\n\n元の動画は変更されず、圧縮はデバイス上で行われます。",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "動画が小さくなる仕組み",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "圧縮中はminimoを開いたままにしてください。移動すると戻ったときに現在の動画が最初から始まります",
    ),
    "language": MessageLookupByLibrary.simpleMessage("言語"),
    "languageDescription": MessageLookupByLibrary.simpleMessage("アプリの言語を選択"),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage("保存せずに終了"),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "クラウドからのダウンロードや大きなファイルのコピーには時間がかかる場合があります",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("動画を読み込み中..."),
    "low": MessageLookupByLibrary.simpleMessage("低"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("khlebobul 作"),
    "medium": MessageLookupByLibrary.simpleMessage("中"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "一部のギャラリーメタデータをコピーできませんでした",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("その他のアプリ"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("私のサイト"),
    "next": MessageLookupByLibrary.simpleMessage("次へ"),
    "noAudio": MessageLookupByLibrary.simpleMessage("音声なし"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "別のモードをお試しください — これでは小さくなりません",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "1本または複数の動画を選択します。minimoはローカルファイルを使用し、元の動画は変更しません",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage("動画を選択"),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "画質プリセットを選ぶか、解像度と音声を手動で調整します",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage("変更内容を選択"),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "圧縮はデバイス上で行われ、動画はどこにもアップロードされません。結果に満足したら小さいコピーを保存します",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage("プライバシーを優先"),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video)はオープンソースです。コードの確認、プロジェクトのフォロー、お問い合わせができます",
    ),
    "original": MessageLookupByLibrary.simpleMessage("オリジナル"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "一部の元動画を削除できませんでした",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("圧縮前"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "デバイスが熱くなると圧縮が遅くなることがあります",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("ファイルから"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("ギャラリーから"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage("画面をオンのままにする"),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "動画の圧縮中に画面がスリープしないようにします",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("プロジェクトサイト"),
    "quality": MessageLookupByLibrary.simpleMessage("画質"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("アプリを評価"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage("元の動画を置き換え"),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "圧縮済み動画を保存した後、写真アプリが元の動画の削除確認を求めます",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("解像度"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "寸法を下げると容量を最も節約できます",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "解像度をhdに下げます",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "解像度をsdに下げます",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("新規保存"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "元の動画を残し、新しい動画をギャラリーに保存します",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage("元の動画の横に保存"),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "元の動画を残し、日付とメタデータをコピーします",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage("保存方法"),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage("動画をアルバムに保存"),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("保存済み"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "share": MessageLookupByLibrary.simpleMessage("共有"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage("共有または保存先…"),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage("友達と共有"),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage("過熱警告を表示"),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "デバイスが遅くなる可能性があるときに小さなバナーを表示します",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("シンプル"),
    "skip": MessageLookupByLibrary.simpleMessage("スキップ"),
    "small": MessageLookupByLibrary.simpleMessage("小"),
    "smaller": MessageLookupByLibrary.simpleMessage("小さい"),
    "stay": MessageLookupByLibrary.simpleMessage("戻る"),
    "stereo": MessageLookupByLibrary.simpleMessage("ステレオ"),
    "system": MessageLookupByLibrary.simpleMessage("システム"),
    "todo": MessageLookupByLibrary.simpleMessage("近日公開"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("再試行"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "圧縮動画を保存せずに終了しますか？",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage("動画が保存されていません"),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("動画ビットレート"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "目標ビットレートを設定するか、画質プリセットに任せます",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "プレビューできません",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("待機中"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
