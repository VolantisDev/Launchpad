abstract class PlatformLocatorBase {
  Future<String?> locateInstallDir() {
    return Future.value(null);
  }

  Future<String?> locateMainExe() {
    return Future.value(null);
  }

  Future<String?> locateInstalledVersion() {
    return Future.value(null);
  }

  Future<String?> locateUninstallCommand() {
    return Future.value(null);
  }

  Future<List<String>?> locateLibraryDirs() {
    return Future.value(null);
  }

  Future<String?> locateIcon() {
    return Future.value(null);
  }
}

class CallbackLocator extends PlatformLocatorBase {
  CallbackLocator({
    this.installDir,
    this.mainExe,
    this.installedVersion,
    this.uninstallCommand,
    this.icon,
    this.libraryDirs,
  });

  final Future<String?> Function()? installDir;
  final Future<String?> Function()? mainExe;
  final Future<String?> Function()? installedVersion;
  final Future<String?> Function()? uninstallCommand;
  final Future<String?> Function()? icon;
  final Future<List<String>?> Function()? libraryDirs;

  @override
  locateInstallDir() {
    return (installDir != null) ? installDir!() : Future.value(null);
  }

  @override
  locateMainExe() {
    return (mainExe != null) ? mainExe!() : Future.value(null);
  }

  @override
  locateInstalledVersion() {
    return (installedVersion != null)
        ? installedVersion!()
        : Future.value(null);
  }

  @override
  locateUninstallCommand() {
    return (uninstallCommand != null)
        ? uninstallCommand!()
        : Future.value(null);
  }

  @override
  locateIcon() {
    return (icon != null) ? icon!() : Future.value(null);
  }

  @override
  locateLibraryDirs() {
    return (libraryDirs != null) ? libraryDirs!() : Future.value(null);
  }
}
