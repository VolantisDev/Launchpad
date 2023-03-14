// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:chopper/chopper.dart' as chopper;

part 'launchpad_api.swagger.chopper.dart';
part 'launchpad_api.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class LaunchpadApi extends ChopperService {
  static LaunchpadApi create({
    ChopperClient? client,
    Authenticator? authenticator,
    Uri? baseUrl,
    Iterable<dynamic>? interceptors,
  }) {
    if (client != null) {
      return _$LaunchpadApi(client);
    }

    final newClient = ChopperClient(
        services: [_$LaunchpadApi()],
        converter: $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        authenticator: authenticator,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$LaunchpadApi(newClient);
  }

  ///
  Future<chopper.Response<String>> helloGet() {
    return _helloGet();
  }

  ///
  @Get(path: '/hello')
  Future<chopper.Response<String>> _helloGet();

  ///
  Future<chopper.Response<Status>> statusGet() {
    generatedMapping.putIfAbsent(Status, () => Status.fromJsonFactory);

    return _statusGet();
  }

  ///
  @Get(path: '/status')
  Future<chopper.Response<Status>> _statusGet();

  ///
  Future<chopper.Response<ReleaseInfo>> releaseInfoGet() {
    generatedMapping.putIfAbsent(
        ReleaseInfo, () => ReleaseInfo.fromJsonFactory);

    return _releaseInfoGet();
  }

  ///
  @Get(path: '/release-info')
  Future<chopper.Response<ReleaseInfo>> _releaseInfoGet();

  ///
  Future<chopper.Response<Listing>> platformsGet() {
    return _platformsGet();
  }

  ///
  @Get(path: '/platforms')
  Future<chopper.Response<Listing>> _platformsGet();

  ///
  ///@param platformId The id of the platform
  Future<chopper.Response<PlatformDocument>> platformsPlatformIdGet(
      {required String? platformId}) {
    generatedMapping.putIfAbsent(
        PlatformDocument, () => PlatformDocument.fromJsonFactory);

    return _platformsPlatformIdGet(platformId: platformId);
  }

  ///
  ///@param platformId The id of the platform
  @Get(path: '/platforms/{platformId}')
  Future<chopper.Response<PlatformDocument>> _platformsPlatformIdGet(
      {@Path('platformId') required String? platformId});

  ///
  Future<chopper.Response<Listing>> launcherTypesGet() {
    return _launcherTypesGet();
  }

  ///
  @Get(path: '/launcher-types')
  Future<chopper.Response<Listing>> _launcherTypesGet();

  ///
  ///@param launcherTypeId The id of the launcher type
  Future<chopper.Response<LauncherTypeDocument>> launcherTypesLauncherTypeIdGet(
      {required String? launcherTypeId}) {
    generatedMapping.putIfAbsent(
        LauncherTypeDocument, () => LauncherTypeDocument.fromJsonFactory);

    return _launcherTypesLauncherTypeIdGet(launcherTypeId: launcherTypeId);
  }

  ///
  ///@param launcherTypeId The id of the launcher type
  @Get(path: '/launcher-types/{launcherTypeId}')
  Future<chopper.Response<LauncherTypeDocument>>
      _launcherTypesLauncherTypeIdGet(
          {@Path('launcherTypeId') required String? launcherTypeId});

  ///
  Future<chopper.Response<Listing>> gameTypesGet() {
    return _gameTypesGet();
  }

  ///
  @Get(path: '/game-types')
  Future<chopper.Response<Listing>> _gameTypesGet();

  ///
  ///@param gameTypeId The id of the game type
  Future<chopper.Response<GameTypeDocument>> gameTypesGameTypeIdGet(
      {required String? gameTypeId}) {
    generatedMapping.putIfAbsent(
        GameTypeDocument, () => GameTypeDocument.fromJsonFactory);

    return _gameTypesGameTypeIdGet(gameTypeId: gameTypeId);
  }

  ///
  ///@param gameTypeId The id of the game type
  @Get(path: '/game-types/{gameTypeId}')
  Future<chopper.Response<GameTypeDocument>> _gameTypesGameTypeIdGet(
      {@Path('gameTypeId') required String? gameTypeId});

  ///
  Future<chopper.Response<List<Object>>> gamesGet() {
    return _gamesGet();
  }

  ///
  @Get(path: '/games')
  Future<chopper.Response<List<Object>>> _gamesGet();

  ///
  Future<chopper.Response<List<String>>> gameKeysGet() {
    return _gameKeysGet();
  }

  ///
  @Get(path: '/game-keys')
  Future<chopper.Response<List<String>>> _gameKeysGet();

  ///
  ///@param gameId The id of the game
  Future<chopper.Response<GameDocument>> gamesGameIdGet(
      {required String? gameId}) {
    generatedMapping.putIfAbsent(
        GameDocument, () => GameDocument.fromJsonFactory);

    return _gamesGameIdGet(gameId: gameId);
  }

  ///
  ///@param gameId The id of the game
  @Get(path: '/games/{gameId}')
  Future<chopper.Response<GameDocument>> _gamesGameIdGet(
      {@Path('gameId') required String? gameId});

  ///
  ///@param gameKey The key of the game
  ///@param platformId The id of the platform
  Future<chopper.Response<Object>> lookupGameKeyPlatformIdGet({
    required String? gameKey,
    required String? platformId,
  }) {
    return _lookupGameKeyPlatformIdGet(
        gameKey: gameKey, platformId: platformId);
  }

  ///
  ///@param gameKey The key of the game
  ///@param platformId The id of the platform
  @Get(path: '/lookup/{gameKey}/{platformId}')
  Future<chopper.Response<Object>> _lookupGameKeyPlatformIdGet({
    @Path('gameKey') required String? gameKey,
    @Path('platformId') required String? platformId,
  });

  ///
  ///@param message The error message
  ///@param what What caused the error
  ///@param file What file the error originated in
  ///@param line The line within the file
  ///@param extra Extra information about the error
  ///@param stack The stack trace if available
  ///@param email The email address of the submitter if provided
  ///@param details Additional details by the submitter if provided
  ///@param version The version of Launchpad that generated the error
  Future<chopper.Response> submitErrorPost({
    required String? message,
    required String? what,
    required String? file,
    required int? line,
    String? extra,
    String? stack,
    String? email,
    String? details,
    String? version,
  }) {
    return _submitErrorPost(
        message: message,
        what: what,
        file: file,
        line: line,
        extra: extra,
        stack: stack,
        email: email,
        details: details,
        version: version);
  }

  ///
  ///@param message The error message
  ///@param what What caused the error
  ///@param file What file the error originated in
  ///@param line The line within the file
  ///@param extra Extra information about the error
  ///@param stack The stack trace if available
  ///@param email The email address of the submitter if provided
  ///@param details Additional details by the submitter if provided
  ///@param version The version of Launchpad that generated the error
  @Post(
    path: '/submit-error',
    optionalBody: true,
  )
  Future<chopper.Response> _submitErrorPost({
    @Query('message') required String? message,
    @Query('what') required String? what,
    @Query('file') required String? file,
    @Query('line') required int? line,
    @Query('extra') String? extra,
    @Query('stack') String? stack,
    @Query('email') String? email,
    @Query('details') String? details,
    @Query('version') String? version,
  });

  ///
  ///@param feedback The feedback that was submitted
  ///@param email The email address of the submitter if provided
  ///@param version The version of Launchpad
  Future<chopper.Response> submitFeedbackPost({
    required String? feedback,
    String? email,
    String? version,
  }) {
    return _submitFeedbackPost(
        feedback: feedback, email: email, version: version);
  }

  ///
  ///@param feedback The feedback that was submitted
  ///@param email The email address of the submitter if provided
  ///@param version The version of Launchpad
  @Post(
    path: '/submit-feedback',
    optionalBody: true,
  )
  Future<chopper.Response> _submitFeedbackPost({
    @Query('feedback') required String? feedback,
    @Query('email') String? email,
    @Query('version') String? version,
  });
}

