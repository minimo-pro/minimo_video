// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `minimo (video)`
  String get appName {
    return Intl.message('minimo (video)', name: 'appName', desc: '', args: []);
  }

  /// `by khlebobul`
  String get madeByKhlebobul {
    return Intl.message(
      'by khlebobul',
      name: 'madeByKhlebobul',
      desc: '',
      args: [],
    );
  }

  /// `skip`
  String get skip {
    return Intl.message('skip', name: 'skip', desc: '', args: []);
  }

  /// `next`
  String get next {
    return Intl.message('next', name: 'next', desc: '', args: []);
  }

  /// `get started`
  String get getStarted {
    return Intl.message('get started', name: 'getStarted', desc: '', args: []);
  }

  /// `pick videos`
  String get onboardingPickTitle {
    return Intl.message(
      'pick videos',
      name: 'onboardingPickTitle',
      desc: '',
      args: [],
    );
  }

  /// `choose one or several videos. minimo works with local files and keeps the originals untouched`
  String get onboardingPickDescription {
    return Intl.message(
      'choose one or several videos. minimo works with local files and keeps the originals untouched',
      name: 'onboardingPickDescription',
      desc: '',
      args: [],
    );
  }

  /// `choose what changes`
  String get onboardingQualityTitle {
    return Intl.message(
      'choose what changes',
      name: 'onboardingQualityTitle',
      desc: '',
      args: [],
    );
  }

  /// `choose a quality preset or adjust resolution and audio manually`
  String get onboardingQualityDescription {
    return Intl.message(
      'choose a quality preset or adjust resolution and audio manually',
      name: 'onboardingQualityDescription',
      desc: '',
      args: [],
    );
  }

  /// `private by default`
  String get onboardingSaveTitle {
    return Intl.message(
      'private by default',
      name: 'onboardingSaveTitle',
      desc: '',
      args: [],
    );
  }

  /// `compression happens on your device. videos are not uploaded anywhere; save the smaller copy when you like the result`
  String get onboardingSaveDescription {
    return Intl.message(
      'compression happens on your device. videos are not uploaded anywhere; save the smaller copy when you like the result',
      name: 'onboardingSaveDescription',
      desc: '',
      args: [],
    );
  }

  /// `TODO`
  String get todo {
    return Intl.message('TODO', name: 'todo', desc: '', args: []);
  }

  /// `about`
  String get about {
    return Intl.message('about', name: 'about', desc: '', args: []);
  }

  /// `minimo (video) was born from a simple frustration.\n\nthis project gives everyone a convenient and free way to compress videos directly on a mobile device, save storage and keep the moments that matter.`
  String get aboutStory {
    return Intl.message(
      'minimo (video) was born from a simple frustration.\n\nthis project gives everyone a convenient and free way to compress videos directly on a mobile device, save storage and keep the moments that matter.',
      name: 'aboutStory',
      desc: '',
      args: [],
    );
  }

  /// `how video gets smaller`
  String get howCompressionWorksTitle {
    return Intl.message(
      'how video gets smaller',
      name: 'howCompressionWorksTitle',
      desc: '',
      args: [],
    );
  }

  /// `minimo makes a new copy of your video and stores it more efficiently. it can lower the bitrate, reduce the picture size, or remove audio if you choose that.\n\nlower bitrate means the video keeps fewer tiny details that are hard to notice. lower resolution means each frame has fewer pixels. both reduce file size.\n\nyour original video stays untouched, and compression happens on your device.`
  String get howCompressionWorksBody {
    return Intl.message(
      'minimo makes a new copy of your video and stores it more efficiently. it can lower the bitrate, reduce the picture size, or remove audio if you choose that.\n\nlower bitrate means the video keeps fewer tiny details that are hard to notice. lower resolution means each frame has fewer pixels. both reduce file size.\n\nyour original video stays untouched, and compression happens on your device.',
      name: 'howCompressionWorksBody',
      desc: '',
      args: [],
    );
  }

  /// `minimo (video) is open source. explore the code, follow the project or get in touch`
  String get openSourceNote {
    return Intl.message(
      'minimo (video) is open source. explore the code, follow the project or get in touch',
      name: 'openSourceNote',
      desc: '',
      args: [],
    );
  }

  /// `project website`
  String get projectWebsite {
    return Intl.message(
      'project website',
      name: 'projectWebsite',
      desc: '',
      args: [],
    );
  }

  /// `github repository`
  String get githubRepository {
    return Intl.message(
      'github repository',
      name: 'githubRepository',
      desc: '',
      args: [],
    );
  }

  /// `x (twitter)`
  String get xTwitter {
    return Intl.message('x (twitter)', name: 'xTwitter', desc: '', args: []);
  }

  /// `my website`
  String get myWebsite {
    return Intl.message('my website', name: 'myWebsite', desc: '', args: []);
  }

  /// `my other apps`
  String get myOtherApps {
    return Intl.message(
      'my other apps',
      name: 'myOtherApps',
      desc: '',
      args: [],
    );
  }

  /// `email copied`
  String get emailCopied {
    return Intl.message(
      'email copied',
      name: 'emailCopied',
      desc: '',
      args: [],
    );
  }

  /// `settings`
  String get settings {
    return Intl.message('settings', name: 'settings', desc: '', args: []);
  }

  /// `add "{prefix}" prefix`
  String addPrefix(String prefix) {
    return Intl.message(
      'add "$prefix" prefix',
      name: 'addPrefix',
      desc: '',
      args: [prefix],
    );
  }

  /// `adds "{prefix}" before the original file name. disabling keeps the original file name`
  String addPrefixDescription(String prefix) {
    return Intl.message(
      'adds "$prefix" before the original file name. disabling keeps the original file name',
      name: 'addPrefixDescription',
      desc: '',
      args: [prefix],
    );
  }

  /// `show overheat warning`
  String get showOverheatWarning {
    return Intl.message(
      'show overheat warning',
      name: 'showOverheatWarning',
      desc: '',
      args: [],
    );
  }

  /// `shows a small banner during compression when the device may slow down`
  String get showOverheatWarningDescription {
    return Intl.message(
      'shows a small banner during compression when the device may slow down',
      name: 'showOverheatWarningDescription',
      desc: '',
      args: [],
    );
  }

  /// `save videos to album`
  String get saveVideosToAlbum {
    return Intl.message(
      'save videos to album',
      name: 'saveVideosToAlbum',
      desc: '',
      args: [],
    );
  }

  /// `saves compressed videos to the {album} album instead of recently saved`
  String saveVideosToAlbumDescription(String album) {
    return Intl.message(
      'saves compressed videos to the $album album instead of recently saved',
      name: 'saveVideosToAlbumDescription',
      desc: '',
      args: [album],
    );
  }

  /// `delete originals after saving`
  String get deleteOriginalsAfterSaving {
    return Intl.message(
      'delete originals after saving',
      name: 'deleteOriginalsAfterSaving',
      desc: '',
      args: [],
    );
  }

  /// `deletes selected originals only after compressed videos are saved`
  String get deleteOriginalsAfterSavingDescription {
    return Intl.message(
      'deletes selected originals only after compressed videos are saved',
      name: 'deleteOriginalsAfterSavingDescription',
      desc: '',
      args: [],
    );
  }

  /// `keep screen awake`
  String get preventScreenSleep {
    return Intl.message(
      'keep screen awake',
      name: 'preventScreenSleep',
      desc: '',
      args: [],
    );
  }

  /// `prevents the screen from sleeping while videos are compressing`
  String get preventScreenSleepDescription {
    return Intl.message(
      'prevents the screen from sleeping while videos are compressing',
      name: 'preventScreenSleepDescription',
      desc: '',
      args: [],
    );
  }

  /// `clear cache`
  String get clearCache {
    return Intl.message('clear cache', name: 'clearCache', desc: '', args: []);
  }

  /// `removes temporary app files. videos saved to your gallery remain untouched`
  String get clearCacheDescription {
    return Intl.message(
      'removes temporary app files. videos saved to your gallery remain untouched',
      name: 'clearCacheDescription',
      desc: '',
      args: [],
    );
  }

  /// `hold the button to clear cache`
  String get holdToClearCache {
    return Intl.message(
      'hold the button to clear cache',
      name: 'holdToClearCache',
      desc: '',
      args: [],
    );
  }

  /// `cache cleared`
  String get cacheCleared {
    return Intl.message(
      'cache cleared',
      name: 'cacheCleared',
      desc: '',
      args: [],
    );
  }

  /// `failed to clear cache`
  String get cacheClearFailed {
    return Intl.message(
      'failed to clear cache',
      name: 'cacheClearFailed',
      desc: '',
      args: [],
    );
  }

  /// `language`
  String get language {
    return Intl.message('language', name: 'language', desc: '', args: []);
  }

  /// `select the language for the app`
  String get languageDescription {
    return Intl.message(
      'select the language for the app',
      name: 'languageDescription',
      desc: '',
      args: [],
    );
  }

  /// `dark theme`
  String get darkTheme {
    return Intl.message('dark theme', name: 'darkTheme', desc: '', args: []);
  }

  /// `use the dark appearance`
  String get darkThemeDescription {
    return Intl.message(
      'use the dark appearance',
      name: 'darkThemeDescription',
      desc: '',
      args: [],
    );
  }

  /// `system`
  String get system {
    return Intl.message('system', name: 'system', desc: '', args: []);
  }

  /// `english`
  String get english {
    return Intl.message('english', name: 'english', desc: '', args: []);
  }

  /// `русский`
  String get russian {
    return Intl.message('русский', name: 'russian', desc: '', args: []);
  }

  /// `compression can slow down if your device gets hot`
  String get overheatWarning {
    return Intl.message(
      'compression can slow down if your device gets hot',
      name: 'overheatWarning',
      desc: '',
      args: [],
    );
  }

  /// `keep minimo open during compression. if you leave, the current video restarts when you return`
  String get iosBackgroundCompressionWarning {
    return Intl.message(
      'keep minimo open during compression. if you leave, the current video restarts when you return',
      name: 'iosBackgroundCompressionWarning',
      desc: '',
      args: [],
    );
  }

  /// `quality`
  String get quality {
    return Intl.message('quality', name: 'quality', desc: '', args: []);
  }

  /// `resolution`
  String get resolution {
    return Intl.message('resolution', name: 'resolution', desc: '', args: []);
  }

  /// `high`
  String get high {
    return Intl.message('high', name: 'high', desc: '', args: []);
  }

  /// `good`
  String get good {
    return Intl.message('good', name: 'good', desc: '', args: []);
  }

  /// `medium`
  String get medium {
    return Intl.message('medium', name: 'medium', desc: '', args: []);
  }

  /// `low`
  String get low {
    return Intl.message('low', name: 'low', desc: '', args: []);
  }

  /// `small`
  String get small {
    return Intl.message('small', name: 'small', desc: '', args: []);
  }

  /// `reduce dimensions for the biggest size savings`
  String get resolutionDescription {
    return Intl.message(
      'reduce dimensions for the biggest size savings',
      name: 'resolutionDescription',
      desc: '',
      args: [],
    );
  }

  /// `audio`
  String get audio {
    return Intl.message('audio', name: 'audio', desc: '', args: []);
  }

  /// `keep the original audio or remove it to save more space`
  String get audioDescription {
    return Intl.message(
      'keep the original audio or remove it to save more space',
      name: 'audioDescription',
      desc: '',
      args: [],
    );
  }

  /// `stereo`
  String get stereo {
    return Intl.message('stereo', name: 'stereo', desc: '', args: []);
  }

  /// `no audio`
  String get noAudio {
    return Intl.message('no audio', name: 'noAudio', desc: '', args: []);
  }

  /// `original`
  String get original {
    return Intl.message('original', name: 'original', desc: '', args: []);
  }

  /// `compressed`
  String get compressed {
    return Intl.message('compressed', name: 'compressed', desc: '', args: []);
  }

  /// `simple`
  String get simpleOptions {
    return Intl.message('simple', name: 'simpleOptions', desc: '', args: []);
  }

  /// `advanced`
  String get advancedOptions {
    return Intl.message(
      'advanced',
      name: 'advancedOptions',
      desc: '',
      args: [],
    );
  }

  /// `bitrate will be reduced to save space`
  String get bitrateReducedDescription {
    return Intl.message(
      'bitrate will be reduced to save space',
      name: 'bitrateReducedDescription',
      desc: '',
      args: [],
    );
  }

  /// `resolution will be reduced to hd`
  String get resolutionReducedHdDescription {
    return Intl.message(
      'resolution will be reduced to hd',
      name: 'resolutionReducedHdDescription',
      desc: '',
      args: [],
    );
  }

  /// `resolution will be reduced to sd`
  String get resolutionReducedSdDescription {
    return Intl.message(
      'resolution will be reduced to sd',
      name: 'resolutionReducedSdDescription',
      desc: '',
      args: [],
    );
  }

  /// `better`
  String get better {
    return Intl.message('better', name: 'better', desc: '', args: []);
  }

  /// `smaller`
  String get smaller {
    return Intl.message('smaller', name: 'smaller', desc: '', args: []);
  }

  /// `try another mode — this won't make it smaller`
  String get noSavingsHint {
    return Intl.message(
      'try another mode — this won\'t make it smaller',
      name: 'noSavingsHint',
      desc: '',
      args: [],
    );
  }

  /// `compress`
  String get compress {
    return Intl.message('compress', name: 'compress', desc: '', args: []);
  }

  /// `compressing...`
  String get compressing {
    return Intl.message(
      'compressing...',
      name: 'compressing',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message('cancel', name: 'cancel', desc: '', args: []);
  }

  /// `hold the button to cancel compression`
  String get holdToCancelCompression {
    return Intl.message(
      'hold the button to cancel compression',
      name: 'holdToCancelCompression',
      desc: '',
      args: [],
    );
  }

  /// `compression cancelled`
  String get compressionCancelled {
    return Intl.message(
      'compression cancelled',
      name: 'compressionCancelled',
      desc: '',
      args: [],
    );
  }

  /// `estimating time remaining...`
  String get estimatingTimeRemaining {
    return Intl.message(
      'estimating time remaining...',
      name: 'estimatingTimeRemaining',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{about 1 second left} other{about {count} seconds left}}`
  String secondsRemaining(int count) {
    return Intl.plural(
      count,
      one: 'about 1 second left',
      other: 'about $count seconds left',
      name: 'secondsRemaining',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{about 1 minute left} other{about {count} minutes left}}`
  String minutesRemaining(int count) {
    return Intl.plural(
      count,
      one: 'about 1 minute left',
      other: 'about $count minutes left',
      name: 'minutesRemaining',
      desc: '',
      args: [count],
    );
  }

  /// `from gallery`
  String get pickFromGallery {
    return Intl.message(
      'from gallery',
      name: 'pickFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `from files`
  String get pickFromFiles {
    return Intl.message(
      'from files',
      name: 'pickFromFiles',
      desc: '',
      args: [],
    );
  }

  /// `loading videos...`
  String get loadingVideos {
    return Intl.message(
      'loading videos...',
      name: 'loadingVideos',
      desc: '',
      args: [],
    );
  }

  /// `large or numerous files may take longer to load`
  String get loadingManyVideosHint {
    return Intl.message(
      'large or numerous files may take longer to load',
      name: 'loadingManyVideosHint',
      desc: '',
      args: [],
    );
  }

  /// `choose a video file`
  String get failedToPickVideos {
    return Intl.message(
      'choose a video file',
      name: 'failedToPickVideos',
      desc: '',
      args: [],
    );
  }

  /// `compression complete`
  String get compressionComplete {
    return Intl.message(
      'compression complete',
      name: 'compressionComplete',
      desc: '',
      args: [],
    );
  }

  /// `compression completed`
  String get compressionCompleted {
    return Intl.message(
      'compression completed',
      name: 'compressionCompleted',
      desc: '',
      args: [],
    );
  }

  /// `compression failed`
  String get compressionFailed {
    return Intl.message(
      'compression failed',
      name: 'compressionFailed',
      desc: '',
      args: [],
    );
  }

  /// `we couldn't compress this video. try again or choose another one.`
  String get compressionFailedDescription {
    return Intl.message(
      'we couldn\'t compress this video. try again or choose another one.',
      name: 'compressionFailedDescription',
      desc: '',
      args: [],
    );
  }

  /// `already optimized`
  String get alreadyOptimized {
    return Intl.message(
      'already optimized',
      name: 'alreadyOptimized',
      desc: '',
      args: [],
    );
  }

  /// `this video is already small. try lower quality or choose another one.`
  String get alreadyOptimizedDescription {
    return Intl.message(
      'this video is already small. try lower quality or choose another one.',
      name: 'alreadyOptimizedDescription',
      desc: '',
      args: [],
    );
  }

  /// `try again`
  String get tryAgain {
    return Intl.message('try again', name: 'tryAgain', desc: '', args: []);
  }

  /// `you saved {size}`
  String youSavedSize(String size) {
    return Intl.message(
      'you saved $size',
      name: 'youSavedSize',
      desc: '',
      args: [size],
    );
  }

  /// `share`
  String get share {
    return Intl.message('share', name: 'share', desc: '', args: []);
  }

  /// `compare`
  String get compareVideos {
    return Intl.message('compare', name: 'compareVideos', desc: '', args: []);
  }

  /// `before`
  String get originalVideo {
    return Intl.message('before', name: 'originalVideo', desc: '', args: []);
  }

  /// `after`
  String get compressedVideo {
    return Intl.message('after', name: 'compressedVideo', desc: '', args: []);
  }

  /// `preview unavailable`
  String get videoPreviewUnavailable {
    return Intl.message(
      'preview unavailable',
      name: 'videoPreviewUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message('save', name: 'save', desc: '', args: []);
  }

  /// `delete original`
  String get deleteOriginal {
    return Intl.message(
      'delete original',
      name: 'deleteOriginal',
      desc: '',
      args: [],
    );
  }

  /// `hold the button to delete originals`
  String get holdToDeleteOriginals {
    return Intl.message(
      'hold the button to delete originals',
      name: 'holdToDeleteOriginals',
      desc: '',
      args: [],
    );
  }

  /// `failed to share: {error}`
  String failedToShare(String error) {
    return Intl.message(
      'failed to share: $error',
      name: 'failedToShare',
      desc: '',
      args: [error],
    );
  }

  /// `saved {saved} video(s) and deleted {deleted} original(s)`
  String savedVideosAndDeletedOriginals(int saved, int deleted) {
    return Intl.message(
      'saved $saved video(s) and deleted $deleted original(s)',
      name: 'savedVideosAndDeletedOriginals',
      desc: '',
      args: [saved, deleted],
    );
  }

  /// `videos saved, but some originals could not be deleted: {error}`
  String savedButOriginalsNotDeleted(String error) {
    return Intl.message(
      'videos saved, but some originals could not be deleted: $error',
      name: 'savedButOriginalsNotDeleted',
      desc: '',
      args: [error],
    );
  }

  /// `waiting`
  String get waiting {
    return Intl.message('waiting', name: 'waiting', desc: '', args: []);
  }

  /// `failed`
  String get failed {
    return Intl.message('failed', name: 'failed', desc: '', args: []);
  }

  /// `video {current} of {total}`
  String videoProgress(int current, int total) {
    return Intl.message(
      'video $current of $total',
      name: 'videoProgress',
      desc: '',
      args: [current, total],
    );
  }

  /// `{completed} of {total} videos compressed`
  String videosCompressed(int completed, int total) {
    return Intl.message(
      '$completed of $total videos compressed',
      name: 'videosCompressed',
      desc: '',
      args: [completed, total],
    );
  }

  /// `{count, plural, =1{save 1 video} other{save {count} videos}}`
  String saveVideos(int count) {
    return Intl.plural(
      count,
      one: 'save 1 video',
      other: 'save $count videos',
      name: 'saveVideos',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{saved 1 video to gallery} other{saved {count} videos to gallery}}`
  String savedVideosToGallery(int count) {
    return Intl.plural(
      count,
      one: 'saved 1 video to gallery',
      other: 'saved $count videos to gallery',
      name: 'savedVideosToGallery',
      desc: '',
      args: [count],
    );
  }

  /// `failed to save: {error}`
  String failedToSave(String error) {
    return Intl.message(
      'failed to save: $error',
      name: 'failedToSave',
      desc: '',
      args: [error],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
