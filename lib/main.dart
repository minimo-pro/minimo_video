import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

final _appRouter = AppRouter();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'minimo (video)',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _appRouter.config(),
    );
  }
}
