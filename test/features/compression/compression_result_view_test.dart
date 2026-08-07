import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/constants/app_icons.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/domain/compression_result.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_result_view.dart';
import 'package:minimo_video/generated/l10n.dart';
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
  });
}

void _noop() {}
