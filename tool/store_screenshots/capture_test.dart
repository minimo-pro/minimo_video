// Renders real app screens with demo data for the store screenshot editor.
//
//   flutter test tool/store_screenshots/capture_test.dart
//
// Output: store_screenshots/public/screenshots/<platform>/<device>/en/*.png
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/constants/app_icons.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/domain/compression_result.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_progress_view.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_result_view.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_settings_view.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:minimo_video/theme/app_theme.dart';
import 'package:minimo_video/widgets/app_action_button.dart';
import 'package:minimo_video/widgets/bottom_frame.dart';
import 'package:minimo_video/widgets/pressable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _root = 'store_screenshots/public';
const _mb = 1024 * 1024;

final _photos = [
  'beach',
  'dog',
  'birthday',
  'mountains',
  'concert',
].map((name) => File('$_root/photos/$name.jpg').absolute.path).toList();

enum _Chrome { iphone, android, ipad }

class _Device {
  final String folder;
  final Size physicalSize;
  final double pixelRatio;
  final EdgeInsets padding;
  final TargetPlatform platform;
  final _Chrome chrome;

  const _Device({
    required this.folder,
    required this.physicalSize,
    required this.pixelRatio,
    required this.padding,
    required this.platform,
    required this.chrome,
  });
}

const _devices = [
  _Device(
    folder: 'apple/iphone',
    physicalSize: Size(1320, 2868),
    pixelRatio: 3,
    padding: EdgeInsets.only(top: 62, bottom: 34),
    platform: TargetPlatform.iOS,
    chrome: _Chrome.iphone,
  ),
  _Device(
    folder: 'apple/ipad',
    physicalSize: Size(2064, 2752),
    pixelRatio: 2.5,
    padding: EdgeInsets.only(top: 32, bottom: 20),
    platform: TargetPlatform.iOS,
    chrome: _Chrome.ipad,
  ),
  _Device(
    folder: 'android/phone',
    physicalSize: Size(1080, 2416),
    pixelRatio: 2.625,
    padding: EdgeInsets.only(top: 36, bottom: 20),
    platform: TargetPlatform.android,
    chrome: _Chrome.android,
  ),
];

final _videos = [
  _video('summer_beach.MOV', 612, 0),
  _video('puppy_first_run.MOV', 438, 1),
  _video('lia_turns_5.MOV', 389, 2),
  _video('lake_hike_4k.MOV', 512, 3),
  _video('festival_night.MOV', 274, 4),
  _video('sunset_timelapse.MOV', 236, 0),
];

PickedVideo _video(String name, int sizeMb, int photo) => PickedVideo(
  path: _photos[photo],
  name: name,
  size: sizeMb * _mb,
  sourceIdentifier: 'photos-$name',
  canPreserveMetadata: true,
  canDeleteOriginal: true,
);

List<String?> get _thumbs => [for (final v in _videos) v.path];

CompressState _readyState({CompressionSettings? settings}) => CompressState(
  status: CompressStatus.ready,
  videos: _videos,
  thumbnailPaths: _thumbs,
  videoStatuses: List.filled(_videos.length, VideoCompressionStatus.waiting),
  results: const [],
  compressionRunId: 0,
  processingIndex: 0,
  progress: 0,
  elapsed: Duration.zero,
  settings: settings ?? const CompressionSettings(),
  estimatedSize: 612 * _mb,
  isSaving: false,
);

CompressState _processingState() => CompressState(
  status: CompressStatus.processing,
  videos: _videos,
  thumbnailPaths: _thumbs,
  videoStatuses: const [
    VideoCompressionStatus.compressed,
    VideoCompressionStatus.compressed,
    VideoCompressionStatus.processing,
    VideoCompressionStatus.waiting,
    VideoCompressionStatus.waiting,
    VideoCompressionStatus.waiting,
  ],
  results: [for (final v in _videos.take(2)) _compressed(v)],
  compressionRunId: 1,
  processingIndex: 2,
  progress: 0.42,
  currentVideoProgress: 0.64,
  elapsed: const Duration(seconds: 84),
  settings: const CompressionSettings(),
  estimatedSize: 612 * _mb,
  isSaving: false,
);

CompressState _doneState() => CompressState(
  status: CompressStatus.done,
  videos: _videos,
  thumbnailPaths: _thumbs,
  videoStatuses: List.filled(
    _videos.length,
    VideoCompressionStatus.compressed,
  ),
  results: [for (final v in _videos) _compressed(v)],
  compressionRunId: 1,
  processingIndex: _videos.length - 1,
  progress: 1,
  elapsed: const Duration(minutes: 3),
  settings: const CompressionSettings(),
  isSaving: false,
);

CompressedVideo _compressed(PickedVideo video) => CompressedVideo(
  source: video,
  result: CompressionResult(
    success: true,
    originalSize: video.size,
    outputSize: (video.size * 0.25).round(),
    outputPath: video.path,
  ),
);

final _captureKey = GlobalKey();

