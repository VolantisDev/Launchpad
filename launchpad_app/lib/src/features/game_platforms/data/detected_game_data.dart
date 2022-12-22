import 'package:isar/isar.dart';

part 'detected_game_data.g.dart';

@collection
class DetectedGameData {
  /// The internal unique databse ID of the record.
  Id? id = Isar.autoIncrement;

  /// The unique user-level identifier for the game.
  String? key;

  String? name;

  /// The type of process management to use for the launcher, if needed.
  /// is one.
  String launcherProcessType = 'default';

  /// The type of process management to use for the game.
  String gameProcessType = 'default';

  /// Either the full path or the path relative to the game's install directory.
  String? gameExe;

  String? installDir;

  /// The ID the game is known as by its platform, if any.
  String? platformRef;
}
