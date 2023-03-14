import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider.freezed.dart';

part 'provider.g.dart';

@freezed
class Provider with _$Provider {
  const Provider._();

  const factory Provider({
    required String key,
    required String name,
    required String type,
    required String url,
    required String icon,
    required String color,
    required String description,
  }) = _Provider;

  factory Provider.fromJson(Map<String, Object?> json) =>
      _$ProviderFromJson(json);
}