@JsonSerializable(explicitToJson: true)
class Status {
  Status({
    required this.authenticated,
    required this.email,
  });

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  @JsonKey(name: 'authenticated')
  final bool authenticated;
  @JsonKey(name: 'email')
  final String email;
  static const fromJsonFactory = _$StatusFromJson;
  static const toJsonFactory = _$StatusToJson;
  Map<String, dynamic> toJson() => _$StatusToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Status &&
            (identical(other.authenticated, authenticated) ||
                const DeepCollectionEquality()
                    .equals(other.authenticated, authenticated)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(authenticated) ^
      const DeepCollectionEquality().hash(email) ^
      runtimeType.hashCode;
}

extension $StatusExtension on Status {
  Status copyWith({bool? authenticated, String? email}) {
    return Status(
        authenticated: authenticated ?? this.authenticated,
        email: email ?? this.email);
  }

  Status copyWithWrapped(
      {Wrapped<bool>? authenticated, Wrapped<String>? email}) {
    return Status(
        authenticated:
            (authenticated != null ? authenticated.value : this.authenticated),
        email: (email != null ? email.value : this.email));
  }
}

@JsonSerializable(explicitToJson: true)
class ReleaseInfo {
  ReleaseInfo({
    this.tag,
    required this.version,
    required this.installer,
    required this.releasePage,
    this.timestamp,
  });

