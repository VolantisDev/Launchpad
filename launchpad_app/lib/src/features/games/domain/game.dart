import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';

part 'game.g.dart';

@freezed
class Game with _$Game {
  const Game._();

  const factory Game({
    required String key,
    required String name,
    required String platformId,
    required String installDir,
    String? platformRef,
    String? exeFile,
  }) = _Game;

  factory Game.fromJson(Map<String, Object?> json) => _$GameFromJson(json);
}
