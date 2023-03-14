import 'package:hive/hive.dart';
import 'package:state_persistence/state_persistence.dart';

class HiveStateStorage extends PersistedStateStorage {
  var box = Hive.openBox("persisted_state");

  @override
  Future<void> clear() {
    return box.then((openBox) => openBox.put("state", <String, dynamic>{}));
  }

  @override
  Future<Map<String, dynamic>?> load() {
    return box.then(
        (openBox) => openBox.get("state", defaultValue: <String, dynamic>{}));
  }

  @override
  Future<void> save(Map<String, dynamic>? data) {
    return box.then((openBox) => openBox.put("state", data));
  }
}
