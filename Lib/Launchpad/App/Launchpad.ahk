class Launchpad extends AppBase {
    customTrayMenu := true
    detectGames := false

    GetParameterDefinitions(config) {
        parameters := super.GetParameterDefinitions(config)
        parameters["backups_file"] := this.dataDir . "\Backups.json"
        parameters["cache_dir"] := this.tmpDir . "\Cache"
        parameters["api_endpoint"] := "https://api.launchpad.games/v1"
        parameters["caches.file"] := "cache.file"
        parameters["caches.api"] := "cache.api",
        parameters["installers.Update"] := "installer.launchpad_update"
        parameters["installers.Dependencies"] := "installer.dependencies"
        return parameters
    }

    GetServiceDefinitions(config) {
        services := super.GetServiceDefinitions(config)

        services["Config"] := Map(
            "class", "LaunchpadConfig",
            "arguments", [AppRef(), ParameterRef("config_path")]
        )

        services["State"] := Map(
            "class", "LaunchpadAppState",
            "arguments", [AppRef(), ParameterRef("state_path")]
        )

        services["BackupManager"] := Map(
            "class", "BackupManager",
            "arguments", [AppRef(), ParameterRef("backups_file")]
        )

        services["datasource.api"] := Map(
            "class", "ApiDataSource",
            "arguments", [AppRef(), ServiceRef("CacheManager"), "api", ParameterRef("api_endpoint")]
        )

        services["DataSourceManager"] := Map(
            "class", "DataSourceManager",
            "arguments", [ServiceRef("EventManager")],
            "calls", [
                Map(
                    "method", "SetItem", 
                    "arguments", ["api", ServiceRef("datasource.api"), true]
                )
            ]
        )

        services["builder.ahk_launcher"] := Map(
            "class", "AhkLauncherBuilder",
            "arguments", [AppRef(), ServiceRef("Notifier")]
        )

        services["BuilderManager"] := Map(
            "class", "BuilderManager",
            "arguments", AppRef(),
            "calls", [
                Map(
                    "method", "SetItem", 
                    "arguments", ["ahk", ServiceRef("builder.ahk_launcher"), true]
                )
            ]
        )

        services["LauncherManager"] := Map(
            "class", "LauncherManager",
            "arguments", AppRef()
        )

        services["PlatformManager"] := Map(
            "class", "PlatformManager",
            "arguments", AppRef()
        )

        services["installer.launchpad_update"] := Map(
            "class", "LaunchpadUpdate",
            "arguments", [this.Version, ServiceRef("State"), ServiceRef("CacheManager"), "file", this.tmpDir]
        )

        services["installer.dependencies"] := Map(
            "class", "DependencyInstaller",
            "arguments", [this.Version, ServiceRef("State"), ServiceRef("CacheManager"), "file", [], this.tmpDir]
        )

        services["cache_state.file"] := Map(
            "class", "CacheState",
            "arguments", [AppRef(), ParameterRef("cache_dir"), "File.json"]
        )

        services["cache_state.api"] := Map(
            "class", "CacheState",
            "arguments", [AppRef(), ParameterRef("cache_dir"), "API.json"]
        )

        services["cache.file"] := Map(
            "class", "FileCache",
            "arguments", [AppRef(), ServiceRef("cache_state.file"), ParameterRef("cache_dir"), "File"]
        )

        services["cache.api"] := Map(
            "class", "FileCache",
            "arguments", [AppRef(), ServiceRef("cache_state.api"), ParameterRef("cache_dir"), "API"]
        )

        return services
    }

    GetDefaultModules(config) {
        modules := super.GetDefaultModules(config)
        modules["Bethesda"] := "Bethesda"
        modules["Blizzard"] := "Blizzard"
        modules["Epic"] := "Epic"
        modules["Origin"] := "Origin"
        modules["Riot"] := "Riot"
        modules["Steam"] := "Steam"
        return modules
    }

    CheckForUpdates(notify := true) {
        updateAvailable := false

        if (this.Version != "{{VERSION}}") {
            dataSource := this.Service("DataSourceManager").GetItem("api")
            releaseInfoStr := dataSource.ReadItem("release-info")

            if (releaseInfoStr) {
                data := JsonData()
                releaseInfo := data.FromString(&releaseInfoStr)

                if (releaseInfo && releaseInfo["data"].Has("version") && releaseInfo["data"]["version"] && this.Service("VersionChecker").VersionIsOutdated(releaseInfo["data"]["version"], this.Version)) {
                    updateAvailable := true
                    this.Service("GuiManager").Dialog("UpdateAvailableWindow", releaseInfo)
                }
            }
        }

        if (!updateAvailable && notify) {
            this.Service("Notifier").Info("You're running the latest version of Launchpad. Shiny!")
        }
    }

    UpdateIncludes() {
        this.RunAhkScript(this.appDir . "\Scripts\UpdateIncludes.ahk")
        this.RestartApp()
    }

    BuildApp() {
        this.RunAhkScript(this.appDir . "\Scripts\Build.ahk")
    }

    RunAhkScript(scriptPath) {
        SplitPath(scriptPath, &scriptDir)
        ahkExe := this.appDir . "\Vendor\AutoHotKey\AutoHotkey" . (A_Is64bitOS ? "64" : "32") . ".exe"

        if (FileExist(ahkExe) && FileExist(scriptPath)) {
            RunWait(ahkExe . " " . scriptPath, scriptDir)
        } else {
            throw AppException("Could not run AHK script")
        }
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

    RunApp(config) {
        if (this.Config.ApiAutoLogin) {
            this.Service("Auth").Login()
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
