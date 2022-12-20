import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import 'package:launchpad_app/src/features/launchers/data/launcher.dart';

part 'isar_instance.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarInstance(FutureProviderRef ref) {
  return Isar.open([LauncherSchema]);
}
