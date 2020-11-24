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
        get => this.appConfigObj
        set => this.appConfigObj := value
    }

    ApiEndpoint[] {
        get => this.apiEndpointObj
        set => this.apiEndpointObj := value
    }

    GuiManager[] {
        get => this.guiServiceObj
        set => this.guiServiceObj := value
    }

    Dependencies[] {
        get => this.dependencyManagerObj
        set => this.dependencyManagerObj := value
    }

    LauncherManager[] {
        get => this.launcherManagerObj
        set => this.launcherManagerObj := value
    }

    CacheManager[] {
        get => this.cacheManagerObj
        set => this.cacheManagerObj := value
    }

    Notifications[] {
        get => this.notificationServiceObj
        set => this.notificationServiceObj := value
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
        this.launcherManagerObj := LauncherManager.new(this, AhkLauncherBuilder.new(this))

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
