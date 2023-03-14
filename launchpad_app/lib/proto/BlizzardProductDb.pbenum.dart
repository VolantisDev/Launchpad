///
//  Generated code. Do not modify.
//  source: BlizzardProductDb.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class UserSettings_ShortcutOption extends $pb.ProtobufEnum {
  static const UserSettings_ShortcutOption SHORTCUT_NONE = UserSettings_ShortcutOption._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SHORTCUT_NONE');
  static const UserSettings_ShortcutOption SHORTCUT_USER = UserSettings_ShortcutOption._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SHORTCUT_USER');
  static const UserSettings_ShortcutOption SHORTCUT_ALL_USERS = UserSettings_ShortcutOption._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SHORTCUT_ALL_USERS');

  static const $core.List<UserSettings_ShortcutOption> values = <UserSettings_ShortcutOption> [
    SHORTCUT_NONE,
    SHORTCUT_USER,
    SHORTCUT_ALL_USERS,
  ];

  static final $core.Map<$core.int, UserSettings_ShortcutOption> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserSettings_ShortcutOption? valueOf($core.int value) => _byValue[value];

  const UserSettings_ShortcutOption._($core.int v, $core.String n) : super(v, n);
}

class UserSettings_LanguageSettingType extends $pb.ProtobufEnum {
  static const UserSettings_LanguageSettingType LANGSETTING_NONE = UserSettings_LanguageSettingType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LANGSETTING_NONE');
  static const UserSettings_LanguageSettingType LANGSETING_SINGLE = UserSettings_LanguageSettingType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LANGSETING_SINGLE');
  static const UserSettings_LanguageSettingType LANGSETTING_SIMPLE = UserSettings_LanguageSettingType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LANGSETTING_SIMPLE');
  static const UserSettings_LanguageSettingType LANGSETTING_ADVANCED = UserSettings_LanguageSettingType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LANGSETTING_ADVANCED');

  static const $core.List<UserSettings_LanguageSettingType> values = <UserSettings_LanguageSettingType> [
    LANGSETTING_NONE,
    LANGSETING_SINGLE,
    LANGSETTING_SIMPLE,
    LANGSETTING_ADVANCED,
  ];

  static final $core.Map<$core.int, UserSettings_LanguageSettingType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserSettings_LanguageSettingType? valueOf($core.int value) => _byValue[value];

  const UserSettings_LanguageSettingType._($core.int v, $core.String n) : super(v, n);
}

class LanguageSetting_LanguageOption extends $pb.ProtobufEnum {
  static const LanguageSetting_LanguageOption LANGOPTION_NONE = LanguageSetting_LanguageOption._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LANGOPTION_NONE');
  static const LanguageSetting_LanguageOption LANGOPTION_TEXT = LanguageSetting_LanguageOption._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LANGOPTION_TEXT');
  static const LanguageSetting_LanguageOption LANGOPTION_SPEECH = LanguageSetting_LanguageOption._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LANGOPTION_SPEECH');
  static const LanguageSetting_LanguageOption LANGOPTION_TEXT_AND_SPEECH = LanguageSetting_LanguageOption._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LANGOPTION_TEXT_AND_SPEECH');

  static const $core.List<LanguageSetting_LanguageOption> values = <LanguageSetting_LanguageOption> [
    LANGOPTION_NONE,
    LANGOPTION_TEXT,
    LANGOPTION_SPEECH,
    LANGOPTION_TEXT_AND_SPEECH,
  ];

  static final $core.Map<$core.int, LanguageSetting_LanguageOption> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LanguageSetting_LanguageOption? valueOf($core.int value) => _byValue[value];

  const LanguageSetting_LanguageOption._($core.int v, $core.String n) : super(v, n);
}

class ProductOperations_Operation extends $pb.ProtobufEnum {
  static const ProductOperations_Operation OP_UPDATE = ProductOperations_Operation._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OP_UPDATE');
  static const ProductOperations_Operation OP_BACKFILL = ProductOperations_Operation._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OP_BACKFILL');
  static const ProductOperations_Operation OP_REPAIR = ProductOperations_Operation._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OP_REPAIR');

  static const $core.List<ProductOperations_Operation> values = <ProductOperations_Operation> [
    OP_UPDATE,
    OP_BACKFILL,
    OP_REPAIR,
  ];

  static final $core.Map<$core.int, ProductOperations_Operation> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ProductOperations_Operation? valueOf($core.int value) => _byValue[value];

  const ProductOperations_Operation._($core.int v, $core.String n) : super(v, n);
}

