class LauncherGen {
    appName := ""
    appDir := ""
    tempDir := A_Temp . "\LauncherGen"
    appConfigObj := {}
    apiEndpointObj := {}
    launchersObj := {}
    
    AppConfig[] {
        get {
            return this.appConfigObj
        }
        set {
            return this.appConfigObj := value
        }
    }

    ApiEndpoint[] {
        get {
            return this.apiEndpointObj
        }
        set {
            return this.apiEndpointObj := value
        }
    }

    Launchers[] {
        get {
            return this.launchersObj
        }
        set {
            return this.launchersObj := value
        }
    }

    __New(appName, appDir, cachePath := "") {
        this.appName := appName
        this.appDir := appDir

        if (cachePath == "") {
            cachePath := this.tempDir . "\API"
        }
        
        this.apiEndpointObj := new ApiEndpoint(this, new ApiCache(this, cachePath))
        this.appConfigObj := new AppConfig(this)
        this.launchersObj := new LauncherConfig(this, this.appConfigObj.LauncherFile, true)
    }

    UpdateDependencies(forceUpdate := false) {
        Progress, Off
        Progress, M, Initializing..., Please wait while dependencies are updated., Updating Dependencies

        listingInstance := new ApiListing(this, "dependencies")

        if (listingInstance.Exists()) {
            listing := listingInstance.Read()

            count := 0
            for index, key in listing.items
                count++
            Progress, R0-%count% M, Initializing..., Please wait while dependencies are updated., Updating Dependencies

            count := 0
            updated := 0
            for index, key in listing.items {
                count++
                Progress, %count%,% "Discovering " . key . "...", Please wait while dependencies are updated., Updating Dependencies

                item := new ApiDependency(this, key)

                if (item.Exists()) {
                    dependencyConfig := item.Read()
                    dependencyClass := dependencyConfig.class
                    dependencyInstance := new %dependencyClass%(this, key, dependencyConfig)

                    if (dependencyInstance.NeedsUpdate(forceUpdate)) {
                        updated++
                        if (dependencyInstance.IsInstalled()) {
                            Progress,,% "Updating " . dependencyConfig.name . "...", Please wait while dependencies are updated., Updating Dependencies
                            dependencyInstance.Update(forceUpdate)
                        } else {
                            Progress,,% "Installing " . dependencyConfig.name . "...", Please wait while dependencies are updated., Updating Dependencies
                            dependencyInstance.Install()
                        }
                    }
                }
            }
        }

        Progress, Off

        if (updated > 0 or forceUpdate) {
            this.Toast("Updated " . updated . " dependencies.")
        }
    }

    BuildLaunchers(updateExisting := false) {
        Progress, Off
        Progress, M, Initializing..., Please wait while your launchers are built., Building Launchers

        count := 0
        for key, value in this.Launchers.Games
            count++
        Progress, R0-%count% M, Initializing..., Please wait while your launchers are built., Building Launchers

        built := 0
        count := 0
        For key, config in this.Launchers.Games {
            count++
            Progress, %count%,% "Discovering " . key . "...", Please wait while your launchers are built., Building Launchers
            success := false

            if (updateExisting or !this.LauncherExists(key, config)) {
                Progress,,% "Building launcher: " . key . "...", Please wait while your launchers are built., Building Launchers
                success := this.BuildLauncher(key, config)

                if (success) {
                    built++
                }
            }
        }

        Progress, Off
        this.Toast("Built " . built . " launchers.")
    }

    GetLauncherFile(key, ext := ".exe") {
        gameDir := this.AppConfig.LauncherDir

        if (this.AppConfig.IndividualDirs) {
            gameDir .= "\" . key
        }

        return gameDir . "\" . key . ext
    }

    LauncherExists(key, config) {
        if (!FileExist(this.AppConfig.LauncherDir)) {
            return false
        }

        return FileExist(this.GetLauncherFile(key)) != ""
    }

    BuildLauncher(key, config) {
        generatorInstance := new Builder(this, key, config)
        return generatorInstance.Build()
    }

    LaunchMainWindow() {
        window := new MainWindow(this)
        window.Show()
    }

    LaunchManageWindow() {
        this.Toast("A launcher management GUI is coming soon.")
        ; @todo Show Launcher Manager window.
    }

    ReloadLauncherFile() {
        this.Launchers.LoadConfig()
    }

    OpenLauncherFile() {
        Run, % this.AppConfig.LauncherFile
    }

    ChangeLauncherFile() {
        FileSelectFile, launcherFile, 1,, Select the Launchers file to use, JSON Documents (*.json)
        this.AppConfig.LauncherFile := launcherFile
        return launcherFile
    }

    OpenLauncherDir() {
        Run, % this.AppConfig.LauncherDir
    }

    ChangeLauncherDir() {
        FileSelectFolder, launcherDir,, 3, Create or select the folder to create game launchers within
        this.AppConfig.LauncherDir := launcherDir
        return launcherDir
    }

    OpenAssetsDir() {
        Run, % this.AppConfig.AssetsDir
    }

    ChangeAssetsDir() {
        FileSelectFolder, assetsDir,, 3, Create or select the folder to create game launcher assets within
        this.AppConfig.AssetsDir := assetsDir
        return assetsDir
    }

    Cleanup() {
        this.Toast("Launcher cleanup functionality is coming soon.")
        ; @todo Confirm deletion of generated launchers and then delete them.
    }

    FlushCache() {
        return this.apiEndpoint.cache.FlushCache()
    }

    Toast(message, title := "LauncherGen", seconds := 10, options := 17) {
        TrayTip, %title%, %message%, %seconds%, %options%
    }
}
