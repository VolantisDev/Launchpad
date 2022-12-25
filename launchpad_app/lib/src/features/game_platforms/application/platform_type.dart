import 'dart:io';

import 'package:launchpad_app/proto/BlizzardProductDb.pb.dart';
import 'package:launchpad_app/src/features/game_platforms/application/game_detector.dart';
import 'package:launchpad_app/src/features/game_platforms/application/platform_locator/platform_locator.dart';
import 'package:launchpad_app/src/features/game_platforms/application/platform_locator/xml_locator.dart';
import 'package:launchpad_app/src/features/games/domain/game.dart';
import 'package:launchpad_app/src/features/games/domain/game_platform.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffi/ffi.dart';
import 'package:path_provider_windows/path_provider_windows.dart';

import 'package:vdf/vdf.dart';
import 'package:win32/win32.dart';
import 'package:win32_registry/win32_registry.dart';

import 'platform_locator/registry_locator.dart';

class PlatformType {
  PlatformType({
    required this.key,
    required this.name,
    this.downloadUrl,
    this.defaultInstallDir,
    this.defaultExePath,
    this.locators = const <PlatformLocatorBase>[],
    this.gameDetectors = const <GameDetectorBase>[],
    this.defaultLibraryDirs,
  });

  final String key;
  final String name;
  final String? downloadUrl;
  final String? defaultInstallDir;
  final String? defaultExePath;
  final List<String>? defaultLibraryDirs;
  final List<PlatformLocatorBase> locators;
  final List<GameDetectorBase> gameDetectors;

  Future<bool> isInstalled() async {
    var mainExe = await locateMainExe();

    return (mainExe != null && File(mainExe).existsSync());
  }

  Future<String?> locateInstallDir() async {
    var installDir = defaultInstallDir;

    if (locators != null) {
      for (var locator in locators!) {
        installDir = await locator.locateInstallDir();

        if (installDir != null) {
          break;
        }
      }
    }

    return installDir;
  }

