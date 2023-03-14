// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'launch_process.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LaunchProcess _$LaunchProcessFromJson(Map<String, dynamic> json) {
  return _LaunchProcess.fromJson(json);
}

/// @nodoc
mixin _$LaunchProcess {
  String get processType => throw _privateConstructorUsedError;
  LaunchConfig get launchConfig => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LaunchProcessCopyWith<LaunchProcess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LaunchProcessCopyWith<$Res> {
  factory $LaunchProcessCopyWith(
          LaunchProcess value, $Res Function(LaunchProcess) then) =
      _$LaunchProcessCopyWithImpl<$Res, LaunchProcess>;
  @useResult
  $Res call({String processType, LaunchConfig launchConfig});

  $LaunchConfigCopyWith<$Res> get launchConfig;
}

/// @nodoc
class _$LaunchProcessCopyWithImpl<$Res, $Val extends LaunchProcess>
    implements $LaunchProcessCopyWith<$Res> {
  _$LaunchProcessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processType = null,
    Object? launchConfig = null,
  }) {
    return _then(_value.copyWith(
      processType: null == processType
          ? _value.processType
          : processType // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_LaunchProcessCopyWith<$Res>
    implements $LaunchProcessCopyWith<$Res> {
  factory _$$_LaunchProcessCopyWith(
          _$_LaunchProcess value, $Res Function(_$_LaunchProcess) then) =
      __$$_LaunchProcessCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String processType, LaunchConfig launchConfig});

  @override
  $LaunchConfigCopyWith<$Res> get launchConfig;
}

/// @nodoc
class __$$_LaunchProcessCopyWithImpl<$Res>
    extends _$LaunchProcessCopyWithImpl<$Res, _$_LaunchProcess>
    implements _$$_LaunchProcessCopyWith<$Res> {
  __$$_LaunchProcessCopyWithImpl(
      _$_LaunchProcess _value, $Res Function(_$_LaunchProcess) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processType = null,
    Object? launchConfig = null,
  }) {
    return _then(_$_LaunchProcess(
      processType: null == processType
          ? _value.processType
          : processType // ignore: cast_nullable_to_non_nullable
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
class _$_LaunchProcess extends _LaunchProcess with DiagnosticableTreeMixin {
  const _$_LaunchProcess(
      {required this.processType, required this.launchConfig})
      : super._();

  factory _$_LaunchProcess.fromJson(Map<String, dynamic> json) =>
      _$$_LaunchProcessFromJson(json);

  @override
  final String processType;
  @override
  final LaunchConfig launchConfig;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LaunchProcess(processType: $processType, launchConfig: $launchConfig)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LaunchProcess'))
      ..add(DiagnosticsProperty('processType', processType))
      ..add(DiagnosticsProperty('launchConfig', launchConfig));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LaunchProcess &&
            (identical(other.processType, processType) ||
                other.processType == processType) &&
            (identical(other.launchConfig, launchConfig) ||
                other.launchConfig == launchConfig));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, processType, launchConfig);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LaunchProcessCopyWith<_$_LaunchProcess> get copyWith =>
      __$$_LaunchProcessCopyWithImpl<_$_LaunchProcess>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LaunchProcessToJson(
      this,
    );
  }
}

abstract class _LaunchProcess extends LaunchProcess {
  const factory _LaunchProcess(
      {required final String processType,
      required final LaunchConfig launchConfig}) = _$_LaunchProcess;
  const _LaunchProcess._() : super._();

  factory _LaunchProcess.fromJson(Map<String, dynamic> json) =
      _$_LaunchProcess.fromJson;

  @override
  String get processType;
  @override
  LaunchConfig get launchConfig;
  @override
  @JsonKey(ignore: true)
  _$$_LaunchProcessCopyWith<_$_LaunchProcess> get copyWith =>
      throw _privateConstructorUsedError;
}
