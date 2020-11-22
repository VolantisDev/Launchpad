class Launchpad {
    appName := ""
    appDir := ""
    appConfigObj := ""
    apiEndpointObj := ""
    guiServiceObj := ""
    dependencyManagerObj := ""
    launcherManagerObj := ""
    cacheManagerObj := ""
    notificationServiceObj := ""
    
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

    GuiManager[] {
        get {
            return this.guiServiceObj
        }
        set {
            return this.guiServiceObj := value
        }
    }

    Dependencies[] {
        get {
            return this.dependencyManagerObj
        }
        set {
            return this.dependencyManagerObj := value
        }
    }

    LauncherManager[] {
        get {
            return this.launcherManagerObj
        }
        set {
            return this.launcherManagerObj := value
        }
    }

    CacheManager[] {
        get {
            return this.cacheManagerObj
        }
        set {
            return this.cacheManagerObj := value
        }
    }

    Notifications[] {
        get {
            return this.notificationServiceObj
        }
        set {
            return this.notificationServiceObj := value
        }
    }

    __New(appName, appDir) {
        this.appName := appName
        this.appDir := appDir
    
        this.appConfigObj := AppConfig.new(this, A_Temp . "\Launchpad", )
        this.notificationServiceObj := NotificationService.new(this, ToastNotifier.new(this))
        this.guiServiceObj := GuiService.new(this)
        this.cacheManagerObj := CacheManager.new(this, this.appConfigObj.CacheDir)
        this.apiEndpointObj := ApiEndpoint.new(this, this.appConfigObj.ApiEndpoint, this.cacheManagerObj.GetCache("api"))
        this.dependencyManagerObj := DependencyManager.new(this)
        this.launcherManagerObj := LauncherManager.new(this, Builder.new(this))

        this.dependencyManagerObj.InitializeDependencies()
        this.launcherManagerObj.LoadLauncherFile(this.appConfigObj.LauncherFile)
    }

    ExitApp() {
        if (this.AppConfig.CleanLaunchersOnExit) {
            this.LauncherManager.CleanLaunchers(false)
        }

        if (this.AppConfig.FlushCacheOnExit) {
            this.CacheManager.FlushCaches(false)
        }

        ExitApp
    }

    CheckForUpdates() {
        Run("https://github.com/bmcclure/Launchpad/releases")
    }

    OpenWebsite() {
        Run("https://github.com/bmcclure/Launchpad")
    }

    ProvideFeedback() {
        Run("https://github.com/bmcclure/Launchpad/issues")
    }
}
