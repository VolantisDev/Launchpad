class Launchpad extends AppBase {
    customTrayMenu := true
    detectGames := false

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

    Backups {
        get => this.Services.Get("BackupManager")
        set => this.Services.Set("BackupManager", value)
    }

    LoadServices(config) {
        super.LoadServices(config)
        this.Backups := BackupManager.new(this, this.Config.BackupsFile)
        this.DataSources := DataSourceManager.new(this.Events)
        this.DataSources.SetItem("api", ApiDataSource.new(this, this.Cache.GetItem("api"), this.Config.ApiEndpoint), true)
        this.Builders := BuilderManager.new(this)
        this.Launchers := LauncherManager.new(this)
        this.Platforms := PlatformManager.new(this)
    }

    GetCaches() {
        caches := super.GetCaches()
        caches["file"] := FileCache.new(this, CacheState.new(this, this.Config.CacheDir . "\File.json"), this.Config.CacheDir . "\File")
        caches["api"] := FileCache.new(this, CacheState.new(this, this.Config.CacheDir . "\API.json"), this.Config.CacheDir . "\API")
        return caches
    }

    DiscoverModules(config) {
        modules := super.DiscoverModules(config)
        modules["Bethesda"] := "BethesdaModule"
        modules["Blizzard"] := "BlizzardModule"
        modules["Epic"] := "EpicModule"
        modules["Origin"] := "OriginModule"
        modules["Riot"] := "RiotModule"
        modules["Steam"] := "SteamModule"
        return modules
    }

    CheckForUpdates(notify := true) {
        updateAvailable := false

        if (this.Version != "{{VERSION}}") {
            dataSource := this.DataSources.GetItem("api")
            releaseInfoStr := dataSource.ReadItem("release-info")

            if (releaseInfoStr) {
                data := JsonData.new()
                releaseInfo := data.FromString(releaseInfoStr)

                if (releaseInfo && releaseInfo["data"].Has("version") && releaseInfo["data"]["version"] && this.VersionChecker.VersionIsOutdated(releaseInfo["data"]["version"], this.Version)) {
                    updateAvailable := true
                    this.GuiManager.Dialog("UpdateAvailableWindow", releaseInfo)
                }
            }
        }

        if (!updateAvailable && notify) {
            this.Notifications.Info("You're running the latest version of Launchpad. Shiny!")
        }
    }

    UpdateIncludes() {
        RunWait(this.appDir . "\Scripts\UpdateIncludes.bat", this.appDir . "\Scripts")
        Reload()
    }

    BuildApp() {
        Run(this.appDir . "\Scripts\Build.bat", this.appDir . "\Scripts")
    }

    SetTrayMenuItems(menuItems) {
        menuItems := super.SetTrayMenuItems(menuItems)

        if (!A_IsCompiled) {
            menuItems.Push("")
            menuItems.Push(Map("label", "Build Launchpad", "name", "BuildApp"))
            menuItems.Push(Map("label", "Update Includes", "name", "UpdateIncludes"))
        }

        return menuItems
    }

    HandleTrayMenuClick(result) {
        result := super.HandleTrayMenuClick(result)

        if (result == "BuildApp") {
            this.BuildApp()
        } else if (result == "UpdateIncludes") {
            this.UpdateIncludes()
        }

        return result
    }

    InitializeApp(config) {
        super.InitializeApp(config)
        this.Builders.SetItem("ahk", AhkLauncherBuilder.new(this), true)
        this.Installers.SetItem("LaunchpadUpdate", LaunchpadUpdate.new(this.Version, this.State, this.Cache.GetItem("file"), this.tmpDir))
        this.Installers.SetItem("Dependencies", DependencyInstaller.new(this.Version, this.State, this.Cache.GetItem("file"), [], this.tmpDir))
        this.Installers.SetupInstallers()
        this.Installers.InstallRequirements()
    }

    RunApp(config) {
        this.Auth.SetAuthProvider(LaunchpadApiAuthProvider.new(this, this.State))

        if (this.Config.ApiAutoLogin) {
            this.Auth.Login()
        }
        
        super.RunApp(config)
        this.OpenApp()

        this.Platforms.LoadComponents(this.Config.PlatformsFile)
        this.Launchers.LoadComponents(this.Config.LauncherFile)
        this.Backups.LoadComponents()

        if (this.detectGames) {
            this.Platforms.DetectGames()
        }
    }

    InitialSetup(config) {
        super.InitialSetup(config)
        result := this.GuiManager.Form("SetupWindow")

        if (result == "Exit") {
            this.ExitApp()
        } else if (result == "Detect") {
            this.detectGames := true
        }
    }

    UpdateStatusIndicators() {
        if (this.GuiManager.WindowExists("MainWindow")) {
            this.GuiManager.GetWindow("MainWindow").UpdateStatusIndicator()
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
