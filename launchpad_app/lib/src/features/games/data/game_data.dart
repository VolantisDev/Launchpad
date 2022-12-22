import 'package:isar/isar.dart';

part 'game_data.g.dart';

@collection
class GameData {
  Id? id = Isar.autoIncrement;

  String? key;

  String? name;

  String? platformId;

  String? installDir;

  String? exeFile;
}
