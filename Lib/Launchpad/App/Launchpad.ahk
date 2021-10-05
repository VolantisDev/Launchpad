class Launchpad extends AppBase {
    customTrayMenu := true
    detectGames := false
    isSetup := false

    GetParameterDefinitions(config) {
        parameters := super.GetParameterDefinitions(config)
        parameters["config.player_name"] := ""
        parameters["config.destination_dir"] := this.dataDir . "\Launchers"
        parameters["config.launcher_file"] := this.dataDir . "\Launchers.json",
        parameters["config.platforms_file"] := this.dataDir . "\Platforms.json"
        parameters["config.assets_dir"] := this.dataDir . "\Launcher Assets"
        parameters["config.data_source_key"] := "api"
        parameters["config.builder_key"] := "ahk"
        parameters["config.api_endpoint"] := "https://api.launchpad.games/v1"
        parameters["config.api_authentication"] := true
        parameters["config.api_auto_login"] := false
        parameters["config.backup_dir"] := this.dataDir . "\Backups"
        parameters["config.backups_file"] := this.dataDir . "\Backups.json"
        parameters["config.backups_to_keep"] := 5
        parameters["config.auto_backup_config_files"] := true
        parameters["config.rebuild_existing_launchers"] := false
        parameters["config.create_desktop_shortcuts"] := true
        parameters["config.clean_launchers_on_build"] := false
        parameters["config.clean_launchers_on_exit"] := true
        parameters["config.check_updates_on_start"] := true
        parameters["config.use_advanced_launcher_editor"] := false
        parameters["config.default_launcher_theme"] := ""
        parameters["config.override_launcher_theme"] := false
        parameters["config.backups_view_mode"] := "Report"
        parameters["config.platforms_view_mode"] := "Report"
        parameters["config.launcher_double_click_action"] := "Edit"
        parameters["launcher_config.games"] := Map()
        parameters["platforms_config.platforms"] := Map()
        parameters["backups_config.backups"] := Map()
        parameters["caches.file"] := "cache.file"
        parameters["caches.api"] := "cache.api",
        parameters["installers.Update"] := "installer.launchpad_update"
        parameters["installers.Dependencies"] := "installer.dependencies"
        parameters["updater"] := "LaunchpadUpdate"
        parameters["dependency_installer"] := "Dependencies",
        parameters["previous_config_file"] := A_ScriptDir . "\" . this.appName . ".ini"
        return parameters
    }

    GetServiceDefinitions(config) {
        services := super.GetServiceDefinitions(config)

        services["Config"] := Map(
            "class", "LaunchpadConfig",
            "arguments", [ServiceRef("config_storage.app_config"), ContainerRef(), ParameterRef("config_key")]
        )

        services["State"] := Map(
            "class", "LaunchpadAppState",
            "arguments", [AppRef(), ParameterRef("state_path")]
        )

        services["config_storage.backups"] := Map(
            "class", "JsonConfigStorage",
            "arguments", [ParameterRef("config.backups_file"), "Backups"]
        )

        services["config.backups"] := Map(
            "class", "PersistentConfig",
            "arguments", [ServiceRef("config_storage.backups"), ContainerRef(), "backups_config", "backups"]
        )

        services["BackupManager"] := Map(
            "class", "BackupManager",
            "arguments", [AppRef(), ServiceRef("config.backups")]
        )

        services["datasource.api"] := Map(
            "class", "ApiDataSource",
            "arguments", [AppRef(), ServiceRef("CacheManager"), "api", ParameterRef("config.api_endpoint")]
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
                    "arguments", ["ahk", ServiceRef("builder.ahk_launcher")]
                )
            ]
        )

        services["config_storage.launchers"] := Map(
            "class", "JsonConfigStorage",
            "arguments", [ParameterRef("config.launcher_file"), "Games"]
        )

        services["config.launchers"] := Map(
            "class", "LauncherConfig",
            "arguments", [ServiceRef("config_storage.launchers"), ContainerRef(), "launcher_config", "games"]
        )

        services["LauncherManager"] := Map(
            "class", "LauncherManager",
            "arguments", [AppRef(), ServiceRef("config.launchers")]
        )

        services["config_storage.platforms"] := Map(
            "class", "JsonConfigStorage",
            "arguments", [ParameterRef("config.platforms_file"), "Platforms"]
        )

        services["config.platforms"] := Map(
            "class", "PlatformsConfig",
            "arguments", [ServiceRef("config_storage.platforms"), ContainerRef(), "platforms_config", "platforms"]
        )

        services["PlatformManager"] := Map(
            "class", "PlatformManager",
            "arguments", [AppRef(), ServiceRef("config.platforms")]
        )

        services["installer.launchpad_update"] := Map(
            "class", "LaunchpadUpdate",
            "arguments", [this.Version, ServiceRef("State"), ServiceRef("CacheManager"), "file", this.tmpDir]
        )

        services["installer.dependencies"] := Map(
            "class", "DependencyInstaller",
            "arguments", [this.Version, ServiceRef("State"), ServiceRef("CacheManager"), "file", [], this.tmpDir]
        )

        services["cache_state.api"] := Map(
            "class", "CacheState",
            "arguments", [AppRef(), ParameterRef("config.cache_dir"), "API.json"]
        )

        services["cache.api"] := Map(
            "class", "FileCache",
            "arguments", [AppRef(), ServiceRef("cache_state.api"), ParameterRef("config.cache_dir"), "API"]
        )

        services["LaunchpadIniMigrator"] := Map(
            "class", "LaunchpadIniMigrator",
            "arguments", [AppRef(), ServiceRef("GuiManager")]
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
        this.MigrateConfiguration()
        

        if (this.Config["api_auto_login"]) {
            this.Service("Auth").Login()
        }
        
        super.RunApp(config)
        
        this.Service("PlatformManager").LoadComponents()
        this.Service("LauncherManager").LoadComponents()
        this.Service("BackupManager").LoadComponents()

        this.OpenApp()

        if (this.detectGames) {
            this.Service("PlatformManager").DetectGames()
        }
    }

    MigrateConfiguration() {
        configFile := this.Parameter("previous_config_file")

        if (configFile && FileExist(configFile)) {
            response := this.Service("GuiManager").Dialog("DialogBox", "Migrate settings?", this.appName . " uses a new configuration file format, and has detected that you have a previous configuration file.`n`nWould you like to automatically migrate your settings?`n`nChoose Yes to migrate your previous configuration. Choose no to simply delete it and start from scratch.")
        
            if (response == "Yes") {
                this.Service("LaunchpadIniMigrator").Migrate(configFile, this.Config)
            } else {
                FileDelete(configFile)
            }
        }
    }

    InitialSetup(config) {
        result := this.Service("GuiManager").Form("SetupWindow")

        if (result == "Exit") {
            this.ExitApp()
        } else if (result == "Detect") {
            this.detectGames := true
        }

        this.isSetup := true
        super.InitialSetup(config)
    }

    UpdateStatusIndicators() {
        if (this.Service("GuiManager").WindowExists("MainWindow")) {
            this.Service("GuiManager").GetWindow("MainWindow").UpdateStatusIndicator()
        }
    }

    ExitApp() {
        if (this.isSetup && this.Config["clean_launchers_on_exit"]) {
            this.Service("BuilderManager").CleanLaunchers()
        }

        if (this.isSetup && this.Config["flush_cache_on_exit"]) {
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
