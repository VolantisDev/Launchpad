class Launchpad {
    appName := ""
    appDir := ""
    appConfigObj := ""
    windowManagerObj := ""
    dependencyManagerObj := ""
    launcherManagerObj := ""
    cacheManagerObj := ""
    notificationServiceObj := ""
    dataSourceManagerObj := ""
    builderManagerObj := ""
    
    Config[] {
        get => this.appConfigObj
        set => this.appConfigObj := value
    }

    Windows[] {
        get => this.windowManagerObj
        set => this.windowManagerObj := value
    }

    Dependencies[] {
        get => this.dependencyManagerObj
        set => this.dependencyManagerObj := value
    }

    Launchers[] {
        get => this.launcherManagerObj
        set => this.launcherManagerObj := value
    }

    Cache[] {
        get => this.cacheManagerObj
        set => this.cacheManagerObj := value
    }

    Notifications[] {
        get => this.notificationServiceObj
        set => this.notificationServiceObj := value
    }

    DataSources[] {
        get => this.dataSourceManagerObj
        set => this.dataSourceManagerObj := value
    }

    Builders[] {
        get => this.builderManagerObj
        set => this.builderManagerObj := value
    }

    __New(appName, appDir) {
        this.appName := appName
        this.appDir := appDir

        config := AppConfig.new(this, A_Temp . "\Launchpad")

        this.appConfigObj := config
        this.cacheManagerObj := CacheManager.new(this, config.CacheDir)
        this.notificationServiceObj := NotificationService.new(this, ToastNotifier.new(this))
        this.windowManagerObj := WindowManager.new(this)
        this.cacheManagerObj := CacheManager.new(this, config.CacheDir)
        this.dataSourceManagerObj := DataSourceManager.new(this)
        this.dependencyManagerObj := DependencyManager.new(this)
        this.builderManagerObj := BuilderManager.new(this)
        this.launcherManagerObj := LauncherManager.new(this)

        this.InitializeApp()
    }

    InitializeApp() {
        this.Builders.SetBuilder("ahk", AhkLauncherBuilder.new(this), true)
        
        this.DataSources.SetDataSource("api", ApiDataSource.new(this, this.Cache.GetCache("api"), this.Config.ApiEndpoint), true)
        this.Dependencies.InitializeDependencies()
        this.Launchers.SetDataSource("api")
        this.Launchers.LoadLaunchers(this.Config.LauncherFile)
    }

    ExitApp() {
        if (this.Config.CleanLaunchersOnExit) {
            this.Builders.CleanLaunchers()
        }

        if (this.Config.FlushCacheOnExit) {
            this.Cache.FlushCaches(false)
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
