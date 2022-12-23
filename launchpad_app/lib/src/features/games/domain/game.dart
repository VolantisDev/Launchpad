import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:launchpad_app/src/features/games/domain/launch_config.dart';

part 'game.freezed.dart';

part 'game.g.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required String key,
    required String name,
    required String platformId,
    required String installDir,
    required String exeFile,
    required LaunchConfig launchConfig,
  }) = _Game;

  factory Game.fromJson(Map<String, Object?> json) => _$GameFromJson(json);
}
