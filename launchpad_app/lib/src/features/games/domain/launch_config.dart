import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../data/launch_config_data.dart';

part 'launch_config.freezed.dart';
part 'launch_config.g.dart';

@freezed
class LaunchConfig with _$LaunchConfig {
  const LaunchConfig._();

  const factory LaunchConfig({
    required String type,
    required String gameId,
    required String gameKey,
    required String platformId,
    required Map<String, Object?> values,
  }) = _LaunchConfig;

  factory LaunchConfig.fromJson(Map<String, Object?> json) =>
      _$LaunchConfigFromJson(json);
}
