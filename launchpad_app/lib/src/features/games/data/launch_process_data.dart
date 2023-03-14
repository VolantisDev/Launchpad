import 'package:isar/isar.dart';
import 'package:launchpad_app/src/features/games/data/game_data.dart';

part 'launch_process_data.g.dart';

@collection
class LaunchProcessData {
  Id? id = Isar.autoIncrement;

  final game = IsarLink<GameData>();

  String? type;

  String? dir;

  String? exe;

  String? startCommand;

  String? startUri;

  String? startArgs;

  String? processId;

  String? processIdType;

  final childProcesses = IsarLinks<LaunchProcessData>();
}
