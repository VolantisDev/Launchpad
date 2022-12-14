class SteamPlatform extends RegistryLookupGamePlatformBase {
    key := "Steam"
    displayName := "Steam"
    launcherType := "Default"
    gameType := "Default"
    installDirRegKey := "HKCU\SOFTWARE\Valve\Steam"
    installDirRegValue := "SteamPath"
    exePathRegKey := "HKCU\SOFTWARE\Valve\Steam"
    exePathRegValue := "SteamExe"
    versionRegView := 32
    versionRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam"
    uninstallCmdRegView := 32
    uninstallCmdRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam"

    Install() {
        Run("https://store.steampowered.com/about")
    }

    GetLibraryDirs() {
        libraryDirs := super.GetLibraryDirs()

        installDir := this.GetInstallDir()
        installDir := StrReplace(installDir, "/", "\")

        if (installDir) {
            steamapps := installDir . "\steamapps"

            if (!this.LibraryDirExists(steamapps)) {
                libraryDirs.Push(steamapps)
            }

            vdfFile := steamapps . "\libraryfolders.vdf"

            if (FileExist(vdfFile)) {
                data := VdfData()
                obj := data.FromFile(vdfFile)

                if (IsObject(obj) && obj.Has("LibraryFolders")) {
                    for key, val in obj["LibraryFolders"] {
                        if (IsInteger(key)) {
                            dir := StrReplace(val, "/", "\") . "\steamapps"

                            if (!this.LibraryDirExists(dir)) {
                                libraryDirs.Push(dir)
                            }
                        }
                    }
                }
            }
        }

        return libraryDirs
    }

    DetectInstalledGames() {
        games := []

        libraryDirs := this.GetLibraryDirs()

        for index, dir in libraryDirs {
            Loop Files dir . "\appmanifest_*.acf" {
                data := VdfData()
                obj := data.FromFile(A_LoopFileFullPath)

                if (IsObject(obj) && obj.Has("AppState")) {
                    gameState := obj["AppState"]
                    platformRef := gameState["appid"]
                    key := gameState["name"]
                    installDir := dir . "\common\" . gameState["installdir"]
                    installDir := StrReplace(installDir, "/", "\")
                    possibleExes := []

                    if (DirExist(installDir)) {
                        locator := GameExeLocator(installDir)
                        possibleExes := locator.Locate("")
                    }

                    mainExe := this.DetermineMainExe(key, possibleExes)
                    games.Push(DetectedGame(key, this, this.launcherType, this.gameType, installDir, mainExe, platformRef, possibleExes))
                }
            }
        }

        return games
    }

    GetExePath() {
        exePath := super.GetExePath()

        if (!exePath) {
            installDir := this.GetInstallDir()

            if (installDir) {
                exePath := installDir . "\Steam.exe"
            }
        }

        return exePath
    }
}
