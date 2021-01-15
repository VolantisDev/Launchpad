class SteamPlatform extends RegistryLookupGamePlatformBase {
    launcherType := "Default" ; @todo Create steam type?
    gameType := "Default" ; @todo Create steam type?
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

        if (installDir) {
            libraryDirs.Push(installDir . "\steamapps")

            vdfFile := installDir . "\steamapps\libraryfolders.vdf"

            if (FileExist(vdfFile)) {
                data := VdfData.new()
                obj := data.FromFile(vdfFile)

                if (IsObject(obj) and obj.Has("LibraryFolders")) {
                    for key, val in obj["LibraryFolders"] {
                        if (IsInteger(key)) {
                            libraryDirs.Push(val)
                        }
                    }
                }
            }
        }

        return libraryDirs
    }

    DetectInstalledGames() {
        games := []

        for index, dir in this.GetLibraryDirs() {
            Loop Files dir . "\appmanifest_*.acf" {
                data := VdfData.new()
                obj := data.FromFile(A_LoopFileFullPath)

                if (IsObject(obj) and obj.Has("AppState")) {
                    gameState := obj["AppState"]
                    launcherSpecificId := gameState["appid"]
                    key := gameState["name"]
                    installDir := dir . "\common\" . gameState["installdir"]
                    possibleExes := []
                    mainExe := ""

                    if (DirExist(installDir)) {
                        Loop Files installDir . "\*.exe", "R" {
                            possibleExes.Push(A_LoopFileFullPath)
                        }
                    }

                    if (possibleExes.Length == 1) {
                        mainExe := possibleExes[1]
                    }
                    
                    games.Push(DetectedGame.new(key, this, this.launcherType, this.gameType, installDir, mainExe, launcherSpecificId, possibleExes))
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
