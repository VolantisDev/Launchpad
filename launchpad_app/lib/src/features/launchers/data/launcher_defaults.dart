import 'package:isar/isar.dart';

part 'launcher_defaults.g.dart';

@collection
class LauncherDefaults {
  Id? id = Isar.autoIncrement;

  String? key;

  String? providerId;
}
