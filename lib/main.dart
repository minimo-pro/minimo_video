import 'package:flutter/material.dart';

import 'screens/start_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'minimo (video)',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const StartPage(),
    );
  }
}
