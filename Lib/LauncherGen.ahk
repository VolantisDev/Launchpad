class Launchpad {
    appName := ""
    appDir := ""
    tempDir := A_Temp . "\Launchpad"
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
        
        this.appConfigObj := new AppConfig(this)

        this.tempDir := this.appConfigObj.CacheDir

        if (cachePath == "") {
            cachePath := this.tempDir . "\API"
        }

        this.apiEndpointObj := new ApiEndpoint(this, this.appConfigObj.ApiEndpoint, new ApiCache(this, cachePath))
        this.launchersObj := new LauncherConfig(this, this.appConfigObj.LauncherFile, true)
    }

    UpdateDependencies(forceUpdate := false) {
        Progress, Off
        Progress, M, Initializing..., Please wait while dependencies are updated., Updating Dependencies

        listingInstance := new ApiListing(this, "dependencies")
        updated := 0

        if (listingInstance.Exists()) {
            listing := listingInstance.Read()

            count := 0
            for index, key in listing.items
                count++
            Progress, R0-%count% M, Initializing..., Please wait while dependencies are updated., Updating Dependencies

            count := 0
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
        window := new MainWindow(this, "Launchpad")
        window.Show()
    }

    LaunchManageWindow() {
        window := new LauncherManager(this)
        window.Show()
    }

    LaunchToolsWindow() {
        window := new ToolsWindow(this)
        window.Show()
    }

    LaunchSettingsWindow() {
        window := new SettingsWindow(this)
        window.Show()
    }

    ReloadLauncherFile() {
        this.Launchers.LoadConfig()
    }

    OpenLauncherFile() {
        Run, % this.AppConfig.LauncherFile
    }

    ChangeLauncherFile() {
        existingFile := this.AppConfig.GetIniValue("LauncherFile")
        FileSelectFile, launcherFile, 3, %existingFile%, Select the Launchers file to use, JSON Documents (*.json)

        if (launcherFile != "") {
            this.AppConfig.LauncherFile := launcherFile
        }
        
        return launcherFile
    }

    OpenLauncherDir() {
        Run, % this.AppConfig.LauncherDir
    }

    ChangeLauncherDir() {
        existingDir := this.AppConfig.GetIniValue("LauncherDir")
        FileSelectFolder, launcherDir, *%existingDir%, 3, Create or select the folder to create game launchers within

        if (launcherDir != "") {
            this.AppConfig.LauncherDir := launcherDir
        }
        
        return launcherDir
    }

    OpenAssetsDir() {
        Run, % this.AppConfig.AssetsDir
    }

    ChangeAssetsDir() {
        existingDir := this.AppConfig.AssetsDir
        FileSelectFolder, assetsDir, *%existingDir%, 3, Create or select the folder to create game launcher assets within
        
        if (assetsDir != "") {
            this.AppConfig.AssetsDir := assetsDir
        }

        return assetsDir
    }

    ChangeCacheDir() {
        existingDir := this.AppConfig.CacheDir
        FileSelectFolder, cacheDir, *%existingDir%, 3, Create or select the folder to save Launchpad's cache files to
        
        if (cacheDir != "") {
            this.AppConfig.CacheDir := cacheDir
        }

        return cacheDir
    }

    ChangeApiEndpoint() {
        text := "Enter the base URL of the API endpoint you would like Launchpad to connect to.`n`nLeave blank to revert to the default."

        existingEndpoint := this.AppConfig.ApiEndpoint

        dialog := new SingleInputBox(this, "API Endpoint URL", text, existingEndpoint, "MainWindow")
        apiEndpointUrl := dialog.Show()

        if (apiEndpointUrl != existingEndpoint) {
            this.AppConfig.ApiEndpoint := apiEndpointUrl
            apiEndpointUrl := this.AppConfig.ApiEndpoint

            if (apiEndpointUrl != existingEndpoint) {
                this.ApiEndpoint.endpointUrl := this.AppConfig.ApiEndpoint
                this.FlushCache()
            }
        }
        
        return apiEndpointUrl
    }

    Cleanup() {
        Progress, Off
        Progress, M, Initializing..., Please wait while your launchers are cleaned., Cleaning Launchers

        count := 0
        for key, value in this.Launchers.Games
            count++
        Progress, R0-%count% M, Initializing..., Please wait while your launchers are cleaned., Cleaning Launchers

        cleaned := 0
        count := 0
        For key, config in this.Launchers.Games {
            count++
            Progress, %count%,% "Cleaning " . key . "...", Please wait while your launchers are cleaned., Cleaning Launchers
            
            success := false

            filePath := this.AppConfig.AssetsDir . "\" . key . "\" . key . ".ahk"

            if (FileExist(filePath)) {
                FileDelete, %filePath%
                cleaned++
            }
        }

        Progress, Off
        this.Toast("Cleaned " . cleaned . " launchers.")
    }

    FlushCache() {
        return this.apiEndpoint.cache.FlushCache()
    }

    Toast(message, title := "Launchpad", seconds := 10, options := 17) {
        TrayTip, %title%, %message%, %seconds%, %options%
    }

    ExitApp() {
        if (this.AppConfig.CleanOnExit) {
            this.FlushCache()
            this.Cleanup()
        }

        ExitApp
    }
}
