import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.custom(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    duration: const Duration(milliseconds: 420),
    reverseDuration: const Duration(milliseconds: 320),
    opaque: true,
  );

  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      page: SplashRoute.page,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 220),
    ),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: StartRoute.page),
    AutoRoute(page: CompressRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: InfoRoute.page),
  ];
}
