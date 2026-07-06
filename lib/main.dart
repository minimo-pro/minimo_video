import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'router/app_router.dart';
import 'services/app_cache_service.dart';
import 'services/app_settings_service.dart';
import 'theme/app_theme.dart';

final _appRouter = AppRouter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettingsService.instance.load();
  await AppCacheService.clear().onError((_, _) {});
  runApp(const MainApp());
}

// TODO: Remove legacy CocoaPods integration and migrate fully to Swift Package Manager.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettingsService.instance,
      builder: (context, _) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        locale: AppSettingsService.instance.locale,
        onGenerateTitle: (context) => S.of(context).appName,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
