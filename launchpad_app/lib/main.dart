import 'package:catcher/catcher.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/routing/routes.dart';
import 'package:launchpad_app/src/utils/globals.dart';
import 'package:launchpad_app/src/utils/theme_provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

final _router =
    GoRouter(routes: $appRoutes, navigatorKey: Catcher.navigatorKey);

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if it's not on the web, windows or android, load the accent color
  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }

  setPathUrlStrategy();

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setSize(const Size(900, 600));
      await windowManager.setMinimumSize(const Size(400, 400));
      await windowManager.center();
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [ConsoleHandler()]);

  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["support@volantisdev.com"])
  ]);

  Catcher(
      rootWidget: const ProviderScope(
        child: MyApp(),
      ),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);

    return FluentApp.router(
        title: appTitle,
        themeMode: appTheme.mode,
        debugShowCheckedModeBanner: false,
        color: appTheme.color,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          accentColor: appTheme.color,
          visualDensity: VisualDensity.standard,
          focusTheme: FocusThemeData(
            glowFactor: is10footScreen() ? 2.0 : 0.0,
          ),
        ),
        theme: ThemeData(
          accentColor: appTheme.color,
          visualDensity: VisualDensity.standard,
          focusTheme: FocusThemeData(
            glowFactor: is10footScreen() ? 2.0 : 0.0,
          ),
        ),
        locale: appTheme.locale,
        builder: (context, child) {
          return Directionality(
            textDirection: appTheme.textDirection,
            child: NavigationPaneTheme(
              data: NavigationPaneThemeData(
                backgroundColor: appTheme.windowEffect !=
                        flutter_acrylic.WindowEffect.disabled
                    ? Colors.transparent
                    : null,
              ),
              child: child!,
            ),
          );
        },
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser);
  }
}
