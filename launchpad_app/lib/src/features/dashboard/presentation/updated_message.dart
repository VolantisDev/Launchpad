import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:once/once.dart';

import 'changelog.dart';

class UpdatedMessage extends StatefulHookConsumerWidget {
  const UpdatedMessage({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdatedMessage> createState() => _UpdatedMessage();
}

class _UpdatedMessage extends ConsumerState<UpdatedMessage> {
  @override
  build(BuildContext context) {
    final theme = FluentTheme.of(context);

    // TODO Put actual current version information here
    return OnceWidget.showOnEveryNewVersion(
      builder: () {
        return Column(children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => const Changelog(),
              );
            },
            icon: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What's new in Launchpad 10",
                  style: theme.typography.body
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text('Dec 17, 2022', style: theme.typography.caption),
                Text(
                  'A brand new desktop app!',
                  style: theme.typography.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22.0),
        ]);
      },
    );
  }
}
