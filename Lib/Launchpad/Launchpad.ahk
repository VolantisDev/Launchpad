class Launchpad {
    appName := ""
    appDir := ""
    tmpDir := A_Temp . "\Launchpad"
    appDataDir := A_AppData . "\Volantis\Launchpad"
    appConfigObj := ""
    appStateObj := ""
    windowManagerObj := ""
    launcherManagerObj := ""
    platformManagerObj := ""
    cacheManagerObj := ""
    notificationServiceObj := ""
    dataSourceManagerObj := ""
    builderManagerObj := ""
    installerManagerObj := ""
    themeManagerObj := ""
    eventManagerObj := ""
    idGenObj := ""
    blizzardProductDbObj := ""
    moduleManagerObj := ""
    
    Config {
        get => this.appConfigObj
        set => this.appConfigObj := value
    }

    Modules {
        get => this.moduleManagerObj
        set => this.moduleManagerObj := value
    }

    Windows {
        get => this.windowManagerObj
        set => this.windowManagerObj := value
    }

    Launchers {
        get => this.launcherManagerObj
        set => this.launcherManagerObj := value
    }

    Platforms {
        get => this.platformManagerObj
        set => this.platformManagerObj := value
    }

    Cache {
        get => this.cacheManagerObj
        set => this.cacheManagerObj := value
    }

    Notifications {
        get => this.notificationServiceObj
        set => this.notificationServiceObj := value
    }

    DataSources {
        get => this.dataSourceManagerObj
        set => this.dataSourceManagerObj := value
    }

    Builders {
        get => this.builderManagerObj
        set => this.builderManagerObj := value
    }

    AppState {
        get => this.appStateObj
        set => this.appStateObj := value
    }

    Installers {
        get => this.installerManagerObj
        set => this.installerManagerObj := value
    }

    Themes {
        get => this.themeManagerObj
        set => this.themeManagerObj := value
    }

    Events {
        get => this.eventManagerObj
        set => this.eventManagerObj := value
    }

    IdGen {
        get => this.idGenObj
        set => this.idGenObj := value
    }

    BlizzardProductDb {
        get => this.blizzardProductDbObj
        set => this.blizzardProductDbObj := value
    }

    Logger {
        get => this.loggerServiceObj
        set => this.loggerServiceObj := value
    }

    Version {
        get => this.LaunchpadVersion()
    }

    __New(appName, appDir) {
        InvalidParameterException.CheckTypes("Launchpad", "appName", appName, "", "appDir", appDir, "")
        this.appName := appName
        this.appDir := appDir

        DirCreate(this.tmpDir)
        DirCreate(this.appDataDir)
        
        config := AppConfig.new(this, this.tmpDir, this.appDataDir)
        this.appConfigObj := config

        idGen := UuidGenerator.new()
        this.idGen := idGen
        
        this.appStateObj := LaunchpadAppState.new(this.appDataDir . "\State.json")
        
        eventManagerObj := EventManager.new()
        this.eventManagerObj := eventManagerObj

        this.errorCallback := ObjBindMethod(this, "OnException")
        OnError(this.errorCallback)
    
        this.moduleManagerObj := ModuleManager.new(this)
        this.loggerServiceObj := LoggerService.new(FileLogger.new(A_ScriptDir . "\log.txt", config.LoggingLevel, 5))
        this.cacheManagerObj := CacheManager.new(this, config.CacheDir)
        this.themeManagerObj := ThemeManager.new(this, appDir . "\Resources\Themes", appDir . "\Resources", eventManagerObj, idGen)
        this.notificationServiceObj := NotificationService.new(this, ToastNotifier.new(this))
        this.windowManagerObj := WindowManager.new(this)
        this.cacheManagerObj := CacheManager.new(this, config.CacheDir)
        this.dataSourceManagerObj := DataSourceManager.new(eventManagerObj)
        this.builderManagerObj := BuilderManager.new(this)
        this.blizzardProductDbObj := BlizzardProductDb.new(this)
        this.launcherManagerObj := LauncherManager.new(this)
        this.platformManagerObj := PlatformManager.new(this)
        this.installerManagerObj := InstallerManager.new(this)
       
        this.InitializeApp()
    }

    OnException(e, mode) {
        ; @todo allow submission of the error
        extra := (e.HasProp("Extra") && e.Extra != "") ? "`n`nAdditional info:`n" . e.Extra : ""
        occurredIn := e.What ? " in " . e.What : ""

        errorText := "Launchpad has experienced an unhandled exception" . occurredIn
        errorText .= ".`n`n" . e.Message . extra
        errorText .= "`n`nDebugging Information:`nFile: " . e.File . "`nLine: " . e.Line
        errorText .= "`n`nPlease report this error at https://github.com/VolantisDev/Launchpad/issues so that it can be fixed in an upcoming release."
        
        if (mode == "Exit") {
            errorText .= "`n`nThis is an unrecoverable error and the current thread must exit.`nContinuing the application might have unexpected results."
        } else if (mode == "ExitApp") {
            errorText .= "`n`nThis is a fatal error and Launchpad must exit."
        }

        return this.ShowError("Unhandled Exception", errorText, mode != "ExitApp")
    }

    ShowError(title, errorText, allowContinue := true) {
        themeObj := this.Themes ? this.Themes.GetItem() : JsonTheme.new("Steampad")
        btns := allowContinue ? "*&Continue|&Exit Launchpad" : "*&Exit Launchpad"
        dialog := DialogBox.new(title, themeObj, errorText, "AppException", "", "", btns)
        result := dialog.Show()

        if (result == "Exit Launchpad") {
            ExitApp
        }

        return allowContinue ? -1 : 1
    }

    LaunchpadVersion() {
        global appVersion
        return appVersion
    }

    InitializeApp() {
        
        this.Builders.SetItem("ahk", AhkLauncherBuilder.new(this), true)
        this.DataSources.SetItem("api", ApiDataSource.new(this, this.Cache.GetItem("api"), this.Config.ApiEndpoint), true)
        this.Installers.SetupInstallers()

        this.Installers.InstallRequirements()
        this.Platforms.LoadComponents(this.Config.PlatformsFile)
        this.Launchers.LoadComponents(this.Config.LauncherFile)

        result := ""

        if (!FileExist(A_ScriptDir . "\Launchpad.ini")) {
            result := this.Windows.SetupWindow()

            if (result == "Exit") {
                this.ExitApp()
            }
        }

        this.Windows.OpenManageWindow()

        if (result == "Detect") {
            this.Platforms.DetectGames()
        }
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
