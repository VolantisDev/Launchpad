import 'package:launchpad_app/src/features/games/data/game_data.dart';
import 'package:launchpad_app/src/features/games/data/launch_process_data.dart';
import 'package:launchpad_app/src/features/games/data/launch_config_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';

import '../features/game_platforms/data/game_platform_data.dart';

part 'isar_instance.g.dart';

final isarInstance = Isar.open([
  GamePlatformDataSchema,
  GameDataSchema,
  LaunchProcessDataSchema,
  LaunchConfigDataSchema,
]);

@Riverpod(keepAlive: true)
Future<Isar> isarInstanceProvider(FutureProviderRef ref) {
  return isarInstance;
}
