import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:launchpad_app/src/common_widgets/home_container.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HomeContainer();
}

// @TypedGoRoute<LoginRoute>(path: '/login')
// class LoginRoute extends GoRouteData {
//   const LoginRoute();

//   @override
//   Widget build(BuildContext context) => const LoginPage();
// }
