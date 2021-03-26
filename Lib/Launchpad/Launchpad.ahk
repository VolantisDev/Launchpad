class Launchpad extends AppBase {
    Modules {
        get => this.Services.Get("ModuleManager")
        set => this.Services.Set("ModuleManager", value)
    }

    Windows {
        get => this.Services.Get("WindowManager")
        set => this.Services.Set("WindowManager", value)
    }

    Launchers {
        get => this.Services.Get("LauncherManager")
        set => this.Services.Set("LauncherManager", value)
    }

    Platforms {
        get => this.Services.Get("PlatformManager")
        set => this.Services.Set("PlatformManager", value)
    }

    Cache {
        get => this.Services.Get("CacheManager")
        set => this.Services.Set("CacheManager", value)
    }

    Notifications {
        get => this.Services.Get("NotificationService")
        set => this.Services.Set("NotificationService", value)
    }

    DataSources {
        get => this.Services.Get("DataSourceManager")
        set => this.Services.Set("DataSourceManager", value)
    }

    Builders {
        get => this.Services.Get("BuilderManager")
        set => this.Services.Set("BuilderManager", value)
    }

    Installers {
        get => this.Services.Get("InstallerManager")
        set => this.Services.Set("InstallerManager", value)
    }

    Themes {
        get => this.Services.Get("ThemeManager")
        set => this.Services.Set("ThemeManager", value)
    }

    Events {
        get => this.Services.Get("EventManager")
        set => this.Services.Set("EventManager", value)
    }

    IdGen {
        get => this.Services.Get("IdGenerator")
        set => this.Services.Set("IdGenerator", value)
    }

    BlizzardProductDb {
        get => this.Services.Get("BlizzardProductDb")
        set => this.Services.Set("BlizzardProductDb", value)
    }

    Logger {
        get => this.Services.Get("LoggerService")
        set => this.Services.Set("LoggerService", value)
    }

    Auth {
        get => this.Services.Get("AuthService")
        set => this.Services.Set("AuthService", value)
    }

    Backups {
        get => this.Services.Get("BackupManager")
        set => this.Services.Set("BackupManager", value)
    }

    LoadServices(config) {
        super.LoadServices(config)
        
        this.IdGen := UuidGenerator.new()
        this.Events := EventManager.new()
        this.Modules := ModuleManager.new(this)
        this.Logger := LoggerService.new(FileLogger.new(A_ScriptDir . "\log.txt", this.Config.LoggingLevel, true))
        this.Cache := CacheManager.new(this, this.Config.CacheDir)
        this.Backups := BackupManager.new(this, this.Config.BackupsFile)
        this.Themes := ThemeManager.new(this, this.appDir . "\Resources\Themes", this.appDir . "\Resources", this.Events, this.IdGen)
        this.Notifications := NotificationService.new(this, ToastNotifier.new(this))
        this.Windows := WindowManager.new(this)
        this.DataSources := DataSourceManager.new(this.Events)
        this.Builders := BuilderManager.new(this)
        this.BlizzardProductDb := BlizzardProductDb.new(this)
        this.Launchers := LauncherManager.new(this)
        this.Platforms := PlatformManager.new(this)
        this.Installers := InstallerManager.new(this)
        this.Auth := AuthService.new(this, "", this.State)
    }

    CheckForUpdates() {
        if (this.Version != "{{VERSION}}") {
            dataSource := this.DataSources.GetItem("api")
            releaseInfoStr := dataSource.ReadItem("release-info")

            if (releaseInfoStr) {
                data := JsonData.new()
                releaseInfo := data.FromString(releaseInfoStr)

                if (releaseInfo && releaseInfo["data"].Has("version") && releaseInfo["data"]["version"] && this.VersionIsOutdated(releaseInfo["data"]["version"], this.Version)) {
                    this.Windows.UpdateAvailable(releaseInfo)
                }
            }
        }
    }

    ShowError(title, errorText, e, allowContinue := true) {
        try {
            themeObj := this.Themes ? this.Themes.GetItem() : JsonTheme.new("Steampad", this.appDir . "\Resources", this.Events, this.IdGen, true)
            btns := allowContinue ? "*&Continue|&Exit Launchpad" : "*&Exit Launchpad"
            result := this.Windows.ErrorDialog(e, "Unhandled Exception", errorText, "", "", btns)

            if (result == "Exit Launchpad") {
                ExitApp
            }
        } catch (ex) {
            MsgBox("Launchpad had an error, and could not show the usual error dialog because of another error:`n`n" . ex.Message . "`n`nThe original error will follow in another message.")
            MsgBox(e.File . ": " . e.Line . ": " . e.What . ": " . e.Message)
        }

        return allowContinue ? -1 : 1
    }

    InitializeApp(config) {
        super.InitializeApp(config)

        this.Builders.SetItem("ahk", AhkLauncherBuilder.new(this), true)
        this.DataSources.SetItem("api", ApiDataSource.new(this, this.Cache.GetItem("api"), this.Config.ApiEndpoint), true)
        this.Installers.SetupInstallers()
        this.Installers.InstallRequirements()

        if (this.Config.CheckUpdatesOnStart) {
            this.CheckForUpdates()
        }

        this.Auth.SetAuthProvider(LaunchpadApiAuthProvider.new(this, this.State))

        if (this.Config.ApiAutoLogin) {
            this.Auth.Login()
        }
        
        this.Platforms.LoadComponents(this.Config.PlatformsFile)
        this.Launchers.LoadComponents(this.Config.LauncherFile)
        this.Backups.LoadComponents()

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

        super.ExitApp()
    }

    OpenWebsite() {
        Run("https://launchpad.games")
    }

    ProvideFeedback() {
        this.Windows.FeedbackWindow()
    }
}
