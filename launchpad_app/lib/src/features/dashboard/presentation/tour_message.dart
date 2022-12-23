import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:once/once.dart';
import 'package:state_persistence/state_persistence.dart';

class TourMessage extends StatefulHookConsumerWidget {
  const TourMessage({Key? key}) : super(key: key);

  @override
  ConsumerState<TourMessage> createState() => _TourMessage();
}

class _TourMessage extends ConsumerState<TourMessage> {
  var tourBoxIsVisible = true;

  @override
  build(BuildContext context) {
    if (kDebugMode) {
      OnceWidget.clear(key: "tour");
    }

    return PersistedStateBuilder(builder: (context, snapshot) {
      return OnceWidget.showOnce("tour", builder: () {
        if (snapshot.hasData) {
          var tourCompleted = snapshot.data!["tour_completed"] ?? false;
          var tourDismissed = snapshot.data!["tour_dismissed"] ?? false;

          if (tourBoxIsVisible && (tourCompleted || tourDismissed)) {
            setState(() => tourBoxIsVisible = false);
          }

          return Visibility(
              visible: tourBoxIsVisible,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22.0),
                    const Text(
                        'Welcome to Launchpad! Would you like a quick tour to help get up to speed?'),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        FilledButton(
                          onPressed: () => Intro.of(context).start(),
                          child: const Text("Let's go!"),
                        ),
                        const SizedBox(width: 10.0),
                        Button(
                          onPressed: () =>
                              setState(() => tourBoxIsVisible = false),
                          child: const Text('Dismiss'),
                        )
                      ],
                    ),
                    const SizedBox(height: 66.0),
                  ]));
        } else {
          return const SizedBox.shrink();
        }
      });
    });
  }
}

class SponsorButton extends StatelessWidget {
  const SponsorButton({
    Key? key,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
          ),
          shape: BoxShape.circle,
        ),
      ),
      Text(username),
    ]);
  }
}
