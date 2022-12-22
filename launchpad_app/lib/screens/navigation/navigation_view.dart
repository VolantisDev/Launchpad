import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/common_widgets/card_highlight.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../src/common_widgets/page.dart';

class NavigationViewPage extends StatefulHookConsumerWidget {
  const NavigationViewPage({Key? key}) : super(key: key);

  @override
  createState() => _NavigationViewPageState();
}

class _NavigationViewPageState extends ConsumerState<NavigationViewPage>
    with PageMixin {
  static const itemHeight = 300.0;

  var topIndex = 0;

  PaneDisplayMode displayMode = PaneDisplayMode.open;
  var pageTransition = 'default';
  static const pageTransitions = [
    'default',
    'entrance',
    'drill in',
    'horizontal',
  ];

  @override
  build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('NavigationView')),
      children: [
        const Text(
          'The NavigationView control provides top-level navigation for your app. '
          'It adapts to a variety of screen sizes and supports both top and left '
          'navigation styles.',
        ),
        const SizedBox(height: 10.0),
        ...buildDisplayMode(
          PaneDisplayMode.top,
          'Top display mode',
          'The pane is positioned above the content.',
        ),
        ...buildDisplayMode(
          PaneDisplayMode.open,
          'Open display mode',
          'The pane is expanded and positioned to the left of the content.',
        ),
        ...buildDisplayMode(
          PaneDisplayMode.compact,
          'Compact display mode',
          'The pane shows only icons until opened and is positioned to the left '
              'of the content. When opened, the pane overlays the content.',
        ),
        ...buildDisplayMode(
          PaneDisplayMode.minimal,
          'Minimal display mode',
          'Only the menu button is shown until the pane is opened. When opened, '
              'the pane overlays the left side of the content.',
        ),
      ],
    );
  }

  List<Widget> buildDisplayMode(
    PaneDisplayMode displayMode,
    String title,
    String desc,
  ) {
    if (displayMode != this.displayMode) return [];
    return [
      Wrap(runSpacing: 10.0, spacing: 10.0, children: [
        InfoLabel(
          label: 'Display mode',
          child: ComboBox<PaneDisplayMode>(
            value: displayMode,
            items: ([...PaneDisplayMode.values]..remove(PaneDisplayMode.auto))
                .map((mode) {
              return ComboBoxItem(value: mode, child: Text(mode.name));
            }).toList(),
            onChanged: (mode) => setState(
              () => this.displayMode = mode ?? displayMode,
            ),
          ),
        ),
        InfoLabel(
          label: 'Page Transition',
          child: ComboBox<String>(
            items: pageTransitions
                .map((e) => ComboBoxItem(value: e, child: Text(e)))
                .toList(),
            value: pageTransition,
            onChanged: (transition) => setState(
              () => pageTransition = transition ?? pageTransition,
            ),
          ),
        ),
      ]),
      subtitle(content: Text(title)),
      description(content: Text(desc)),
      CardHighlight(
        codeSnippet: '''NavigationView(
  appBar: const NavigationAppBar(
    title: Text('NavigationView'),
  ),
  pane: NavigationPane(
    selected: topIndex,
    onChanged: (index) => setState(() => topIndex = index),
    displayMode: displayMode,
    items: [
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('Home'),
        body: BodyItem(),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.issue_tracking),
        title: const Text('Track an order'),
        infoBadge: const InfoBadge(source: Text('8')),
        body: BodyItem(),
      ),
      PaneItemExpander(
        icon: const Icon(FluentIcons.account_management),
        title: const Text('Account'),
        body: BodyItem(),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.mail),
            title: const Text('Mail'),
            body: BodyItem(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.calendar),
            title: const Text('Calendar'),
            body: BodyItem(),
          ),
        ],
      ),
    ],
  ),
)''',
        child: SizedBox(
          height: itemHeight,
          child: NavigationView(
            appBar: const NavigationAppBar(
              title: Text('NavigationView'),
            ),
            pane: NavigationPane(
              selected: topIndex,
              onChanged: (index) => setState(() => topIndex = index),
              displayMode: displayMode,
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.home),
                  title: const Text('Home'),
                  body: const _NavigationBodyItem(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.issue_tracking),
                  title: const Text('Track orders'),
                  infoBadge: const InfoBadge(source: Text('8')),
                  body: const _NavigationBodyItem(
                    header: 'Badging',
                    content: Text(
                      'Badging is a non-intrusive and intuitive way to display '
                      'notifications or bring focus to an area within an app - '
                      'whether that be for notifications, indicating new content, '
                      'or showing an alert. An InfoBadge is a small piece of UI '
                      'that can be added into an app and customized to display a '
                      'number, icon, or a simple dot.',
                    ),
                  ),
                ),
                PaneItemExpander(
                  icon: const Icon(FluentIcons.account_management),
                  title: const Text('Account'),
                  body: const _NavigationBodyItem(
                    header: 'PaneItemExpander',
                    content: Text(
                      'Some apps may have a more complex hierarchical structure '
                      'that requires more than just a flat list of navigation '
                      'items. You may want to use top-level navigation items to '
                      'display categories of pages, with children items displaying '
                      'specific pages. It is also useful if you have hub-style '
                      'pages that only link to other pages. For these kinds of '
                      'cases, you should create a hierarchical NavigationView.',
                    ),
                  ),
                  items: [
                    PaneItemHeader(header: const Text('Apps')),
                    PaneItem(
                      icon: const Icon(FluentIcons.mail),
                      title: const Text('Mail'),
                      body: const _NavigationBodyItem(),
                    ),
                    PaneItem(
                      icon: const Icon(FluentIcons.calendar),
                      title: const Text('Calendar'),
                      body: const _NavigationBodyItem(),
                    ),
                  ],
                ),
              ],
              footerItems: [
                PaneItem(
                  icon: const Icon(FluentIcons.settings),
                  title: const Text('Settings'),
                  body: const _NavigationBodyItem(),
                ),
              ],
            ),
            transitionBuilder: pageTransition == 'default'
                ? null
                : (child, animation) {
                    switch (pageTransition) {
                      case 'entrance':
                        return EntrancePageTransition(
                          animation: animation,
                          child: child,
                        );
                      case 'drill in':
                        return DrillInPageTransition(
                          animation: animation,
                          child: child,
                        );
                      case 'horizontal':
                        return HorizontalSlidePageTransition(
                          animation: animation,
                          child: child,
                        );
                      default:
                        throw UnsupportedError(
                          '$pageTransition is not a supported transition',
                        );
                    }
                  },
          ),
        ),
      ),
    ];
  }
}

class _NavigationBodyItem extends StatelessWidget {
  const _NavigationBodyItem({
    Key? key,
    this.header,
    this.content,
  }) : super(key: key);

  final String? header;
  final Widget? content;

  @override
  build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(title: Text(header ?? 'This is a header text')),
      content: content ?? const SizedBox.shrink(),
    );
  }
}
