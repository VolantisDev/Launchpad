import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launchpad_app/src/features/game_platforms/application/game_platform_types.dart';

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

  Future<GamePlatformType?> getPlatformType(Ref ref) async {
    var platformTypes = ref.watch(gamePlatformTypesProvider);

    return platformTypes.value?.values
        .firstWhere((element) => element.key == platformTypeId);
  }
}
