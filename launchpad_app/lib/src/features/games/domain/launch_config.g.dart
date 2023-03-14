// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LaunchConfig _$$_LaunchConfigFromJson(Map<String, dynamic> json) =>
    _$_LaunchConfig(
      type: json['type'] as String,
      gameId: json['gameId'] as String,
      gameKey: json['gameKey'] as String,
      platformId: json['platformId'] as String,
      values: json['values'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$_LaunchConfigToJson(_$_LaunchConfig instance) =>
    <String, dynamic>{
      'type': instance.type,
      'gameId': instance.gameId,
      'gameKey': instance.gameKey,
      'platformId': instance.platformId,
      'values': instance.values,
    };
