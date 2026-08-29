import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/presentation/widgets/selected_videos_preview.dart';
import 'package:minimo_video/theme/app_theme.dart';
import 'package:minimo_video/widgets/minimo_loader.dart';

void main() {
  testWidgets('preview border stays white in light mode', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const SelectedVideosPreview(
          selectedCount: 1,
          thumbnailPaths: [null],
          loadingThumbnails: true,
        ),
      ),
    );

    final container = tester
        .widgetList<Container>(find.byType(Container))
        .firstWhere((widget) => widget.foregroundDecoration is BoxDecoration);
    final decoration = container.foregroundDecoration! as BoxDecoration;
    expect((decoration.border! as Border).top.color, Colors.white);
    expect(find.byType(MinimoLoader), findsOneWidget);
  });

  testWidgets('selected count badge stays inside preview top edge', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SelectedVideosPreview(
          selectedCount: 2,
          thumbnailPaths: [null, null],
        ),
      ),
    );

    final previewTop = tester.getTopLeft(find.byType(SelectedVideosPreview)).dy;
    final badgeTop = tester.getTopLeft(find.widgetWithText(Container, '2')).dy;

    expect(badgeTop, greaterThanOrEqualTo(previewTop));
    expect(
      find.byKey(const ValueKey('video-preview-unavailable')),
      findsNWidgets(2),
    );
  });
}
