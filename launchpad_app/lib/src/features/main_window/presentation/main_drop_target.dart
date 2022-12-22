import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainDropTarget extends StatefulHookConsumerWidget {
  const MainDropTarget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  createState() => _MainDropTargetState();
}

class _MainDropTargetState extends ConsumerState<MainDropTarget> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) {
        if (detail.files.isNotEmpty) {
          // TODO Start game detection against the provided files
        }
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Stack(children: <Widget>[
        widget.child,
        Visibility(
          visible: _dragging,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.surface.withOpacity(0.75),
            child: const Center(
                child: Text("Drop files or folders anywhere to add games")),
          ),
        ),
      ]),
    );
  }
}