  factory ReleaseInfo.fromJson(Map<String, dynamic> json) =>
      _$ReleaseInfoFromJson(json);

  @JsonKey(name: 'tag')
  final String? tag;
  @JsonKey(name: 'version')
  final String version;
  @JsonKey(name: 'installer')
  final String installer;
  @JsonKey(name: 'releasePage')
  final String releasePage;
  @JsonKey(name: 'timestamp')
  final int? timestamp;
  static const fromJsonFactory = _$ReleaseInfoFromJson;
  static const toJsonFactory = _$ReleaseInfoToJson;
  Map<String, dynamic> toJson() => _$ReleaseInfoToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ReleaseInfo &&
            (identical(other.tag, tag) ||
                const DeepCollectionEquality().equals(other.tag, tag)) &&
            (identical(other.version, version) ||
                const DeepCollectionEquality()
                    .equals(other.version, version)) &&
            (identical(other.installer, installer) ||
                const DeepCollectionEquality()
                    .equals(other.installer, installer)) &&
            (identical(other.releasePage, releasePage) ||
                const DeepCollectionEquality()
                    .equals(other.releasePage, releasePage)) &&
            (identical(other.timestamp, timestamp) ||
                const DeepCollectionEquality()
                    .equals(other.timestamp, timestamp)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(tag) ^
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash(installer) ^
      const DeepCollectionEquality().hash(releasePage) ^
      const DeepCollectionEquality().hash(timestamp) ^
      runtimeType.hashCode;
}

extension $ReleaseInfoExtension on ReleaseInfo {
  ReleaseInfo copyWith(
      {String? tag,
      String? version,
      String? installer,
      String? releasePage,
      int? timestamp}) {
    return ReleaseInfo(
        tag: tag ?? this.tag,
        version: version ?? this.version,
        installer: installer ?? this.installer,
        releasePage: releasePage ?? this.releasePage,
        timestamp: timestamp ?? this.timestamp);
  }

  ReleaseInfo copyWithWrapped(
      {Wrapped<String?>? tag,
      Wrapped<String>? version,
      Wrapped<String>? installer,
      Wrapped<String>? releasePage,
      Wrapped<int?>? timestamp}) {
    return ReleaseInfo(
        tag: (tag != null ? tag.value : this.tag),
        version: (version != null ? version.value : this.version),
        installer: (installer != null ? installer.value : this.installer),
        releasePage:
            (releasePage != null ? releasePage.value : this.releasePage),
        timestamp: (timestamp != null ? timestamp.value : this.timestamp));
  }
}

typedef Listing = List<Object>;

@JsonSerializable(explicitToJson: true)
class PlatformDocument {
  PlatformDocument({
    required this.id,
    required this.data,
  });

