import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';
import 'package:minimo_video/features/compression/presentation/widgets/video_status_list.dart';
import 'package:minimo_video/theme/app_colors.dart';

void main() {
  testWidgets('current video shows right-aligned red progress', (tester) async {
    final state =
        CompressState.initial(const [
          PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 100),
        ]).copyWith(
          videoStatuses: const [VideoCompressionStatus.processing],
          currentVideoProgress: 0.42,
        );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: VideoStatusList(state: state)),
      ),
    );

    expect(
      find.ancestor(
        of: find.byKey(const ValueKey('video-status-processing')),
        matching: find.byType(ScaleTransition),
      ),
      findsNothing,
    );
    final indicator = tester.widget<SizedBox>(
      find.byKey(const ValueKey('video-status-processing')),
    );
    final text = indicator.child! as Text;
    expect(text.data, '42%');
    expect(text.textAlign, TextAlign.right);
    expect(text.style?.color, CompressionUiColors.red);
  });
}
