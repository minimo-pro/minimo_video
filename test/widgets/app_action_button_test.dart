import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/constants/app_icons.dart';
import 'package:minimo_video/theme/app_colors.dart';
import 'package:minimo_video/theme/app_theme.dart';
import 'package:minimo_video/widgets/app_action_button.dart';

void main() {
  testWidgets('disabled filled action keeps readable foreground', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Center(
          child: AppActionButton(
            label: 'compress',
            variant: AppActionButtonVariant.filled,
            onPressed: null,
          ),
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(
      button.style!.foregroundColor!.resolve({WidgetState.disabled}),
      LightModeColors.text.withValues(alpha: 0.72),
    );
  });

  for (final icon in [AppIcons.arrowBack, AppIcons.share, AppIcons.settings]) {
    testWidgets('icon-only action fits a 47px button: $icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Center(
            child: AppActionButton(
              width: 47,
              icon: icon,
              iconWidth: 24,
              iconHeight: 24,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(AppActionButton)), const Size(47, 47));
    });
  }
}
