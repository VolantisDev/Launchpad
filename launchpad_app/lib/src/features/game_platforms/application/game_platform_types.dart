import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as img;
import 'package:launchpad_app/gen/assets.gen.dart';
import 'package:launchpad_app/proto/BlizzardProductDb.pb.dart';
import 'package:launchpad_app/src/features/game_platforms/application/game_detector.dart';
import 'package:launchpad_app/src/features/game_platforms/application/platform_locator/platform_locator.dart';
import 'package:launchpad_app/src/features/game_platforms/application/platform_locator/xml_locator.dart';
import 'package:launchpad_app/src/features/games/domain/game.dart';
import 'package:launchpad_app/src/features/game_platforms/domain/game_platform.dart';
import 'package:launchpad_dotnet/extract_icon.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_windows/src/folders.dart';
import 'package:path_provider_windows/src/path_provider_windows_real.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:vdf/vdf.dart';
import 'package:win32/win32.dart';
import 'package:win32_registry/win32_registry.dart';

import 'platform_locator/registry_locator.dart';

part 'game_platform_types.g.dart';

class GamePlatformType {
  GamePlatformType({
    required this.key,
    required this.name,
    this.downloadUrl,
    this.defaultInstallDir,
    this.defaultExePath,
    this.defaultIconPath,
    this.defaultVersion,
    List<PlatformLocatorBase>? locators,
    List<GameDetectorBase>? gameDetectors,
    this.defaultLibraryDirs,
  }) {
    this.locators = locators ?? <PlatformLocatorBase>[];
    this.gameDetectors = gameDetectors ?? <GameDetectorBase>[];
  }

  final String key;
  final String name;
  final String? downloadUrl;
  final String? defaultInstallDir;
  final String? defaultExePath;
  final String? defaultIconPath;
  final String? defaultVersion;
  final List<String>? defaultLibraryDirs;
  late List<PlatformLocatorBase> locators;
  late List<GameDetectorBase> gameDetectors;

  Future<bool> isInstalled() async {
    var mainExe = await locateMainExe();

    return (mainExe != null && File(mainExe).existsSync());
  }

  Future<String?> locateInstallDir() async {
    var installDir = defaultInstallDir;

    for (var locator in locators) {
      var checkInstallDir = await locator.locateInstallDir();

      if (checkInstallDir != null) {
        installDir = checkInstallDir;

        break;
      }
    }

    return installDir;
  }

