import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/dashboard.dart';

part 'routes.g.dart';

@TypedGoRoute<DashboardRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[],
)
class DashboardRoute extends GoRouteData {
  const DashboardRoute();

  @override
  Widget build(BuildContext context) => const DashboardPage();
}

// @TypedGoRoute<LoginRoute>(path: '/login')
// class LoginRoute extends GoRouteData {
//   const LoginRoute();

//   @override
//   Widget build(BuildContext context) => const LoginPage();
// }
