import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:launchpad_app/src/features/games/domain/launch_config.dart';

part 'launch_process.freezed.dart';

part 'launch_process.g.dart';

@freezed
class LaunchProcess with _$LaunchProcess {
  const factory LaunchProcess({
    required String processType,
    required LaunchConfig launchConfig,
  }) = _LaunchProcess;

  factory LaunchProcess.fromJson(Map<String, Object?> json) =>
      _$LaunchProcessFromJson(json);
}