void main() {
  setUpAll(() async {
    // Runs under `flutter test`, but lives outside test/ so the regular suite skips it.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({
      'stats_compressed_videos': 248,
      'stats_saved_bytes': (18.4 * 1024 * _mb).round(),
    });
    final pangolin = FontLoader('Pangolin')
      ..addFont(rootBundle.load('assets/fonts/Pangolin-Regular.ttf'));
    await pangolin.load();
    final sf = FontLoader('StatusBar')
      ..addFont(
        Future.value(
          ByteData.sublistView(
            File('/System/Library/Fonts/SFNS.ttf').readAsBytesSync(),
          ),
        ),
      );
    await sf.load();
  });

  for (final device in _devices) {
    testWidgets('capture ${device.folder}', (tester) async {
      tester.view.physicalSize = device.physicalSize;
      tester.view.devicePixelRatio = device.pixelRatio;
      tester.view.padding = FakeViewPadding(
        top: device.padding.top * device.pixelRatio,
        bottom: device.padding.bottom * device.pixelRatio,
      );
      tester.view.viewPadding = tester.view.padding;
      debugDefaultTargetPlatformOverride = device.platform;
      addTearDown(tester.view.reset);

      final ios = device.platform == TargetPlatform.iOS;
      await _precacheImages(tester);

      await _shoot(
        tester,
        device,
        '01-settings',
        _CompressPage(
          child: CompressionSettingsView(
            state: _readyState(),
            onAddVideos: () {},
          ),
        ),
      );

      await _shoot(
        tester,
        device,
        '02-advanced',
        _CompressPage(
          child: CompressionSettingsView(
            state: _readyState(
              settings: const CompressionSettings(
                resolution: '1920:1080',
                videoBitrateMbps: 8,
                frameRate: 30,
                codec: CompressionCodec.hevc,
              ),
            ),
            onAddVideos: () {},
          ),
        ),
        interact: () async {
          await tester.tap(find.text('advanced'));
          await _settle(tester);
        },
      );

      await _shoot(
        tester,
        device,
        '03-progress',
        _CompressPage(
          showBack: false,
          child: CompressionProgressView(state: _processingState()),
        ),
      );

      await _shoot(
        tester,
        device,
        '04-result',
        _CompressPage(
          child: CompressionResultView(state: _doneState(), onTryAgain: () {}),
        ),
      );

      if (ios) {
        await _shoot(
          tester,
          device,
          '05-save-options',
          _CompressPage(
            child: CompressionResultView(
              state: _doneState(),
              onTryAgain: () {},
            ),
          ),
          interact: () async {
            await tester.tap(find.text('save'));
            await _settle(tester);
            await tester.tap(find.text('replace original'));
            await _settle(tester);
          },
        );
      }

      await _shoot(tester, device, '06-home', const _StartPage());

      await _shoot(
        tester,
        device,
        '07-stats',
        const _StartPage(),
        interact: () async {
          await tester.tap(
            find.byWidgetPredicate(
              (w) => w is SvgPicture && _svgAsset(w) == AppIcons.stats,
            ),
          );
          await _settle(tester, seconds: 3);
        },
      );

      await _shoot(
        tester,
        device,
        '08-home-dark',
        const _StartPage(),
        dark: true,
      );

      await _shoot(
        tester,
        device,
        '09-result-dark',
        _CompressPage(
          child: CompressionResultView(state: _doneState(), onTryAgain: () {}),
        ),
        dark: true,
      );

      debugDefaultTargetPlatformOverride = null;
    });
  }
}

String? _svgAsset(SvgPicture picture) {
  final loader = picture.bytesLoader;
  return loader is SvgAssetLoader ? loader.assetName : null;
}

/// Must run before any Image widget starts loading the same provider inside
/// the fake-async zone, otherwise precaching waits on that load forever.
Future<void> _precacheImages(WidgetTester tester) async {
  await tester.pumpWidget(const Directionality(
    textDirection: TextDirection.ltr,
    child: SizedBox(),
  ));
  final context = tester.element(find.byType(SizedBox));
  await tester.runAsync(() async {
    for (final path in _photos) {
      await precacheImage(FileImage(File(path)), context);
    }
    for (final asset in [
      'assets/images/background.png',
      'assets/images/background_dark.png',
    ]) {
      await precacheImage(AssetImage(asset), context);
    }
  });
}

Future<void> _settle(WidgetTester tester, {int seconds = 2}) async {
  for (var i = 0; i < seconds * 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _shoot(
  WidgetTester tester,
  _Device device,
  String name,
  Widget page, {
  bool dark = false,
  Future<void> Function()? interact,
}) async {
  final bloc = CompressBloc(videoCompressorAdapter: _NoopCompressor());

  await tester.pumpWidget(
    RepaintBoundary(
      key: _captureKey,
      child: BlocProvider.value(
        value: bloc,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _theme(AppTheme.light, device.platform),
          darkTheme: _theme(AppTheme.dark, device.platform),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('en'),
          builder: (context, child) => Stack(
            children: [
              child!,
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  type: MaterialType.transparency,
                  child: _StatusBar(chrome: device.chrome, page: page),
                ),
              ),
            ],
          ),
          home: page,
        ),
      ),
    ),
  );

  await _settle(tester);
  if (interact != null) await interact();
  await _settle(tester);

  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_captureKey),
  );
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: device.pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data!.buffer.asUint8List();
  });
  final file = File('$_root/screenshots/${device.folder}/en/$name.png');
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(bytes!);

  await tester.pumpWidget(const SizedBox());
  // Awaiting close() inside the fake-async zone never completes.
  bloc.close();
  await tester.pump();
}

