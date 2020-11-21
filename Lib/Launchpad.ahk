class Launchpad {
    appName := ""
    appDir := ""
    tempDir := ""
    cacheDir := ""
    appConfigObj := ""
    apiEndpointObj := ""
    launchersObj := ""
    caches := Map()
    guiServiceObj := ""
    
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

    GuiManager[] {
        get {
            return this.guiServiceObj
        }
        set {
            return this.guiServiceObj := value
        }
    }

    __New(appName, appDir) {
        this.appName := appName
        this.appDir := appDir
        
        this.appConfigObj := AppConfig.new(this)

        this.tempDir := this.appConfigObj.TempDir
        this.cacheDir := this.appConfigObj.CacheDir
        this.guiServiceObj := GuiService.new(this)

        this.SetupCaches()

        this.apiEndpointObj := ApiEndpoint.new(this, this.appConfigObj.ApiEndpoint, this.caches["api"])
        this.launchersObj := LauncherConfig.new(this, this.appConfigObj.LauncherFile, true)
    }

    SetupCaches() {
        this.caches["app"] := ObjectCache.new(this)
        this.caches["file"] := FileCache.new(this, this.cacheDir)
        this.caches["api"] := FileCache.new(this, this.cacheDir . "\API")
    }

    GetCache(key) {
        return (this.caches.Has(key)) ? this.caches[key] : ""
    }

    SetCache(key, cacheObj) {
        this.caches[key] := cacheObj
    }

    CountDependencies(listingInstance := "") {
        if (listingInstance == "") {
            listingInstance := ApiListing.new(this, "dependencies")
        }

        count := 0

        if (listingInstance.Exists()) {
            listing := listingInstance.Read()

            for index, key in listing["items"] {
                count++
            } 
        }

        return count
    }

    UpdateDependencies(forceUpdate := false, owner := "MainWindow") {
        progress := this.GuiManager.ProgressIndicator("Updating Dependencies", "Please wait while dependencies are updated.", owner, "0-100", 0, "Initializing...")

        listingInstance := ApiListing.new(this, "dependencies")
        updated := 0
        count := this.CountDependencies(listingInstance)

        if (count > 0) {
            progress.SetRange("0-" . count)
            listing := listingInstance.Read()

            currentItem := 1
            for index, key in listing["items"] {
                progress.SetValue(currentItem, key . ": Discovering...")

                item := ApiDependency.new(this, key)

                if (item.Exists()) {
                    dependencyConfig := item.Read()
                    dependencyClass := dependencyConfig["class"]
                    dependencyInstance := %dependencyClass%.new(this, key, dependencyConfig)

                    if (dependencyInstance.NeedsUpdate(forceUpdate)) {
                        installed := dependencyInstance.IsInstalled()
                        statusText := installed ? "Updating" : "Installing"
                        progress.SetDetailText(dependencyConfig["name"] . ": " . statusText . "...")
                        result := installed ? dependencyInstance.Update(forceUpdate) : dependencyInstance.Install()
                        updated++
                    }
                }

                currentItem++
            }
        }

        progress.Finish()

        if (updated > 0 or forceUpdate) {
            this.Toast("Updated " . updated . " dependencies.")
        }
    }

    CountLaunchers() {
        count := 0

        for key, value in this.Launchers.Games {
            count++
        } 

        return count
    }

    BuildLaunchers(updateExisting := false, owner := "MainWindow") {
        count := this.CountLaunchers()
        progress := this.GuiManager.ProgressIndicator("Building Launchers", "Please wait while your launchers are built.", owner, "0-" . count, 0, "Initializing...")

        built := 0
        currentItem := 1
        For key, config in this.Launchers.Games {
            progress.SetValue(currentItem, key . ": Discovering...")
            success := false

            if (updateExisting or !this.LauncherExists(key, config)) {
                progress.SetDetailText(key . ": Building launcher...")
                success := this.BuildLauncher(key, config)

                if (success) {
                    built++
                }
            }

            currentItem++
        }

        progress.Finish()
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
        generatorInstance := Builder.new(this, key, config)
        return generatorInstance.Build()
    }

    ReloadLauncherFile() {
        this.Launchers.LoadConfig()
    }

    OpenLauncherFile() {
        Run(this.AppConfig.LauncherFile)
    }

    ChangeLauncherFile() {
        existingFile := this.AppConfig.GetIniValue("LauncherFile")
        launcherFile := FileSelect(3, existingFile, "Select the Launchers file to use", "JSON Documents (*.json)")

        if (launcherFile != "") {
            this.AppConfig.LauncherFile := launcherFile
        }
        
        return launcherFile
    }

    OpenLauncherDir() {
        Run(this.AppConfig.LauncherDir)
    }

    ChangeLauncherDir() {
        existingDir := this.AppConfig.GetIniValue("LauncherDir")
        launcherDir := DirSelect("*" . existingDir, 3, "Create or select the folder to create game launchers within")

        if (launcherDir != "") {
            this.AppConfig.LauncherDir := launcherDir
        }
        
        return launcherDir
    }

    OpenAssetsDir() {
        Run(this.AppConfig.AssetsDir)
    }

    ChangeAssetsDir() {
        existingDir := this.AppConfig.AssetsDir
        assetsDir := DirSelect("*" . existingDir, 3, "Create or select the folder to create launcher assets within")
        
        if (assetsDir != "") {
            this.AppConfig.AssetsDir := assetsDir
        }

        return assetsDir
    }

    ChangeCacheDir() {
        existingDir := this.AppConfig.CacheDir
        cacheDir := DirSelect("*" . existingDir, 3, "Create or select the folder to save Launchpad's cache files to")
        
        if (cacheDir != "") {
            this.AppConfig.CacheDir := cacheDir
            this.cacheDir := cacheDir
            this.SetupCaches()
        }

        return cacheDir
    }

    ChangeApiEndpoint(owner := "MainWindow") {
        text := "Enter the base URL of the API endpoint you would like Launchpad to connect to.`n`nLeave blank to revert to the default."

        existingEndpoint := this.AppConfig.ApiEndpoint
        apiEndpointUrl := this.GuiManager.SingleInputBox("API Endpoint URL", text, existingEndpoint, owner)

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

    Cleanup(owner := "MainWindow") {
        count := this.CountLaunchers()
        progress := this.GuiManager.ProgressIndicator("Cleaning Launchers", "Please wait while your launchers are cleaned up.", owner, "0-" . count, 0, "Initializing...")

        cleaned := 0
        currentItem := 1
        For key, config in this.Launchers.Games {
            progress.SetValue(currentItem, key . ": Cleaning launcher...")
            success := false

            filePath := this.AppConfig.AssetsDir . "\" . key . "\" . key . ".ahk"

            if (FileExist(filePath)) {
                FileDelete(filePath)
                cleaned++
            }

            currentItem++
        }

        progress.Finish()
        this.Toast("Cleaned " . cleaned . " launchers.")
    }

    FlushCache() {
        for key, cacheObj in this.caches
        {
            cacheObj.FlushCache()
        }

        this.Toast("Flushed all caches.")
    }

    Toast(message, title := "Launchpad", options := 17) {
        TrayTip(message, title, options)
    }

    ExitApp() {
        if (this.AppConfig.CleanOnExit) {
            this.FlushCache()
            this.Cleanup()
        }

        ExitApp
    }

    OpenApiEndpoint() {
        Run(this.AppConfig.ApiEndpoint)
    }

    OpenCacheDir() {
        Run(this.AppConfig.CacheDir)
    }

    OpenHomepage() {
        Run("https://github.com/bmcclure/Launchpad")
    }
}
