import 'package:isar/isar.dart';

part 'launch_config_data.g.dart';

@collection
class LaunchConfigData {
  Id? id = Isar.autoIncrement;

  String type = 'game';

  String? gameId;

  String? gameKey;

  String? platformId;

  List<LaunchConfigValue>? values;

  Map<String, Object?> toConfigMap(List<LaunchConfigValue> values) {
    var configMap = <String, Object?>{};

    for (var value in values) {
      configMap[value.key!] = value;
    }

    return configMap;
  }
}

@embedded
class LaunchConfigValue {
  String? key;

  String? value;
}