  Future<String?> locateMainExe() async {
    var exePath = defaultExePath;

    if (locators != null) {
      for (var locator in locators!) {
        exePath = await locator.locateMainExe();

        if (exePath != null) {
          break;
        }
      }
    }

    if (exePath != null &&
        !exePath.contains(r':/') &&
        !exePath.contains(r':\')) {
      var installDir = await locateInstallDir();

      if (installDir != null) {
        exePath = '$installDir/$exePath';
      }
    }

    return exePath;
  }

  Future<List<String>> locateLibraryDirs() async {
    var libraryDirs = defaultLibraryDirs ?? [];

    if (locators != null) {
      for (var locator in locators!) {
        var dirs = await locator.locateLibraryDirs();

        if (dirs != null) {
          libraryDirs.addAll(dirs);
        }
      }
    }

    return libraryDirs;
  }

  Future<String?> locateInstalledVersion() async {
    var version = '';

    if (locators != null) {
      for (var locator in locators!) {
        version = await locator.locateInstalledVersion() ?? '';

        if (version.isNotEmpty) {
          break;
        }
      }
    }

    return version;
  }
}

final _platformTypes = <String, PlatformType>{};

void setPlatformType(PlatformType platformType) {
  _platformTypes[platformType.key] = platformType;
}

Future<Map<String, PlatformType>> getPlatformTypes() async {
  if (_platformTypes.isEmpty) {
    var appData = await getApplicationSupportDirectory();

    final riotPlatform = PlatformType(
      key: 'riot',
      name: 'Riot Client',
      defaultExePath: "RiotClientServices.exe",
      locators: [
        RegistryLocator(
          installDir: RegistryLocatorValue(
            registryHive: RegistryHive.classesRoot,
            registryKey: r'riotclient\shell\open\command',
            stringSelector: r'^"?(.*)\RiotClientServices.exe"?.*',
          ),
        ),
      ],
      gameDetectors: [
        LibraryFolderDetector(),
      ],
    );

    riotPlatform.locators.add(CallbackLocator(
      libraryDirs: () async {
        var installDir = await riotPlatform.locateInstallDir();

        var libraryDirs = <String>[];

        if (installDir != null && installDir != "") {
          libraryDirs.add(Directory(installDir).parent.path);
        }

        return libraryDirs;
      },
    ));

    final steamPlatform = PlatformType(
      key: 'steam',
      name: 'Steam',
      downloadUrl: 'https://store.steampowered.com/about/',
      defaultInstallDir: r'C:\Program Files (x86)\Steam',
      defaultExePath: 'Steam.exe',
      locators: [
        RegistryUninstallDataLocator(
          uninstallerKey:
              r'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam',
          installDir: RegistryLocatorValue(
            registryHive: RegistryHive.currentUser,
            registryKey: r'SOFTWARE\Valve\Steam',
            registryValueName: 'SteamPath',
          ),
          mainExe: RegistryLocatorValue(
            registryHive: RegistryHive.currentUser,
            registryKey: r'SOFTWARE\Valve\Steam',
            registryValueName: 'SteamExe',
          ),
        )
      ],
    );

    steamPlatform.locators.add(CallbackLocator(
      libraryDirs: () async {
        var installDir = await steamPlatform.locateInstallDir();

        var libraryDirs = <String>[];

        if (installDir != null && installDir != "") {
          var steamApps = Directory('$installDir/steamapps');
          var vdfFile = File('$installDir/steamapps/libraryfolders.vdf');

          if (vdfFile.existsSync()) {
            var vdfData = vdf.decode(vdfFile.readAsStringSync());

            var libraryFolders = vdfData['LibraryFolders'];

            if (libraryFolders is Map) {
              libraryDirs.addAll([
                for (var libraryFolder in libraryFolders.values)
                  '${libraryFolder["path"]}/steamapps',
              ]);
            }
          } else if (steamApps.existsSync()) {
            libraryDirs.add(steamApps.path);
          }
        }

        return libraryDirs;
      },
    ));

    steamPlatform.gameDetectors
        .add(CallbackGameDetector((GamePlatform platform) async {
      var platformType = await platform.getPlatformType();

      var libraryDirs = await platformType.locateLibraryDirs();

      var games = <Game>[];

      for (final libraryDir in libraryDirs) {
        var dir = Directory(libraryDir);

        if (dir.existsSync()) {
          for (final file in dir.listSync(followLinks: false).where((file) =>
              (file is File &&
                  file.uri.pathSegments.last.endsWith('.acf') &&
                  file.uri.pathSegments.last.startsWith('appmanifest_')))) {
            var vdfData = vdf.decode((file as File).readAsStringSync());

            if (vdfData.containsKey("AppState")) {
              var state = vdfData["AppState"];

              games.add(Game(
                key: state["name"],
                platformId: platform.key,
                platformRef: state["appid"],
                installDir: '${dir.path}/common/${state["installdir"]}',
                name: state["name"],
              ));
            }
          }
        }
      }

      return games;
    }));

    return {
      "default": PlatformType(key: 'default', name: 'Default'),
      "bethesda": PlatformType(
        key: 'bethesda',
        name: 'Bethesda.net',
        downloadUrl: 'https://bethesda.net/en/game/bethesda-launcher',
        defaultInstallDir: '',
        defaultExePath: 'BethesdaNetLauncher.exe',
        defaultLibraryDirs: ["games"],
        locators: [
          RegistryUninstallDataLocator(
            uninstallerKey:
                r'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{3448917E-E4FE-4E30-9502-9FD52EABB6F5}_is1',
          )
        ],
        gameDetectors: [
          LibraryFolderDetector(),
        ],
      ),
      "blizzard": PlatformType(
          key: 'blizzard',
          name: 'Battle.net',
          downloadUrl: 'https://www.blizzard.com/en-us/apps/battle.net/desktop',
          defaultInstallDir: r'C:\Program Files (x86)\Battle.net',
          defaultExePath: 'Battle.net.exe',
          locators: [
            RegistryUninstallDataLocator(
              uninstallerKey:
                  r'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Battle.net',
            ),
          ],
          gameDetectors: [
            CallbackGameDetector((GamePlatform platform) async {
              var productDb = await getBlizzardProductDb();
              var games = <Game>[];

              if (productDb != null) {
                for (var product in productDb.productInstall) {
                  var installPath = product.settings.installPath;
                  var folder = Directory(installPath);
                  var key = folder.uri.pathSegments.last;

                  if (folder.existsSync()) {
                    games.add(Game(
                      key: key,
                      platformId: platform.key,
                      platformRef: product.productCode,
                      installDir: folder.path,
                      name: key,
                    ));
                  }
                }
              }

              return games;
            }),
          ]),
      "epic": PlatformType(
          key: 'epic',
          name: 'Epic Store',
          downloadUrl: 'https://www.epicgames.com/store/en-US/download',
          defaultInstallDir: r'C:\Program Files (x86)\Epic Games\Launcher',
          defaultExePath:
              r'\Launcher\Engine\Binaries\Win64\EpicGamesLauncher.exe',
          locators: [
            RegistryUninstallDataLocator(
              uninstallerKey:
                  r'SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\B4B4F9022FD3528499604D6D8AE00CE9\InstallProperties',
            ),
          ]),
      "origin": PlatformType(
        key: 'origin',
        name: 'EA Origin',
        downloadUrl: 'https://www.origin.com/usa/en-us/store/download',
        defaultInstallDir: r'C:\Program Files (x86)\Origin',
        defaultExePath: 'Origin.exe',
        locators: [
          RegistryUninstallDataLocator(
            uninstallerKey:
                r'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Origin',
          ),
          XmlLocator(
            xmlFilePath: "${appData.path}/Origin/local.xml",
            libraryDir:
                XmlLocatorValue('/Settings/Setting[@key="DownloadInPlaceDir"]'),
          )
        ],
        gameDetectors: [
          LibraryFolderDetector(),
        ],
      ),
      "riot": riotPlatform,
      "steam": steamPlatform,
      "uplay": PlatformType(
        key: 'uplay',
        name: 'Uplay',
        downloadUrl: 'https://uplay.ubi.com/',
        defaultInstallDir:
            r'C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher',
        defaultExePath: 'Uplay.exe',
        locators: [
          RegistryUninstallDataLocator(
            uninstallerKey:
                r'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Uplay',
          )
        ],
        gameDetectors: [
          LibraryFolderDetector(),
        ],
      ),
    };
  }

  return _platformTypes;
}

Future<Database?> getBlizzardProductDb() async {
  var dir = await PathProviderWindows().getPath(FOLDERID_ProgramData);
  var productDbPath = '$dir/Battle.net/Agent/product.db';
  var file = File(productDbPath);

  return (file.existsSync())
      ? Database.fromBuffer(file.readAsBytesSync())
      : null;
}

Future<String?> getBlizzardInstallPath(String productCode) async {
  var productDb = await getBlizzardProductDb();

  String? installPath;

  if (productDb != null) {
    for (final install in productDb.productInstall) {
      if (install.productCode == productCode) {
        installPath = install.settings.installPath;
        break;
      }
    }
  }

  return installPath;
}

Future<List<GamePlatform>> createInstalledPlatforms() async {
  var platformTypes = await getPlatformTypes();

  var platforms = <GamePlatform>[];

  for (var platformType in platformTypes.values) {
    if (await platformType.isInstalled()) {
      platforms.add(GamePlatform(
        key: platformType.key,
        name: platformType.name,
        platformTypeId: platformType.key,
        installDir: await platformType.locateInstallDir(),
      ));
    }
  }

  return platforms;
}
