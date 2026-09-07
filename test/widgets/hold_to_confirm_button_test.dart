import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/theme/app_colors.dart';
import 'package:minimo_video/theme/app_theme.dart';
import 'package:minimo_video/widgets/hold_to_confirm_button.dart';

void main() {
  testWidgets('settings variant owns its background while scaling', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: HoldToConfirmButton(
          label: 'clear cache',
          enabled: true,
          onTap: () {},
          onCompleted: () async {},
        ),
      ),
    );

    final backgrounds = tester.widgetList<DecoratedBox>(
      find.byType(DecoratedBox),
    );
    expect(
      backgrounds.any(
        (box) =>
            box.decoration is BoxDecoration &&
            (box.decoration as BoxDecoration).color ==
                LightModeColors.frameBackground,
      ),
      isTrue,
    );
  });

  testWidgets('hold progress slows down toward completion', (tester) async {
    var completed = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: HoldToConfirmButton(
          label: 'clear cache',
          enabled: true,
          onTap: () {},
          onCompleted: () async {
            completed++;
          },
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(HoldToConfirmButton)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 625));

    final clipRect = tester.widget<ClipRect>(find.byType(ClipRect));
    final earlyProgress = clipRect.clipper!.getClip(const Size(100, 10)).width;

    await tester.pump(const Duration(milliseconds: 1250));
    final lateClipRect = tester.widget<ClipRect>(find.byType(ClipRect));
    final lateProgress = lateClipRect.clipper!
        .getClip(const Size(100, 10))
        .width;

    expect(earlyProgress, greaterThan(25));
    expect(100 - lateProgress, lessThan(earlyProgress));
    expect(completed, 0);

    await tester.pump(const Duration(milliseconds: 624));
    expect(completed, 0);
    await tester.pump(const Duration(milliseconds: 20));
    expect(completed, 1);

    await gesture.up();
    await tester.pump();
  });
}
