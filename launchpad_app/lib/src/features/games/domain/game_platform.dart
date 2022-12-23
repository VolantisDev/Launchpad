import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'game_platform.freezed.dart';

part 'game_platform.g.dart';

@freezed
class GamePlatform with _$GamePlatform {
  const factory GamePlatform({
    required String key,
    required String name,
    required String installDir,
    required String exeFile,
    required String iconPath,
    required String launcherProcessType,
    required String gameProcessType,
  }) = _GamePlatform;

  factory GamePlatform.fromJson(Map<String, Object?> json) =>
      _$GamePlatformFromJson(json);
}
