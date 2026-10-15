import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/domain/compression_result.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_comparison_sheet.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

const _result = CompressedVideo(
  source: PickedVideo(path: '/original.mp4', name: 'original.mp4', size: 100),
  result: CompressionResult(
    success: true,
    outputPath: '/compressed.mp4',
    outputSize: 40,
  ),
);

void main() {
  for (final size in [const Size(1920, 1080), const Size(1080, 1920)]) {
    testWidgets('overlay stays aligned when revealing $size', (tester) async {
      final oldPlatform = VideoPlayerPlatform.instance;
      VideoPlayerPlatform.instance = _FakeVideoPlatform(size);
      addTearDown(() => VideoPlayerPlatform.instance = oldPlatform);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const Scaffold(
            body: CompressionComparisonSheet(results: [_result]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final reveal = find.byKey(const ValueKey('comparison-reveal'));
      final clip = find.byKey(const ValueKey('comparison-result-clip'));
      final viewport = tester.getRect(reveal);
      final videos = find.byType(VideoPlayer);
      expect(videos, findsNWidgets(2));
      final bounds = [
        tester.getRect(videos.at(0)),
        tester.getRect(videos.at(1)),
      ];
      expect(bounds[0], bounds[1]);
      final aspect = tester.widget<AspectRatio>(
        find.ancestor(of: reveal, matching: find.byType(AspectRatio)).first,
      );
      expect(aspect.aspectRatio, size.aspectRatio);

      Rect revealedRect() =>
          tester.widget<ClipRect>(clip).clipper!.getClip(viewport.size);
      expect(revealedRect().left, closeTo(viewport.width / 2, 0.01));

      await tester.dragFrom(viewport.center, Offset(-viewport.width * 0.25, 0));
      await tester.pump();
      expect(revealedRect().left, closeTo(viewport.width * 0.25, 0.01));
      expect(tester.getRect(videos.at(0)), bounds[0]);
      expect(tester.getRect(videos.at(1)), bounds[1]);

      final slider = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.slider == true,
        ),
      );
      slider.properties.onIncrease!();
      await tester.pump();
      expect(revealedRect().left, closeTo(viewport.width * 0.15, 0.01));

      await tester.dragFrom(viewport.center, Offset(-viewport.width, 0));
      await tester.pump();
      expect(revealedRect(), Offset.zero & viewport.size);
      await tester.dragFrom(viewport.center, Offset(viewport.width, 0));
      await tester.pump();
      expect(revealedRect().width, 0);

      await tester.tapAt(
        Offset(viewport.left + viewport.width * 0.75, viewport.center.dy),
      );
      await tester.pump();
      expect(revealedRect().left, closeTo(viewport.width * 0.75, 0.01));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
  }
}

class _FakeVideoPlatform extends VideoPlayerPlatform {
  _FakeVideoPlatform(this.size);
  final Size size;
  var _nextId = 0;

  @override
  Future<void> init() async {}
  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async =>
      ++_nextId;
  @override
  Stream<VideoEvent> videoEventsFor(int playerId) => Stream.value(
    VideoEvent(
      eventType: VideoEventType.initialized,
      duration: const Duration(seconds: 10),
      size: playerId == 1 ? size : size / 2,
    ),
  );
  @override
  Future<void> dispose(int playerId) async {}
  @override
  Future<void> setLooping(int playerId, bool looping) async {}
  @override
  Future<void> setVolume(int playerId, double volume) async {}
  @override
  Future<void> pause(int playerId) async {}
  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async {}
  @override
  Widget buildViewWithOptions(VideoViewOptions options) =>
      ColoredBox(color: options.playerId == 1 ? Colors.blue : Colors.red);
}
