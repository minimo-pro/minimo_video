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
}
