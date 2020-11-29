class Launchpad {
    appName := ""
    appDir := ""
    tmpDir := ""
    appConfigObj := ""
    appStateObj := ""
    windowManagerObj := ""
    launcherManagerObj := ""
    cacheManagerObj := ""
    notificationServiceObj := ""
    dataSourceManagerObj := ""
    builderManagerObj := ""
    installerManagerObj := ""
    
    Config[] {
        get => this.appConfigObj
        set => this.appConfigObj := value
    }

    Windows[] {
        get => this.windowManagerObj
        set => this.windowManagerObj := value
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

    AppState[] {
        get => this.appStateObj
        set => this.appStateObj := value
    }

    Installers[] {
        get => this.installerManagerObj
        set => this.installerManagerObj := value
    }

    __New(appName, appDir) {
        InvalidParameterException.CheckTypes("Launchpad", "appName", appName, "", "appDir", appDir, "")
        this.appName := appName
        this.appDir := appDir

        tmpDir := A_Temp . "\Launchpad"
        this.tmpDir := tmpDir
        DirCreate(tmpDir)

        config := AppConfig.new(this, tmpDir)
        appStateObj := LaunchpadAppState.new(tmpDir . "\State.json")

        this.appConfigObj := config
        this.appStateObj := appStateObj
        this.cacheManagerObj := CacheManager.new(this, config.CacheDir)
        this.notificationServiceObj := NotificationService.new(this, ToastNotifier.new(this))
        this.windowManagerObj := WindowManager.new(this)
        this.cacheManagerObj := CacheManager.new(this, config.CacheDir)
        this.dataSourceManagerObj := DataSourceManager.new(this)
        this.builderManagerObj := BuilderManager.new(this)
        this.launcherManagerObj := LauncherManager.new(this)
        this.installerManagerObj := InstallerManager.new(this)

        this.InitializeApp()
    }

    InitializeApp() {
        this.Builders.SetBuilder("ahk", AhkLauncherBuilder.new(this), true)
        this.DataSources.SetDataSource("api", ApiDataSource.new(this, this.Cache.GetCache("api"), this.Config.ApiEndpoint), true)
        this.Installers.SetupInstallers()
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
        Run("https://github.com/VolantisDev/Launchpad/releases/latest")
    }

    OpenWebsite() {
        Run("https://github.com/VolantisDev/Launchpad")
    }

    ProvideFeedback() {
        Run("https://github.com/VolantisDev/Launchpad/issues")
    }
}
