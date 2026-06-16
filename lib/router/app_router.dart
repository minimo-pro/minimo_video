import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: StartRoute.page, initial: true),
    AutoRoute(page: CompressRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: InfoRoute.page),
  ];
}
