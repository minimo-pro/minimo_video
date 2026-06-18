import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../router/app_router.gr.dart';
import '../services/first_launch_service.dart';
import '../theme/app_theme.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.72, curve: Curves.easeOut),
    );
    _scale = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _openNextScreen();
  }

  Future<void> _openNextScreen() async {
    final results = await Future.wait([
      FirstLaunchService.shouldShowOnboarding(),
      Future<void>.delayed(const Duration(milliseconds: 1800)),
    ]);
    final shouldShowOnboarding = results.first as bool;

    if (mounted) {
      context.router.replace(
        shouldShowOnboarding ? const OnboardingRoute() : const StartRoute(),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final strings = S.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.asset(
                      'assets/logo/logo.png',
                      width: 112,
                      height: 112,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    strings.appName,
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 31,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: 38,
                    height: 3,
                    decoration: BoxDecoration(
                      color: theme.accentColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    strings.madeByKhlebobul,
                    style: TextStyle(
                      color: theme.secondaryTextColor,
                      fontSize: 17,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