  factory PlatformDocument.fromJson(Map<String, dynamic> json) =>
      _$PlatformDocumentFromJson(json);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'data')
  final Platform data;
  static const fromJsonFactory = _$PlatformDocumentFromJson;
  static const toJsonFactory = _$PlatformDocumentToJson;
  Map<String, dynamic> toJson() => _$PlatformDocumentToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is PlatformDocument &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $PlatformDocumentExtension on PlatformDocument {
  PlatformDocument copyWith({String? id, Platform? data}) {
    return PlatformDocument(id: id ?? this.id, data: data ?? this.data);
  }

  PlatformDocument copyWithWrapped(
      {Wrapped<String>? id, Wrapped<Platform>? data}) {
    return PlatformDocument(
        id: (id != null ? id.value : this.id),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class Platform {
  Platform({
    required this.key,
    required this.name,
    required this.launcherType,
    required this.gameType,
    required this.$class,
    required this.enabled,
    this.registry,
    this.links,
  });

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);

  @JsonKey(name: 'key')
  final String key;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'launcherType')
  final String launcherType;
  @JsonKey(name: 'gameType')
  final String gameType;
  @JsonKey(name: 'class')
  final String $class;
  @JsonKey(name: 'enabled')
  final bool enabled;
  @JsonKey(name: 'registry')
  final Platform$Registry? registry;
  @JsonKey(name: 'links')
  final Platform$Links? links;
  static const fromJsonFactory = _$PlatformFromJson;
  static const toJsonFactory = _$PlatformToJson;
  Map<String, dynamic> toJson() => _$PlatformToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Platform &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.launcherType, launcherType) ||
                const DeepCollectionEquality()
                    .equals(other.launcherType, launcherType)) &&
            (identical(other.gameType, gameType) ||
                const DeepCollectionEquality()
                    .equals(other.gameType, gameType)) &&
            (identical(other.$class, $class) ||
                const DeepCollectionEquality().equals(other.$class, $class)) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality()
                    .equals(other.enabled, enabled)) &&
            (identical(other.registry, registry) ||
                const DeepCollectionEquality()
                    .equals(other.registry, registry)) &&
            (identical(other.links, links) ||
                const DeepCollectionEquality().equals(other.links, links)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(launcherType) ^
      const DeepCollectionEquality().hash(gameType) ^
      const DeepCollectionEquality().hash($class) ^
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(registry) ^
      const DeepCollectionEquality().hash(links) ^
      runtimeType.hashCode;
}

extension $PlatformExtension on Platform {
  Platform copyWith(
      {String? key,
      String? name,
      String? launcherType,
      String? gameType,
      String? $class,
      bool? enabled,
      Platform$Registry? registry,
      Platform$Links? links}) {
    return Platform(
        key: key ?? this.key,
        name: name ?? this.name,
        launcherType: launcherType ?? this.launcherType,
        gameType: gameType ?? this.gameType,
        $class: $class ?? this.$class,
        enabled: enabled ?? this.enabled,
        registry: registry ?? this.registry,
        links: links ?? this.links);
  }

  Platform copyWithWrapped(
      {Wrapped<String>? key,
      Wrapped<String>? name,
      Wrapped<String>? launcherType,
      Wrapped<String>? gameType,
      Wrapped<String>? $class,
      Wrapped<bool>? enabled,
      Wrapped<Platform$Registry?>? registry,
      Wrapped<Platform$Links?>? links}) {
    return Platform(
        key: (key != null ? key.value : this.key),
        name: (name != null ? name.value : this.name),
        launcherType:
            (launcherType != null ? launcherType.value : this.launcherType),
        gameType: (gameType != null ? gameType.value : this.gameType),
        $class: ($class != null ? $class.value : this.$class),
        enabled: (enabled != null ? enabled.value : this.enabled),
        registry: (registry != null ? registry.value : this.registry),
        links: (links != null ? links.value : this.links));
  }
}

@JsonSerializable(explicitToJson: true)
class LauncherTypeDocument {
  LauncherTypeDocument({
    required this.id,
    required this.data,
  });

