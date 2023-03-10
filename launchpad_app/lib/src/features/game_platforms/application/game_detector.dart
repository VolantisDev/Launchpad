import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/features/games/domain/game.dart';
import 'package:launchpad_app/src/features/game_platforms/domain/game_platform.dart';

abstract class GameDetectorBase {
  Future<List<Game>> detectGames(GamePlatform platform, Ref ref);
}

class LibraryFolderDetector extends GameDetectorBase {
  @override
  detectGames(GamePlatform platform, Ref ref) async {
    var platformType = await platform.getPlatformType(ref);
    var libraryFolders = await platformType?.locateLibraryDirs();

    var games = <Game>[];

    if (libraryFolders != null) {
      for (var libraryFolder in libraryFolders) {
        var dir = Directory(libraryFolder);

        if (dir.existsSync()) {
          for (var file
              in dir.listSync(followLinks: false).whereType<Directory>()) {
            var key = file.uri.pathSegments.last;

            games.add(Game(
              key: dirKeyGenerator(file),
              name: dirNameGenerator(file),
              platformId: platform.key,
              installDir: file.path,
              exeFile: file.path,
            ));
          }
        }
      }
    }

    return games;
  }

  String dirKeyGenerator(Directory dir) {
    return dir.uri.pathSegments.last;
  }

  String dirNameGenerator(Directory dir) {
    return dir.uri.pathSegments.last;
  }
}

class CallbackGameDetector extends GameDetectorBase {
  CallbackGameDetector(this.callback);

  final Future<List<Game>> Function(GamePlatform platform) callback;

  @override
  detectGames(GamePlatform platform, Ref ref) {
    return callback(platform);
  }
}
