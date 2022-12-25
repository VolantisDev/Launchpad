// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_platform.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GamePlatform _$GamePlatformFromJson(Map<String, dynamic> json) {
  return _GamePlatform.fromJson(json);
}

/// @nodoc
mixin _$GamePlatform {
  String get key => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get platformTypeId => throw _privateConstructorUsedError;
  String? get installDir => throw _privateConstructorUsedError;
  String? get exeFile => throw _privateConstructorUsedError;
  String? get iconPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GamePlatformCopyWith<GamePlatform> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamePlatformCopyWith<$Res> {
  factory $GamePlatformCopyWith(
          GamePlatform value, $Res Function(GamePlatform) then) =
      _$GamePlatformCopyWithImpl<$Res, GamePlatform>;
  @useResult
  $Res call(
      {String key,
      String name,
      String platformTypeId,
      String? installDir,
      String? exeFile,
      String? iconPath});
}

/// @nodoc
class _$GamePlatformCopyWithImpl<$Res, $Val extends GamePlatform>
    implements $GamePlatformCopyWith<$Res> {
  _$GamePlatformCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? platformTypeId = null,
    Object? installDir = freezed,
    Object? exeFile = freezed,
    Object? iconPath = freezed,
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
      platformTypeId: null == platformTypeId
          ? _value.platformTypeId
          : platformTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      installDir: freezed == installDir
          ? _value.installDir
          : installDir // ignore: cast_nullable_to_non_nullable
              as String?,
      exeFile: freezed == exeFile
          ? _value.exeFile
          : exeFile // ignore: cast_nullable_to_non_nullable
              as String?,
      iconPath: freezed == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GamePlatformCopyWith<$Res>
    implements $GamePlatformCopyWith<$Res> {
  factory _$$_GamePlatformCopyWith(
          _$_GamePlatform value, $Res Function(_$_GamePlatform) then) =
      __$$_GamePlatformCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String name,
      String platformTypeId,
      String? installDir,
      String? exeFile,
      String? iconPath});
}

/// @nodoc
class __$$_GamePlatformCopyWithImpl<$Res>
    extends _$GamePlatformCopyWithImpl<$Res, _$_GamePlatform>
    implements _$$_GamePlatformCopyWith<$Res> {
  __$$_GamePlatformCopyWithImpl(
      _$_GamePlatform _value, $Res Function(_$_GamePlatform) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? platformTypeId = null,
    Object? installDir = freezed,
    Object? exeFile = freezed,
    Object? iconPath = freezed,
  }) {
    return _then(_$_GamePlatform(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      platformTypeId: null == platformTypeId
          ? _value.platformTypeId
          : platformTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      installDir: freezed == installDir
          ? _value.installDir
          : installDir // ignore: cast_nullable_to_non_nullable
              as String?,
      exeFile: freezed == exeFile
          ? _value.exeFile
          : exeFile // ignore: cast_nullable_to_non_nullable
              as String?,
      iconPath: freezed == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GamePlatform extends _GamePlatform with DiagnosticableTreeMixin {
  const _$_GamePlatform(
      {required this.key,
      required this.name,
      required this.platformTypeId,
      this.installDir,
      this.exeFile,
      this.iconPath})
      : super._();

  factory _$_GamePlatform.fromJson(Map<String, dynamic> json) =>
      _$$_GamePlatformFromJson(json);

  @override
  final String key;
  @override
  final String name;
  @override
  final String platformTypeId;
  @override
  final String? installDir;
  @override
  final String? exeFile;
  @override
  final String? iconPath;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GamePlatform(key: $key, name: $name, platformTypeId: $platformTypeId, installDir: $installDir, exeFile: $exeFile, iconPath: $iconPath)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GamePlatform'))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('platformTypeId', platformTypeId))
      ..add(DiagnosticsProperty('installDir', installDir))
      ..add(DiagnosticsProperty('exeFile', exeFile))
      ..add(DiagnosticsProperty('iconPath', iconPath));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GamePlatform &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.platformTypeId, platformTypeId) ||
                other.platformTypeId == platformTypeId) &&
            (identical(other.installDir, installDir) ||
                other.installDir == installDir) &&
            (identical(other.exeFile, exeFile) || other.exeFile == exeFile) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, key, name, platformTypeId, installDir, exeFile, iconPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GamePlatformCopyWith<_$_GamePlatform> get copyWith =>
      __$$_GamePlatformCopyWithImpl<_$_GamePlatform>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GamePlatformToJson(
      this,
    );
  }
}

abstract class _GamePlatform extends GamePlatform {
  const factory _GamePlatform(
      {required final String key,
      required final String name,
      required final String platformTypeId,
      final String? installDir,
      final String? exeFile,
      final String? iconPath}) = _$_GamePlatform;
  const _GamePlatform._() : super._();

  factory _GamePlatform.fromJson(Map<String, dynamic> json) =
      _$_GamePlatform.fromJson;

  @override
  String get key;
  @override
  String get name;
  @override
  String get platformTypeId;
  @override
  String? get installDir;
  @override
  String? get exeFile;
  @override
  String? get iconPath;
  @override
  @JsonKey(ignore: true)
  _$$_GamePlatformCopyWith<_$_GamePlatform> get copyWith =>
      throw _privateConstructorUsedError;
}
