import 'package:catcher/catcher.dart';
import 'package:go_router/go_router.dart';
import 'package:launchpad_app/src/routing/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  return GoRouter(
    routes: $appRoutes,
    navigatorKey: Catcher.navigatorKey,
  );
}
