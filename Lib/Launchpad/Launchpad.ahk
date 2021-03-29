class Launchpad extends AppBase {
    Launchers {
        get => this.Services.Get("LauncherManager")
        set => this.Services.Set("LauncherManager", value)
    }

    Platforms {
        get => this.Services.Get("PlatformManager")
        set => this.Services.Set("PlatformManager", value)
    }

    DataSources {
        get => this.Services.Get("DataSourceManager")
        set => this.Services.Set("DataSourceManager", value)
    }

    Builders {
        get => this.Services.Get("BuilderManager")
        set => this.Services.Set("BuilderManager", value)
    }

    BlizzardProductDb {
        get => this.Services.Get("BlizzardProductDb")
        set => this.Services.Set("BlizzardProductDb", value)
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
        this.Backups := BackupManager.new(this, this.Config.BackupsFile)
        this.DataSources := DataSourceManager.new(this.Events)
        this.Builders := BuilderManager.new(this)
        this.BlizzardProductDb := BlizzardProductDb.new(this)
        this.Launchers := LauncherManager.new(this)
        this.Platforms := PlatformManager.new(this)
        this.Auth := AuthService.new(this, "", this.State)
    }

    GetCaches() {
        caches := super.GetCaches()
        caches["file"] := FileCache.new(this, CacheState.new(this, this.Config.CacheDir . "\File.json"), this.Config.CacheDir . "\File")
        caches["api"] := FileCache.new(this, CacheState.new(this, this.Config.CacheDir . "\API.json"), this.Config.CacheDir . "\API")
        return caches
    }

    CheckForUpdates() {
        if (this.Version != "{{VERSION}}") {
            dataSource := this.DataSources.GetItem("api")
            releaseInfoStr := dataSource.ReadItem("release-info")

            if (releaseInfoStr) {
                data := JsonData.new()
                releaseInfo := data.FromString(releaseInfoStr)

                if (releaseInfo && releaseInfo["data"].Has("version") && releaseInfo["data"]["version"] && this.VersionChecker.VersionIsOutdated(releaseInfo["data"]["version"], this.Version)) {
                    this.GuiManager.Dialog("UpdateAvailableWindow", releaseInfo)
                }
            }
        }
    }

    OnUpdateIncludes(itemName, itemPos, menu) {
        RunWait(A_ScriptDir . "\Scripts\UpdateIncludes.bat", A_ScriptDir . "\Scripts")
        Reload()
    }

    OnBuildLaunchpad(itemName, itemPos, menu) {
        Run(A_ScriptDir . "\Scripts\Build.bat", A_ScriptDir . "\Scripts")
    }

    InitializeApp(config) {
        super.InitializeApp(config)

        if (!A_IsCompiled) {
            this.updateIncludesCallback := ObjBindMethod(this, "OnUpdateIncludes")
            this.buildLaunchpadCallback := ObjBindMethod(this, "OnBuildLaunchpad")

            trayMenu := A_TrayMenu
            trayMenu.Add("Update Includes", this.updateIncludesCallback)
            trayMenu.Add("Build Launchpad", this.buildLaunchpadCallback)
        }

        this.Builders.SetItem("ahk", AhkLauncherBuilder.new(this), true)
        this.DataSources.SetItem("api", ApiDataSource.new(this, this.Cache.GetItem("api"), this.Config.ApiEndpoint), true)
        this.Installers.SetItem("LaunchpadUpdate", LaunchpadUpdate.new(this.Version, this.State, this.Cache.GetItem("file"), this.tmpDir))
        this.Installers.SetItem("Dependencies", DependencyInstaller.new(this.Version, this.State, this.Cache.GetItem("file"), [], this.tmpDir))
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
            result := this.GuiManager.OpenWindow("SetupWindow")

            if (result == "Exit") {
                this.ExitApp()
            }
        }

        this.GuiManager.OpenWindow("ManageWindow")

        if (result == "Detect") {
            this.Platforms.DetectGames()
        }
    }

    UpdateStatusIndicators() {
        if (this.GuiManager.WindowExists("ManageWindow")) {
            this.GuiManager.GetWindow("ManageWindow").UpdateStatusIndicator()
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
        this.GuiManager.Dialog("FeedbackWindow")
    }
}
