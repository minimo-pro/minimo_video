import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimo_video/constants/app_icons.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/domain/compression_result.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_result_view.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:minimo_video/widgets/animated_asset_checkbox.dart';
import 'package:minimo_video/widgets/app_action_button.dart';

void main() {
  testWidgets('result actions are VS, save, then share', (tester) async {
    const source = PickedVideo(
      path: '/video.mp4',
      name: 'video.mp4',
      size: 100,
    );
    const state = CompressState(
      status: CompressStatus.done,
      videos: [source],
      thumbnailPaths: [null],
      videoStatuses: [VideoCompressionStatus.compressed],
      results: [
        CompressedVideo(
          source: source,
          result: CompressionResult(
            success: true,
            originalSize: 100,
            outputSize: 40,
            outputPath: '/small.mp4',
          ),
        ),
      ],
      compressionRunId: 1,
      processingIndex: 0,
      progress: 1,
      elapsed: Duration.zero,
      settings: CompressionSettings(),
      isSaving: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(
          body: CompressionResultView(state: state, onTryAgain: _noop),
        ),
      ),
    );

    final vs = find.text('VS');
    final save = find.text('save');
    final share = find.byWidgetPredicate(
      (widget) => widget is AppActionButton && widget.icon == AppIcons.share,
    );

    expect(tester.getCenter(vs).dx, lessThan(tester.getCenter(save).dx));
    expect(tester.getCenter(save).dx, lessThan(tester.getCenter(share).dx));
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Tooltip && widget.message == 'share or save to…',
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows notice when requested HEVC falls back to H.264', (
    tester,
  ) async {
    const source = PickedVideo(
      path: '/video.mp4',
      name: 'video.mp4',
      size: 100,
    );
    const state = CompressState(
      status: CompressStatus.done,
      videos: [source],
      thumbnailPaths: [null],
      videoStatuses: [VideoCompressionStatus.compressed],
      results: [
        CompressedVideo(
          source: source,
          result: CompressionResult(
            success: true,
            originalSize: 100,
            outputSize: 40,
            outputPath: '/small.mp4',
            usedCodec: CompressionCodec.h264,
          ),
        ),
      ],
      compressionRunId: 1,
      processingIndex: 0,
      progress: 1,
      elapsed: Duration.zero,
      settings: CompressionSettings(codec: CompressionCodec.hevc),
      isSaving: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(
          body: CompressionResultView(state: state, onTryAgain: _noop),
        ),
      ),
    );

    expect(
      find.text("HEVC wasn't available, so this video was saved as H.264"),
      findsOneWidget,
    );
  });

  testWidgets('save skips the options sheet on Android', (tester) async {
    const source = PickedVideo(
      path: '/video.mp4',
      name: 'video.mp4',
      size: 100,
      sourceIdentifier: 'photos-id',
      canDeleteOriginal: true,
    );
    const state = CompressState(
      status: CompressStatus.done,
      videos: [source],
      thumbnailPaths: [null],
      videoStatuses: [VideoCompressionStatus.compressed],
      results: [
        CompressedVideo(
          source: source,
          result: CompressionResult(
            success: true,
            originalSize: 100,
            outputSize: 40,
            outputPath: '/small.mp4',
          ),
        ),
      ],
      compressionRunId: 1,
      processingIndex: 0,
      progress: 1,
      elapsed: Duration.zero,
      settings: CompressionSettings(),
      isSaving: false,
    );

    final bloc = CompressBloc(videoCompressorAdapter: _NoopCompressor());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider.value(
          value: bloc,
          child: const Scaffold(
            body: CompressionResultView(state: state, onTryAgain: _noop),
          ),
        ),
      ),
    );

    await tester.tap(find.text('save'));
    await tester.pumpAndSettle();

    expect(find.text('save as new'), findsNothing);
    expect(find.byType(AnimatedAssetCheckbox), findsNothing);
  });

  testWidgets('saved action shows checkmark and stays disabled', (
    tester,
  ) async {
    const source = PickedVideo(
      path: '/video.mp4',
      name: 'video.mp4',
      size: 100,
    );
    const state = CompressState(
      status: CompressStatus.done,
      videos: [source],
      thumbnailPaths: [null],
      videoStatuses: [VideoCompressionStatus.compressed],
      results: [
        CompressedVideo(
          source: source,
          result: CompressionResult(
            success: true,
            originalSize: 100,
            outputSize: 40,
            outputPath: '/small.mp4',
          ),
        ),
      ],
      compressionRunId: 1,
      processingIndex: 0,
      progress: 1,
      elapsed: Duration.zero,
      settings: CompressionSettings(),
      isSaving: false,
      isSaved: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(
          body: CompressionResultView(state: state, onTryAgain: _noop),
        ),
      ),
    );

    final action = tester.widget<AppActionButton>(
      find.byWidgetPredicate(
        (widget) => widget is AppActionButton && widget.label == 'saved',
      ),
    );
    expect(action.icon, AppIcons.check);
    expect(action.onPressed, isNull);
  });
}

void _noop() {}

class _NoopCompressor extends VideoCompressorAdapter {
  @override
  Future<int?> estimateCompressedSize(
    Iterable<String> inputPaths,
    CompressionSettings settings,
  ) async => 0;

  @override
  Future<String?> createThumbnail(String inputPath) async => null;
}
