import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/presentation/widgets/compression_mode_switch.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:minimo_video/theme/app_theme.dart';

void main() {
  testWidgets('labels use the app font family', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: const [
          S.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: CompressionModeSwitch(
            value: CompressionOptionsMode.simple,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    TextStyle styleOf(String label) {
      return DefaultTextStyle.of(tester.element(find.text(label))).style;
    }

    expect(styleOf('simple').fontFamily, 'Pangolin');
    expect(styleOf('advanced').fontFamily, 'Pangolin');
  });
}
