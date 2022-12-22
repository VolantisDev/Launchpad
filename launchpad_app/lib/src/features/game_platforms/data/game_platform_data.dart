import 'package:isar/isar.dart';

part 'game_platform_data.g.dart';

@collection
class GamePlatformData {
  Id? id = Isar.autoIncrement;

  String? key;

  String? name;

  String? installDir;

  String? exeFile;

  String? iconPath;

  String launcherProcessType = 'default';

  String gameProcessType = 'default';
}
