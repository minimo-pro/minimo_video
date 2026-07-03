import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/presentation/widgets/selected_videos_preview.dart';
import 'package:minimo_video/theme/app_theme.dart';

void main() {
  testWidgets('preview border stays white in light mode', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const SelectedVideosPreview(
          selectedCount: 1,
          thumbnailPaths: [null],
        ),
      ),
    );

    final container = tester
        .widgetList<Container>(find.byType(Container))
        .firstWhere((widget) => widget.foregroundDecoration is BoxDecoration);
    final decoration = container.foregroundDecoration! as BoxDecoration;
    expect((decoration.border! as Border).top.color, Colors.white);
  });
}
