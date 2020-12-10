class Launchpad {
    appName := ""
    appDir := ""
    tmpDir := A_Temp . "\Launchpad"
    appDataDir := A_AppData . "\Volantis\Launchpad"
    appConfigObj := ""
    appStateObj := ""
    windowManagerObj := ""
    launcherManagerObj := ""
    cacheManagerObj := ""
    notificationServiceObj := ""
    dataSourceManagerObj := ""
    builderManagerObj := ""
    installerManagerObj := ""
    themeManagerObj := ""
    eventManagerObj := ""
    
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

    Themes[] {
        get => this.themeManagerObj
        set => this.themeManagerObj := value
    }

    Events[] {
        get => this.eventManagerObj
        set => this.eventManagerObj := value
    }

    __New(appName, appDir) {
        InvalidParameterException.CheckTypes("Launchpad", "appName", appName, "", "appDir", appDir, "")
        this.appName := appName
        this.appDir := appDir

        DirCreate(this.tmpDir)
        DirCreate(this.appDataDir)

        config := AppConfig.new(this, this.tmpDir, this.appDataDir)
        appStateObj := LaunchpadAppState.new(this.appDataDir . "\State.json")
        eventManagerObj := EventManager.new()

        this.appConfigObj := config
        this.appStateObj := appStateObj
        this.eventManagerObj := eventManagerObj
        this.cacheManagerObj := CacheManager.new(this, config.CacheDir)
        this.notificationServiceObj := NotificationService.new(this, ToastNotifier.new(this))
        this.themeManagerObj := ThemeManager.new(this, appDir . "\Resources\Themes", eventManagerObj)
        this.windowManagerObj := WindowManager.new(this)
        this.cacheManagerObj := CacheManager.new(this, config.CacheDir)
        this.dataSourceManagerObj := DataSourceManager.new(this)
        this.builderManagerObj := BuilderManager.new(this)
        this.launcherManagerObj := LauncherManager.new(this)
        this.installerManagerObj := InstallerManager.new(this)

        this.InitializeApp()
    }

    InitializeApp() {
        this.Builders.SetItem("ahk", AhkLauncherBuilder.new(this), true)
        this.DataSources.SetItem("api", ApiDataSource.new(this, this.Cache.GetItem("api"), this.Config.ApiEndpoint), true)
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
