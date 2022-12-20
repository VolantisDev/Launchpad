// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launchpad_api.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      authenticated: json['authenticated'] as bool,
      email: json['email'] as String,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'authenticated': instance.authenticated,
      'email': instance.email,
    };

ReleaseInfo _$ReleaseInfoFromJson(Map<String, dynamic> json) => ReleaseInfo(
      tag: json['tag'] as String?,
      version: json['version'] as String,
      installer: json['installer'] as String,
      releasePage: json['releasePage'] as String,
      timestamp: json['timestamp'] as int?,
    );

Map<String, dynamic> _$ReleaseInfoToJson(ReleaseInfo instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'version': instance.version,
      'installer': instance.installer,
      'releasePage': instance.releasePage,
      'timestamp': instance.timestamp,
    };

PlatformDocument _$PlatformDocumentFromJson(Map<String, dynamic> json) =>
    PlatformDocument(
      id: json['id'] as String,
      data: Platform.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlatformDocumentToJson(PlatformDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data.toJson(),
    };

Platform _$PlatformFromJson(Map<String, dynamic> json) => Platform(
      key: json['key'] as String,
      name: json['name'] as String,
      launcherType: json['launcherType'] as String,
      gameType: json['gameType'] as String,
      $class: json['class'] as String,
      enabled: json['enabled'] as bool,
      registry: json['registry'] == null
          ? null
          : Platform$Registry.fromJson(
              json['registry'] as Map<String, dynamic>),
      links: json['links'] == null
          ? null
          : Platform$Links.fromJson(json['links'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlatformToJson(Platform instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'launcherType': instance.launcherType,
      'gameType': instance.gameType,
      'class': instance.$class,
      'enabled': instance.enabled,
      'registry': instance.registry?.toJson(),
      'links': instance.links?.toJson(),
    };

LauncherTypeDocument _$LauncherTypeDocumentFromJson(
        Map<String, dynamic> json) =>
    LauncherTypeDocument(
      id: json['id'] as String,
      data: LauncherType.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LauncherTypeDocumentToJson(
        LauncherTypeDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data.toJson(),
    };

LauncherType _$LauncherTypeFromJson(Map<String, dynamic> json) => LauncherType(
      key: json['key'] as String,
      name: json['name'] as String,
      defaults: json['defaults'] as Object,
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$LauncherTypeToJson(LauncherType instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'defaults': instance.defaults,
      'enabled': instance.enabled,
    };

GameTypeDocument _$GameTypeDocumentFromJson(Map<String, dynamic> json) =>
    GameTypeDocument(
      id: json['id'] as String,
      data: GameType.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameTypeDocumentToJson(GameTypeDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data.toJson(),
    };

GameType _$GameTypeFromJson(Map<String, dynamic> json) => GameType(
      key: json['key'] as String,
      name: json['name'] as String,
      defaults: json['defaults'] as Object,
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$GameTypeToJson(GameType instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'defaults': instance.defaults,
      'enabled': instance.enabled,
    };

RegistryValue _$RegistryValueFromJson(Map<String, dynamic> json) =>
    RegistryValue(
      view: json['view'] as int,
      key: json['key'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$RegistryValueToJson(RegistryValue instance) =>
    <String, dynamic>{
      'view': instance.view,
      'key': instance.key,
      'value': instance.value,
    };

GameDocument _$GameDocumentFromJson(Map<String, dynamic> json) => GameDocument(
      id: json['id'] as String,
      data: Game.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameDocumentToJson(GameDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data.toJson(),
    };

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      key: json['key'] as String,
      platform: json['platform'] as String,
      defaults: json['defaults'] as Object,
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'key': instance.key,
      'platform': instance.platform,
      'defaults': instance.defaults,
    };

Platform$Registry _$Platform$RegistryFromJson(Map<String, dynamic> json) =>
    Platform$Registry(
      uninstallCmd: json['uninstallCmd'] == null
          ? null
          : RegistryValue.fromJson(
              json['uninstallCmd'] as Map<String, dynamic>),
      installDir: json['installDir'] == null
          ? null
          : RegistryValue.fromJson(json['installDir'] as Map<String, dynamic>),
      version: json['version'] == null
          ? null
          : RegistryValue.fromJson(json['version'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Platform$RegistryToJson(Platform$Registry instance) =>
    <String, dynamic>{
      'uninstallCmd': instance.uninstallCmd?.toJson(),
      'installDir': instance.installDir?.toJson(),
      'version': instance.version?.toJson(),
    };

Platform$Links _$Platform$LinksFromJson(Map<String, dynamic> json) =>
    Platform$Links(
      install: json['install'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$Platform$LinksToJson(Platform$Links instance) =>
    <String, dynamic>{
      'install': instance.install,
      'website': instance.website,
    };
