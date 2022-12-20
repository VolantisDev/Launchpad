import 'package:isar/isar.dart';

part 'launcher.g.dart';

@collection
class Launcher {
  Id? id = Isar.autoIncrement;

  String? key;

  String? name;
}
