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
    authServiceObj := ""
    
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

    Auth {
        get => this.authServiceObj
        set => this.authServiceObj := value
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
        this.loggerServiceObj := LoggerService.new(FileLogger.new(A_ScriptDir . "\log.txt", config.LoggingLevel, true))
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
        this.authServiceObj := AuthService.new(this, "", this.appStateObj)
       
        this.InitializeApp()
    }
    
    CheckForUpdates() {
        global appVersion

        if (appVersion != "{{VERSION}}") {
            dataSource := this.DataSources.GetItem("api")
            releaseInfoStr := dataSource.ReadItem("release-info")

            if (releaseInfoStr) {
                data := JsonData.new()
                releaseInfo := data.FromString(releaseInfoStr)

                if (releaseInfo && releaseInfo["data"].Has("version") && releaseInfo["data"]["version"] && this.VersionIsOutdated(releaseInfo["data"]["version"], appVersion)) {
                    this.Windows.UpdateAvailable(releaseInfo)
                }
            }
        }
    }

    VersionIsOutdated(latestVersion, installedVersion) {
        splitLatestVersion := StrSplit(latestVersion, ".")
        splitInstalledVersion := StrSplit(installedVersion, ".")

        for (index, numPart in splitInstalledVersion) {
            latestVersionPart := splitLatestVersion.Has(index) ? splitLatestVersion[index] : 0

            if ((latestVersionPart + 0) > (numPart + 0)) {
                return true
            } else if ((latestVersionPart + 0) < (numPart + 0)) {
                return false
            } 
        }

        return false
    }

    OnException(e, mode) {
        ; @todo allow submission of the error
        extra := (e.HasProp("Extra") && e.Extra != "") ? "`n`nExtra information:`n" . e.Extra : ""
        occurredIn := e.What ? " in " . e.What : ""

        errorText := "Launchpad has experienced an unhandled exception which it may not be able to fully recover from. You can find the details below, and submit the error to the developers to be fixed."
        errorText .= "`n`n" . e.Message . extra

        errorText .= "`n`nOccurred in: " . e.What
        
        if (e.File) {
            errorText .= "`nFile: " . e.File . " (Line " . e.Line . ")"
        }

        errorText .= "`n"

        return this.ShowError("Unhandled Exception", errorText, e, mode != "ExitApp")
    }

    ShowError(title, errorText, e, allowContinue := true) {
        themeObj := this.Themes ? this.Themes.GetItem() : JsonTheme.new("Steampad")
        btns := allowContinue ? "*&Continue|&Exit Launchpad" : "*&Exit Launchpad"
        result := this.Windows.ErrorDialog(e, "Unhandled Exception", errorText, "", "", btns)

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
        this.Auth.SetAuthProvider(LaunchpadApiAuthProvider.new(this, this.appStateObj))

        if (this.Config.ApiAutoLogin) {
            this.Auth.Login()
        }

        if (this.Config.CheckUpdatesOnStart) {
            this.CheckForUpdates()
        }
        
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

    UpdateStatusIndicators() {
        if (this.Windows.WindowIsOpen("ManageWindow")) {
            this.Windows._components["ManageWindow"].UpdateStatusIndicator()
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

    OpenWebsite() {
        Run("https://github.com/VolantisDev/Launchpad")
    }

    ProvideFeedback() {
        this.Windows.FeedbackWindow()
    }
}