  factory LauncherTypeDocument.fromJson(Map<String, dynamic> json) =>
      _$LauncherTypeDocumentFromJson(json);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'data')
  final LauncherType data;
  static const fromJsonFactory = _$LauncherTypeDocumentFromJson;
  static const toJsonFactory = _$LauncherTypeDocumentToJson;
  Map<String, dynamic> toJson() => _$LauncherTypeDocumentToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is LauncherTypeDocument &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $LauncherTypeDocumentExtension on LauncherTypeDocument {
  LauncherTypeDocument copyWith({String? id, LauncherType? data}) {
    return LauncherTypeDocument(id: id ?? this.id, data: data ?? this.data);
  }

  LauncherTypeDocument copyWithWrapped(
      {Wrapped<String>? id, Wrapped<LauncherType>? data}) {
    return LauncherTypeDocument(
        id: (id != null ? id.value : this.id),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class LauncherType {
  LauncherType({
    required this.key,
    required this.name,
    required this.defaults,
    required this.enabled,
  });

  factory LauncherType.fromJson(Map<String, dynamic> json) =>
      _$LauncherTypeFromJson(json);

  @JsonKey(name: 'key')
  final String key;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'defaults')
  final Object defaults;
  @JsonKey(name: 'enabled')
  final bool enabled;
  static const fromJsonFactory = _$LauncherTypeFromJson;
  static const toJsonFactory = _$LauncherTypeToJson;
  Map<String, dynamic> toJson() => _$LauncherTypeToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is LauncherType &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.defaults, defaults) ||
                const DeepCollectionEquality()
                    .equals(other.defaults, defaults)) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(other.enabled, enabled)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(defaults) ^
      const DeepCollectionEquality().hash(enabled) ^
      runtimeType.hashCode;
}

extension $LauncherTypeExtension on LauncherType {
  LauncherType copyWith(
      {String? key, String? name, Object? defaults, bool? enabled}) {
    return LauncherType(
        key: key ?? this.key,
        name: name ?? this.name,
        defaults: defaults ?? this.defaults,
        enabled: enabled ?? this.enabled);
  }

  LauncherType copyWithWrapped(
      {Wrapped<String>? key,
      Wrapped<String>? name,
      Wrapped<Object>? defaults,
      Wrapped<bool>? enabled}) {
    return LauncherType(
        key: (key != null ? key.value : this.key),
        name: (name != null ? name.value : this.name),
        defaults: (defaults != null ? defaults.value : this.defaults),
        enabled: (enabled != null ? enabled.value : this.enabled));
  }
}

@JsonSerializable(explicitToJson: true)
class GameTypeDocument {
  GameTypeDocument({
    required this.id,
    required this.data,
  });

  factory GameTypeDocument.fromJson(Map<String, dynamic> json) =>
      _$GameTypeDocumentFromJson(json);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'data')
  final GameType data;
  static const fromJsonFactory = _$GameTypeDocumentFromJson;
  static const toJsonFactory = _$GameTypeDocumentToJson;
  Map<String, dynamic> toJson() => _$GameTypeDocumentToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is GameTypeDocument &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $GameTypeDocumentExtension on GameTypeDocument {
  GameTypeDocument copyWith({String? id, GameType? data}) {
    return GameTypeDocument(id: id ?? this.id, data: data ?? this.data);
  }

  GameTypeDocument copyWithWrapped(
      {Wrapped<String>? id, Wrapped<GameType>? data}) {
    return GameTypeDocument(
        id: (id != null ? id.value : this.id),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class GameType {
  GameType({
    required this.key,
    required this.name,
    required this.defaults,
    required this.enabled,
  });

  factory GameType.fromJson(Map<String, dynamic> json) =>
      _$GameTypeFromJson(json);

  @JsonKey(name: 'key')
  final String key;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'defaults')
  final Object defaults;
  @JsonKey(name: 'enabled')
  final bool enabled;
  static const fromJsonFactory = _$GameTypeFromJson;
  static const toJsonFactory = _$GameTypeToJson;
  Map<String, dynamic> toJson() => _$GameTypeToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is GameType &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.defaults, defaults) ||
                const DeepCollectionEquality()
                    .equals(other.defaults, defaults)) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(other.enabled, enabled)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(defaults) ^
      const DeepCollectionEquality().hash(enabled) ^
      runtimeType.hashCode;
}

extension $GameTypeExtension on GameType {
  GameType copyWith(
      {String? key, String? name, Object? defaults, bool? enabled}) {
    return GameType(
        key: key ?? this.key,
        name: name ?? this.name,
        defaults: defaults ?? this.defaults,
        enabled: enabled ?? this.enabled);
  }