  Future<String?> locateMainExe() async {
    var exePath = defaultExePath;

    for (var locator in locators) {
      var checkExePath = await locator.locateMainExe();

      if (checkExePath != null) {
        exePath = checkExePath;

        break;
      }
    }

    if (exePath != null &&
        exePath != '' &&
        !exePath.contains(r':/') &&
        !exePath.contains(r':\')) {
      var installDir = await locateInstallDir();

      if (installDir != null && installDir != '') {
        exePath = '$installDir/$exePath';
      }
    }

    return exePath;
  }

  Future<List<String>> locateLibraryDirs() async {
    var libraryDirs = defaultLibraryDirs ?? [];

    for (var locator in locators) {
      var dirs = await locator.locateLibraryDirs();

      if (dirs != null) {
        libraryDirs.addAll(dirs);
      }
    }

    return libraryDirs;
  }

  Future<String?> locateInstalledVersion() async {
    String? version = defaultVersion;

    for (var locator in locators) {
      var checkVersion = await locator.locateInstalledVersion() ?? '';

      if (checkVersion.isNotEmpty) {
        version = checkVersion;

        break;
      }
    }

    return version;
  }

  Future<String?> locateIconPath() async {
    var iconPath = defaultIconPath;

    for (var locator in locators) {
      var checkIconPath = await locator.locateIcon();

      if (checkIconPath != null && checkIconPath.isNotEmpty) {
        iconPath = checkIconPath;

        break;
      }
    }

    return iconPath;
  }

  Future<bool> createPlatformIcoFile(String exePath, String outputName,
      {String? iconFolderName = "platforms"}) async {
    var outputFile = await getApplicationIconPath(outputName,
        iconFolderName: iconFolderName);

    if (!File(outputFile).existsSync()) {
      extractApplicationIcon(exePath, outputFile, overwrite: true);
    }

    return File(outputFile).existsSync();
  }

  Future<String> getApplicationIconPath(String outputName,
      {String? iconFolderName = 'platforms'}) async {
    var iconDir = "${(await getApplicationSupportDirectory()).path}/icons";

    if (iconFolderName != null) {
      iconDir = '$iconDir/$iconFolderName';
    }

    if (!Directory(iconDir).existsSync()) {
      Directory(iconDir).createSync(recursive: true);
    }

    return "$iconDir/$outputName.ico";
  }

  Future<img.Image?> getClosestIconSize(String iconPath,
      {int size = 16}) async {
    var bytes = File(iconPath).readAsBytesSync();
    var decoder = img.IcoDecoder();
    img.IcoInfo? info = decoder.startDecode(bytes) as img.IcoInfo?;
    img.Image? image;

    if (info != null) {
      var numberOfImages = info.images?.length ?? 0;
      var frameIndex = -1;
      var closestSizeOver = 0;
      var overIndex = -1;
      var closestSizeUnder = 0;
      var underIndex = -1;

      if (numberOfImages > 0) {
        for (var i = 0; i < numberOfImages; i++) {
          var imageData = info.images![i];

          if (imageData.width == size) {
            frameIndex = i;
            break;
          }

          if (imageData.width > size) {
            if (closestSizeOver == 0 || (imageData.width < closestSizeOver)) {
              closestSizeOver = imageData.width;
              overIndex = i;
            }
          } else {
            if (closestSizeUnder == 0 || (imageData.width > closestSizeUnder)) {
              closestSizeUnder = imageData.width;
              underIndex = i;
            }
          }
        }

        if (frameIndex == -1) {
          if (closestSizeOver > -1 && closestSizeUnder > -1) {
            if (closestSizeOver - size < size - closestSizeUnder) {
              frameIndex = overIndex;
            } else {
              frameIndex = underIndex;
            }
          } else if (closestSizeOver > -1) {
            frameIndex = overIndex;
          } else if (closestSizeUnder > -1) {
            frameIndex = underIndex;
          }
        }

        if (frameIndex > -1) {
          image = decoder.decodeFrame(frameIndex);
        }
      }
    }

    return image;
  }

  Future<Image?> getApplicationIconImage(String filePath, String outputName,
      {String? iconFolderName, int size = 16}) async {
    img.Image? iconImage;
    Image? image;

    if (await createPlatformIcoFile(filePath, outputName)) {
      var outputFile = await getApplicationIconPath(outputName,
          iconFolderName: iconFolderName);

      // TODO Call getCLosestIconSize and find a way to render it
      image = Image.file(
        File(outputFile),
        width: size.toDouble(),
        height: size.toDouble(),
      );
    }

    return image;
  }

  Future<Widget> locateIcon({int size = 16}) async {
    var iconPath = await locateIconPath();
    Widget? icon;

    if (iconPath != null && iconPath.isNotEmpty) {
      var isSvg = p.extension(iconPath) == '.svg';
      var isExe = p.extension(iconPath) == '.exe';
      var isIco = p.extension(iconPath) == '.ico';
      var isAsset = false;

      if (iconPath.startsWith('asset://')) {
        isAsset = true;
        iconPath = iconPath.replaceFirst('asset://', '');
      }

      try {
        if (isExe) {
          icon = await getApplicationIconImage(iconPath, key,
              iconFolderName: "platforms");
        } else if (isIco) {
          if (isAsset || File(iconPath).existsSync()) {
            var bytes = File(iconPath).readAsBytesSync();
            var decoder = img.IcoDecoder();
            img.IcoInfo? info = decoder.startDecode(bytes) as img.IcoInfo?;

            if (info != null) {
              var iconImage = decoder.decodeFrame(0);

              if (iconImage != null) {
                icon = Image.memory(iconImage.getBytes());
              }
            }
          }
        } else if (isSvg) {
          icon = isAsset
              ? SvgPicture.asset(
                  iconPath,
                  width: size.toDouble(),
                  height: size.toDouble(),
                )
              : SvgPicture.file(
                  File(iconPath),
                  width: size.toDouble(),
                  height: size.toDouble(),
                );
        } else {
          icon = isAsset
              ? Image.asset(
                  iconPath,
                  width: size.toDouble(),
                  height: size.toDouble(),
                )
              : Image.file(
                  File(iconPath),
                  width: size.toDouble(),
                  height: size.toDouble(),
                );
        }
      } on Exception catch (_) {
        icon = null;
      }
    }

    icon ??= const Icon(FluentIcons.game);

    return icon;
  }
}

@Riverpod(keepAlive: true)
Future<Map<String, GamePlatformType>> gamePlatformTypes(
    GamePlatformTypesRef ref) async {
  var appData =
      await PathProviderWindows().getPath(WindowsKnownFolder.RoamingAppData);

  appData ??= "C:/Users/${Platform.environment['USERNAME']}/AppData/Roaming";

  final riotPlatform = GamePlatformType(
    key: 'riot',
    name: 'Riot Client',
    defaultExePath: "RiotClientServices.exe",
    defaultIconPath: Assets.graphics.platformIconRiot.keyName,
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

  final steamPlatform = GamePlatformType(
    key: 'steam',
    name: 'Steam',
    downloadUrl: 'https://store.steampowered.com/about/',
    defaultInstallDir: r'C:\Program Files (x86)\Steam',
    defaultExePath: 'Steam.exe',
    defaultIconPath: Assets.graphics.platformIconSteam.keyName,
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
    var libraryDirs = await steamPlatform.locateLibraryDirs();

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
    "default": GamePlatformType(key: 'default', name: 'Default'),
    "bethesda": GamePlatformType(
      key: 'bethesda',
      name: 'Bethesda.net',
      downloadUrl: 'https://bethesda.net/en/game/bethesda-launcher',
      defaultInstallDir: '',
      defaultExePath: 'BethesdaNetLauncher.exe',
      defaultIconPath: Assets.graphics.platformIconBethesda.keyName,
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
    "blizzard": GamePlatformType(
        key: 'blizzard',
        name: 'Battle.net',
        downloadUrl: 'https://www.blizzard.com/en-us/apps/battle.net/desktop',
        defaultInstallDir: r'C:\Program Files (x86)\Battle.net',
        defaultExePath: 'Battle.net.exe',
        defaultIconPath: Assets.graphics.platformIconBlizzard.keyName,
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
    "ea": GamePlatformType(
      key: 'ea',
      name: 'EA App',
      downloadUrl: 'https://www.ea.com/games/library/pc-download',
      defaultInstallDir:
          r'C:\Program Files\Electronic Arts\EA Desktop\EA Desktop',
      defaultExePath: 'EADesktop.exe',
      defaultIconPath: Assets.graphics.platformIconEa.keyName,
      defaultLibraryDirs: [r'C:\Program Files\EA Games'],
      locators: [
        RegistryLocator(
          installDir: RegistryLocatorValue(
            registryKey: r'SOFTWARE\Electronic Arts\EA Desktop',
            registryValueName: 'InstallLocation',
          ),
          mainExe: RegistryLocatorValue(
            registryKey: r'SOFTWARE\Electronic Arts\EA Desktop',
            registryValueName: 'DesktopAppPath',
          ),
        )
      ],
      gameDetectors: [
        LibraryFolderDetector(),
      ],
    ),
    "epic": GamePlatformType(
        key: 'epic',
        name: 'Epic Store',
        downloadUrl: 'https://www.epicgames.com/store/en-US/download',
        defaultInstallDir: r'C:\Program Files (x86)\Epic Games\Launcher',
        defaultExePath:
            r'\Launcher\Engine\Binaries\Win64\EpicGamesLauncher.exe',
        defaultIconPath: Assets.graphics.platformIconEpic.keyName,
        locators: [
          RegistryUninstallDataLocator(
            uninstallerKey:
                r'SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\B4B4F9022FD3528499604D6D8AE00CE9\InstallProperties',
          ),
        ]),
    "origin": GamePlatformType(
      key: 'origin',
      name: 'EA Origin',
      downloadUrl: 'https://www.origin.com/usa/en-us/store/download',
      defaultInstallDir: r'C:\Program Files (x86)\Origin',
      defaultExePath: 'Origin.exe',
      defaultIconPath: Assets.graphics.platformIconOrigin.keyName,
      locators: [
        RegistryUninstallDataLocator(
          uninstallerKey:
              r'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Origin',
        ),
        XmlLocator(
          xmlFilePath: "$appData/Origin/local.xml",
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
    "uplay": GamePlatformType(
      key: 'uplay',
      name: 'Uplay',
      downloadUrl: 'https://uplay.ubi.com/',
      defaultInstallDir:
          r'C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher',
      defaultExePath: 'Uplay.exe',
      defaultIconPath: Assets.graphics.platformIconUplay.keyName,
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
