// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'launch_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LaunchConfig _$LaunchConfigFromJson(Map<String, dynamic> json) {
  return _LaunchConfig.fromJson(json);
}

/// @nodoc
mixin _$LaunchConfig {
  String get type => throw _privateConstructorUsedError;
  String get gameId => throw _privateConstructorUsedError;
  String get gameKey => throw _privateConstructorUsedError;
  String get platformId => throw _privateConstructorUsedError;
  Map<String, Object?> get values => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LaunchConfigCopyWith<LaunchConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LaunchConfigCopyWith<$Res> {
  factory $LaunchConfigCopyWith(
          LaunchConfig value, $Res Function(LaunchConfig) then) =
      _$LaunchConfigCopyWithImpl<$Res, LaunchConfig>;
  @useResult
  $Res call(
      {String type,
      String gameId,
      String gameKey,
      String platformId,
      Map<String, Object?> values});
}

/// @nodoc
class _$LaunchConfigCopyWithImpl<$Res, $Val extends LaunchConfig>
    implements $LaunchConfigCopyWith<$Res> {
  _$LaunchConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? gameId = null,
    Object? gameKey = null,
    Object? platformId = null,
    Object? values = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      gameId: null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
      gameKey: null == gameKey
          ? _value.gameKey
          : gameKey // ignore: cast_nullable_to_non_nullable
              as String,
      platformId: null == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LaunchConfigCopyWith<$Res>
    implements $LaunchConfigCopyWith<$Res> {
  factory _$$_LaunchConfigCopyWith(
          _$_LaunchConfig value, $Res Function(_$_LaunchConfig) then) =
      __$$_LaunchConfigCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String gameId,
      String gameKey,
      String platformId,
      Map<String, Object?> values});
}

/// @nodoc
class __$$_LaunchConfigCopyWithImpl<$Res>
    extends _$LaunchConfigCopyWithImpl<$Res, _$_LaunchConfig>
    implements _$$_LaunchConfigCopyWith<$Res> {
  __$$_LaunchConfigCopyWithImpl(
      _$_LaunchConfig _value, $Res Function(_$_LaunchConfig) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? gameId = null,
    Object? gameKey = null,
    Object? platformId = null,
    Object? values = null,
  }) {
    return _then(_$_LaunchConfig(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      gameId: null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
      gameKey: null == gameKey
          ? _value.gameKey
          : gameKey // ignore: cast_nullable_to_non_nullable
              as String,
      platformId: null == platformId
          ? _value.platformId
          : platformId // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LaunchConfig extends _LaunchConfig with DiagnosticableTreeMixin {
  const _$_LaunchConfig(
      {required this.type,
      required this.gameId,
      required this.gameKey,
      required this.platformId,
      required final Map<String, Object?> values})
      : _values = values,
        super._();

  factory _$_LaunchConfig.fromJson(Map<String, dynamic> json) =>
      _$$_LaunchConfigFromJson(json);

  @override
  final String type;
  @override
  final String gameId;
  @override
  final String gameKey;
  @override
  final String platformId;
  final Map<String, Object?> _values;
  @override
  Map<String, Object?> get values {
    if (_values is EqualUnmodifiableMapView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_values);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LaunchConfig(type: $type, gameId: $gameId, gameKey: $gameKey, platformId: $platformId, values: $values)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LaunchConfig'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('gameId', gameId))
      ..add(DiagnosticsProperty('gameKey', gameKey))
      ..add(DiagnosticsProperty('platformId', platformId))
      ..add(DiagnosticsProperty('values', values));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LaunchConfig &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.gameKey, gameKey) || other.gameKey == gameKey) &&
            (identical(other.platformId, platformId) ||
                other.platformId == platformId) &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, gameId, gameKey,
      platformId, const DeepCollectionEquality().hash(_values));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LaunchConfigCopyWith<_$_LaunchConfig> get copyWith =>
      __$$_LaunchConfigCopyWithImpl<_$_LaunchConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LaunchConfigToJson(
      this,
    );
  }
}

abstract class _LaunchConfig extends LaunchConfig {
  const factory _LaunchConfig(
      {required final String type,
      required final String gameId,
      required final String gameKey,
      required final String platformId,
      required final Map<String, Object?> values}) = _$_LaunchConfig;
  const _LaunchConfig._() : super._();

  factory _LaunchConfig.fromJson(Map<String, dynamic> json) =
      _$_LaunchConfig.fromJson;

  @override
  String get type;
  @override
  String get gameId;
  @override
  String get gameKey;
  @override
  String get platformId;
  @override
  Map<String, Object?> get values;
  @override
  @JsonKey(ignore: true)
  _$$_LaunchConfigCopyWith<_$_LaunchConfig> get copyWith =>
      throw _privateConstructorUsedError;
}
