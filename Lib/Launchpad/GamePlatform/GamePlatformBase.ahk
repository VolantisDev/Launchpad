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
    merger := ""

    Name {
        get => this.displayName
        set => this.displayName := value
    }

    __New(app, installDir := "", exePath := "", installedVersion := "", uninstallCmd := "", libraryDirs := "") {
        this.app := app
        this.installDir := installDir
        this.exePath := exePath
        this.installedVersion := installedVersion
        this.uninstallCmd := ""
        this.merger := ListMerger(true)

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
        return this.app["version_checker"].VersionIsOutdated(this.GetLatestVersion(), this.GetInstalledVersion())
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

    GetPlatformRef(key) {
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
                platformRef := this.GetPlatformRef(key)
                detectedGameObj := DetectedGame(key, this, this.launcherType, this.gameType, installDir, exeName, platformRef, possibleExes)
                
                if (this.installDir) {
                    detectedGameObj.launcherInstallDir := this["InstallDir"]
                }
                
                games.Push(detectedGameObj)
            }
        }

        return games
    }

    DetermineMainExe(key, possibleExes) {
        mainExe := ""

        if (possibleExes.Length == 1) {
            mainExe := possibleExes[1]
        } else if (possibleExes.Length > 1) {
            ; @todo move the API functionality into a module that depends on WebServices
            if (this.app.Services.Has("entity_manager.web_service")) {
                mgr := this.app["entity_manager.web_service"]
    
                if (mgr.Has("launchpad_api")) {
                    webService := mgr["launchpad_api"]
    
                    resultData := webService.AdapterRequest(
                        Map("id", key),
                        Map(
                            "adapterType", "entity_data", 
                            "entityType", "launcher"
                        ),
                        "read",
                        true
                    )

                    for key, data in resultData {
                        if (
                            data 
                            && HasBase(data, Map.Prototype)
                            && data.Has("defaults")
                            && data["defaults"]
                            && data["defaults"].Has("GameExe")
                            && data["defaults"]["GameExe"]
                        ) {
                            for index, possibleExe in possibleExes {
                                SplitPath(possibleExe, &fileName)
    
                                if (data["defaults"]["GameExe"] == fileName) {
                                    mainExe := possibleExe
                                    break 2
                                }
                            }
                        }
                    }
                }
            }

            
        }

        return mainExe
    }
}
