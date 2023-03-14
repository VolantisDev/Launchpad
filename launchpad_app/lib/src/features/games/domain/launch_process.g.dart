// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LaunchProcess _$$_LaunchProcessFromJson(Map<String, dynamic> json) =>
    _$_LaunchProcess(
      processType: json['processType'] as String,
      launchConfig:
          LaunchConfig.fromJson(json['launchConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_LaunchProcessToJson(_$_LaunchProcess instance) =>
    <String, dynamic>{
      'processType': instance.processType,
      'launchConfig': instance.launchConfig,
    };
