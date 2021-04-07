class BlizzardPlatform extends RegistryLookupGamePlatformBase {
    key := "Blizzard"
    displayName := "Battle.net"
    launcherType := "Blizzard"
    gameType := "Blizzard"
    installDirRegView := 32
    installDirRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Battle.net"
    uninstallCmdRegView := 32
    uninstallCmdRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Battle.net"

    Install() {
        Run("https://www.blizzard.com/en-us/apps/battle.net/desktop")
    }

    GetLibraryDirs() {
        libraryDirs := super.GetLibraryDirs()
        ; TODO: Detect Blizzard library dirs
        return libraryDirs
    }

    DetectInstalledGames() {
        productDb := this.app.Services.Get("BlizzardProductDb")
        productInstalls := productDb.GetProductInstalls()
        games := []

        for index, productData in productInstalls {
            launcherSpecificId := productData["productCode"]

            if (launcherSpecificId != "agent" && launcherSpecificId != "bna" && productData.Has("settings") && productData["settings"].Has("installPath")) {
                installPath := productData["settings"]["installPath"]
                installPath := StrReplace(installPath, "/", "\")
                SplitPath(installPath, key)
                locator := GameExeLocator.new(installPath)
                possibleExes := locator.Locate("")
                mainExe := this.DetermineMainExe(key, possibleExes)
                games.Push(DetectedGame.new(key, this, this.launcherType, this.gameType, installPath, mainExe, launcherSpecificId, possibleExes))
            }
        }

        return games
    }

    GetExePath() {
        exePath := super.GetExePath()

        if (!exePath) {
            installDir := this.GetInstallDir()

            if (installDir) {
                exePath := installDir . "\Battle.net.exe"
            }
        }

        return exePath
    }
}
