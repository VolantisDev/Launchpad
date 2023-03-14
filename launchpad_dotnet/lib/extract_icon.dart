import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

typedef ExtractIconNative = Int32 Function(
    Pointer<Utf8> inputPath, Pointer<Utf8> outputPath, Bool overwrite);
typedef ExtractIconFunc = int Function(
    Pointer<Utf8> inputPath, Pointer<Utf8> outputPath, bool overwrite);

DynamicLibrary loadLaunchpadDotnetLibrary() {
  var libraryPath = kReleaseMode
      ? '${Directory(Platform.resolvedExecutable).parent.path}/data/flutter_assets/packages/launchpad_dotnet/assets/bin/release/LaunchpadDotNet.dll'
      : '${Directory.current.path}/../launchpad_dotnet/assets/bin/debug/LaunchpadDotNet.dll';

  return DynamicLibrary.open(libraryPath);
}

bool extractApplicationIcon(String inputPath, String outputPath,
    {bool overwrite = false}) {
  final extractIconFunc = loadLaunchpadDotnetLibrary()
      .lookup<NativeFunction<ExtractIconNative>>('extract_icon')
      .asFunction<ExtractIconFunc>();

  final result = extractIconFunc(
      inputPath.toNativeUtf8(), outputPath.toNativeUtf8(), overwrite);

  return (result != -1);
}
