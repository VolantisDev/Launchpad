﻿class Launchpad extends AppBase {
    customTrayMenu := true
    detectGames := false
    isSetup := false

    CheckForUpdates(notify := true) {
        updateAvailable := false

        if (this.Version != "{{VERSION}}" && this.Service("manager.data_source").GetDefaultDataSource()) {
            dataSource := this.Service("manager.data_source").GetDefaultDataSource()
            releaseInfoStr := dataSource.ReadItem("release-info")

            if (releaseInfoStr) {
                data := JsonData()
                releaseInfo := data.FromString(&releaseInfoStr)

                if (releaseInfo && releaseInfo["data"].Has("version") && releaseInfo["data"]["version"] && this.Service("version_checker").VersionIsOutdated(releaseInfo["data"]["version"], this.Version)) {
                    updateAvailable := true
                    this.Service("manager.gui").Dialog(Map("type", "UpdateAvailableWindow"), releaseInfo)
                }
            }
        }

        if (!updateAvailable && notify) {
            this.Service("notifier").Info("You're running the latest version of Launchpad. Shiny!")
        }
    }

    UpdateIncludes() {
        this.RunAhkScript(this.appDir . "\Scripts\UpdateIncludes.ahk")
        this.RestartApp()
    }

    InitializeApp(config) {
        eventMgr := this.Service("manager.event")
        eventMgr.Register(EntityEvents.ENTITY_CREATED, "LaunchpadEntityCreated", ObjBindMethod(this, "OnEntityCreated"))
        eventMgr.Register(EntityEvents.ENTITY_UPDATED, "LaunchpadEntityUpdated", ObjBindMethod(this, "OnEntityUpdated"))
        eventMgr.Register(EntityEvents.ENTITY_DELETED, "LaunchpadEntityDeleted", ObjBindMethod(this, "OnEntityDeleted"))
        eventMgr.Register(EntityEvents.ENTITY_LOADED, "LaunchpadEntityLoaded", ObjBindMethod(this, "OnEntityLoaded"))
        super.InitializeApp(config)
    }

    OnEntityCreated(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "launcher") {
            this.State.SetLauncherCreated(event.Entity.Id)
        }
    }

    OnEntityUpdated(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "launcher" && !this.State.GetLauncherCreated(event.Entity.Id)) {
            this.State.SetLauncherCreated(event.Entity.Id)
        }
    }

    OnEntityDeleted(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "launcher") {
            this.State.DeleteLauncherInfo(event.Entity.Id)
        }
    }

    OnEntityLoaded(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "launcher" && !this.State.GetLauncherCreated(event.Entity.Id)) {
            this.State.SetLauncherCreated(event.Entity.Id)
        }
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

    OnServicesLoaded(event, extra, eventName, hwnd) {
        super.OnServicesLoaded(event, extra, eventName, hwnd)
    }

    RunApp(config) {
        this.MigrateConfiguration()

        if (this.Config["api_auto_login"] && this.Services.Has("Auth")) {
            this.Service("Auth").Login()
        }
        
        super.RunApp(config)
        
        this.Service("entity_manager.platform").LoadComponents()
        this.Service("entity_manager.launcher").LoadComponents()
        this.Service("entity_manager.backup").LoadComponents()

        this.OpenApp()

        if (this.detectGames) {
            this.Service("entity_manager.platform").DetectGames()
        }
    }

    MigrateConfiguration() {
        configFile := this.Parameter("previous_config_file")

        if (configFile && FileExist(configFile)) {
            response := this.Service("manager.gui").Dialog(Map(
                "title", "Migrate settings?",
                "text", this.appName . " uses a new configuration file format, and has detected that you have a previous configuration file.`n`nWould you like to automatically migrate your settings?`n`nChoose Yes to migrate your previous configuration. Choose no to simply delete it and start from scratch."
            ))
        
            if (response == "Yes") {
                this.Service("ini_migrator").Migrate(configFile, this.Config)
            } else {
                FileDelete(configFile)
            }
        }
    }

    InitialSetup(config) {
        result := this.Service("manager.gui").Dialog(Map("type", "SetupWindow"))

        if (result == "Exit") {
            this.ExitApp()
        } else if (result == "Detect") {
            this.detectGames := true
        }

        this.isSetup := true
        super.InitialSetup(config)
    }

    UpdateStatusIndicators() {
        if (this.Service("manager.gui").Has("MainWindow")) {
            this.Service("manager.gui")["MainWindow"].UpdateStatusIndicator()
        }
    }

    ExitApp() {
        if (this.isSetup && this.Config["clean_launchers_on_exit"]) {
            this.Service("manager.builder").CleanLaunchers()
        }

        if (this.isSetup && this.Config["flush_cache_on_exit"]) {
            this.Service("manager.cache").FlushCaches(false, false)
        }

        super.ExitApp()
    }

    OpenWebsite() {
        Run("https://launchpad.games")
    }

    ProvideFeedback() {
        this.Service("manager.gui").Dialog(Map("type", "FeedbackWindow"))
    }

    RestartApp() {
        if (this.Services.Has("manager.gui")) {
            guiMgr := this.Service("manager.gui")

            if (guiMgr.Has("MainWindow")) {
                guiMgr.StoreWindowState(this.Service("manager.gui")["MainWindow"])
            }
        }

        super.RestartApp()
    }
}
