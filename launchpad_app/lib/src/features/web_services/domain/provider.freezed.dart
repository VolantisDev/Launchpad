// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Provider _$ProviderFromJson(Map<String, dynamic> json) {
  return _Provider.fromJson(json);
}

/// @nodoc
mixin _$Provider {
  String get key => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProviderCopyWith<Provider> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderCopyWith<$Res> {
  factory $ProviderCopyWith(Provider value, $Res Function(Provider) then) =
      _$ProviderCopyWithImpl<$Res, Provider>;
  @useResult
  $Res call(
      {String key,
      String name,
      String type,
      String url,
      String icon,
      String color,
      String description});
}

/// @nodoc
class _$ProviderCopyWithImpl<$Res, $Val extends Provider>
    implements $ProviderCopyWith<$Res> {
  _$ProviderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? type = null,
    Object? url = null,
    Object? icon = null,
    Object? color = null,
    Object? description = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProviderCopyWith<$Res> implements $ProviderCopyWith<$Res> {
  factory _$$_ProviderCopyWith(
          _$_Provider value, $Res Function(_$_Provider) then) =
      __$$_ProviderCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String name,
      String type,
      String url,
      String icon,
      String color,
      String description});
}

/// @nodoc
class __$$_ProviderCopyWithImpl<$Res>
    extends _$ProviderCopyWithImpl<$Res, _$_Provider>
    implements _$$_ProviderCopyWith<$Res> {
  __$$_ProviderCopyWithImpl(
      _$_Provider _value, $Res Function(_$_Provider) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? type = null,
    Object? url = null,
    Object? icon = null,
    Object? color = null,
    Object? description = null,
  }) {
    return _then(_$_Provider(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Provider extends _Provider {
  const _$_Provider(
      {required this.key,
      required this.name,
      required this.type,
      required this.url,
      required this.icon,
      required this.color,
      required this.description})
      : super._();

  factory _$_Provider.fromJson(Map<String, dynamic> json) =>
      _$$_ProviderFromJson(json);

  @override
  final String key;
  @override
  final String name;
  @override
  final String type;
  @override
  final String url;
  @override
  final String icon;
  @override
  final String color;
  @override
  final String description;

  @override
  String toString() {
    return 'Provider(key: $key, name: $name, type: $type, url: $url, icon: $icon, color: $color, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Provider &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, key, name, type, url, icon, color, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProviderCopyWith<_$_Provider> get copyWith =>
      __$$_ProviderCopyWithImpl<_$_Provider>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProviderToJson(
      this,
    );
  }
}

abstract class _Provider extends Provider {
  const factory _Provider(
      {required final String key,
      required final String name,
      required final String type,
      required final String url,
      required final String icon,
      required final String color,
      required final String description}) = _$_Provider;
  const _Provider._() : super._();

  factory _Provider.fromJson(Map<String, dynamic> json) = _$_Provider.fromJson;

  @override
  String get key;
  @override
  String get name;
  @override
  String get type;
  @override
  String get url;
  @override
  String get icon;
  @override
  String get color;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$_ProviderCopyWith<_$_Provider> get copyWith =>
      throw _privateConstructorUsedError;
}
