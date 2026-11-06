import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/presentation/widgets/selected_videos_preview.dart';
import 'package:minimo_video/theme/app_colors.dart';
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

  testWidgets('three-digit count stays on one line inside badge', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SelectedVideosPreview(
          selectedCount: 104,
          thumbnailPaths: [null, null, null],
        ),
      ),
    );

    final badge = find.widgetWithText(Container, '104');
    final count = find.text('104');
    final paragraph = tester.renderObject<RenderParagraph>(count);

    expect(
      paragraph.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 3),
      ),
      hasLength(1),
    );
    expect(
      tester.getRect(badge).contains(tester.getRect(count).center),
      isTrue,
    );
  });

  testWidgets('shows an HDR badge on HDR thumbnails', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SelectedVideosPreview(
          selectedCount: 2,
          thumbnailPaths: [null, null],
          hdrFlags: [true, false],
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('video-preview-hdr-badge')),
      findsOneWidget,
    );
    expect(find.text('HDR'), findsOneWidget);
    final badge = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('video-preview-hdr-badge')),
    );
    expect((badge.decoration as BoxDecoration).color, CompressionUiColors.red);
    expect(tester.widget<Text>(find.text('HDR')).style!.fontSize, 11);
  });
}
