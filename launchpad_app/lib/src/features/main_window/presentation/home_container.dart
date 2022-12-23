import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/gen/assets.gen.dart';
import 'package:launchpad_app/src/features/dashboard/presentation/dashboard.dart';
import 'package:launchpad_app/src/features/main_window/presentation/main_drop_target.dart';
import 'package:launchpad_app/src/utils/globals.dart';
import 'package:launchpad_app/src/utils/theme_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_info/platform_info.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:state_persistence/state_persistence.dart';
import 'package:updat/updat_window_manager.dart';
import 'package:url_launcher/link.dart';
import 'package:window_manager/window_manager.dart';

import '../../settings/presentation/settings.dart';

import '../../../utils/theme.dart';

class HomeContainer extends StatefulHookConsumerWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  createState() => _HomeContainerState();
}

class _HomeContainerState extends ConsumerState<HomeContainer>
    with WindowListener, ProtocolListener {
  var value = false;

  var index = 0;

  final viewKey = GlobalKey();

  final searchKey = GlobalKey();
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  final originalItems = [
    PaneItem(
      icon: const Icon(FluentIcons.home),
      title: const Text('Dashboard'),
      body: const DashboardPage(),
    ),
    PaneItemHeader(header: const Text("Games")),
    // TODO Add links to the most recent 5 games edited, launched, or built
    PaneItem(
      icon: const Icon(FluentIcons.game),
      title: const Text('All Games'),
      body: const Text('To be replaced with a page widget.'),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.add),
      title: const Text('Add Game'),
      body: const Text('To be replaced with a page widget.'),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.search),
      title: const Text('Find Installed Games'),
      body: const Text('To be replaced with a page widget.'),
    ),
    PaneItemHeader(header: const Text("Game Platforms")),
    // TODO Add links to all enabled and installed game platforms here
    PaneItem(
      icon: const Icon(FluentIcons.library),
      title: const Text('All Platforms'),
      body: const Text('Show manage list for platform entities.'),
    ),
    // PaneItemHeader(header: const Icon(FluentIcons.archive)),
    // PaneItem(
    //   icon: const Icon(FluentIcons.lifesaver),
    //   title: const Text('All Backups'),
    //   body: const Text('.'),
    // ),
    // PaneItem(
    //   icon: const Icon(FluentIcons.archive),
    //   title: const Text('Add Backup'),
    //   body: const Text('.'),
    // ),
    // PaneItemHeader(header: const Text("Web Services")),
    // // TODO Add links to all enabled web services here
    // PaneItem(
    //   icon: const Icon(FluentIcons.globe),
    //   title: const Text('All Web Services'),
    //   body: const Text('Show manage list for platform entities.'),
    // ),
    // PaneItem(
    //   icon: const Icon(FluentIcons.o_d_link),
    //   title: const Text('Add Web Service'),
    //   body: const Text('.'),
    // ),
    // PaneItemHeader(header: const Icon(FluentIcons.puzzle)),
    // PaneItem(
    //   icon: const Icon(FluentIcons.puzzle),
    //   title: const Text('Modules'),
    //   body: const Text('.'),
    // ),
    // PaneItem(
    //   icon: const Icon(FluentIcons.download),
    //   title: const Text('Extend Launchpad'),
    //   body: const Text('.'),
    // ),
  ];
  final footerItems = [
    PaneItemSeparator(),
    PaneItem(
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: Settings(),
    ),
    _LinkPaneItemAction(
      icon: const Icon(FluentIcons.open_source),
      title: const Text('Source code'),
      link: 'https://github.com/VolantisDev/Launchpad/tree/flutter',
      body: const SizedBox.shrink(),
    ),
  ];

  @override
  dispose() {
    protocolHandler.removeListener(this);
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  initState() {
    protocolHandler.addListener(this);
    windowManager.addListener(this);
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
  }

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  void onProtocolUrlReceived(String url) {
    // TODO Handle protocol response
  }

  @override
  build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);

    return FutureBuilder<PackageInfo>(
        future: _getPackageInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Failed to initialize.");
          } else if (!snapshot.hasData) {
            return const ProgressRing();
          } else {
            final data = snapshot.data!;

            return UpdatWindowManager(
                appName: appTitle,
                currentVersion: data.version,
                getLatestVersion: () async {
                  final data = await http.get(Uri.parse(
                    "https://api.github.com/repos/VolantisDev/Launchpad/releases/latest",
                  ));

                  return jsonDecode(data.body)["tag_name"];
                },
                getBinaryUrl: (version) async {
                  var ext = Platform.instance.operatingSystem.name == 'windows'
                      ? 'exe'
                      : 'dmg';

                  return "https://github.com/VolantisDev/Launchpad/releases/download/$version/Launchpad-${Platform.instance.operatingSystem}-$version.$ext";
                },
                getChangelog: (_, __) async {
                  final data = await http.get(Uri.parse(
                    "https://api.github.com/repos/VolantisDev/Launchpad/releases/latest",
                  ));
                  return jsonDecode(data.body)["body"];
                },
                child: MainDropTarget(
                    child: NavigationView(
                  key: viewKey,
                  appBar: NavigationAppBar(
                    automaticallyImplyLeading: false,
                    title: () {
                      if (kIsWeb) {
                        return const Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(appTitle),
                        );
                      }
                      return const DragToMoveArea(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(appTitle),
                        ),
                      );
                    }(),
                    actions: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8.0),
                            child: ToggleSwitch(
                              content: const Text('Dark Mode'),
                              checked:
                                  FluentTheme.of(context).brightness.isDark,
                              onChanged: (v) {
                                appTheme.mode =
                                    v ? ThemeMode.dark : ThemeMode.light;
                              },
                            ),
                          ),
                          if (!kIsWeb) const WindowButtons(),
                        ]),
                  ),
                  pane: NavigationPane(
                    selected: index,
                    onChanged: (i) {
                      setState(() => index = i);
                    },
                    header: SizedBox(
                      height: kOneLineTileHeight + 5,
                      child: SvgPicture.asset(
                        FluentTheme.of(context).brightness.isDark
                            ? Assets.graphics.logoWide.path
                            : Assets.graphics.light.logoWide.path,
                        semanticsLabel: 'Launchpad',
                      ),
                    ),
                    displayMode: appTheme.displayMode,
                    indicator: () {
                      switch (appTheme.indicator) {
                        case NavigationIndicators.end:
                          return const EndNavigationIndicator();
                        case NavigationIndicators.sticky:
                        default:
                          return const StickyNavigationIndicator();
                      }
                    }(),
                    items: originalItems,
                    autoSuggestBox: AutoSuggestBox(
                      key: searchKey,
                      focusNode: searchFocusNode,
                      controller: searchController,
                      items: originalItems.whereType<PaneItem>().map((item) {
                        assert(item.title is Text);
                        final text = (item.title as Text).data!;

                        return AutoSuggestBoxItem(
                          label: text,
                          value: text,
                          onSelected: () async {
                            final itemIndex = NavigationPane(
                              items: originalItems,
                            ).effectiveIndexOf(item);

                            setState(() => index = itemIndex);
                            await Future.delayed(
                                const Duration(milliseconds: 17));
                            searchController.clear();
                          },
                        );
                      }).toList(),
                      placeholder: 'Search',
                    ),
                    autoSuggestBoxReplacement: const Icon(FluentIcons.search),
                    footerItems: footerItems,
                  ),
                  onOpenSearch: () {
                    searchFocusNode.requestFocus();
                  },
                )));
          }
        });
  }

  @override
  onWindowClose() async {
    var isPreventClose = await windowManager.isPreventClose();

    if (isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _LinkPaneItemAction extends PaneItem {
  _LinkPaneItemAction({
    required super.icon,
    required this.link,
    required super.body,
    super.title,
  });

  final String link;

  @override
  build(
    BuildContext context,
    bool selected,
    VoidCallback? onPressed, {
    PaneDisplayMode? displayMode,
    var showTextOnTop = true,
    bool? autofocus,
    int? itemIndex,
  }) {
    return Link(
      uri: Uri.parse(link),
      builder: (context, followLink) => super.build(
        context,
        selected,
        followLink,
        displayMode: displayMode,
        showTextOnTop: showTextOnTop,
        itemIndex: itemIndex,
        autofocus: autofocus,
      ),
    );
  }
}
