import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/generated/l10n.dart';
import 'package:minimo_video/router/app_router.gr.dart';
import 'package:minimo_video/screens/onboarding_screen.dart';
import 'package:minimo_video/services/first_launch_service.dart';
import 'package:minimo_video/theme/app_theme.dart';
import 'package:minimo_video/widgets/app_action_button.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: OnboardingRoute.page, initial: true),
    AutoRoute(
      page: PageInfo(
        StartRoute.name,
        builder: (_) => const Scaffold(body: Text('start destination')),
      ),
    ),
  ];
}

Widget _app({
  String locale = 'en',
  bool dark = false,
  bool reduceMotion = false,
  double textScale = 1,
  RootStackRouter? router,
}) {
  Widget builder(BuildContext context, Widget? child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      disableAnimations: reduceMotion,
      textScaler: TextScaler.linear(textScale),
    ),
    child: child!,
  );
  const delegates = <LocalizationsDelegate<dynamic>>[
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  if (router != null) {
    return MaterialApp.router(
      routerConfig: router.config(),
      locale: Locale(locale),
      localizationsDelegates: delegates,
      supportedLocales: S.delegate.supportedLocales,
      theme: dark ? AppTheme.dark : AppTheme.light,
      builder: builder,
    );
  }
  return MaterialApp(
    locale: Locale(locale),
    localizationsDelegates: delegates,
    supportedLocales: S.delegate.supportedLocales,
    theme: dark ? AppTheme.dark : AppTheme.light,
    builder: builder,
    home: const OnboardingScreen(),
  );
}

Finder get _next => find.byWidgetPredicate(
  (widget) =>
      widget is AppActionButton &&
      widget.variant == AppActionButtonVariant.filled,
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'minimo',
      packageName: 'minimo',
      version: '1.2.0',
      buildNumber: '38',
      buildSignature: '',
    );
  });

  testWidgets('next, swipe back and finish preserve first-launch state', (
    tester,
  ) async {
    final router = _Router();
    addTearDown(router.dispose);
    await tester.pumpWidget(_app(router: router));
    await tester.pumpAndSettle();
    expect(find.text('01 / 03'), findsOneWidget);
    expect(await FirstLaunchService.shouldShowOnboarding(), isTrue);
    await tester.tap(_next);
    await tester.pumpAndSettle();
    expect(find.text('02 / 03'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('01 / 03'), findsOneWidget);
    for (var i = 0; i < 2; i++) {
      await tester.tap(_next);
      await tester.pumpAndSettle();
    }
    expect(find.text('03 / 03'), findsOneWidget);
    expect(find.text(S.current.getStarted), findsOneWidget);
    await tester.tap(_next);
    await tester.pumpAndSettle();
    expect(find.text('start destination'), findsOneWidget);
    expect(await FirstLaunchService.shouldShowOnboarding(), isFalse);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('last_seen_version'), '1.2.0');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'components fade and rise in sequence, including page transitions',
    (tester) async {
      double opacity(int page, String part) => tester
          .widget<Opacity>(
            find
                .descendant(
                  of: find.byKey(ValueKey('onboarding-$page-$part')),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity;

      await tester.pumpWidget(_app());
      await tester.pump(const Duration(milliseconds: 140));
      expect(opacity(0, 'artwork'), greaterThan(opacity(0, 'description')));
      final lift = tester.widget<Transform>(
        find
            .descendant(
              of: find.byKey(const ValueKey('onboarding-0-title')),
              matching: find.byType(Transform),
            )
            .first,
      );
      expect(lift.transform.getTranslation().y, greaterThan(0));
      await tester.pumpAndSettle();
      expect(opacity(0, 'description'), 1);
      final controller = tester
          .widget<PageView>(find.byType(PageView))
          .controller!;
      controller.jumpTo(controller.position.viewportDimension / 2);
      await tester.pump();
      expect(opacity(1, 'title'), inExclusiveRange(0, 1));
      expect(opacity(1, 'artwork'), greaterThan(opacity(1, 'description')));
      controller.jumpToPage(1);
      await tester.pumpAndSettle();
      expect(opacity(1, 'description'), 1);
      expect(tester.takeException(), isNull);
    },
  );

  for (final reduced in [false, true]) {
    testWidgets('next and start icons follow their labels, reduced=$reduced', (
      tester,
    ) async {
      await tester.pumpWidget(_app(reduceMotion: reduced));
      await tester.pumpAndSettle();
      for (var page = 0; page < 3; page++) {
        final label = find.descendant(of: _next, matching: find.byType(Text));
        final icon = find.descendant(
          of: _next,
          matching: find.byType(SvgPicture),
        );
        expect(
          tester.getRect(icon).left,
          greaterThan(tester.getRect(label).right),
        );
        if (page < 2) {
          await tester.tap(_next);
          await tester.pumpAndSettle();
        }
      }
      if (reduced) {
        final fades = tester.widgetList<Opacity>(
          find.descendant(
            of: find.byType(PageView),
            matching: find.byType(Opacity),
          ),
        );
        expect(fades, isNotEmpty);
        expect(fades.every((fade) => fade.opacity == 1), isTrue);
      }
    });
  }

  testWidgets('progress segments follow a swipe and reverse on return', (
    tester,
  ) async {
    double progress(int index) => tester
        .widget<LinearProgressIndicator>(
          find.byKey(ValueKey('onboarding-progress-$index')),
        )
        .value!;
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect([progress(0), progress(1), progress(2)], [1, 0, 0]);
    final controller = tester
        .widget<PageView>(find.byType(PageView))
        .controller!;
    controller.jumpTo(controller.position.viewportDimension / 2);
    await tester.pump();
    expect(progress(1), closeTo(0.5, 0.001));
    controller.jumpToPage(2);
    await tester.pumpAndSettle();
    expect([progress(0), progress(1), progress(2)], [1, 1, 1]);
    controller.jumpToPage(0);
    await tester.pumpAndSettle();
    expect([progress(0), progress(1), progress(2)], [1, 0, 0]);
  });

  testWidgets('skip completes onboarding with reduced motion', (tester) async {
    final router = _Router();
    addTearDown(router.dispose);
    await tester.pumpWidget(_app(router: router, reduceMotion: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.skip));
    await tester.pumpAndSettle();
    expect(find.text('start destination'), findsOneWidget);
    expect(await FirstLaunchService.shouldShowOnboarding(), isFalse);
  });

  for (final locale in S.delegate.supportedLocales) {
    for (final dark in [false, true]) {
      testWidgets('all steps fit small screen: $locale, dark=$dark', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          _app(
            locale: locale.languageCode,
            dark: dark,
            reduceMotion: true,
            textScale: 1.6,
          ),
        );
        await tester.pumpAndSettle();
        for (var step = 0; step < 3; step++) {
          expect(tester.takeException(), isNull);
          expect(tester.getRect(_next).bottom, lessThanOrEqualTo(568));
          if (step < 2) {
            await tester.tap(_next);
            await tester.pump();
            expect(find.text('0${step + 2} / 03'), findsOneWidget);
            await tester.pumpAndSettle();
          }
        }
      });
    }
  }
}
