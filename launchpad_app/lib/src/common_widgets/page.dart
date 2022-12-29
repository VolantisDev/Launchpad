import 'dart:async';

import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/common_widgets/deferred_widget.dart';

import 'package:fluent_ui/fluent_ui.dart';

mixin PageMixin {
  Widget description({required Widget content}) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 4.0),
        child: DefaultTextStyle(
          style: FluentTheme.of(context).typography.body!,
          child: content,
        ),
      );
    });
  }

  Widget subtitle({required Widget content}) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: 14.0, bottom: 2.0),
        child: DefaultTextStyle(
          style: FluentTheme.of(context).typography.subtitle!,
          child: content,
        ),
      );
    });
  }
}

abstract class Page extends HookConsumerWidget with PageMixin {
  Page({super.key}) {
    _pageIndex++;
  }

  final StreamController _controller = StreamController.broadcast();
  Stream get stateStream => _controller.stream;

  @override
  Widget build(BuildContext context, WidgetRef ref);

  void setState(VoidCallback func) {
    func();
    _controller.add(null);
  }
}

int _pageIndex = -1;

class ScrollablePage extends Page {
  ScrollablePage(
      {super.key, this.header, this.bottomBar, this.children = const []});

  final scrollController = ScrollController();

  final Widget? header;
  final Widget? bottomBar;
  final List<Widget> children;

  Widget? buildHeader(BuildContext context, WidgetRef ref) {
    return header;
  }

  List<Widget> buildScrollable(BuildContext context, WidgetRef ref) {
    return children;
  }

  Widget? buildBottomBar(BuildContext context, WidgetRef ref) {
    return bottomBar;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      key: PageStorageKey(_pageIndex),
      header: buildHeader(context, ref),
      bottomBar: buildBottomBar(context, ref),
      content: ImprovedScrolling(
          scrollController: scrollController,
          enableCustomMouseWheelScrolling: true,
          customMouseWheelScrollConfig: const CustomMouseWheelScrollConfig(
            scrollAmountMultiplier: 12.5,
            scrollDuration: Duration(milliseconds: 350),
            scrollCurve: Curves.easeOutCubic,
            mouseWheelTurnsThrottleTimeMs: 50,
          ),
          child: ListView(
            controller: scrollController,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              bottom: kPageDefaultVerticalPadding,
              start: PageHeader.horizontalPadding(context),
              end: PageHeader.horizontalPadding(context),
            ),
            children: buildScrollable(context, ref),
          )),
    );
  }
}

class EmptyPage extends Page {
  final Widget? child;

  EmptyPage({
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return child ?? const SizedBox.shrink();
  }
}

typedef DeferredPageBuilder = Page Function();

class DeferredPage extends Page {
  final LibraryLoader libraryLoader;
  final DeferredPageBuilder createPage;

  DeferredPage({
    super.key,
    required this.libraryLoader,
    required this.createPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DeferredWidget(
        libraryLoader, () => createPage().build(context, ref));
  }
}

extension PageExtension on List<Page> {
  List<Widget> transform(BuildContext context, WidgetRef ref) {
    return map((page) {
      return StreamBuilder(
        stream: page.stateStream,
        builder: (context, _) {
          return page.build(context, ref);
        },
      );
    }).toList();
  }
}
