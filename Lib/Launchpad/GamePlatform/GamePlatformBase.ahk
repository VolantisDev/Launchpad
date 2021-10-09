class GamePlatformBase {
    key := ""
    app := ""
    installDir := ""
    exePath := ""
    uninstallCmd := ""
    installedVersion := ""
    latestVersion := ""
    libraryDirs := []
    launcherType := "Default"
    gameType := "Default"
    displayName := ""

    __New(app, installDir := "", exePath := "", installedVersion := "", uninstallCmd := "", libraryDirs := "") {
        this.app := app
        this.installDir := installDir
        this.exePath := exePath
        this.installedVersion := installedVersion
        this.uninstallCmd := ""

        if (libraryDirs != "") {
            if (Type(libraryDirs) == "String") {
                libraryDirs := [libraryDirs]
            }

            this.libraryDirs := libraryDirs
        }
    }

    LibraryDirExists(dir) {
        exists := false

        if (this.libraryDirs) {
            for index, key in this.libraryDirs {
                if (key == dir) {
                    exists := true
                    break
                }
            }
        }
        
        return exists
    }

    GetLibraryDirs() {
        return this.libraryDirs
    }

    GetInstallDir() {
        return this.installDir
    }

    GetExePath() {
        return this.exePath
    }

    GetUninstallCmd() {
        return this.uninstallCmd
    }

    OpenDir() {
        installDir := this.GetInstallDir()

        if (installDir) {
            Run(installDir)
        }
    }

    Run() {
        exePath := this.GetExePath()

        if (exePath) {
            Run(exePath)
        }
    }

    IsInstalled() {
        exePath := this.GetExePath()
        return (exePath && FileExist(exePath))
    }

    NeedsUpdate() {
        return this.app.Service("VersionChecker").VersionIsOutdated(this.GetLatestVersion(), this.GetInstalledVersion())
    }

    GetInstalledVersion() {
        if (!this.installedVersion) {
            this.installedVersion := this.LookupInstalledVersion()
        }

        return this.installedVersion
    }

    GetLatestVersion() {
        if (!this.latestVersion) {
            this.latestVerison := this.LookupLatestVersion()
        }

        return this.latestVersion
    }

    LookupInstalledVersion() {
        return ""
    }

    LookupLatestVersion() {
        return ""
    }

    Update() {  
        if (this.NeedsUpdate()) {
            this.Install()
        }
    }

    Install() {

    }

    Uninstall() {
        if (this.uninstallCmd) {
            result := MsgBox("Are you sure you want to uninstall " . this.displayName . "?", "Uninstall " . this.displayName, "YesNo")
        
            if (result == "Yes") {
                RunWait(this.uninstallCmd)
            }
        }
    }

    FilterGameDirectories() {
        return []
    }

    GetLauncherSpecificId(key) {
        return key
    }

    GetLauncherKey(key) {
        return key
    }

    DetectInstalledGames() {
        games := []

        filterGameDirectories := this.FilterGameDirectories()

        for index, dir in this.GetLibraryDirs() {
            Loop Files dir . "\*", "D" {
                for index, filterDir in filterGameDirectories {
                    if filterDir == A_LoopFileName {
                        continue 2
                    }
                }

                key := this.GetLauncherKey(A_LoopFileName)
                installDir := A_LoopFileFullPath
                locator := GameExeLocator(installDir)
                possibleExes := locator.Locate("")
                exeName := this.DetermineMainExe(key, possibleExes)
                launcherSpecificId := this.GetLauncherSpecificId(key)
                detectedGameObj := DetectedGame(key, this, this.launcherType, this.gameType, installDir, exeName, launcherSpecificId, possibleExes)
                
                if (this.installDir) {
                    detectedGameObj.launcherInstallDir := this.InstallDir
                }
                
                games.Push(detectedGameObj)
            }
        }

        return games
    }

    DetermineMainExe(key, possibleExes) {
        dataSource := this.app.Service("DataSourceManager").GetDefaultDataSource()
        dsData := this.GetDataSourceDefaults(dataSource, key)

        mainExe := ""

        if (possibleExes.Length == 1) {
            mainExe := possibleExes[1]
        } else if (possibleExes.Length > 1 && dsData.Has("GameExe")) {
            for index, possibleExe in possibleExes {
                SplitPath(possibleExe, &fileName)

                if (dsData["GameExe"] == fileName) {
                    mainExe := possibleExe
                    break
                }
            }
        }

        return mainExe
    }

    GetDataSourceDefaults(dataSource, key) {
        defaults := Map()
        dsData := dataSource.ReadJson(key, "Games")

        if (dsData != "" && dsData.Has("data") && dsData["data"].Has("defaults")) {
            defaults := this.MergeFromObject(defaults, dsData["data"]["defaults"], false)
        }

        return defaults
    }

    MergeFromObject(mainObject, defaults, overwriteKeys := false) {
        for key, value in defaults {
            if (overwriteKeys or !mainObject.Has(key)) {
                if (value == "true" or value == "false") {
                    mainObject[key] := (value == "true")
                } else {
                    mainObject[key] := value
                }
            }
        }

        return mainObject
    }
}
