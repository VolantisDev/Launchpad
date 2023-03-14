///
//  Generated code. Do not modify.
//  source: BlizzardProductDb.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'BlizzardProductDb.pbenum.dart';

export 'BlizzardProductDb.pbenum.dart';

class ProductInstall extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProductInstall', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productCode', protoName: 'productCode')
    ..aOM<UserSettings>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'settings', subBuilder: UserSettings.create)
    ..aOM<CachedProductState>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cachedProductState', protoName: 'cachedProductState', subBuilder: CachedProductState.create)
    ..aOM<ProductOperations>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productOperations', protoName: 'productOperations', subBuilder: ProductOperations.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keyword')
    ..hasRequiredFields = false
  ;

  ProductInstall._() : super();
  factory ProductInstall({
    $core.String? uid,
    $core.String? productCode,
    UserSettings? settings,
    CachedProductState? cachedProductState,
    ProductOperations? productOperations,
    $core.String? keyword,
  }) {
    final _result = create();
    if (uid != null) {
      _result.uid = uid;
    }
    if (productCode != null) {
      _result.productCode = productCode;
    }
    if (settings != null) {
      _result.settings = settings;
    }
    if (cachedProductState != null) {
      _result.cachedProductState = cachedProductState;
    }
    if (productOperations != null) {
      _result.productOperations = productOperations;
    }
    if (keyword != null) {
      _result.keyword = keyword;
    }
    return _result;
  }
  factory ProductInstall.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProductInstall.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProductInstall clone() => ProductInstall()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProductInstall copyWith(void Function(ProductInstall) updates) => super.copyWith((message) => updates(message as ProductInstall)) as ProductInstall; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProductInstall create() => ProductInstall._();
  ProductInstall createEmptyInstance() => create();
  static $pb.PbList<ProductInstall> createRepeated() => $pb.PbList<ProductInstall>();
  @$core.pragma('dart2js:noInline')
  static ProductInstall getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProductInstall>(create);
  static ProductInstall? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get productCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set productCode($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProductCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductCode() => clearField(2);

  @$pb.TagNumber(3)
  UserSettings get settings => $_getN(2);
  @$pb.TagNumber(3)
  set settings(UserSettings v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSettings() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettings() => clearField(3);
  @$pb.TagNumber(3)
  UserSettings ensureSettings() => $_ensure(2);

  @$pb.TagNumber(4)
  CachedProductState get cachedProductState => $_getN(3);
  @$pb.TagNumber(4)
  set cachedProductState(CachedProductState v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCachedProductState() => $_has(3);
  @$pb.TagNumber(4)
  void clearCachedProductState() => clearField(4);
  @$pb.TagNumber(4)
  CachedProductState ensureCachedProductState() => $_ensure(3);

  @$pb.TagNumber(5)
  ProductOperations get productOperations => $_getN(4);
  @$pb.TagNumber(5)
  set productOperations(ProductOperations v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasProductOperations() => $_has(4);
  @$pb.TagNumber(5)
  void clearProductOperations() => clearField(5);
  @$pb.TagNumber(5)
  ProductOperations ensureProductOperations() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get keyword => $_getSZ(5);
  @$pb.TagNumber(6)
  set keyword($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasKeyword() => $_has(5);
  @$pb.TagNumber(6)
  void clearKeyword() => clearField(6);
}

class UserSettings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserSettings', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'installPath', protoName: 'installPath')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playRegion', protoName: 'playRegion')
    ..e<UserSettings_ShortcutOption>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'desktopShortcut', $pb.PbFieldType.OE, protoName: 'desktopShortcut', defaultOrMaker: UserSettings_ShortcutOption.SHORTCUT_NONE, valueOf: UserSettings_ShortcutOption.valueOf, enumValues: UserSettings_ShortcutOption.values)
    ..e<UserSettings_ShortcutOption>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startmenuShortcut', $pb.PbFieldType.OE, protoName: 'startmenuShortcut', defaultOrMaker: UserSettings_ShortcutOption.SHORTCUT_NONE, valueOf: UserSettings_ShortcutOption.valueOf, enumValues: UserSettings_ShortcutOption.values)
    ..e<UserSettings_LanguageSettingType>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'languageSettings', $pb.PbFieldType.OE, protoName: 'languageSettings', defaultOrMaker: UserSettings_LanguageSettingType.LANGSETTING_NONE, valueOf: UserSettings_LanguageSettingType.valueOf, enumValues: UserSettings_LanguageSettingType.values)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selectedTextLanguage', protoName: 'selectedTextLanguage')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selectedSpeechLanguage', protoName: 'selectedSpeechLanguage')
    ..pc<LanguageSetting>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'languages', $pb.PbFieldType.PM, subBuilder: LanguageSetting.create)
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gfxOverrideTags', protoName: 'gfxOverrideTags')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'versionbranch')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'countryCode3Letter', protoName: 'countryCode3Letter')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'countryCode2Letter', protoName: 'countryCode2Letter')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productExtra', protoName: 'productExtra')
    ..hasRequiredFields = false
  ;

  UserSettings._() : super();
  factory UserSettings({
    $core.String? installPath,
    $core.String? playRegion,
    UserSettings_ShortcutOption? desktopShortcut,
    UserSettings_ShortcutOption? startmenuShortcut,
    UserSettings_LanguageSettingType? languageSettings,
    $core.String? selectedTextLanguage,
    $core.String? selectedSpeechLanguage,
    $core.Iterable<LanguageSetting>? languages,
    $core.String? gfxOverrideTags,
    $core.String? versionbranch,
    $core.String? countryCode3Letter,
    $core.String? countryCode2Letter,
    $core.String? productExtra,
  }) {
    final _result = create();
    if (installPath != null) {
      _result.installPath = installPath;
    }
    if (playRegion != null) {
      _result.playRegion = playRegion;
    }
    if (desktopShortcut != null) {
      _result.desktopShortcut = desktopShortcut;
    }
    if (startmenuShortcut != null) {
      _result.startmenuShortcut = startmenuShortcut;
    }
    if (languageSettings != null) {
      _result.languageSettings = languageSettings;
    }
    if (selectedTextLanguage != null) {
      _result.selectedTextLanguage = selectedTextLanguage;
    }
    if (selectedSpeechLanguage != null) {
      _result.selectedSpeechLanguage = selectedSpeechLanguage;
    }
    if (languages != null) {
      _result.languages.addAll(languages);
    }
    if (gfxOverrideTags != null) {
      _result.gfxOverrideTags = gfxOverrideTags;
    }
    if (versionbranch != null) {
      _result.versionbranch = versionbranch;
    }
    if (countryCode3Letter != null) {
      _result.countryCode3Letter = countryCode3Letter;
    }
    if (countryCode2Letter != null) {
      _result.countryCode2Letter = countryCode2Letter;
    }
    if (productExtra != null) {
      _result.productExtra = productExtra;
    }
    return _result;
  }
  factory UserSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserSettings clone() => UserSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserSettings copyWith(void Function(UserSettings) updates) => super.copyWith((message) => updates(message as UserSettings)) as UserSettings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserSettings create() => UserSettings._();
  UserSettings createEmptyInstance() => create();
  static $pb.PbList<UserSettings> createRepeated() => $pb.PbList<UserSettings>();
  @$core.pragma('dart2js:noInline')
  static UserSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserSettings>(create);
  static UserSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get installPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set installPath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInstallPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get playRegion => $_getSZ(1);
  @$pb.TagNumber(2)
  set playRegion($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayRegion() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayRegion() => clearField(2);

  @$pb.TagNumber(3)
  UserSettings_ShortcutOption get desktopShortcut => $_getN(2);
  @$pb.TagNumber(3)
  set desktopShortcut(UserSettings_ShortcutOption v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDesktopShortcut() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesktopShortcut() => clearField(3);

  @$pb.TagNumber(4)
  UserSettings_ShortcutOption get startmenuShortcut => $_getN(3);
  @$pb.TagNumber(4)
  set startmenuShortcut(UserSettings_ShortcutOption v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStartmenuShortcut() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartmenuShortcut() => clearField(4);

  @$pb.TagNumber(5)
  UserSettings_LanguageSettingType get languageSettings => $_getN(4);
  @$pb.TagNumber(5)
  set languageSettings(UserSettings_LanguageSettingType v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasLanguageSettings() => $_has(4);
  @$pb.TagNumber(5)
  void clearLanguageSettings() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get selectedTextLanguage => $_getSZ(5);
  @$pb.TagNumber(6)
  set selectedTextLanguage($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSelectedTextLanguage() => $_has(5);
  @$pb.TagNumber(6)
  void clearSelectedTextLanguage() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get selectedSpeechLanguage => $_getSZ(6);
  @$pb.TagNumber(7)
  set selectedSpeechLanguage($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSelectedSpeechLanguage() => $_has(6);
  @$pb.TagNumber(7)
  void clearSelectedSpeechLanguage() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<LanguageSetting> get languages => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get gfxOverrideTags => $_getSZ(8);
  @$pb.TagNumber(9)
  set gfxOverrideTags($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasGfxOverrideTags() => $_has(8);
  @$pb.TagNumber(9)
  void clearGfxOverrideTags() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get versionbranch => $_getSZ(9);
  @$pb.TagNumber(10)
  set versionbranch($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasVersionbranch() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersionbranch() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get countryCode3Letter => $_getSZ(10);
  @$pb.TagNumber(11)
  set countryCode3Letter($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCountryCode3Letter() => $_has(10);
  @$pb.TagNumber(11)
  void clearCountryCode3Letter() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get countryCode2Letter => $_getSZ(11);
  @$pb.TagNumber(12)
  set countryCode2Letter($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasCountryCode2Letter() => $_has(11);
  @$pb.TagNumber(12)
  void clearCountryCode2Letter() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get productExtra => $_getSZ(12);
  @$pb.TagNumber(13)
  set productExtra($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasProductExtra() => $_has(12);
  @$pb.TagNumber(13)
  void clearProductExtra() => clearField(13);
}

class LanguageSetting extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LanguageSetting', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'language')
    ..e<LanguageSetting_LanguageOption>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'option', $pb.PbFieldType.OE, defaultOrMaker: LanguageSetting_LanguageOption.LANGOPTION_NONE, valueOf: LanguageSetting_LanguageOption.valueOf, enumValues: LanguageSetting_LanguageOption.values)
    ..hasRequiredFields = false
  ;

  LanguageSetting._() : super();
  factory LanguageSetting({
    $core.String? language,
    LanguageSetting_LanguageOption? option,
  }) {
    final _result = create();
    if (language != null) {
      _result.language = language;
    }
    if (option != null) {
      _result.option = option;
    }
    return _result;
  }
  factory LanguageSetting.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LanguageSetting.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LanguageSetting clone() => LanguageSetting()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LanguageSetting copyWith(void Function(LanguageSetting) updates) => super.copyWith((message) => updates(message as LanguageSetting)) as LanguageSetting; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LanguageSetting create() => LanguageSetting._();
  LanguageSetting createEmptyInstance() => create();
  static $pb.PbList<LanguageSetting> createRepeated() => $pb.PbList<LanguageSetting>();
  @$core.pragma('dart2js:noInline')
  static LanguageSetting getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LanguageSetting>(create);
  static LanguageSetting? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get language => $_getSZ(0);
  @$pb.TagNumber(1)
  set language($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLanguage() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanguage() => clearField(1);

  @$pb.TagNumber(2)
  LanguageSetting_LanguageOption get option => $_getN(1);
  @$pb.TagNumber(2)
  set option(LanguageSetting_LanguageOption v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOption() => $_has(1);
  @$pb.TagNumber(2)
  void clearOption() => clearField(2);
}

class CachedProductState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CachedProductState', createEmptyInstance: create)
    ..aOM<BaseProductState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'baseProductState', protoName: 'baseProductState', subBuilder: BaseProductState.create)
    ..aOM<BackfillProgress>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backfillProgress', protoName: 'backfillProgress', subBuilder: BackfillProgress.create)
    ..aOM<RepairProgress>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'repairProgress', protoName: 'repairProgress', subBuilder: RepairProgress.create)
    ..aOM<UpdateProgress>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateProgress', protoName: 'updateProgress', subBuilder: UpdateProgress.create)
    ..hasRequiredFields = false
  ;

  CachedProductState._() : super();
  factory CachedProductState({
    BaseProductState? baseProductState,
    BackfillProgress? backfillProgress,
    RepairProgress? repairProgress,
    UpdateProgress? updateProgress,
  }) {
    final _result = create();
    if (baseProductState != null) {
      _result.baseProductState = baseProductState;
    }
    if (backfillProgress != null) {
      _result.backfillProgress = backfillProgress;
    }
    if (repairProgress != null) {
      _result.repairProgress = repairProgress;
    }
    if (updateProgress != null) {
      _result.updateProgress = updateProgress;
    }
    return _result;
  }
  factory CachedProductState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CachedProductState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CachedProductState clone() => CachedProductState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CachedProductState copyWith(void Function(CachedProductState) updates) => super.copyWith((message) => updates(message as CachedProductState)) as CachedProductState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CachedProductState create() => CachedProductState._();
  CachedProductState createEmptyInstance() => create();
  static $pb.PbList<CachedProductState> createRepeated() => $pb.PbList<CachedProductState>();
  @$core.pragma('dart2js:noInline')
  static CachedProductState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CachedProductState>(create);
  static CachedProductState? _defaultInstance;

  @$pb.TagNumber(1)
  BaseProductState get baseProductState => $_getN(0);
  @$pb.TagNumber(1)
  set baseProductState(BaseProductState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBaseProductState() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseProductState() => clearField(1);
  @$pb.TagNumber(1)
  BaseProductState ensureBaseProductState() => $_ensure(0);

  @$pb.TagNumber(2)
  BackfillProgress get backfillProgress => $_getN(1);
  @$pb.TagNumber(2)
  set backfillProgress(BackfillProgress v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBackfillProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearBackfillProgress() => clearField(2);
  @$pb.TagNumber(2)
  BackfillProgress ensureBackfillProgress() => $_ensure(1);

  @$pb.TagNumber(3)
  RepairProgress get repairProgress => $_getN(2);
  @$pb.TagNumber(3)
  set repairProgress(RepairProgress v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRepairProgress() => $_has(2);
  @$pb.TagNumber(3)
  void clearRepairProgress() => clearField(3);
  @$pb.TagNumber(3)
  RepairProgress ensureRepairProgress() => $_ensure(2);

  @$pb.TagNumber(4)
  UpdateProgress get updateProgress => $_getN(3);
  @$pb.TagNumber(4)
  set updateProgress(UpdateProgress v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasUpdateProgress() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdateProgress() => clearField(4);
  @$pb.TagNumber(4)
  UpdateProgress ensureUpdateProgress() => $_ensure(3);
}

class BaseProductState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BaseProductState', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'installed')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playable')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateComplete', protoName: 'updateComplete')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundDownloadAvailable', protoName: 'backgroundDownloadAvailable')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundDownloadComplete', protoName: 'backgroundDownloadComplete')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentVersion', protoName: 'currentVersion')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentVersionStr', protoName: 'currentVersionStr')
    ..pc<BuildConfig>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'installedBuildConfig', $pb.PbFieldType.PM, protoName: 'installedBuildConfig', subBuilder: BuildConfig.create)
    ..pc<BuildConfig>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundDownloadBuildConfig', $pb.PbFieldType.PM, protoName: 'backgroundDownloadBuildConfig', subBuilder: BuildConfig.create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'decryptionKey', protoName: 'decryptionKey')
    ..pPS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'completedInstallActions', protoName: 'completedInstallActions')
    ..aOS(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tags')
    ..hasRequiredFields = false
  ;

  BaseProductState._() : super();
  factory BaseProductState({
    $core.bool? installed,
    $core.bool? playable,
    $core.bool? updateComplete,
    $core.bool? backgroundDownloadAvailable,
    $core.bool? backgroundDownloadComplete,
    $core.String? currentVersion,
    $core.String? currentVersionStr,
    $core.Iterable<BuildConfig>? installedBuildConfig,
    $core.Iterable<BuildConfig>? backgroundDownloadBuildConfig,
    $core.String? decryptionKey,
    $core.Iterable<$core.String>? completedInstallActions,
    $core.String? tags,
  }) {
    final _result = create();
    if (installed != null) {
      _result.installed = installed;
    }
    if (playable != null) {
      _result.playable = playable;
    }
    if (updateComplete != null) {
      _result.updateComplete = updateComplete;
    }
    if (backgroundDownloadAvailable != null) {
      _result.backgroundDownloadAvailable = backgroundDownloadAvailable;
    }
    if (backgroundDownloadComplete != null) {
      _result.backgroundDownloadComplete = backgroundDownloadComplete;
    }
    if (currentVersion != null) {
      _result.currentVersion = currentVersion;
    }
    if (currentVersionStr != null) {
      _result.currentVersionStr = currentVersionStr;
    }
    if (installedBuildConfig != null) {
      _result.installedBuildConfig.addAll(installedBuildConfig);
    }
    if (backgroundDownloadBuildConfig != null) {
      _result.backgroundDownloadBuildConfig.addAll(backgroundDownloadBuildConfig);
    }
    if (decryptionKey != null) {
      _result.decryptionKey = decryptionKey;
    }
    if (completedInstallActions != null) {
      _result.completedInstallActions.addAll(completedInstallActions);
    }
    if (tags != null) {
      _result.tags = tags;
    }
    return _result;
  }
  factory BaseProductState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BaseProductState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BaseProductState clone() => BaseProductState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BaseProductState copyWith(void Function(BaseProductState) updates) => super.copyWith((message) => updates(message as BaseProductState)) as BaseProductState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BaseProductState create() => BaseProductState._();
  BaseProductState createEmptyInstance() => create();
  static $pb.PbList<BaseProductState> createRepeated() => $pb.PbList<BaseProductState>();
  @$core.pragma('dart2js:noInline')
  static BaseProductState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BaseProductState>(create);
  static BaseProductState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get installed => $_getBF(0);
  @$pb.TagNumber(1)
  set installed($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInstalled() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstalled() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get playable => $_getBF(1);
  @$pb.TagNumber(2)
  set playable($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayable() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayable() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get updateComplete => $_getBF(2);
  @$pb.TagNumber(3)
  set updateComplete($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdateComplete() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdateComplete() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get backgroundDownloadAvailable => $_getBF(3);
  @$pb.TagNumber(4)
  set backgroundDownloadAvailable($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBackgroundDownloadAvailable() => $_has(3);
  @$pb.TagNumber(4)
  void clearBackgroundDownloadAvailable() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get backgroundDownloadComplete => $_getBF(4);
  @$pb.TagNumber(5)
  set backgroundDownloadComplete($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBackgroundDownloadComplete() => $_has(4);
  @$pb.TagNumber(5)
  void clearBackgroundDownloadComplete() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get currentVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set currentVersion($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCurrentVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrentVersion() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get currentVersionStr => $_getSZ(6);
  @$pb.TagNumber(7)
  set currentVersionStr($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCurrentVersionStr() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentVersionStr() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<BuildConfig> get installedBuildConfig => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<BuildConfig> get backgroundDownloadBuildConfig => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get decryptionKey => $_getSZ(9);
  @$pb.TagNumber(10)
  set decryptionKey($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDecryptionKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearDecryptionKey() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.String> get completedInstallActions => $_getList(10);

  @$pb.TagNumber(17)
  $core.String get tags => $_getSZ(11);
  @$pb.TagNumber(17)
  set tags($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(17)
  $core.bool hasTags() => $_has(11);
  @$pb.TagNumber(17)
  void clearTags() => clearField(17);
}

class BuildConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BuildConfig', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'region')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'buildConfig', protoName: 'buildConfig')
    ..hasRequiredFields = false
  ;

  BuildConfig._() : super();
  factory BuildConfig({
    $core.String? region,
    $core.String? buildConfig,
  }) {
    final _result = create();
    if (region != null) {
      _result.region = region;
    }
    if (buildConfig != null) {
      _result.buildConfig = buildConfig;
    }
    return _result;
  }
  factory BuildConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BuildConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BuildConfig clone() => BuildConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BuildConfig copyWith(void Function(BuildConfig) updates) => super.copyWith((message) => updates(message as BuildConfig)) as BuildConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BuildConfig create() => BuildConfig._();
  BuildConfig createEmptyInstance() => create();
  static $pb.PbList<BuildConfig> createRepeated() => $pb.PbList<BuildConfig>();
  @$core.pragma('dart2js:noInline')
  static BuildConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BuildConfig>(create);
  static BuildConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get region => $_getSZ(0);
  @$pb.TagNumber(1)
  set region($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRegion() => $_has(0);
  @$pb.TagNumber(1)
  void clearRegion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get buildConfig => $_getSZ(1);
  @$pb.TagNumber(2)
  set buildConfig($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBuildConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearBuildConfig() => clearField(2);
}

class BackfillProgress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BackfillProgress', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'progress', $pb.PbFieldType.OD)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgrounddownload')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paused')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'downloadLimit', protoName: 'downloadLimit')
    ..hasRequiredFields = false
  ;

  BackfillProgress._() : super();
  factory BackfillProgress({
    $core.double? progress,
    $core.bool? backgrounddownload,
    $core.bool? paused,
    $core.bool? downloadLimit,
  }) {
    final _result = create();
    if (progress != null) {
      _result.progress = progress;
    }
    if (backgrounddownload != null) {
      _result.backgrounddownload = backgrounddownload;
    }
    if (paused != null) {
      _result.paused = paused;
    }
    if (downloadLimit != null) {
      _result.downloadLimit = downloadLimit;
    }
    return _result;
  }
  factory BackfillProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BackfillProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BackfillProgress clone() => BackfillProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BackfillProgress copyWith(void Function(BackfillProgress) updates) => super.copyWith((message) => updates(message as BackfillProgress)) as BackfillProgress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BackfillProgress create() => BackfillProgress._();
  BackfillProgress createEmptyInstance() => create();
  static $pb.PbList<BackfillProgress> createRepeated() => $pb.PbList<BackfillProgress>();
  @$core.pragma('dart2js:noInline')
  static BackfillProgress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackfillProgress>(create);
  static BackfillProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get backgrounddownload => $_getBF(1);
  @$pb.TagNumber(2)
  set backgrounddownload($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBackgrounddownload() => $_has(1);
  @$pb.TagNumber(2)
  void clearBackgrounddownload() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get paused => $_getBF(2);
  @$pb.TagNumber(3)
  set paused($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPaused() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaused() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get downloadLimit => $_getBF(3);
  @$pb.TagNumber(4)
  set downloadLimit($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDownloadLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearDownloadLimit() => clearField(4);
}

class RepairProgress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RepairProgress', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'progress', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  RepairProgress._() : super();
  factory RepairProgress({
    $core.double? progress,
  }) {
    final _result = create();
    if (progress != null) {
      _result.progress = progress;
    }
    return _result;
  }
  factory RepairProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RepairProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RepairProgress clone() => RepairProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RepairProgress copyWith(void Function(RepairProgress) updates) => super.copyWith((message) => updates(message as RepairProgress)) as RepairProgress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RepairProgress create() => RepairProgress._();
  RepairProgress createEmptyInstance() => create();
  static $pb.PbList<RepairProgress> createRepeated() => $pb.PbList<RepairProgress>();
  @$core.pragma('dart2js:noInline')
  static RepairProgress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RepairProgress>(create);
  static RepairProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => clearField(1);
}

class UpdateProgress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateProgress', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastDiscSetUsed', protoName: 'lastDiscSetUsed')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'progress', $pb.PbFieldType.OD)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'discIgnored', protoName: 'discIgnored')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalToDownload', $pb.PbFieldType.OU6, protoName: 'totalToDownload', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  UpdateProgress._() : super();
  factory UpdateProgress({
    $core.String? lastDiscSetUsed,
    $core.double? progress,
    $core.bool? discIgnored,
    $fixnum.Int64? totalToDownload,
  }) {
    final _result = create();
    if (lastDiscSetUsed != null) {
      _result.lastDiscSetUsed = lastDiscSetUsed;
    }
    if (progress != null) {
      _result.progress = progress;
    }
    if (discIgnored != null) {
      _result.discIgnored = discIgnored;
    }
    if (totalToDownload != null) {
      _result.totalToDownload = totalToDownload;
    }
    return _result;
  }
  factory UpdateProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateProgress clone() => UpdateProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateProgress copyWith(void Function(UpdateProgress) updates) => super.copyWith((message) => updates(message as UpdateProgress)) as UpdateProgress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateProgress create() => UpdateProgress._();
  UpdateProgress createEmptyInstance() => create();
  static $pb.PbList<UpdateProgress> createRepeated() => $pb.PbList<UpdateProgress>();
  @$core.pragma('dart2js:noInline')
  static UpdateProgress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateProgress>(create);
  static UpdateProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lastDiscSetUsed => $_getSZ(0);
  @$pb.TagNumber(1)
  set lastDiscSetUsed($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLastDiscSetUsed() => $_has(0);
  @$pb.TagNumber(1)
  void clearLastDiscSetUsed() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get progress => $_getN(1);
  @$pb.TagNumber(2)
  set progress($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get discIgnored => $_getBF(2);
  @$pb.TagNumber(3)
  set discIgnored($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDiscIgnored() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscIgnored() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalToDownload => $_getI64(3);
  @$pb.TagNumber(4)
  set totalToDownload($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalToDownload() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalToDownload() => clearField(4);
}

class ProductOperations extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProductOperations', createEmptyInstance: create)
    ..e<ProductOperations_Operation>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activeOperation', $pb.PbFieldType.OE, protoName: 'activeOperation', defaultOrMaker: ProductOperations_Operation.OP_UPDATE, valueOf: ProductOperations_Operation.valueOf, enumValues: ProductOperations_Operation.values)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'priority', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  ProductOperations._() : super();
  factory ProductOperations({
    ProductOperations_Operation? activeOperation,
    $fixnum.Int64? priority,
  }) {
    final _result = create();
    if (activeOperation != null) {
      _result.activeOperation = activeOperation;
    }
    if (priority != null) {
      _result.priority = priority;
    }
    return _result;
  }
  factory ProductOperations.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProductOperations.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProductOperations clone() => ProductOperations()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProductOperations copyWith(void Function(ProductOperations) updates) => super.copyWith((message) => updates(message as ProductOperations)) as ProductOperations; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProductOperations create() => ProductOperations._();
  ProductOperations createEmptyInstance() => create();
  static $pb.PbList<ProductOperations> createRepeated() => $pb.PbList<ProductOperations>();
  @$core.pragma('dart2js:noInline')
  static ProductOperations getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProductOperations>(create);
  static ProductOperations? _defaultInstance;

  @$pb.TagNumber(1)
  ProductOperations_Operation get activeOperation => $_getN(0);
  @$pb.TagNumber(1)
  set activeOperation(ProductOperations_Operation v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasActiveOperation() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveOperation() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get priority => $_getI64(1);
  @$pb.TagNumber(2)
  set priority($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPriority() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriority() => clearField(2);
}

class ProductConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProductConfig', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productCode', protoName: 'productCode')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'metadataHash', protoName: 'metadataHash')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..hasRequiredFields = false
  ;

  ProductConfig._() : super();
  factory ProductConfig({
    $core.String? productCode,
    $core.String? metadataHash,
    $core.String? timestamp,
  }) {
    final _result = create();
    if (productCode != null) {
      _result.productCode = productCode;
    }
    if (metadataHash != null) {
      _result.metadataHash = metadataHash;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    return _result;
  }
  factory ProductConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProductConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProductConfig clone() => ProductConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProductConfig copyWith(void Function(ProductConfig) updates) => super.copyWith((message) => updates(message as ProductConfig)) as ProductConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProductConfig create() => ProductConfig._();
  ProductConfig createEmptyInstance() => create();
  static $pb.PbList<ProductConfig> createRepeated() => $pb.PbList<ProductConfig>();
  @$core.pragma('dart2js:noInline')
  static ProductConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProductConfig>(create);
  static ProductConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set productCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProductCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get metadataHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set metadataHash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMetadataHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadataHash() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get timestamp => $_getSZ(2);
  @$pb.TagNumber(3)
  set timestamp($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);
}

class ActiveProcess extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ActiveProcess', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'processName', protoName: 'processName')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pid', $pb.PbFieldType.O3)
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uri')
    ..hasRequiredFields = false
  ;

  ActiveProcess._() : super();
  factory ActiveProcess({
    $core.String? processName,
    $core.int? pid,
    $core.Iterable<$core.String>? uri,
  }) {
    final _result = create();
    if (processName != null) {
      _result.processName = processName;
    }
    if (pid != null) {
      _result.pid = pid;
    }
    if (uri != null) {
      _result.uri.addAll(uri);
    }
    return _result;
  }
  factory ActiveProcess.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ActiveProcess.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ActiveProcess clone() => ActiveProcess()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ActiveProcess copyWith(void Function(ActiveProcess) updates) => super.copyWith((message) => updates(message as ActiveProcess)) as ActiveProcess; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ActiveProcess create() => ActiveProcess._();
  ActiveProcess createEmptyInstance() => create();
  static $pb.PbList<ActiveProcess> createRepeated() => $pb.PbList<ActiveProcess>();
  @$core.pragma('dart2js:noInline')
  static ActiveProcess getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActiveProcess>(create);
  static ActiveProcess? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get processName => $_getSZ(0);
  @$pb.TagNumber(1)
  set processName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProcessName() => $_has(0);
  @$pb.TagNumber(1)
  void clearProcessName() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get pid => $_getIZ(1);
  @$pb.TagNumber(2)
  set pid($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPid() => $_has(1);
  @$pb.TagNumber(2)
  void clearPid() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get uri => $_getList(2);
}

class InstallHandshake extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InstallHandshake', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'product')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid')
    ..aOM<UserSettings>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'settings', subBuilder: UserSettings.create)
    ..hasRequiredFields = false
  ;

  InstallHandshake._() : super();
  factory InstallHandshake({
    $core.String? product,
    $core.String? uid,
    UserSettings? settings,
  }) {
    final _result = create();
    if (product != null) {
      _result.product = product;
    }
    if (uid != null) {
      _result.uid = uid;
    }
    if (settings != null) {
      _result.settings = settings;
    }
    return _result;
  }
  factory InstallHandshake.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InstallHandshake.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InstallHandshake clone() => InstallHandshake()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InstallHandshake copyWith(void Function(InstallHandshake) updates) => super.copyWith((message) => updates(message as InstallHandshake)) as InstallHandshake; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InstallHandshake create() => InstallHandshake._();
  InstallHandshake createEmptyInstance() => create();
  static $pb.PbList<InstallHandshake> createRepeated() => $pb.PbList<InstallHandshake>();
  @$core.pragma('dart2js:noInline')
  static InstallHandshake getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InstallHandshake>(create);
  static InstallHandshake? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get product => $_getSZ(0);
  @$pb.TagNumber(1)
  set product($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProduct() => $_has(0);
  @$pb.TagNumber(1)
  void clearProduct() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get uid => $_getSZ(1);
  @$pb.TagNumber(2)
  set uid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUid() => clearField(2);

  @$pb.TagNumber(3)
  UserSettings get settings => $_getN(2);
  @$pb.TagNumber(3)
  set settings(UserSettings v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSettings() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettings() => clearField(3);
  @$pb.TagNumber(3)
  UserSettings ensureSettings() => $_ensure(2);
}

class DownloadSettings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DownloadSettings', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'downloadLimit', $pb.PbFieldType.O3, protoName: 'downloadLimit')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backfillLimit', $pb.PbFieldType.O3, protoName: 'backfillLimit')
    ..hasRequiredFields = false
  ;

  DownloadSettings._() : super();
  factory DownloadSettings({
    $core.int? downloadLimit,
    $core.int? backfillLimit,
  }) {
    final _result = create();
    if (downloadLimit != null) {
      _result.downloadLimit = downloadLimit;
    }
    if (backfillLimit != null) {
      _result.backfillLimit = backfillLimit;
    }
    return _result;
  }
  factory DownloadSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DownloadSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DownloadSettings clone() => DownloadSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DownloadSettings copyWith(void Function(DownloadSettings) updates) => super.copyWith((message) => updates(message as DownloadSettings)) as DownloadSettings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DownloadSettings create() => DownloadSettings._();
  DownloadSettings createEmptyInstance() => create();
  static $pb.PbList<DownloadSettings> createRepeated() => $pb.PbList<DownloadSettings>();
  @$core.pragma('dart2js:noInline')
  static DownloadSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DownloadSettings>(create);
  static DownloadSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get downloadLimit => $_getIZ(0);
  @$pb.TagNumber(1)
  set downloadLimit($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDownloadLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearDownloadLimit() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get backfillLimit => $_getIZ(1);
  @$pb.TagNumber(2)
  set backfillLimit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBackfillLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearBackfillLimit() => clearField(2);
}

class Database extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Database', createEmptyInstance: create)
    ..pc<ProductInstall>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productInstall', $pb.PbFieldType.PM, protoName: 'productInstall', subBuilder: ProductInstall.create)
    ..pc<InstallHandshake>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activeInstalls', $pb.PbFieldType.PM, protoName: 'activeInstalls', subBuilder: InstallHandshake.create)
    ..pc<ActiveProcess>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activeProcesses', $pb.PbFieldType.PM, protoName: 'activeProcesses', subBuilder: ActiveProcess.create)
    ..pc<ProductConfig>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productConfigs', $pb.PbFieldType.PM, protoName: 'productConfigs', subBuilder: ProductConfig.create)
    ..aOM<DownloadSettings>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'downloadSettings', protoName: 'downloadSettings', subBuilder: DownloadSettings.create)
    ..hasRequiredFields = false
  ;

  Database._() : super();
  factory Database({
    $core.Iterable<ProductInstall>? productInstall,
    $core.Iterable<InstallHandshake>? activeInstalls,
    $core.Iterable<ActiveProcess>? activeProcesses,
    $core.Iterable<ProductConfig>? productConfigs,
    DownloadSettings? downloadSettings,
  }) {
    final _result = create();
    if (productInstall != null) {
      _result.productInstall.addAll(productInstall);
    }
    if (activeInstalls != null) {
      _result.activeInstalls.addAll(activeInstalls);
    }
    if (activeProcesses != null) {
      _result.activeProcesses.addAll(activeProcesses);
    }
    if (productConfigs != null) {
      _result.productConfigs.addAll(productConfigs);
    }
    if (downloadSettings != null) {
      _result.downloadSettings = downloadSettings;
    }
    return _result;
  }
  factory Database.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Database.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Database clone() => Database()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Database copyWith(void Function(Database) updates) => super.copyWith((message) => updates(message as Database)) as Database; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Database create() => Database._();
  Database createEmptyInstance() => create();
  static $pb.PbList<Database> createRepeated() => $pb.PbList<Database>();
  @$core.pragma('dart2js:noInline')
  static Database getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Database>(create);
  static Database? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ProductInstall> get productInstall => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<InstallHandshake> get activeInstalls => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<ActiveProcess> get activeProcesses => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<ProductConfig> get productConfigs => $_getList(3);

  @$pb.TagNumber(5)
  DownloadSettings get downloadSettings => $_getN(4);
  @$pb.TagNumber(5)
  set downloadSettings(DownloadSettings v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDownloadSettings() => $_has(4);
  @$pb.TagNumber(5)
  void clearDownloadSettings() => clearField(5);
  @$pb.TagNumber(5)
  DownloadSettings ensureDownloadSettings() => $_ensure(4);
}

