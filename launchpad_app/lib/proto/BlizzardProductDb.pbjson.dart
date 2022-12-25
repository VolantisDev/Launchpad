///
//  Generated code. Do not modify.
//  source: BlizzardProductDb.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use productInstallDescriptor instead')
const ProductInstall$json = const {
  '1': 'ProductInstall',
  '2': const [
    const {'1': 'uid', '3': 1, '4': 1, '5': 9, '10': 'uid'},
    const {'1': 'productCode', '3': 2, '4': 1, '5': 9, '10': 'productCode'},
    const {'1': 'settings', '3': 3, '4': 1, '5': 11, '6': '.UserSettings', '10': 'settings'},
    const {'1': 'cachedProductState', '3': 4, '4': 1, '5': 11, '6': '.CachedProductState', '10': 'cachedProductState'},
    const {'1': 'productOperations', '3': 5, '4': 1, '5': 11, '6': '.ProductOperations', '10': 'productOperations'},
    const {'1': 'keyword', '3': 6, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `ProductInstall`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productInstallDescriptor = $convert.base64Decode('Cg5Qcm9kdWN0SW5zdGFsbBIQCgN1aWQYASABKAlSA3VpZBIgCgtwcm9kdWN0Q29kZRgCIAEoCVILcHJvZHVjdENvZGUSKQoIc2V0dGluZ3MYAyABKAsyDS5Vc2VyU2V0dGluZ3NSCHNldHRpbmdzEkMKEmNhY2hlZFByb2R1Y3RTdGF0ZRgEIAEoCzITLkNhY2hlZFByb2R1Y3RTdGF0ZVISY2FjaGVkUHJvZHVjdFN0YXRlEkAKEXByb2R1Y3RPcGVyYXRpb25zGAUgASgLMhIuUHJvZHVjdE9wZXJhdGlvbnNSEXByb2R1Y3RPcGVyYXRpb25zEhgKB2tleXdvcmQYBiABKAlSB2tleXdvcmQ=');
@$core.Deprecated('Use userSettingsDescriptor instead')
const UserSettings$json = const {
  '1': 'UserSettings',
  '2': const [
    const {'1': 'installPath', '3': 1, '4': 1, '5': 9, '10': 'installPath'},
    const {'1': 'playRegion', '3': 2, '4': 1, '5': 9, '10': 'playRegion'},
    const {'1': 'desktopShortcut', '3': 3, '4': 1, '5': 14, '6': '.UserSettings.ShortcutOption', '10': 'desktopShortcut'},
    const {'1': 'startmenuShortcut', '3': 4, '4': 1, '5': 14, '6': '.UserSettings.ShortcutOption', '10': 'startmenuShortcut'},
    const {'1': 'languageSettings', '3': 5, '4': 1, '5': 14, '6': '.UserSettings.LanguageSettingType', '10': 'languageSettings'},
    const {'1': 'selectedTextLanguage', '3': 6, '4': 1, '5': 9, '10': 'selectedTextLanguage'},
    const {'1': 'selectedSpeechLanguage', '3': 7, '4': 1, '5': 9, '10': 'selectedSpeechLanguage'},
    const {'1': 'languages', '3': 8, '4': 3, '5': 11, '6': '.LanguageSetting', '10': 'languages'},
    const {'1': 'gfxOverrideTags', '3': 9, '4': 1, '5': 9, '10': 'gfxOverrideTags'},
    const {'1': 'versionbranch', '3': 10, '4': 1, '5': 9, '10': 'versionbranch'},
    const {'1': 'countryCode3Letter', '3': 11, '4': 1, '5': 9, '10': 'countryCode3Letter'},
    const {'1': 'countryCode2Letter', '3': 12, '4': 1, '5': 9, '10': 'countryCode2Letter'},
    const {'1': 'productExtra', '3': 13, '4': 1, '5': 9, '10': 'productExtra'},
  ],
  '4': const [UserSettings_ShortcutOption$json, UserSettings_LanguageSettingType$json],
};

@$core.Deprecated('Use userSettingsDescriptor instead')
const UserSettings_ShortcutOption$json = const {
  '1': 'ShortcutOption',
  '2': const [
    const {'1': 'SHORTCUT_NONE', '2': 0},
    const {'1': 'SHORTCUT_USER', '2': 1},
    const {'1': 'SHORTCUT_ALL_USERS', '2': 2},
  ],
};

@$core.Deprecated('Use userSettingsDescriptor instead')
const UserSettings_LanguageSettingType$json = const {
  '1': 'LanguageSettingType',
  '2': const [
    const {'1': 'LANGSETTING_NONE', '2': 0},
    const {'1': 'LANGSETING_SINGLE', '2': 1},
    const {'1': 'LANGSETTING_SIMPLE', '2': 2},
    const {'1': 'LANGSETTING_ADVANCED', '2': 3},
  ],
};

/// Descriptor for `UserSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userSettingsDescriptor = $convert.base64Decode('CgxVc2VyU2V0dGluZ3MSIAoLaW5zdGFsbFBhdGgYASABKAlSC2luc3RhbGxQYXRoEh4KCnBsYXlSZWdpb24YAiABKAlSCnBsYXlSZWdpb24SRgoPZGVza3RvcFNob3J0Y3V0GAMgASgOMhwuVXNlclNldHRpbmdzLlNob3J0Y3V0T3B0aW9uUg9kZXNrdG9wU2hvcnRjdXQSSgoRc3RhcnRtZW51U2hvcnRjdXQYBCABKA4yHC5Vc2VyU2V0dGluZ3MuU2hvcnRjdXRPcHRpb25SEXN0YXJ0bWVudVNob3J0Y3V0Ek0KEGxhbmd1YWdlU2V0dGluZ3MYBSABKA4yIS5Vc2VyU2V0dGluZ3MuTGFuZ3VhZ2VTZXR0aW5nVHlwZVIQbGFuZ3VhZ2VTZXR0aW5ncxIyChRzZWxlY3RlZFRleHRMYW5ndWFnZRgGIAEoCVIUc2VsZWN0ZWRUZXh0TGFuZ3VhZ2USNgoWc2VsZWN0ZWRTcGVlY2hMYW5ndWFnZRgHIAEoCVIWc2VsZWN0ZWRTcGVlY2hMYW5ndWFnZRIuCglsYW5ndWFnZXMYCCADKAsyEC5MYW5ndWFnZVNldHRpbmdSCWxhbmd1YWdlcxIoCg9nZnhPdmVycmlkZVRhZ3MYCSABKAlSD2dmeE92ZXJyaWRlVGFncxIkCg12ZXJzaW9uYnJhbmNoGAogASgJUg12ZXJzaW9uYnJhbmNoEi4KEmNvdW50cnlDb2RlM0xldHRlchgLIAEoCVISY291bnRyeUNvZGUzTGV0dGVyEi4KEmNvdW50cnlDb2RlMkxldHRlchgMIAEoCVISY291bnRyeUNvZGUyTGV0dGVyEiIKDHByb2R1Y3RFeHRyYRgNIAEoCVIMcHJvZHVjdEV4dHJhIk4KDlNob3J0Y3V0T3B0aW9uEhEKDVNIT1JUQ1VUX05PTkUQABIRCg1TSE9SVENVVF9VU0VSEAESFgoSU0hPUlRDVVRfQUxMX1VTRVJTEAIidAoTTGFuZ3VhZ2VTZXR0aW5nVHlwZRIUChBMQU5HU0VUVElOR19OT05FEAASFQoRTEFOR1NFVElOR19TSU5HTEUQARIWChJMQU5HU0VUVElOR19TSU1QTEUQAhIYChRMQU5HU0VUVElOR19BRFZBTkNFRBAD');
@$core.Deprecated('Use languageSettingDescriptor instead')
const LanguageSetting$json = const {
  '1': 'LanguageSetting',
  '2': const [
    const {'1': 'language', '3': 1, '4': 1, '5': 9, '10': 'language'},
    const {'1': 'option', '3': 2, '4': 1, '5': 14, '6': '.LanguageSetting.LanguageOption', '10': 'option'},
  ],
  '4': const [LanguageSetting_LanguageOption$json],
};

@$core.Deprecated('Use languageSettingDescriptor instead')
const LanguageSetting_LanguageOption$json = const {
  '1': 'LanguageOption',
  '2': const [
    const {'1': 'LANGOPTION_NONE', '2': 0},
    const {'1': 'LANGOPTION_TEXT', '2': 1},
    const {'1': 'LANGOPTION_SPEECH', '2': 2},
    const {'1': 'LANGOPTION_TEXT_AND_SPEECH', '2': 3},
  ],
};

/// Descriptor for `LanguageSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List languageSettingDescriptor = $convert.base64Decode('Cg9MYW5ndWFnZVNldHRpbmcSGgoIbGFuZ3VhZ2UYASABKAlSCGxhbmd1YWdlEjcKBm9wdGlvbhgCIAEoDjIfLkxhbmd1YWdlU2V0dGluZy5MYW5ndWFnZU9wdGlvblIGb3B0aW9uInEKDkxhbmd1YWdlT3B0aW9uEhMKD0xBTkdPUFRJT05fTk9ORRAAEhMKD0xBTkdPUFRJT05fVEVYVBABEhUKEUxBTkdPUFRJT05fU1BFRUNIEAISHgoaTEFOR09QVElPTl9URVhUX0FORF9TUEVFQ0gQAw==');
@$core.Deprecated('Use cachedProductStateDescriptor instead')
const CachedProductState$json = const {
  '1': 'CachedProductState',
  '2': const [
    const {'1': 'baseProductState', '3': 1, '4': 1, '5': 11, '6': '.BaseProductState', '10': 'baseProductState'},
    const {'1': 'backfillProgress', '3': 2, '4': 1, '5': 11, '6': '.BackfillProgress', '10': 'backfillProgress'},
    const {'1': 'repairProgress', '3': 3, '4': 1, '5': 11, '6': '.RepairProgress', '10': 'repairProgress'},
    const {'1': 'updateProgress', '3': 4, '4': 1, '5': 11, '6': '.UpdateProgress', '10': 'updateProgress'},
  ],
};

/// Descriptor for `CachedProductState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cachedProductStateDescriptor = $convert.base64Decode('ChJDYWNoZWRQcm9kdWN0U3RhdGUSPQoQYmFzZVByb2R1Y3RTdGF0ZRgBIAEoCzIRLkJhc2VQcm9kdWN0U3RhdGVSEGJhc2VQcm9kdWN0U3RhdGUSPQoQYmFja2ZpbGxQcm9ncmVzcxgCIAEoCzIRLkJhY2tmaWxsUHJvZ3Jlc3NSEGJhY2tmaWxsUHJvZ3Jlc3MSNwoOcmVwYWlyUHJvZ3Jlc3MYAyABKAsyDy5SZXBhaXJQcm9ncmVzc1IOcmVwYWlyUHJvZ3Jlc3MSNwoOdXBkYXRlUHJvZ3Jlc3MYBCABKAsyDy5VcGRhdGVQcm9ncmVzc1IOdXBkYXRlUHJvZ3Jlc3M=');
@$core.Deprecated('Use baseProductStateDescriptor instead')
const BaseProductState$json = const {
  '1': 'BaseProductState',
  '2': const [
    const {'1': 'installed', '3': 1, '4': 1, '5': 8, '10': 'installed'},
    const {'1': 'playable', '3': 2, '4': 1, '5': 8, '10': 'playable'},
    const {'1': 'updateComplete', '3': 3, '4': 1, '5': 8, '10': 'updateComplete'},
    const {'1': 'backgroundDownloadAvailable', '3': 4, '4': 1, '5': 8, '10': 'backgroundDownloadAvailable'},
    const {'1': 'backgroundDownloadComplete', '3': 5, '4': 1, '5': 8, '10': 'backgroundDownloadComplete'},
    const {'1': 'currentVersion', '3': 6, '4': 1, '5': 9, '10': 'currentVersion'},
    const {'1': 'currentVersionStr', '3': 7, '4': 1, '5': 9, '10': 'currentVersionStr'},
    const {'1': 'installedBuildConfig', '3': 8, '4': 3, '5': 11, '6': '.BuildConfig', '10': 'installedBuildConfig'},
    const {'1': 'backgroundDownloadBuildConfig', '3': 9, '4': 3, '5': 11, '6': '.BuildConfig', '10': 'backgroundDownloadBuildConfig'},
    const {'1': 'decryptionKey', '3': 10, '4': 1, '5': 9, '10': 'decryptionKey'},
    const {'1': 'completedInstallActions', '3': 11, '4': 3, '5': 9, '10': 'completedInstallActions'},
    const {'1': 'tags', '3': 17, '4': 1, '5': 9, '10': 'tags'},
  ],
};

/// Descriptor for `BaseProductState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List baseProductStateDescriptor = $convert.base64Decode('ChBCYXNlUHJvZHVjdFN0YXRlEhwKCWluc3RhbGxlZBgBIAEoCFIJaW5zdGFsbGVkEhoKCHBsYXlhYmxlGAIgASgIUghwbGF5YWJsZRImCg51cGRhdGVDb21wbGV0ZRgDIAEoCFIOdXBkYXRlQ29tcGxldGUSQAobYmFja2dyb3VuZERvd25sb2FkQXZhaWxhYmxlGAQgASgIUhtiYWNrZ3JvdW5kRG93bmxvYWRBdmFpbGFibGUSPgoaYmFja2dyb3VuZERvd25sb2FkQ29tcGxldGUYBSABKAhSGmJhY2tncm91bmREb3dubG9hZENvbXBsZXRlEiYKDmN1cnJlbnRWZXJzaW9uGAYgASgJUg5jdXJyZW50VmVyc2lvbhIsChFjdXJyZW50VmVyc2lvblN0chgHIAEoCVIRY3VycmVudFZlcnNpb25TdHISQAoUaW5zdGFsbGVkQnVpbGRDb25maWcYCCADKAsyDC5CdWlsZENvbmZpZ1IUaW5zdGFsbGVkQnVpbGRDb25maWcSUgodYmFja2dyb3VuZERvd25sb2FkQnVpbGRDb25maWcYCSADKAsyDC5CdWlsZENvbmZpZ1IdYmFja2dyb3VuZERvd25sb2FkQnVpbGRDb25maWcSJAoNZGVjcnlwdGlvbktleRgKIAEoCVINZGVjcnlwdGlvbktleRI4Chdjb21wbGV0ZWRJbnN0YWxsQWN0aW9ucxgLIAMoCVIXY29tcGxldGVkSW5zdGFsbEFjdGlvbnMSEgoEdGFncxgRIAEoCVIEdGFncw==');
@$core.Deprecated('Use buildConfigDescriptor instead')
const BuildConfig$json = const {
  '1': 'BuildConfig',
  '2': const [
    const {'1': 'region', '3': 1, '4': 1, '5': 9, '10': 'region'},
    const {'1': 'buildConfig', '3': 2, '4': 1, '5': 9, '10': 'buildConfig'},
  ],
};

/// Descriptor for `BuildConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buildConfigDescriptor = $convert.base64Decode('CgtCdWlsZENvbmZpZxIWCgZyZWdpb24YASABKAlSBnJlZ2lvbhIgCgtidWlsZENvbmZpZxgCIAEoCVILYnVpbGRDb25maWc=');
@$core.Deprecated('Use backfillProgressDescriptor instead')
const BackfillProgress$json = const {
  '1': 'BackfillProgress',
  '2': const [
    const {'1': 'progress', '3': 1, '4': 1, '5': 1, '10': 'progress'},
    const {'1': 'backgrounddownload', '3': 2, '4': 1, '5': 8, '10': 'backgrounddownload'},
    const {'1': 'paused', '3': 3, '4': 1, '5': 8, '10': 'paused'},
    const {'1': 'downloadLimit', '3': 4, '4': 1, '5': 8, '10': 'downloadLimit'},
  ],
};

/// Descriptor for `BackfillProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backfillProgressDescriptor = $convert.base64Decode('ChBCYWNrZmlsbFByb2dyZXNzEhoKCHByb2dyZXNzGAEgASgBUghwcm9ncmVzcxIuChJiYWNrZ3JvdW5kZG93bmxvYWQYAiABKAhSEmJhY2tncm91bmRkb3dubG9hZBIWCgZwYXVzZWQYAyABKAhSBnBhdXNlZBIkCg1kb3dubG9hZExpbWl0GAQgASgIUg1kb3dubG9hZExpbWl0');
@$core.Deprecated('Use repairProgressDescriptor instead')
const RepairProgress$json = const {
  '1': 'RepairProgress',
  '2': const [
    const {'1': 'progress', '3': 1, '4': 1, '5': 1, '10': 'progress'},
  ],
};

/// Descriptor for `RepairProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repairProgressDescriptor = $convert.base64Decode('Cg5SZXBhaXJQcm9ncmVzcxIaCghwcm9ncmVzcxgBIAEoAVIIcHJvZ3Jlc3M=');
@$core.Deprecated('Use updateProgressDescriptor instead')
const UpdateProgress$json = const {
  '1': 'UpdateProgress',
  '2': const [
    const {'1': 'lastDiscSetUsed', '3': 1, '4': 1, '5': 9, '10': 'lastDiscSetUsed'},
    const {'1': 'progress', '3': 2, '4': 1, '5': 1, '10': 'progress'},
    const {'1': 'discIgnored', '3': 3, '4': 1, '5': 8, '10': 'discIgnored'},
    const {'1': 'totalToDownload', '3': 4, '4': 1, '5': 4, '10': 'totalToDownload'},
  ],
};

/// Descriptor for `UpdateProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProgressDescriptor = $convert.base64Decode('Cg5VcGRhdGVQcm9ncmVzcxIoCg9sYXN0RGlzY1NldFVzZWQYASABKAlSD2xhc3REaXNjU2V0VXNlZBIaCghwcm9ncmVzcxgCIAEoAVIIcHJvZ3Jlc3MSIAoLZGlzY0lnbm9yZWQYAyABKAhSC2Rpc2NJZ25vcmVkEigKD3RvdGFsVG9Eb3dubG9hZBgEIAEoBFIPdG90YWxUb0Rvd25sb2Fk');
@$core.Deprecated('Use productOperationsDescriptor instead')
const ProductOperations$json = const {
  '1': 'ProductOperations',
  '2': const [
    const {'1': 'activeOperation', '3': 1, '4': 1, '5': 14, '6': '.ProductOperations.Operation', '10': 'activeOperation'},
    const {'1': 'priority', '3': 2, '4': 1, '5': 4, '10': 'priority'},
  ],
  '4': const [ProductOperations_Operation$json],
};

@$core.Deprecated('Use productOperationsDescriptor instead')
const ProductOperations_Operation$json = const {
  '1': 'Operation',
  '2': const [
    const {'1': 'OP_UPDATE', '2': 0},
    const {'1': 'OP_BACKFILL', '2': 1},
    const {'1': 'OP_REPAIR', '2': 2},
  ],
};

/// Descriptor for `ProductOperations`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productOperationsDescriptor = $convert.base64Decode('ChFQcm9kdWN0T3BlcmF0aW9ucxJGCg9hY3RpdmVPcGVyYXRpb24YASABKA4yHC5Qcm9kdWN0T3BlcmF0aW9ucy5PcGVyYXRpb25SD2FjdGl2ZU9wZXJhdGlvbhIaCghwcmlvcml0eRgCIAEoBFIIcHJpb3JpdHkiOgoJT3BlcmF0aW9uEg0KCU9QX1VQREFURRAAEg8KC09QX0JBQ0tGSUxMEAESDQoJT1BfUkVQQUlSEAI=');
@$core.Deprecated('Use productConfigDescriptor instead')
const ProductConfig$json = const {
  '1': 'ProductConfig',
  '2': const [
    const {'1': 'productCode', '3': 1, '4': 1, '5': 9, '10': 'productCode'},
    const {'1': 'metadataHash', '3': 2, '4': 1, '5': 9, '10': 'metadataHash'},
    const {'1': 'timestamp', '3': 3, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

/// Descriptor for `ProductConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productConfigDescriptor = $convert.base64Decode('Cg1Qcm9kdWN0Q29uZmlnEiAKC3Byb2R1Y3RDb2RlGAEgASgJUgtwcm9kdWN0Q29kZRIiCgxtZXRhZGF0YUhhc2gYAiABKAlSDG1ldGFkYXRhSGFzaBIcCgl0aW1lc3RhbXAYAyABKAlSCXRpbWVzdGFtcA==');
@$core.Deprecated('Use activeProcessDescriptor instead')
const ActiveProcess$json = const {
  '1': 'ActiveProcess',
  '2': const [
    const {'1': 'processName', '3': 1, '4': 1, '5': 9, '10': 'processName'},
    const {'1': 'pid', '3': 2, '4': 1, '5': 5, '10': 'pid'},
    const {'1': 'uri', '3': 3, '4': 3, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `ActiveProcess`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activeProcessDescriptor = $convert.base64Decode('Cg1BY3RpdmVQcm9jZXNzEiAKC3Byb2Nlc3NOYW1lGAEgASgJUgtwcm9jZXNzTmFtZRIQCgNwaWQYAiABKAVSA3BpZBIQCgN1cmkYAyADKAlSA3VyaQ==');
@$core.Deprecated('Use installHandshakeDescriptor instead')
const InstallHandshake$json = const {
  '1': 'InstallHandshake',
  '2': const [
    const {'1': 'product', '3': 1, '4': 1, '5': 9, '10': 'product'},
    const {'1': 'uid', '3': 2, '4': 1, '5': 9, '10': 'uid'},
    const {'1': 'settings', '3': 3, '4': 1, '5': 11, '6': '.UserSettings', '10': 'settings'},
  ],
};

/// Descriptor for `InstallHandshake`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List installHandshakeDescriptor = $convert.base64Decode('ChBJbnN0YWxsSGFuZHNoYWtlEhgKB3Byb2R1Y3QYASABKAlSB3Byb2R1Y3QSEAoDdWlkGAIgASgJUgN1aWQSKQoIc2V0dGluZ3MYAyABKAsyDS5Vc2VyU2V0dGluZ3NSCHNldHRpbmdz');
@$core.Deprecated('Use downloadSettingsDescriptor instead')
const DownloadSettings$json = const {
  '1': 'DownloadSettings',
  '2': const [
    const {'1': 'downloadLimit', '3': 1, '4': 1, '5': 5, '10': 'downloadLimit'},
    const {'1': 'backfillLimit', '3': 2, '4': 1, '5': 5, '10': 'backfillLimit'},
  ],
};

/// Descriptor for `DownloadSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadSettingsDescriptor = $convert.base64Decode('ChBEb3dubG9hZFNldHRpbmdzEiQKDWRvd25sb2FkTGltaXQYASABKAVSDWRvd25sb2FkTGltaXQSJAoNYmFja2ZpbGxMaW1pdBgCIAEoBVINYmFja2ZpbGxMaW1pdA==');
@$core.Deprecated('Use databaseDescriptor instead')
const Database$json = const {
  '1': 'Database',
  '2': const [
    const {'1': 'productInstall', '3': 1, '4': 3, '5': 11, '6': '.ProductInstall', '10': 'productInstall'},
    const {'1': 'activeInstalls', '3': 2, '4': 3, '5': 11, '6': '.InstallHandshake', '10': 'activeInstalls'},
    const {'1': 'activeProcesses', '3': 3, '4': 3, '5': 11, '6': '.ActiveProcess', '10': 'activeProcesses'},
    const {'1': 'productConfigs', '3': 4, '4': 3, '5': 11, '6': '.ProductConfig', '10': 'productConfigs'},
    const {'1': 'downloadSettings', '3': 5, '4': 1, '5': 11, '6': '.DownloadSettings', '10': 'downloadSettings'},
  ],
};

/// Descriptor for `Database`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List databaseDescriptor = $convert.base64Decode('CghEYXRhYmFzZRI3Cg5wcm9kdWN0SW5zdGFsbBgBIAMoCzIPLlByb2R1Y3RJbnN0YWxsUg5wcm9kdWN0SW5zdGFsbBI5Cg5hY3RpdmVJbnN0YWxscxgCIAMoCzIRLkluc3RhbGxIYW5kc2hha2VSDmFjdGl2ZUluc3RhbGxzEjgKD2FjdGl2ZVByb2Nlc3NlcxgDIAMoCzIOLkFjdGl2ZVByb2Nlc3NSD2FjdGl2ZVByb2Nlc3NlcxI2Cg5wcm9kdWN0Q29uZmlncxgEIAMoCzIOLlByb2R1Y3RDb25maWdSDnByb2R1Y3RDb25maWdzEj0KEGRvd25sb2FkU2V0dGluZ3MYBSABKAsyES5Eb3dubG9hZFNldHRpbmdzUhBkb3dubG9hZFNldHRpbmdz');
