import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:launchpad_app/src/features/game_platforms/application/platform_type.dart';

part 'game_platform.freezed.dart';

part 'game_platform.g.dart';

@freezed
class GamePlatform with _$GamePlatform {
  const GamePlatform._();

  const factory GamePlatform({
    required String key,
    required String name,
    required String platformTypeId,
    String? installDir,
    String? exeFile,
    String? iconPath,
  }) = _GamePlatform;

  factory GamePlatform.fromJson(Map<String, Object?> json) =>
      _$GamePlatformFromJson(json);

  Future<PlatformType> getPlatformType() async {
    var platformTypes = await getPlatformTypes();

    return platformTypes.values
        .firstWhere((element) => element.key == platformTypeId);
  }
}
