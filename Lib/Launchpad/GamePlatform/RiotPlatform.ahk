class RiotPlatform extends RegistryLookupGamePlatformBase {
    key := "Riot"
    displayName := "Riot Client"
    launcherType := "Riot"
    gameType := "Riot"
    installDirRegView := 64
    installDirRegKey := "HKCR\riotclient\shell\open\command"
    installDirRegValue := ""

    __New(app, installDir := "", exePath := "", installedVersion := "", uninstallCmd := "", libraryDirs := "") {
        super.__New(app, installDir, exePath, installedVersion, uninstallCmd, libraryDirs)
        this.installDir := this.GetRiotClientPath()
    }

    Install() {

    }

    GetRiotClientPath() {
        val := this.LookupRegValue(this.installDirRegView, this.installDirRegKey, this.installDirRegValue)

        if (val) {
            foundPos := InStr(val, "\RiotClientServices.exe")
            val := SubStr(val, 2, foundPos - 1)
        }

        return val
    }

    GetExePath() {
        exePath := super.GetExePath()

        if (!exePath) {
            installDir := this.GetInstallDir()

            if (installDir) {
                exePath := installDir . "\RiotClientServices.exe"
            }
        }

        return exePath
    }

    GetLibraryDirs() {
        libraryDirs := super.GetLibraryDirs()

        if (this.installDir) {
            installDir := this.installDir
            if (SubStr(installDir, -1) == "\") {
                installDir := SubStr(installDir, 1, -1)
            }

            gamesDir := SubStr(installDir, 1, InStr(installDir, "\", false, -1)-1)
            
            if (DirExist(gamesDir)) {
                libraryDirs.Push(gamesDir)
            }
        }

        return libraryDirs
    }

    FilterGameDirectories() {
        dirs := super.FilterGameDirectories()
        dirs.Push("Riot Client")
        return dirs
    }

    GetLauncherSpecificId(key) {
        if (key == "VALORANT") {
            key := "valorant"
        } else if (key == "Legends of Runeterra") {
            key := "bacon"
        }

        return key
    }

    GetLauncherKey(key) {
        if (key == "LoR") {
            key := "Legends of Runeterra"
        }

        return key
    }
}