  GameType copyWithWrapped(
      {Wrapped<String>? key,
      Wrapped<String>? name,
      Wrapped<Object>? defaults,
      Wrapped<bool>? enabled}) {
    return GameType(
        key: (key != null ? key.value : this.key),
        name: (name != null ? name.value : this.name),
        defaults: (defaults != null ? defaults.value : this.defaults),
        enabled: (enabled != null ? enabled.value : this.enabled));
  }
}

@JsonSerializable(explicitToJson: true)
class RegistryValue {
  RegistryValue({
    required this.view,
    required this.key,
    required this.value,
  });

  factory RegistryValue.fromJson(Map<String, dynamic> json) =>
      _$RegistryValueFromJson(json);

  @JsonKey(name: 'view')
  final int view;
  @JsonKey(name: 'key')
  final String key;
  @JsonKey(name: 'value')
  final String value;
  static const fromJsonFactory = _$RegistryValueFromJson;
  static const toJsonFactory = _$RegistryValueToJson;
  Map<String, dynamic> toJson() => _$RegistryValueToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is RegistryValue &&
            (identical(other.view, view) ||
                const DeepCollectionEquality().equals(other.view, view)) &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(view) ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(value) ^
      runtimeType.hashCode;
}

extension $RegistryValueExtension on RegistryValue {
  RegistryValue copyWith({int? view, String? key, String? value}) {
    return RegistryValue(
        view: view ?? this.view,
        key: key ?? this.key,
        value: value ?? this.value);
  }

  RegistryValue copyWithWrapped(
      {Wrapped<int>? view, Wrapped<String>? key, Wrapped<String>? value}) {
    return RegistryValue(
        view: (view != null ? view.value : this.view),
        key: (key != null ? key.value : this.key),
        value: (value != null ? value.value : this.value));
  }
}

@JsonSerializable(explicitToJson: true)
class GameDocument {
  GameDocument({
    required this.id,
    required this.data,
  });

