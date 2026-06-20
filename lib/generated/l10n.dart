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

  /// `pick your videos`
  String get onboardingPickTitle {
    return Intl.message(
      'pick your videos',
      name: 'onboardingPickTitle',
      desc: '',
      args: [],
    );
  }

  /// `choose one or several videos you want to make smaller.`
  String get onboardingPickDescription {
    return Intl.message(
      'choose one or several videos you want to make smaller.',
      name: 'onboardingPickDescription',
      desc: '',
      args: [],
    );
  }

  /// `choose the balance`
  String get onboardingQualityTitle {
    return Intl.message(
      'choose the balance',
      name: 'onboardingQualityTitle',
      desc: '',
      args: [],
    );
  }

  /// `use simple presets or fine-tune quality, speed and resolution.`
  String get onboardingQualityDescription {
    return Intl.message(
      'use simple presets or fine-tune quality, speed and resolution.',
      name: 'onboardingQualityDescription',
      desc: '',
      args: [],
    );
  }

  /// `compress and save`
  String get onboardingSaveTitle {
    return Intl.message(
      'compress and save',
      name: 'onboardingSaveTitle',
      desc: '',
      args: [],
    );
  }

  /// `preview the estimated size, compress, then save the result to your gallery.`
  String get onboardingSaveDescription {
    return Intl.message(
      'preview the estimated size, compress, then save the result to your gallery.',
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

  /// `minimo (video) was born from a simple frustration. i love sports and often watch short match clips shared by clubs and telegram channels. even a few seconds of video can take up far more space than they should.\n\nthis project gives everyone a convenient and free way to compress videos directly on a mobile device, save storage and keep the moments that matter.`
  String get aboutStory {
    return Intl.message(
      'minimo (video) was born from a simple frustration. i love sports and often watch short match clips shared by clubs and telegram channels. even a few seconds of video can take up far more space than they should.\n\nthis project gives everyone a convenient and free way to compress videos directly on a mobile device, save storage and keep the moments that matter.',
      name: 'aboutStory',
      desc: '',
      args: [],
    );
  }

  /// `minimo (video) is open source. explore the code, follow the project or get in touch.`
  String get openSourceNote {
    return Intl.message(
      'minimo (video) is open source. explore the code, follow the project or get in touch.',
      name: 'openSourceNote',
      desc: '',
      args: [],
    );
  }

  /// `rate the app`
  String get rateTheApp {
    return Intl.message('rate the app', name: 'rateTheApp', desc: '', args: []);
  }

  /// `share with friends`
  String get shareWithFriends {
    return Intl.message(
      'share with friends',
      name: 'shareWithFriends',
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

  /// `telegram`
  String get telegram {
    return Intl.message('telegram', name: 'telegram', desc: '', args: []);
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

  /// `quality`
  String get quality {
    return Intl.message('quality', name: 'quality', desc: '', args: []);
  }

  /// `speed`
  String get speed {
    return Intl.message('speed', name: 'speed', desc: '', args: []);
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

  /// `ultra fast`
  String get ultraFast {
    return Intl.message('ultra fast', name: 'ultraFast', desc: '', args: []);
  }

  /// `fast`
  String get fast {
    return Intl.message('fast', name: 'fast', desc: '', args: []);
  }

  /// `slow`
  String get slow {
    return Intl.message('slow', name: 'slow', desc: '', args: []);
  }

  /// `very slow`
  String get verySlow {
    return Intl.message('very slow', name: 'verySlow', desc: '', args: []);
  }

  /// `lower CRF keeps more detail, higher CRF creates a smaller file`
  String get qualityDescription {
    return Intl.message(
      'lower CRF keeps more detail, higher CRF creates a smaller file',
      name: 'qualityDescription',
      desc: '',
      args: [],
    );
  }

  /// `slower encoding usually produces a smaller file at the same quality`
  String get speedDescription {
    return Intl.message(
      'slower encoding usually produces a smaller file at the same quality',
      name: 'speedDescription',
      desc: '',
      args: [],
    );
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

  /// `frame rate`
  String get frameRate {
    return Intl.message('frame rate', name: 'frameRate', desc: '', args: []);
  }

  /// `lower frame rate reduces size but can make motion less smooth`
  String get frameRateDescription {
    return Intl.message(
      'lower frame rate reduces size but can make motion less smooth',
      name: 'frameRateDescription',
      desc: '',
      args: [],
    );
  }

  /// `video codec`
  String get videoCodec {
    return Intl.message('video codec', name: 'videoCodec', desc: '', args: []);
  }

  /// `choose compatibility or better compression`
  String get videoCodecDescription {
    return Intl.message(
      'choose compatibility or better compression',
      name: 'videoCodecDescription',
      desc: '',
      args: [],
    );
  }

  /// `most compatible`
  String get mostCompatible {
    return Intl.message(
      'most compatible',
      name: 'mostCompatible',
      desc: '',
      args: [],
    );
  }

  /// `smaller, newer devices`
  String get smallerNewerDevices {
    return Intl.message(
      'smaller, newer devices',
      name: 'smallerNewerDevices',
      desc: '',
      args: [],
    );
  }

  /// `audio`
  String get audio {
    return Intl.message('audio', name: 'audio', desc: '', args: []);
  }

  /// `stereo sounds best; mono or no audio saves more space`
  String get audioDescription {
    return Intl.message(
      'stereo sounds best; mono or no audio saves more space',
      name: 'audioDescription',
      desc: '',
      args: [],
    );
  }

  /// `stereo`
  String get stereo {
    return Intl.message('stereo', name: 'stereo', desc: '', args: []);
  }

  /// `mono`
  String get mono {
    return Intl.message('mono', name: 'mono', desc: '', args: []);
  }

  /// `no audio`
  String get noAudio {
    return Intl.message('no audio', name: 'noAudio', desc: '', args: []);
  }

  /// `additional options`
  String get additionalOptions {
    return Intl.message(
      'additional options',
      name: 'additionalOptions',
      desc: '',
      args: [],
    );
  }

  /// `two-pass encoding`
  String get twoPassEncoding {
    return Intl.message(
      'two-pass encoding',
      name: 'twoPassEncoding',
      desc: '',
      args: [],
    );
  }

  /// `better compression, but takes significantly longer`
  String get twoPassEncodingDescription {
    return Intl.message(
      'better compression, but takes significantly longer',
      name: 'twoPassEncodingDescription',
      desc: '',
      args: [],
    );
  }

  /// `noise reduction`
  String get noiseReduction {
    return Intl.message(
      'noise reduction',
      name: 'noiseReduction',
      desc: '',
      args: [],
    );
  }

  /// `smooths visual noise before encoding`
  String get noiseReductionDescription {
    return Intl.message(
      'smooths visual noise before encoding',
      name: 'noiseReductionDescription',
      desc: '',
      args: [],
    );
  }

  /// `optimize for streaming`
  String get optimizeForStreaming {
    return Intl.message(
      'optimize for streaming',
      name: 'optimizeForStreaming',
      desc: '',
      args: [],
    );
  }

  /// `allows playback to start before the file fully downloads`
  String get optimizeForStreamingDescription {
    return Intl.message(
      'allows playback to start before the file fully downloads',
      name: 'optimizeForStreamingDescription',
      desc: '',
      args: [],
    );
  }

  /// `preserve metadata`
  String get preserveMetadata {
    return Intl.message(
      'preserve metadata',
      name: 'preserveMetadata',
      desc: '',
      args: [],
    );
  }

  /// `keeps available creation and video information`
  String get preserveMetadataDescription {
    return Intl.message(
      'keeps available creation and video information',
      name: 'preserveMetadataDescription',
      desc: '',
      args: [],
    );
  }

  /// `hardware acceleration`
  String get hardwareAcceleration {
    return Intl.message(
      'hardware acceleration',
      name: 'hardwareAcceleration',
      desc: '',
      args: [],
    );
  }

  /// `uses the device encoder for faster processing`
  String get hardwareAccelerationDescription {
    return Intl.message(
      'uses the device encoder for faster processing',
      name: 'hardwareAccelerationDescription',
      desc: '',
      args: [],
    );
  }

  /// `original`
  String get original {
    return Intl.message('original', name: 'original', desc: '', args: []);
  }

  /// `compressed`
  String get compressed {
    return Intl.message('compressed', name: 'compressed', desc: '', args: []);
  }

  /// `simple options`
  String get simpleOptions {
    return Intl.message(
      'simple options',
      name: 'simpleOptions',
      desc: '',
      args: [],
    );
  }

  /// `advanced options`
  String get advancedOptions {
    return Intl.message(
      'advanced options',
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

  /// `loading videos...`
  String get loadingVideos {
    return Intl.message(
      'loading videos...',
      name: 'loadingVideos',
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

  /// `compress other videos`
  String get compressOtherVideos {
    return Intl.message(
      'compress other videos',
      name: 'compressOtherVideos',
      desc: '',
      args: [],
    );
  }

  /// `failed`
  String get failed {
    return Intl.message('failed', name: 'failed', desc: '', args: []);
  }

  /// `CRF {value}`
  String crfValue(int value) {
    return Intl.message(
      'CRF $value',
      name: 'crfValue',
      desc: '',
      args: [value],
    );
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
