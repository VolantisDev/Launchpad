import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../games/domain/game_platform.dart';
import 'game_platform_types.dart';

part 'game_platforms.g.dart';

@Riverpod(keepAlive: true)
Future<List<GamePlatform>> gamePlatforms(GamePlatformsRef ref) async {
  var platformTypes = ref.watch(gamePlatformTypesProvider).value;
  var platforms = <GamePlatform>[];

  if (platformTypes != null) {
    for (var platformType in platformTypes.values) {
      if (await platformType.isInstalled()) {
        platforms.add(GamePlatform(
          key: platformType.key,
          name: platformType.name,
          platformTypeId: platformType.key,
          installDir: await platformType.locateInstallDir(),
          exeFile: await platformType.locateMainExe(),
          iconPath: await platformType.locateIconPath(),
        ));
      }
    }
  }

  return platforms;
}
