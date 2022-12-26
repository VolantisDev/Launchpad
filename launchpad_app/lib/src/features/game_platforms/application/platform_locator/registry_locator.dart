import 'package:win32/win32.dart';
import 'package:win32_registry/win32_registry.dart';

import 'platform_locator.dart';

class RegistryLocator extends PlatformLocatorBase {
  RegistryLocator(
      {this.installDir,
      this.mainExe,
      this.installedVersion,
      this.uninstallCommand,
      this.icon,
      this.libraryDir});

  final RegistryLocatorValue? installDir;
  final RegistryLocatorValue? mainExe;
  final RegistryLocatorValue? installedVersion;
  final RegistryLocatorValue? uninstallCommand;
  final RegistryLocatorValue? icon;
  final RegistryLocatorValue? libraryDir;

  @override
  Future<String?> locateInstallDir() {
    return Future.value(lookupValue(installDir));
  }

  @override
  Future<String?> locateMainExe() {
    return Future.value(lookupValue(mainExe));
  }

  @override
  Future<String?> locateInstalledVersion() {
    return Future.value(lookupValue(installedVersion));
  }

  @override
  Future<String?> locateIcon() {
    return Future.value(lookupValue(icon));
  }

  @override
  Future<String?> locateUninstallCommand() {
    return Future.value(lookupValue(uninstallCommand));
  }

  @override
  Future<List<String>?> locateLibraryDirs() {
    return Future.value(null);
  }

  String? lookupValue(RegistryLocatorValue? registryValue) {
    return (registryValue != null) ? registryValue.lookupValue() : null;
  }
}

class RegistryUninstallDataLocator extends RegistryLocator {
  RegistryUninstallDataLocator({
    RegistryHive registryHive = RegistryHive.localMachine,
    required String uninstallerKey,
    String? installDirValue = 'InstallLocation',
    String? installedVersionValue = 'DisplayVersion',
    String? uninstallCommandValue = 'UninstallString',
    String? iconValue = 'DisplayIcon',
    RegistryLocatorValue? installDir,
    RegistryLocatorValue? mainExe,
    RegistryLocatorValue? installedVersion,
    RegistryLocatorValue? uninstallCommand,
    RegistryLocatorValue? icon,
  }) : super(
          installDir: installDir ??
              RegistryLocatorValue(
                registryHive: registryHive,
                registryKey: uninstallerKey,
                registryValueName: installDirValue ?? '',
              ),
          mainExe: mainExe,
          installedVersion: installedVersion ??
              RegistryLocatorValue(
                registryHive: registryHive,
                registryKey: uninstallerKey,
                registryValueName: installedVersionValue ?? '',
              ),
          uninstallCommand: uninstallCommand ??
              RegistryLocatorValue(
                registryHive: registryHive,
                registryKey: uninstallerKey,
                registryValueName: uninstallCommandValue ?? '',
              ),
          icon: icon ??
              RegistryLocatorValue(
                registryHive: registryHive,
                registryKey: uninstallerKey,
                registryValueName: iconValue ?? '',
              ),
        );
}

class RegistryLocatorValue {
  RegistryLocatorValue({
    this.registryHive = RegistryHive.localMachine,
    required this.registryKey,
    this.registryValueName = '',
    this.stringSelector,
    this.stripTrailingSlash = true,
  });

  final RegistryHive registryHive;
  final String registryKey;
  final String registryValueName;

  /// A regular expression to select a substring from the registry value.
  final String? stringSelector;
  final bool stripTrailingSlash;

  String? lookupValue() {
    String? value;

    try {
      final key = Registry.openPath(registryHive, path: registryKey);
      value = key.getValueAsString(registryValueName);
    } on WindowsException catch (_) {
      value = null;
    }

    if (value != null && stringSelector != null) {
      final regex = RegExp(stringSelector!);
      final match = regex.firstMatch(value);
      value = (match != null) ? match.group(0) : null;
    }

    if (value != null &&
        stripTrailingSlash &&
        (value[value.length - 1] == r'\' || value[value.length - 1] == '/')) {
      value = value.substring(0, value.length - 1);
    }

    return value;
  }
}
