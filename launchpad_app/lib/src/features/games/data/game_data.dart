import 'package:isar/isar.dart';

import 'game_platform_data.dart';
import 'launch_config_data.dart';
import 'launch_process_data.dart';

part 'game_data.g.dart';

@collection
class GameData {
  Id? id = Isar.autoIncrement;

  String? key;

  String? name;

  final gamePlatform = IsarLink<GamePlatformData>();

  String? platformRef;

  String? installDir;

  String? exeFile;

  String? iconPath;

  String? iconType;

  final launchConfig = IsarLink<LaunchConfigData>();

  final launchProcesses = IsarLinks<LaunchProcessData>();
}
