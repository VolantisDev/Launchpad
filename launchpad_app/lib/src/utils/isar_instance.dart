import 'package:launchpad_app/src/features/game_platforms/data/detected_game_data.dart';
import 'package:launchpad_app/src/features/game_platforms/data/game_platform_data.dart';
import 'package:launchpad_app/src/features/games/data/game_data.dart';
import 'package:launchpad_app/src/features/games/data/launch_config_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';

part 'isar_instance.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarInstance(FutureProviderRef ref) {
  return Isar.open([
    DetectedGameDataSchema,
    GamePlatformDataSchema,
    GameDataSchema,
    LaunchConfigDataSchema,
  ]);
}
