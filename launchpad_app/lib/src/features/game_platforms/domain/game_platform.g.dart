// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_platform.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GamePlatform _$$_GamePlatformFromJson(Map<String, dynamic> json) =>
    _$_GamePlatform(
      key: json['key'] as String,
      name: json['name'] as String,
      installDir: json['installDir'] as String,
      exeFile: json['exeFile'] as String,
      iconPath: json['iconPath'] as String,
      launcherProcessType: json['launcherProcessType'] as String,
      gameProcessType: json['gameProcessType'] as String,
    );

Map<String, dynamic> _$$_GamePlatformToJson(_$_GamePlatform instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'installDir': instance.installDir,
      'exeFile': instance.exeFile,
      'iconPath': instance.iconPath,
      'launcherProcessType': instance.launcherProcessType,
      'gameProcessType': instance.gameProcessType,
    };
