class EpicPlatform extends RegistryLookupGamePlatformBase {
    displayName := "Epic"
    launcherType := "Epic"
    gameType := "Epic"
    installDirRegView := 32
    installDirRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0E63B233-DC24-442C-BD38-0B91D90FEC5B}"
    versionRegView := 32
    versionRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0E63B233-DC24-442C-BD38-0B91D90FEC5B}"
    uninstallCmdRegView := 32
    uninstallCmdRegKey := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0E63B233-DC24-442C-BD38-0B91D90FEC5B}"

    Install() {
        Run("https://www.epicgames.com/store/en-US/download")
    }

    GetLibraryDirs() {
        libraryDirs := super.GetLibraryDirs()
        
        ; @todo determine dirs from installed games?

        return libraryDirs
    }

    DetectInstalledGames() {
        manifestsDir := A_AppDataCommon . "\Epic\EpicGamesLauncher\Data\Manifests"

        games := []

        if (DirExist(manifestsDir)) {
            Loop Files manifestsDir . "\*.item" {
                data := JsonData.new()
                obj := data.FromFile(A_LoopFileFullPath)
                isGame := false

                if (obj["bIsApplication"]) {
                    for index, category in obj["AppCategories"] {
                        if (category == "games") {
                            isGame := true
                            break
                        }
                    }
                }

                if (isGame) {
                    key := obj["DisplayName"]
                    installDir := obj["InstallLocation"]
                    launcherSpecificId := obj["AppName"]
                    ;exeName := obj["LaunchExecutable"]
                    ;possibleExes := [obj["LaunchExecutable"]]
                    possibleExes := []
                    mainExe := ""

                    Loop Files installDir . "\*.exe", "R" {
                        if (this.ExeIsValid(A_LoopFileName, A_LoopFileFullPath)) {
                            possibleExes.Push(A_LoopFileFullPath)
                        }
                    }

                    mainExe := this.DetermineMainExe(key, possibleExes)
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
                bits := DirExist("C:\Program Files (x86)") ? "64" : "32"
                exePath := installDir . "\Launcher\Engine\Binaries\Win" . bits . "\EpicGamesLauncher.exe"
            }
        }

        return exePath
    }
}
