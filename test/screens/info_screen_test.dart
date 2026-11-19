import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:minimo_video/screens/info_screen.dart';
import 'package:minimo_video/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('About opens the Threads profile externally on a small screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'minimo',
      packageName: 'minimo',
      version: '1.2.0',
      buildNumber: '38',
      buildSignature: '',
    );
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    MethodCall? launched;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      launched = call;
      return true;
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('ru'),
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: const [
          S.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: const InfoScreen(),
      ),
    );
    await tester.pumpAndSettle();
    final threads = find.text('threads');
    expect(threads, findsOneWidget);
    await tester.ensureVisible(threads);
    await tester.pumpAndSettle();
    await tester.tap(threads);
    await tester.pumpAndSettle();
    expect(launched?.method, 'launch');
    final arguments = launched!.arguments as Map;
    expect(arguments['url'], 'https://www.threads.com/@khlebobul');
    expect(arguments['useSafariVC'], isFalse);
    expect(arguments['useWebView'], isFalse);
  });
}
