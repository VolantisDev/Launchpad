class AppBase {
    versionStr := ""
    appName := ""
    appDir := ""
    tmpDir := ""
    dataDir := ""
    configObj := ""
    stateObj := ""
    serviceContainerObj := ""
    themeReady := false
    startConfig := ""
    isSetup := false

    static Instance := ""

    Version {
        get => this.versionStr
        set => this.versionStr := value
    }

    Services {
        get => this.serviceContainerObj
        set => this.serviceContainerObj := value
    }

    Config {
        get => this["config.app"]
    }

    State {
        get => this["state.app"]
    }

    Parameter[key] {
        get => this.Services.GetParameter(key)
        set => this.Services.SetParameter(key, value)
    }

    __Item[serviceId] {
        get => this.Service(serviceId)
    }

    __New(config := "", autoStart := true) {
        AppBase.Instance := this

        if (config && config.Has("console") && config["console"]) {
            this.AllocConsole()
        }

        if (config && config.Has("trayIcon") && config["trayIcon"]) {
            TraySetIcon(config["trayIcon"])
        }

        this.startConfig := config

        if (autoStart) {
            this.Startup(config)
        }
    }

    GetParameterDefinitions(config) {
        return Map(
            "version", this.versionStr,
            "app_name", this.appName,
            "app_dir", this.appDir,
            "data_dir", this.dataDir,
            "tmp_dir", this.tmpDir,
            "app.website_url", "",
            "app.custom_tray_menu", false,
            "app.developer", "",
            "app.has_settings", false,
            "app.settings_window", "",
            "app.show_restart_menu_item", true,
            "app.supports_update_check", false,
            "app.show_about_menu_item", false,
            "app.about_window", "",
            "app.show_website_menu_item", false,
            "resources_dir", "@@{app_dir}\Resources",
            "config_path", "@@{app_dir}\" . this.appName . ".json",
            "config_key", "config",
            "config.backup_dir", "@@{data_dir}\\Backups",
            "config.backups_file", "@@{data_dir}\Backups.json",
            "config.backups_view_mode", "Report",
            "config.theme_name", "Steampad",
            "config.themes_dir", "@@{app_dir}\Resources\Themes",
            "config.cache_dir", "@@{tmp_dir}\Cache",
            "config.flush_cache_on_exit", false,
            "config.check_updates_on_start", false,
            "config.force_error_window_to_top", false,
            "config.logging_level", "Error",
            "config.modules_file", "@@{data_dir}\Modules.json",
            "config.modules_view_mode", "Report",
            "config.log_path", "@@{data_dir}\" . this.appName . "Log.txt",
            "config.module_dirs", ["@@{data_dir}\Modules"],
            "config.core_module_dirs", ["@@{app_dir}\Lib\"],
            "config.main_window", "MainWindow",
            "state_path", "@@{data_dir}\" . this.appName . "State.json",
            "service_files.app", "@@{app_dir}\" . this.appName . ".services.json",
            "service_files.user", "@@{data_dir}\" . this.appName . ".services.json",
            "include_files.modules", "@@{data_dir}\ModuleIncludes.ahk",
            "include_files.module_tests", "@@{data_dir}\ModuleIncludes.test.ahk",
            "themes.extra_themes", [],
            "module_config", Map(),
            "modules.Auth", true,
            "structured_data.basic", Map(
                "class", "BasicData",
                "extensions", []
            ),
            "structured_data.ahk", Map(
                "class", "AhkVariable",
                "extensions", []
            ),
            "structured_data.json", Map(
                "class", "JsonData",
                "extensions", [".json"]
            ),
            "structured_data.proto", Map(
                "class", "ProtobufData",
                "extensions", [".db", ".proto"]
            ),
            "structured_data.vdf", Map(
                "class", "VdfData",
                "extensions", [".ahk"]
            ),
            "structured_data.xml", Map(
                "class", "Xml",
                "extensions", [".xml"]
            ),
            "entity_type.backup", Map(
                "name_singular", "Backup",
                "name_plural", "Backups",
                "entity_class", "BackupEntity",
                "entity_manager_class", "BackupManager",
                "storage_config_storage_parent_key", "Backups",
                "storage_config_path_parameter", "config.backups_file",
                "manager_view_mode_parameter", "config.backups_view_mode",
                "manager_gui", "ManageBackupsWindow",
                "manager_link_in_tools_menu", true
            ),
            "entity_field_type.boolean", "BooleanEntityField",
            "entity_field_type.class_name", "ClassNameEntityField",
            "entity_field_type.directory", "DirEntityField",
            "entity_field_type.entity_reference", "EntityReferenceField",
            "entity_field_type.file", "FileEntityField",
            "entity_field_type.hotkey", "HotkeyEntityField",
            "entity_field_type.icon_file", "IconFileEntityField",
            "entity_field_type.id", "IdEntityField",
            "entity_field_type.number", "NumberEntityField",
            "entity_field_type.service_reference", "ServiceReferenceField",
            "entity_field_type.string", "StringEntityField",
            "entity_field_type.time_offset", "TimeOffsetEntityField",
            "entity_field_type.url", "UrlEntityField",
            "entity_field_widget_type.checkbox", "CheckboxEntityFieldWidget",
            "entity_field_widget_type.combo", "ComboBoxEntityFieldWidget",
            "entity_field_widget_type.directory", "DirectoryEntityFieldWidget",
            "entity_field_widget_type.entity_form", "EntityFormEntityFieldWidget",
            "entity_field_widget_type.entity_select", "EntitySelectEntityFieldWidget",
            "entity_field_widget_type.file", "FileEntityFieldWidget",
            "entity_field_widget_type.hotkey", "HotkeyEntityFieldWidget",
            "entity_field_widget_type.number", "NumberEntityFieldWidget",
            "entity_field_widget_type.select", "SelectEntityFieldWidget",
            "entity_field_widget_type.text", "TextEntityFieldWidget",
            "entity_field_widget_type.time_offset", "TimeOffsetEntityFieldWidget",
            "entity_field_widget_type.url", "UrlEntityFieldWidget"
        )
    }

    GetServiceDefinitions(config) {
        return Map(
            "cache.file", Map(
                "class", "FileCache",
                "arguments", [
                    "@{App}", 
                    "@cache_state.file", 
                    "@@config.cache_dir", 
                    "File"
                ]
            ),
            "cache_state.file", Map(
                "class", "CacheState",
                "arguments", ["@{App}", "@@config.cache_dir", "File.json"]
            ),
            "cloner.list", Map(
                "class", "ListCloner",
                "arguments", [true]
            ),
            "config.app", Map(
                "class", "AppConfig",
                "arguments", ["@config_storage.app_config", "@{}", "@@config_key"]
            ),
            "config.modules", Map(
                "class", "PersistentConfig",
                "arguments", ["@config_storage.modules", "@{}", "module_config"]
            ),
            "config_storage.app_config", Map(
                "class", "JsonConfigStorage",
                "arguments", "@@config_path"
            ),
            "config_storage.modules", Map(
                "class", "JsonConfigStorage",
                "arguments", ["@@config.modules_file", "modules"]
            ),
            "debugger", Map(
                "class", "Debugger",
                "calls", Map(
                    "method", "SetLogger",
                    "arguments", "@logger"
                )
            ),
            "definition_loader.entity_type", Map(
                "class", "ParameterEntityTypeDefinitionLoader",
                "arguments", ["@{}", "entity_type", "@factory.entity_type"]
            ),
            "definition_loader.modules", Map(
                "class", "ModuleDefinitionLoader",
                "arguments", [
                    "@factory.modules",
                    "@config.modules",
                    "@@config.module_dirs",
                    "@@config.core_module_dirs",
                    "@@modules"
                ]
            ),
            "definition_loader.themes", Map(
                "class", "DirDefinitionLoader",
                "arguments", [
                    "@factory.structured_data", 
                    "@@config.themes_dir", 
                    "", 
                    false, 
                    false, 
                    "", 
                    "theme"
                ]
            ),
            "factory.entity_field_widget", Map(
                "class", "EntityFieldWidgetFactory",
                "arguments", ["@{}"]
            ),
            "factory.entity_type", Map(
                "class", "EntityTypeFactory",
                "arguments", ["@{}", "@manager.event", "@id_sanitizer"]
            ),
            "factory.gui", Map(
                "class", "GuiFactory",
                "arguments", ["@{}", "@manager.theme", "@id_generator"]
            ),
            "factory.modules", Map(
                "class", "ModuleFactory",
                "arguments", ["@{}", "@factory.structured_data", "@config.modules"]
            ),
            "factory.structured_data", Map(
                "class", "StructuredDataFactory",
                "arguments", "@@structured_data"
            ),
            "factory.theme", Map(
                "class", "ThemeFactory",
                "arguments", [
                    "@{}", 
                    "@@resources_dir", 
                    "@manager.event", 
                    "@id_generator", 
                    "@logger"
                ]
            ),
            "gdip", "Gdip",
            "id_generator", "UuidGenerator",
            "id_sanitizer", Map(
                "class", "StringSanitizer"
            ),
            "installer.themes", Map(
                "class", "ThemeInstaller",
                "arguments", [
                    "@@version",
                    "@state.app",
                    "@manager.cache",
                    "file",
                    "@@themes.extra_themes",
                    "@@{tmp_dir}\Installers"
                ]
            ),
            "logger", Map(
                "class", "LoggerService",
                "arguments", ["@logger.file"]
            ),
            "logger.file", Map(
                "class", "FileLogger", 
                "arguments", [
                    "@@config.log_path", 
                    "@@config.logging_level", 
                    true
                ]
            ),
            "manager.cache", Map(
                "class", "CacheManager", 
                "arguments", [
                    "@config.app", 
                    "@{}", 
                    "@manager.event", 
                    "@notifier"
                ]
            ),
            "manager.entity_type", Map(
                "class", "EntityTypeManager",
                "arguments", [
                    "@{}", 
                    "@manager.event", 
                    "@notifier", 
                    "@definition_loader.entity_type"
                ]
            ),
            "manager.event", Map(
                "class", "EventManager"
            ),
            "manager.gui", Map(
                "class", "GuiManager",
                "arguments", [
                    "@{}", 
                    "@factory.gui",
                    "@state.app",
                    "@manager.event",
                    "@notifier"
                ]
            ),
            "manager.installer", Map(
                "class", "InstallerManager",
                "arguments", ["@{}", "@manager.event", "@notifier"]
            ),
            "manager.module", Map(
                "class", "ModuleManager", 
                "arguments", [
                    "@{}", 
                    "@manager.event", 
                    "@notifier",
                    "@config.app",
                    "@config.modules",
                    "@definition_loader.modules"
                ]
            ),
            "manager.theme", Map(
                "class", "ThemeManager",
                "arguments", [
                    "@{}",
                    "@manager.event",
                    "@notifier",
                    "@config.app",
                    "@definition_loader.themes",
                    "Steampad"
                ]
            ),
            "merger.list", Map(
                "class", "ListMerger",
                "arguments", [true]
            ),
            "notifier", Map(
                "class", "NotificationService",
                "arguments", ["@{App}", "@notifier.toast"]
            ),
            "notifier.toast", Map(
                "class", "ToastNotifier",
                "arguments", ["@{App}"]
            ),
            "shell", Map(
                "com", "WScript.Shell",
                "props", Map("CurrentDirectory", "@@app_dir")
            ),
            "state.app", Map(
                "class", "AppState",
                "arguments", ["@{App}", "@@state_path"]
            ),
            "version_checker", "VersionChecker"
        )
    }

    AllocConsole() {
        DllCall("AllocConsole")

        if (WinExist("ahk_id " . DllCall("GetConsoleWindow", "ptr"))) {
            WinHide()
        }
    }

    Startup(config := "") {
        config := config ? config : this.startConfig

        if (!config) {
            config := Map()
        }

        if (!config.Has("appName") || !config["appName"]) {
            SplitPath(A_ScriptName,,,, &appBaseName)
            config["appName"] := appBaseName
        }

        if (!config.Has("appDir") || !config["appDir"]) {
            config["appDir"] := A_ScriptDir
        }

        if (!config.Has("tmpDir") || !config["tmpDir"]) {
            config["tmpDir"] := A_Temp . "\" . config["appName"]
        }

        if (!config.Has("dataDir") || !config["dataDir"]) {
            config["dataDir"] := A_AppData . "\" . config["appName"]
        }

        if (!config.Has("version")) {
            config["version"] := "1.0.0"
        }

        this.appName := config["appName"]
        this.versionStr := config["version"]
        this.appDir := config["appDir"]
        this.tmpDir := config["tmpDir"]
        this.dataDir := config["dataDir"]

        if (!DirExist(this.tmpDir)) {
            DirCreate(this.tmpDir)
        }

        if (!DirExist(this.dataDir)) {
            DirCreate(this.dataDir)
        }

        this.LoadServices(config)

        if (!config.Has("useShell") || config("useShell")) {
            this["shell"]
        }
        
        OnError(ObjBindMethod(this, "OnException"))

        event := AppRunEvent(Events.APP_PRE_INITIALIZE, this, config)
        this["manager.event"].DispatchEvent(event)

        this.InitializeApp(config)

        event := AppRunEvent(Events.APP_POST_INITIALIZE, this, config)
        this["manager.event"].DispatchEvent(event)

        event := AppRunEvent(Events.APP_PRE_RUN, this, config)
        this["manager.event"].DispatchEvent(event)

        this.RunApp(config)

        event := AppRunEvent(Events.APP_POST_STARTUP, this, config)
        this["manager.event"].DispatchEvent(event)
    }

    LoadServices(config) {
        this.Services := ServiceContainer(SimpleDefinitionLoader(
            this.GetServiceDefinitions(config), 
            this.GetParameterDefinitions(config)
        ))
        
        this.Services.LoadDefinitions(MapDefinitionLoader(config))
        sdFactory := this["factory.structured_data"]
        serviceFile := this.Parameter["service_files.app"]

        if (FileExist(serviceFile)) {
            this.Services.LoadDefinitions(FileDefinitionLoader(sdFactory, serviceFile))
        }

        this["config.app"]
        this.InitializeTheme()
        this.InitializeModules(config)

        for index, moduleServiceFile in this["manager.module"].GetModuleServiceFiles() {
            if (FileExist(moduleServiceFile)) {
                this.Services.LoadDefinitions(FileDefinitionLoader(sdFactory, moduleServiceFile))
            } else {
                throw ModuleException("Module service file " . moduleServiceFile . " not found")
            }
        }
        
        ; Reload user config files to ensure they are the active values
        this["config.app"].LoadConfig(true)

        ; Register early event subscribers (e.g. modules)
        this["manager.event"].RegisterServiceSubscribers(this.Services)

        this["manager.event"].Register(Events.APP_SERVICES_LOADED, "AppServices", ObjBindMethod(this, "OnServicesLoaded"))

        event := ServiceDefinitionsEvent(Events.APP_SERVICE_DEFINITIONS, "", "", config)
        this["manager.event"].DispatchEvent(event)

        if (event.Services.Count || event.Parameters.Count) {
            this.Services.LoadDefinitions(SimpleDefinitionLoader(event.Services, event.Parameters))
        }

        serviceFile := this.Parameter["service_files.user"]

        if (FileExist(serviceFile)) {
            this.Services.LoadDefinitions(FileDefinitionLoader(sdFactory, serviceFile))
        }

        ; Register any missing late-loading event subscribers
        this["manager.event"].RegisterServiceSubscribers(this.Services)

        event := AppRunEvent(Events.APP_SERVICES_LOADED, this, config)
        this["manager.event"].DispatchEvent(event)
    }

    OnServicesLoaded(event, extra, eventName, hwnd) {
        this["manager.cache"]
        this["manager.entity_type"].All()
        this["manager.installer"].RunInstallers(InstallerBase.INSTALLER_TYPE_REQUIREMENT)
    }

    InitializeModules(config) {
        includeFiles := this.Parameter["include_files"]
        updated := this["manager.module"].UpdateModuleIncludes(includeFiles["modules"], includeFiles["module_tests"])

        if (updated) {
            message := A_IsCompiled ?
                "Your modules have been updated. Currently, you must recompile " this.appName . " yourself for the changes to take effect. Would you like to exit now (highly recommended)?" :
                "Your modules have been updated, and " this.appName . " must be restarted for the changes to take effect. Would you like to restart now?"

            response := this.app["manager.gui"].Dialog(Map(
                "title", "Module Includes Updated",
                "text", message
            ))
        
            if (response == "Yes") {
                if (A_IsCompiled) {
                    this.ExitApp()
                } else {
                    this.RestartApp()
                }
            }
        }
    }

    InitializeTheme() {
        this[["gdip", "manager.gui", "manager.theme"]]
        this.themeReady := true
    }

    InitializeApp(config) {
        A_AllowMainWindow := false

        if (this.Parameter["app.custom_tray_menu"]) {
            A_TrayMenu.Delete()
            this["manager.event"].Register(Events.AHK_NOTIFYICON, "TrayClick", ObjBindMethod(this, "OnTrayIconRightClick"), 1)
        }
    }

    RunApp(config) {
        if (this.Config["check_updates_on_start"]) {
            this.CheckForUpdates(false)
        }

        if (this.Services.HasParameter("config_path") && !FileExist(this.Parameter["config_path"])) {
            this.InitialSetup(config)
        }
    }

    OpenApp() {
        mainWin := this.Parameter["config.main_window"]

        if (mainWin) {
            if (this["manager.gui"].Has(mainWin)) {
                WinActivate("ahk_id " . this["manager.gui"][mainWin].GetHwnd())
            } else {
                this["manager.gui"].OpenWindow(Map(
                    "type", mainWin,
                    "title", this.appName
                ))
            }
        }
    }

    ExitApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this["manager.event"].DispatchEvent(event)

        if (this.Services.Has("gdip")) {
            Gdip_Shutdown(this.Services["gdip"].GetHandle())
        }

        ExitApp
    }

    RestartApp() {
        event := AppRunEvent(Events.APP_RESTART, this)
        this["manager.event"].DispatchEvent(event)

        if (this.Services.Has("gdip")) {
            Gdip_Shutdown(this.Services["gdip"].GetHandle())
        }

        Reload()
    }

    GetCmdOutput(command, trimOutput := true) {
        output := ""

        if (!this.Services.Has("shell")) {
            throw AppException("The shell is disabled, so shell commands cannot currently be run.")
        }
        
        result := this["shell"].Exec(A_ComSpec . " /C " . command).StdOut.ReadAll()

        if (trimOutput) {
            result := Trim(result, " `r`n`t")
        }

        return result
    }

    Service(name, params*) {
        nameIsArray := HasBase(name, Array.Prototype)

        if (nameIsArray || (params && params.Length)) {
            results := Map()

            if (!nameIsArray) {
                name := [name]
            }

            for index, arrName in name {
                results[arrName] := this[arrName]
            }

            if (params && params.Length) {
                for index, arrName in params {
                    results[arrName] := this[arrName]
                }
            }

            return results
        }

        return this.Services.Get(name)
    }

    OnException(e, mode) {
        extra := (e.HasProp("Extra") && e.Extra != "") ? "`n`nExtra information:`n" . e.Extra : ""
        occurredIn := e.What ? " in " . e.What : ""

        developer := this.Parameter["app.developer"]

        if (!developer) {
            developer := "the developer(s)"
        }

        errorText := this.appName . " has experienced an unhandled exception. You can find the details below."
        errorText .= "`n`n" . e.Message . extra
        
        if (!A_IsCompiled) {
            errorText .= "`n`nOccurred in: " . e.What
        
            if (e.File) {
                errorText .= "`nFile: " . e.File . " (Line " . e.Line . ")"
            }

            if (e.Stack) {
                errorText .= "`n`nStack trace:`n" . e.Stack
            }
        }

        if (this.Services.Has("logger")) {
            this["logger"].Error(errorText)
        }
        
        errorText .= "`n"

        return this.ShowError("Unhandled Exception", errorText, e, mode != "ExitApp")
    }

    ShowError(title, errorText, err, allowContinue := true) {
        try {
            if (this.themeReady) {
                btns := allowContinue ? "*&Continue|&Reload|&Exit" : "*&Reload|&Exit"

                this["manager.gui"].Dialog(Map(
                    "type", "ErrorDialog",
                    "title", "Unhandled Exception",
                    "text", errorText,
                    "buttons", btns,
                    "alwaysOnTop", this.Config["force_error_window_to_top"]
                ), err)
            } else {
                this.ShowUnthemedError(title, err.Message, err, "", allowContinue)
            }
        } catch as ex {
            this.ShowUnthemedError(title, errorText, err, ex, allowContinue)
        }

        return allowContinue ? -1 : 1
    }

    ShowUnthemedError(title, errorText, err, displayErr := "", allowContinue := true) {
        otherErrorInfo := (displayErr && err != displayErr) ? "`n`nThe application could not show the usual error dialog because of another error:`n`n" . displayErr.File . ": " . displayErr.Line . ": " . displayErr.What . ": " . displayErr.Message : ""
        MsgBox(errorText . otherErrorInfo, "Error")
    }
    
    OnTrayIconRightClick(wParam, lParam, msg, hwnd) {
        if (lParam == Events.MOUSE_RIGHT_UP) {
            if (this.Parameter["app.custom_tray_menu"]) {
                this.ShowTrayMenu()
                return 0
            }
        }
    }

    InitialSetup(config) {
        this.isSetup := true
    }

    ShowTrayMenu() {
        menuItems := []
        menuItems.Push(Map("label", "Open " . this.appName, "name", "OpenApp"))
        menuItems := this.SetTrayMenuItems(menuItems)
        menuItems.Push("")
        menuItems.Push(Map("label", "Restart", "name", "RestartApp"))
        menuItems.Push(Map("label", "Exit", "name", "ExitApp"))

        result := this["manager.gui"].Menu(menuItems, this)
        this.HandleTrayMenuClick(result)
    }

    SetTrayMenuItems(menuItems) {
        return menuItems
    }

    HandleTrayMenuClick(result) {
        if (result == "OpenApp") {
            this.OpenApp()
        } else if (result == "RestartApp") {
            this.RestartApp()
        } else if (result == "ExitApp") {
            this.ExitApp()
        }

        return result
    }

    __Delete() {
        this.ExitApp()
        super.__Delete()
    }

    MainMenu(parentGui, parentCtl, showOpenAppItem := false) {
        menuItems := this.GetMainMenuItems(showOpenAppItem)

        if (menuItems.Length) {
            this.HandleMainMenuClick(this["manager.gui"].Menu(
                menuItems, 
                parentGui, 
                parentCtl
            ))
        }
    }

    GetMainMenuItems(showOpenAppItem := false) {
        menuItems := []
        menuItems := this.AddMainMenuEarlyItems(menuItems, showOpenAppItem)

        if (menuItems.Length) {
            menuItems.Push("")
        }

        length := menuItems.Length

        toolsItems := this.GetToolsMenuItems()

        if (toolsItems.Length) {
            menuItems.Push(Map("label", "&Tools", "name", "ToolsMenu", "childItems", toolsItems))
        }

        aboutItems := this.GetAboutMenuItems()

        if (aboutItems.Length) {
            menuItems.Push(Map("label", "&About", "name", "About", "childItems", aboutItems))
        }

        menuItems := this.AddMainMenuMiddleItems(menuItems)

        if (menuItems.Length > length) {
            menuItems.Push("")
        }

        length := menuItems.Length
        menuItems := this.AddMainMenuLateItems(menuItems)

        if (menuItems.Length > length) {
            menuItems.Push("")
        }

        if (this.Parameter["app.show_restart_menu_item"]) {
            menuItems.Push(Map("label", "&Restart", "name", "Reload"))
        }

        menuItems.Push(Map("label", "E&xit", "name", "Exit"))

        event := MenuItemsEvent(Events.APP_MENU_ITEMS_ALTER, menuItems)
        this.Dispatch(event)
        menuItems := event.MenuItems

        return menuItems
    }

    GetAboutMenuItems() {
        aboutItems := []

        if (this.Parameter["app.show_about_menu_item"]) {
            aboutItems.Push(Map("label", "&About " . this.appName, "name", "About"))
        }

        if (this.Parameter["app.show_website_menu_item"]) {
            aboutItems.Push(Map("label", "Open &Website", "name", "OpenWebsite"))
        }

        event := MenuItemsEvent(Events.APP_MENU_ABOUT_ITEMS_ALTER, aboutItems)
        this.Dispatch(event)
        aboutItems := event.MenuItems

        return aboutItems
    }

    GetToolsMenuItems() {
        toolsItems := this.AddEntityManagerMenuLinks([])
        event := MenuItemsEvent(Events.APP_MENU_TOOLS_ITEMS_ALTER, toolsItems)
        this.Dispatch(event)
        toolsItems := event.MenuItems

        return toolsItems
    }

    AddMainMenuEarlyItems(menuItems, showOpenAppItem := false) {
        if (showOpenAppItem) {
            menuItems.Push(Map("label", "Open " . this.appName, "name", "OpenApp"))
            menuItems.Push("")
        }

        event := MenuItemsEvent(Events.APP_MENU_ITEMS_EARLY, menuItems)
        this.Dispatch(event)
        menuItems := event.MenuItems

        return menuItems
    }

    AddMainMenuMiddleItems(menuItems) {
        event := MenuItemsEvent(Events.APP_MENU_ITEMS_MIDDLE, menuItems)
        this.Dispatch(event)
        menuItems := event.MenuItems
        return menuItems
    }

    AddMainMenuLateItems(menuItems) {
        if (this.Parameter["app.has_settings"]) {
            menuItems.Push(Map("label", "&Settings", "name", "Settings"))
        }

        if (this.Parameter["app.supports_update_check"]) {
            menuItems.Push(Map("label", "Check for &Updates", "name", "CheckForUpdates"))
        }

        event := MenuItemsEvent(Events.APP_MENU_ITEMS_LATE, menuItems)
        this.Dispatch(event)
        menuItems := event.MenuItems

        return menuItems
    }

    AddEntityManagerMenuLinks(menuItems) {
        menuEntityTypes := this._getToolsMenuEntityTypes()

        for key, entityType in menuEntityTypes {
            menuLinkText := entityType.definition["manager_menu_link_text"]

            if (!menuLinkText) {
                menuLinkText := "&" . entityType.definition["name_plural"]
            }

            menuItems.Push(Map("label", menuLinkText, "name", "manage_" . key))
        }

        return menuItems
    }

    Dispatch(event) {
        this["manager.event"].DispatchEvent(event)
    }

    _getToolsMenuEntityTypes() {
        entityTypes := Map()

        for key, entityType in this["manager.entity_type"] {
            if (entityType.definition["manager_link_in_tools_menu"]) {
                entityTypes[key] := entityType
            }
        }

        return entityTypes
    }

    HandleMainMenuClick(result) {
        event := MenuResultEvent(Events.APP_MENU_PROCESS_RESULT, result)
        this.Dispatch(event)
        result := event.Result

        if (!event.IsFinished) {
            if (result == "About") {
                this.ShowAbout()
            } else if (result == "OpenWebsite") {
                this.OpenWebsite()
            } else if (result == "Settings") {
                this.ShowSettings()
            } else if (result == "CheckForUpdates") {
                this.CheckForUpdates()
            } else if (result == "Reload") {
                this.restartApp()
            } else if (result == "Exit") {
                this.ExitApp()
            } else {
                for key, entityType in this._getToolsMenuEntityTypes() {
                    if (result == "manage_" . key) {
                        this["entity_type." . key].OpenManageWindow()
                        break
                    }
                }
            }
        }

        return result
    }

    ShowSettings() {
        windowName := this.Parameter["app.settings_window"]

        if (windowName) {
            this["manager.gui"].Dialog(Map("type", windowName, "unique", false))
        }
    }

    ShowAbout() {
        windowName := this.Parameter["app.about_window"]

        if (windowName) {
            this["manager.gui"].Dialog(Map("type", windowName))
        }
    }

    OpenWebsite() {
        websiteUrl := this.Parameter["app.website_url"]

        if (websiteUrl) {
            Run(websiteUrl)
        }
    }

    CheckForUpdates(notify := true) {
        if (this.Parameter["app.supports_update_check"]) {
            updateAvailable := false

            event := ReleaseInfoEvent(Events.APP_GET_RELEASE_INFO, this)
            this["manager.event"].DispatchEvent(event)
            releaseInfo := event.ReleaseInfo

            if (
                releaseInfo 
                && releaseInfo.Has("version") 
                && releaseInfo["version"]
                && this["version_checker"].VersionIsOutdated(releaseInfo["version"], this.Version)
            ) {
                updateAvailable := true
                this["manager.gui"].Dialog(Map("type", "UpdateAvailableWindow"), releaseInfo)
            }

            if (!updateAvailable && notify) {
                this["notifier"].Info("You're running the latest version of " . this.appName . ". Shiny!")
            }
        }
    }
}