  factory GameDocument.fromJson(Map<String, dynamic> json) =>
      _$GameDocumentFromJson(json);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'data')
  final Game data;
  static const fromJsonFactory = _$GameDocumentFromJson;
  static const toJsonFactory = _$GameDocumentToJson;
  Map<String, dynamic> toJson() => _$GameDocumentToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is GameDocument &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $GameDocumentExtension on GameDocument {
  GameDocument copyWith({String? id, Game? data}) {
    return GameDocument(id: id ?? this.id, data: data ?? this.data);
  }

  GameDocument copyWithWrapped({Wrapped<String>? id, Wrapped<Game>? data}) {
    return GameDocument(
        id: (id != null ? id.value : this.id),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class Game {
  Game({
    required this.key,
    required this.platform,
    required this.defaults,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  @JsonKey(name: 'key')
  final String key;
  @JsonKey(name: 'platform')
  final String platform;
  @JsonKey(name: 'defaults')
  final Object defaults;
  static const fromJsonFactory = _$GameFromJson;
  static const toJsonFactory = _$GameToJson;
  Map<String, dynamic> toJson() => _$GameToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Game &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.platform, platform) ||
                const DeepCollectionEquality()
                    .equals(other.platform, platform)) &&
            (identical(other.defaults, defaults) ||
                const DeepCollectionEquality()
                    .equals(other.defaults, defaults)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(platform) ^
      const DeepCollectionEquality().hash(defaults) ^
      runtimeType.hashCode;
}

extension $GameExtension on Game {
  Game copyWith({String? key, String? platform, Object? defaults}) {
    return Game(
        key: key ?? this.key,
        platform: platform ?? this.platform,
        defaults: defaults ?? this.defaults);
  }

  Game copyWithWrapped(
      {Wrapped<String>? key,
      Wrapped<String>? platform,
      Wrapped<Object>? defaults}) {
    return Game(
        key: (key != null ? key.value : this.key),
        platform: (platform != null ? platform.value : this.platform),
        defaults: (defaults != null ? defaults.value : this.defaults));
  }
}

@JsonSerializable(explicitToJson: true)
class Platform$Registry {
  Platform$Registry({
    this.uninstallCmd,
    this.installDir,
    this.version,
  });

  factory Platform$Registry.fromJson(Map<String, dynamic> json) =>
      _$Platform$RegistryFromJson(json);

  @JsonKey(name: 'uninstallCmd')
  final RegistryValue? uninstallCmd;
  @JsonKey(name: 'installDir')
  final RegistryValue? installDir;
  @JsonKey(name: 'version')
  final RegistryValue? version;
  static const fromJsonFactory = _$Platform$RegistryFromJson;
  static const toJsonFactory = _$Platform$RegistryToJson;
  Map<String, dynamic> toJson() => _$Platform$RegistryToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Platform$Registry &&
            (identical(other.uninstallCmd, uninstallCmd) ||
                const DeepCollectionEquality()
                    .equals(other.uninstallCmd, uninstallCmd)) &&
            (identical(other.installDir, installDir) ||
                const DeepCollectionEquality()
                    .equals(other.installDir, installDir)) &&
            (identical(other.version, version) ||
                const DeepCollectionEquality().equals(other.version, version)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(uninstallCmd) ^
      const DeepCollectionEquality().hash(installDir) ^
      const DeepCollectionEquality().hash(version) ^
      runtimeType.hashCode;
}

extension $Platform$RegistryExtension on Platform$Registry {
  Platform$Registry copyWith(
      {RegistryValue? uninstallCmd,
      RegistryValue? installDir,
      RegistryValue? version}) {
    return Platform$Registry(
        uninstallCmd: uninstallCmd ?? this.uninstallCmd,
        installDir: installDir ?? this.installDir,
        version: version ?? this.version);
  }

  Platform$Registry copyWithWrapped(
      {Wrapped<RegistryValue?>? uninstallCmd,
      Wrapped<RegistryValue?>? installDir,
      Wrapped<RegistryValue?>? version}) {
    return Platform$Registry(
        uninstallCmd:
            (uninstallCmd != null ? uninstallCmd.value : this.uninstallCmd),
        installDir: (installDir != null ? installDir.value : this.installDir),
        version: (version != null ? version.value : this.version));
  }
}

@JsonSerializable(explicitToJson: true)
class Platform$Links {
  Platform$Links({
    this.install,
    this.website,
  });

  factory Platform$Links.fromJson(Map<String, dynamic> json) =>
      _$Platform$LinksFromJson(json);

  @JsonKey(name: 'install')
  final String? install;
  @JsonKey(name: 'website')
  final String? website;
  static const fromJsonFactory = _$Platform$LinksFromJson;
  static const toJsonFactory = _$Platform$LinksToJson;
  Map<String, dynamic> toJson() => _$Platform$LinksToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Platform$Links &&
            (identical(other.install, install) ||
                const DeepCollectionEquality()
                    .equals(other.install, install)) &&
            (identical(other.website, website) ||
                const DeepCollectionEquality().equals(other.website, website)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(install) ^
      const DeepCollectionEquality().hash(website) ^
      runtimeType.hashCode;
}

extension $Platform$LinksExtension on Platform$Links {
  Platform$Links copyWith({String? install, String? website}) {
    return Platform$Links(
        install: install ?? this.install, website: website ?? this.website);
  }

  Platform$Links copyWithWrapped(
      {Wrapped<String?>? install, Wrapped<String?>? website}) {
    return Platform$Links(
        install: (install != null ? install.value : this.install),
        website: (website != null ? website.value : this.website));
  }
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
