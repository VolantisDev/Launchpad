class Launchpad extends AppBase {
    detectGames := false

    UpdateIncludes() {
        this.RunAhkScript(this.appDir . "\Scripts\UpdateIncludes.ahk")
        this.RestartApp()
    }

    InitializeApp(config) {
        eventMgr := this["manager.event"]
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
        
        super.RunApp(config)
        
        this["entity_manager.platform"].LoadComponents()
        this["entity_manager.launcher"].LoadComponents()
        this["entity_manager.backup"].LoadComponents()

        this.OpenApp()

        if (this.detectGames) {
            this["entity_manager.platform"].DetectGames()
        }
    }

    MigrateConfiguration() {
        configFile := this.Parameter["previous_config_file"]

        if (configFile && FileExist(configFile)) {
            response := this["manager.gui"].Dialog(Map(
                "title", "Migrate settings?",
                "text", this.appName . " uses a new configuration file format, and has detected that you have a previous configuration file.`n`nWould you like to automatically migrate your settings?`n`nChoose Yes to migrate your previous configuration. Choose no to simply delete it and start from scratch."
            ))
        
            if (response == "Yes") {
                this["ini_migrator"].Migrate(configFile, this.Config)
            } else {
                FileDelete(configFile)
            }
        }
    }

    InitialSetup(config) {
        result := this["manager.gui"].Dialog(Map("type", "SetupWindow"))

        if (result == "Exit") {
            this.ExitApp()
        } else if (result == "Detect") {
            this.detectGames := true
        }

        super.InitialSetup(config)
    }

    UpdateStatusIndicators() {
        if (this["manager.gui"].Has("MainWindow")) {
            serviceMgr := this.container["entity_manager.web_service"]
            webServices := serviceMgr.EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
                .Condition(IsTrueCondition(), "Enabled")
                .Condition(IsTrueCondition(), "StatusIndicator")
                .Execute()

                windowObj := this["manager.gui"]["MainWindow"]
            
            for serviceId, webService in webServices {
                windowObj.UpdateStatusIndicator(webService)
            }
        }
    }

    ExitApp() {
        if (this.isSetup && this.Config["clean_launchers_on_exit"]) {
            this["manager.builder"].CleanLaunchers()
        }

        if (this.isSetup && this.Config["flush_cache_on_exit"]) {
            this["manager.cache"].FlushCaches(false, false)
        }

        super.ExitApp()
    }

    RestartApp() {
        if (this.Services.Has("manager.gui")) {
            guiMgr := this["manager.gui"]

            if (guiMgr.Has("MainWindow")) {
                guiMgr.StoreWindowState(this["manager.gui"]["MainWindow"])
            }
        }

        super.RestartApp()
    }

    AddMainMenuEarlyItems(menuItems, showOpenItem := false) {
        menuItems := super.AddMainMenuEarlyItems(menuItems, showOpenItem)

        launchersItems := []
        launchersItems.Push(Map("label", "&Clean Launchers", "name", "CleanLaunchers"))
        launchersItems.Push(Map("label", "&Reload Launchers", "name", "ReloadLaunchers"))

        menuItems.Push(Map("label", "&Launchers", "name", "LaunchersMenu", "childItems", launchersItems))

        return menuItems
    }

    HandleMainMenuClick(result) {
        if (result == "CleanLaunchers") {
            this["manager.builder"].CleanLaunchers()
        } else if (result == "ReloadLaunchers") {
            this["entity_manager.launcher"].LoadComponents(true)
            guiMgr := this["manager.gui"]

            if (guiMgr.Has("MainWindow")) {
                guiMgr["MainWindow"].UpdateListView()
            }
        } else if (result == "ManageModules") {
            this["manager.gui"].OpenWindow("ManageModulesWindow")
        } else if (result == "FlushCache") {
            this["manager.cache"].FlushCaches(true, true)
        } else {
            super.HandleMainMenuClick(result)
        }

        return result
    }

    GetToolsMenuItems() {
        toolsItems := super.GetToolsMenuItems()
        toolsItems.Push(Map("label", "&Modules", "name", "ManageModules"))
        toolsItems.Push(Map("label", "&Flush Cache", "name", "FlushCache"))

        return toolsItems
    }
}
