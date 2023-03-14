import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/features/games/data/game_data.dart';
import 'package:launchpad_app/src/features/games/data/launch_config_data.dart';
import 'package:launchpad_app/src/utils/isar_instance.dart';

class SampleDataOptions extends StatefulHookConsumerWidget {
  const SampleDataOptions({Key? key}) : super(key: key);

  @override
  ConsumerState<SampleDataOptions> createState() => _SampleDataOptions();
}

class _SampleDataOptions extends ConsumerState<SampleDataOptions> {
  @override
  build(BuildContext context) {
    return Visibility(
        visible: kDebugMode,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
              'This is a debug build. You can import test data or clear all '
              'data using these options. Clearing data will clear all data, '
              'not just test data.'),
          const SizedBox(height: 10.0),
          Row(
            children: [
              FilledButton(
                onPressed: () => importTestData(),
                child: const Text("Import test data"),
              ),
              const SizedBox(width: 10.0),
              Button(
                onPressed: () => clearData(),
                child: const Text('Clear all data'),
              )
            ],
          ),
          const SizedBox(height: 22.0),
        ]));
  }

  Future<void> importTestData() async {
    var instance = await isarInstance;

    instance.collection<LaunchConfigData>().importJson([
      {
        'type': 'game',
        'gameId': 1,
        'gameKey': 'Overwatch',
        'platformId': 'blizzard',
        'values': [
          {
            'key': 'SampleKey',
            'value': 'SampleValue',
          }
        ]
      },
      {
        'type': 'game',
        'gameId': 1,
        'gameKey': 'Overwatch',
        'platformId': 'blizzard',
        'values': [
          {
            'key': 'SampleKey',
            'value': 'SampleValue',
          }
        ]
      },
      {
        'type': 'game',
        'gameId': 1,
        'gameKey': 'Overwatch',
        'platformId': 'blizzard',
        'values': [
          {
            'key': 'SampleKey',
            'value': 'SampleValue',
          }
        ]
      }
    ]);

    instance.collection<GameData>().importJson([
      {
        'id': 1,
        'key': 'Overwatch',
        'name': 'Overwatch 2',
        'platformId': 'blizzard',
        'platformRef': 'pro'
      }
    ]);
  }

  Future<void> clearData() async {
    var instance = await isarInstance;

    instance.collection<GameData>().clear();
  }
}