ThemeData _theme(ThemeData base, TargetPlatform platform) =>
    base.copyWith(platform: platform);

class _CompressPage extends StatelessWidget {
  final Widget child;
  final bool showBack;

  const _CompressPage({required this.child, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
          child: Column(
            children: [
              if (showBack) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppActionButton(
                    width: 47,
                    icon: AppIcons.arrowBack,
                    iconWidth: 22,
                    iconHeight: 22,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartPage extends StatelessWidget {
  const _StartPage();

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final theme = AppTheme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              theme.isDarkTheme
                  ? 'assets/images/background_dark.png'
                  : 'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).appName,
                        style: materialTheme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Pressable(
                      child: Container(
                        width: 300,
                        height: 300,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.frameBackgroundColor.withValues(
                            alpha: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: theme.frameBorderColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppIcons.plus,
                            width: 56,
                            height: 56,
                            colorFilter: ColorFilter.mode(
                              theme.iconColor.withValues(alpha: 0.54),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: BottomFrame(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final _Chrome chrome;
  final Widget page;

  const _StatusBar({required this.chrome, required this.page});

  @override
  Widget build(BuildContext context) {
    final onPhoto = page is _StartPage;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = onPhoto || dark ? Colors.white : const Color(0xFF111111);
    final style = TextStyle(
      fontFamily: 'StatusBar',
      color: color,
      fontSize: switch (chrome) {
        _Chrome.iphone => 17,
        _Chrome.ipad => 14,
        _Chrome.android => 14,
      },
      fontWeight: FontWeight.w600,
      height: 1,
    );

    return switch (chrome) {
      _Chrome.iphone => SizedBox(
        height: 62,
        child: Stack(
          children: [
            Positioned(
              top: 11,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 126,
                  height: 37,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              width: 150,
              top: 21,
              child: Center(child: Text('9:41', style: style)),
            ),
            Positioned(
              right: 30,
              top: 22,
              child: _StatusIcons(color: color, scale: 1),
            ),
          ],
        ),
      ),
      _Chrome.ipad => SizedBox(
        height: 32,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 9, 22, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('9:41  Wed Oct 7', style: style),
              const Spacer(),
              _StatusIcons(color: color, scale: 0.85, cellular: false),
            ],
          ),
        ),
      ),
      _Chrome.android => SizedBox(
        height: 36,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('9:30', style: style),
              const Spacer(),
              _StatusIcons(color: color, scale: 0.85),
            ],
          ),
        ),
      ),
    };
  }
}

class _StatusIcons extends StatelessWidget {
  final Color color;
  final double scale;
  final bool cellular;

  const _StatusIcons({
    required this.color,
    required this.scale,
    this.cellular = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size((cellular ? 78 : 54) * scale, 13 * scale),
      painter: _StatusIconsPainter(color, scale, cellular),
    );
  }
}

class _StatusIconsPainter extends CustomPainter {
  final Color color;
  final double scale;
  final bool cellular;

  _StatusIconsPainter(this.color, this.scale, this.cellular);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(scale);
    final fill = Paint()..color = color;
    var x = 0.0;
    if (cellular) {
      for (var i = 0; i < 4; i++) {
        final h = 4.0 + i * 2.6;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + i * 4.6, 12 - h, 3.2, h),
            const Radius.circular(1),
          ),
          fill,
        );
      }
      x += 24;
    }
    final wifi = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.1
      ..strokeCap = StrokeCap.round;
    final center = Offset(x + 8.5, 12);
    for (final r in [3.5, 7.2, 10.8]) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        -2.36,
        1.57,
        false,
        wifi,
      );
    }
    canvas.drawCircle(center.translate(0, -0.6), 1.5, fill);
    x += 22;
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, 0.5, 25, 12),
      const Radius.circular(3.6),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 2, 2.5, 21, 8),
        const Radius.circular(2),
      ),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 26.2, 4.5, 1.6, 4),
        const Radius.circular(1),
      ),
      Paint()..color = color.withValues(alpha: 0.45),
    );
  }

  @override
  bool shouldRepaint(_StatusIconsPainter old) =>
      old.color != color || old.scale != scale;
}

class _NoopCompressor extends VideoCompressorAdapter {
  @override
  Future<int?> estimateCompressedSize(
    Iterable<String> inputPaths,
    CompressionSettings settings, {
    bool Function()? isCancelled,
  }) async => 0;

  @override
  Future<String?> createThumbnail(String inputPath) async => null;
}
