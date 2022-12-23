// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Game _$GameFromJson(Map<String, dynamic> json) {
  return _Game.fromJson(json);
}

/// @nodoc
mixin _$Game {
  String get key => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get platformId => throw _privateConstructorUsedError;
  String get installDir => throw _privateConstructorUsedError;
  String get exeFile => throw _privateConstructorUsedError;
  LaunchConfig get launchConfig => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameCopyWith<Game> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res, Game>;
  @useResult
  $Res call(
      {String key,
      String name,
      String platformId,
      String installDir,
      String exeFile,
      LaunchConfig launchConfig});

  $LaunchConfigCopyWith<$Res> get launchConfig;
}

/// @nodoc
class _$GameCopyWithImpl<$Res, $Val extends Game>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? platformId = null,
    Object? installDir = null,
    Object? exeFile = null,
    Object? launchConfig = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      platformId: null == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String,
      installDir: null == installDir
          ? _value.installDir
          : installDir // ignore: cast_nullable_to_non_nullable
              as String,
      exeFile: null == exeFile
          ? _value.exeFile
          : exeFile // ignore: cast_nullable_to_non_nullable
              as String,
      launchConfig: null == launchConfig
          ? _value.launchConfig
          : launchConfig // ignore: cast_nullable_to_non_nullable
              as LaunchConfig,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LaunchConfigCopyWith<$Res> get launchConfig {
    return $LaunchConfigCopyWith<$Res>(_value.launchConfig, (value) {
      return _then(_value.copyWith(launchConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GameCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$$_GameCopyWith(_$_Game value, $Res Function(_$_Game) then) =
      __$$_GameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String name,
      String platformId,
      String installDir,
      String exeFile,
      LaunchConfig launchConfig});

  @override
  $LaunchConfigCopyWith<$Res> get launchConfig;
}

/// @nodoc
class __$$_GameCopyWithImpl<$Res> extends _$GameCopyWithImpl<$Res, _$_Game>
    implements _$$_GameCopyWith<$Res> {
  __$$_GameCopyWithImpl(_$_Game _value, $Res Function(_$_Game) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? platformId = null,
    Object? installDir = null,
    Object? exeFile = null,
    Object? launchConfig = null,
  }) {
    return _then(_$_Game(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      platformId: null == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String,
      installDir: null == installDir
          ? _value.installDir
          : installDir // ignore: cast_nullable_to_non_nullable
              as String,
      exeFile: null == exeFile
          ? _value.exeFile
          : exeFile // ignore: cast_nullable_to_non_nullable
              as String,
      launchConfig: null == launchConfig
          ? _value.launchConfig
          : launchConfig // ignore: cast_nullable_to_non_nullable
              as LaunchConfig,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Game with DiagnosticableTreeMixin implements _Game {
  const _$_Game(
      {required this.key,
      required this.name,
      required this.platformId,
      required this.installDir,
      required this.exeFile,
      required this.launchConfig});

  factory _$_Game.fromJson(Map<String, dynamic> json) => _$$_GameFromJson(json);

  @override
  final String key;
  @override
  final String name;
  @override
  final String platformId;
  @override
  final String installDir;
  @override
  final String exeFile;
  @override
  final LaunchConfig launchConfig;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Game(key: $key, name: $name, platformId: $platformId, installDir: $installDir, exeFile: $exeFile, launchConfig: $launchConfig)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Game'))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('platformId', platformId))
      ..add(DiagnosticsProperty('installDir', installDir))
      ..add(DiagnosticsProperty('exeFile', exeFile))
      ..add(DiagnosticsProperty('launchConfig', launchConfig));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Game &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.platformId, platformId) ||
                other.platformId == platformId) &&
            (identical(other.installDir, installDir) ||
                other.installDir == installDir) &&
            (identical(other.exeFile, exeFile) || other.exeFile == exeFile) &&
            (identical(other.launchConfig, launchConfig) ||
                other.launchConfig == launchConfig));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, key, name, platformId, installDir, exeFile, launchConfig);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GameCopyWith<_$_Game> get copyWith =>
      __$$_GameCopyWithImpl<_$_Game>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GameToJson(
      this,
    );
  }
}

abstract class _Game implements Game {
  const factory _Game(
      {required final String key,
      required final String name,
      required final String platformId,
      required final String installDir,
      required final String exeFile,
      required final LaunchConfig launchConfig}) = _$_Game;

  factory _Game.fromJson(Map<String, dynamic> json) = _$_Game.fromJson;

  @override
  String get key;
  @override
  String get name;
  @override
  String get platformId;
  @override
  String get installDir;
  @override
  String get exeFile;
  @override
  LaunchConfig get launchConfig;
  @override
  @JsonKey(ignore: true)
  _$$_GameCopyWith<_$_Game> get copyWith => throw _privateConstructorUsedError;
}
