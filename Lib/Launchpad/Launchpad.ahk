class Launchpad extends AppBase {
    customTrayMenu := true
    detectGames := false

    LoadServices(config) {
        super.LoadServices(config)
        this.Services.Set("BackupManager", BackupManager.new(this, this.Config.BackupsFile))
        this.Services.Set("DataSourceManager", DataSourceManager.new(this.Service("EventManager")))
        this.Service("DataSourceManager").SetItem("api", ApiDataSource.new(this, this.Service("CacheManager").GetItem("api"), this.Config.ApiEndpoint), true)
        this.Services.Set("BuilderManager", BuilderManager.new(this))
        this.Services.Set("LauncherManager", LauncherManager.new(this))
        this.Services.Set("PlatformManager", PlatformManager.new(this))
    }

    GetCaches() {
        caches := super.GetCaches()
        caches["file"] := FileCache.new(this, CacheState.new(this, this.Config.CacheDir . "\File.json"), this.Config.CacheDir . "\File")
        caches["api"] := FileCache.new(this, CacheState.new(this, this.Config.CacheDir . "\API.json"), this.Config.CacheDir . "\API")
        return caches
    }

    GetDefaultModules(config) {
        modules := super.GetDefaultModules(config)
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
            dataSource := this.Service("DataSourceManager").GetItem("api")
            releaseInfoStr := dataSource.ReadItem("release-info")

            if (releaseInfoStr) {
                data := JsonData.new()
                releaseInfo := data.FromString(releaseInfoStr)

                if (releaseInfo && releaseInfo["data"].Has("version") && releaseInfo["data"]["version"] && this.Service("VersionChecker").VersionIsOutdated(releaseInfo["data"]["version"], this.Version)) {
                    updateAvailable := true
                    this.Service("GuiManager").Dialog("UpdateAvailableWindow", releaseInfo)
                }
            }
        }

        if (!updateAvailable && notify) {
            this.Service("NotificationService").Info("You're running the latest version of Launchpad. Shiny!")
        }
    }

    UpdateIncludes() {
        RunWait(this.appDir . "\Scripts\UpdateIncludes.bat", this.appDir . "\Scripts")
        this.RestartApp()
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
        this.Service("BuilderManager").SetItem("ahk", AhkLauncherBuilder.new(this), true)
        this.Service("InstallerManager").SetItem("LaunchpadUpdate", LaunchpadUpdate.new(this.Version, this.State, this.Service("CacheManager").GetItem("file"), this.tmpDir))
        this.Service("InstallerManager").SetItem("Dependencies", DependencyInstaller.new(this.Version, this.State, this.Service("CacheManager").GetItem("file"), [], this.tmpDir))
        this.Service("InstallerManager").SetupInstallers()
        this.Service("InstallerManager").InstallRequirements()
    }

    Service(name) {
        return this.Services.Get(name)
    }

    RunApp(config) {
        this.Service("AuthService").SetAuthProvider(LaunchpadApiAuthProvider.new(this, this.State))

        if (this.Config.ApiAutoLogin) {
            this.Service("AuthService").Login()
        }
        
        super.RunApp(config)
        
        this.Service("PlatformManager").LoadComponents(this.Config.PlatformsFile)
        this.Service("LauncherManager").LoadComponents(this.Config.LauncherFile)
        this.Service("BackupManager").LoadComponents()

        this.OpenApp()

        if (this.detectGames) {
            this.Service("PlatformManager").DetectGames()
        }
    }

    InitialSetup(config) {
        super.InitialSetup(config)
        result := this.Service("GuiManager").Form("SetupWindow")

        if (result == "Exit") {
            this.ExitApp()
        } else if (result == "Detect") {
            this.detectGames := true
        }
    }

    UpdateStatusIndicators() {
        if (this.Service("GuiManager").WindowExists("MainWindow")) {
            this.Service("GuiManager").GetWindow("MainWindow").UpdateStatusIndicator()
        }
    }

    ExitApp() {
        if (this.Config.CleanLaunchersOnExit) {
            this.Service("BuilderManager").CleanLaunchers()
        }

        if (this.Config.FlushCacheOnExit) {
            this.Service("CacheManager").FlushCaches(false)
        }

        super.ExitApp()
    }

    OpenWebsite() {
        Run("https://launchpad.games")
    }

    ProvideFeedback() {
        this.Service("GuiManager").Dialog("FeedbackWindow")
    }

    RestartApp() {
        if (this.Service("GuiManager")) {
            window := this.Service("GuiManager").GetWindow("MainWindow")

            if (window) {
                this.Service("GuiManager").StoreWindowState(window)
            }
        }

        super.RestartApp()
    }
}
