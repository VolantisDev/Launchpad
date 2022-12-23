import 'package:launchpad_app/src/features/games/domain/game_platform.dart';

abstract class PlatformLocator {
  PlatformLocator({required this.platform});

  GamePlatform platform;

  Future<String?> locateInstallDir();

  Future<String?> locateMainExe();

  Future<String?> locateGameLaunchCommand();
}

class PlatformRegistryInfo {
  PlatformRegistryInfo({
    required this.registryPath,
    required this.registryKey,
    required this.registryValue,
  });

  final String registryPath;
  final String registryKey;
  final String registryValue;
}

class PlatformRegistryValueInfo {
  PlatformRegistryValueInfo({
    required this.registryPath,
    required this.registryKey,
    required this.registryValue,
  });

  final String registryPath;
  final String registryKey;
  final String registryValue;
}

class RegistryLocator extends PlatformLocator {
  RegistryLocator({required GamePlatform platform}) : super(platform: platform);

  @override
  Future<String?> locateInstallDir() {
    // TODO: implement locateGameLaunchCommand
    throw UnimplementedError();
  }
  
  @override
  Future<String?> locateGameLaunchCommand() {
    // TODO: implement locateGameLaunchCommand
    throw UnimplementedError();
  }
  
  @override
  Future<String?> locateMainExe() {
    // TODO: implement locateMainExe
    throw UnimplementedError();
  }
}
