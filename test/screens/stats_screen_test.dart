import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:minimo_video/screens/stats_screen.dart';
import 'package:minimo_video/widgets/bottom_frame.dart';
import 'package:minimo_video/widgets/app_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const channel = MethodChannel('dev.fluttercommunity.plus/share');

  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets('statistics sheet fits with bottom clearance at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(bottom: 34);
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(
        _app('ru', home: const Scaffold(body: BottomFrame())),
      );
      await tester.tap(
        find
            .descendant(
              of: find.byType(BottomFrame),
              matching: find.byType(InkWell),
            )
            .at(1),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final button = tester.getRect(find.byType(AppActionButton));
      final screen = tester.getRect(find.byType(StatsScreen));
      expect(button.left, greaterThanOrEqualTo(screen.left + 20));
      expect(button.right, lessThanOrEqualTo(screen.right - 20));
      expect(button.bottom, lessThanOrEqualTo(size.height - 34 - 24));
      expect(
        tester.widget<AppActionButton>(find.byType(AppActionButton)).variant,
        AppActionButtonVariant.filled,
      );
    });
  }

  for (final locale in ['en', 'ru']) {
    for (final count in [0, 12]) {
      testWidgets('shares stored totals in $locale ($count videos)', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({
          'stats_compressed_videos': count,
          'stats_saved_bytes': count == 0 ? 0 : 1610612736,
        });
        MethodCall? shared;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          (call) async {
            shared = call;
            return 'social.app';
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            channel,
            null,
          ),
        );

        await tester.pumpWidget(_app(locale));
        await tester.pumpAndSettle();
        await tester.tap(find.text(locale == 'ru' ? 'поделиться' : 'share'));
        await tester.pumpAndSettle();

        expect(shared?.method, 'share');
        final args = shared!.arguments as Map;
        final size = count == 0 ? '0 B' : '1.5 GB';
        expect(
          args['text'],
          locale == 'ru'
              ? 'Мой результат с minimo (video) 🎬\nВидео сжато: $count\nОсвобождено места: $size\n\nПопробуй minimo и освободи место на телефоне: https://minimo-video.vercel.app'
              : 'My results with minimo (video) 🎬\nVideos compressed: $count\nSpace saved: $size\n\nTry minimo and free up space on your phone: https://minimo-video.vercel.app',
        );
        expect(args['originWidth'], greaterThan(0));
        expect(args['originHeight'], greaterThan(0));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('shows a message when sharing fails', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => throw PlatformException(code: 'unavailable'),
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );

    await tester.pumpWidget(_app('en'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('share'));
    await tester.pumpAndSettle();
    expect(
      find.text("couldn't share the statistics. try again"),
      findsOneWidget,
    );
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });
}

Widget _app(String locale, {Widget home = const StatsScreen()}) => MaterialApp(
  locale: Locale(locale),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: home,
);
