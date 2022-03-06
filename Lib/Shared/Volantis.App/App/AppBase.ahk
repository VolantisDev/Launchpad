class AppBase {
    developer := ""
    versionStr := ""
    appName := ""
    appDir := ""
    tmpDir := ""
    dataDir := ""
    configObj := ""
    stateObj := ""
    serviceContainerObj := ""
    customTrayMenu := false
    themeReady := false
    startConfig := ""

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
        get => this.Service("Config")
    }

    State {
        get => this.Service("State")
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
            "resources_dir", "@@{app_dir}\Resources",
            "config_path", "@@{app_dir}\" . this.appName . ".json",
            "config_key", "config",
            "config.theme_name", "Steampad",
            "config.themes_dir", "@@{app_dir}\Resources\Themes",
            "config.cache_dir", "@@{tmp_dir}\Cache",
            "config.flush_cache_on_exit", false,
            "config.check_updates_on_start", false,
            "config.logging_level", "error",
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
            )
        )
    }

    GetServiceDefinitions(config) {
        return Map(
            "Shell", Map(
                "com", "WScript.Shell",
                "props", Map("CurrentDirectory", "@@app_dir")
            ),
            "config_storage.app_config", Map(
                "class", "JsonConfigStorage",
                "arguments", "@@config_path"
            ),
            "Config", Map(
                "class", "AppConfig",
                "arguments", ["@config_storage.app_config", "@{}", "@@config_key"]
            ),
            "State", Map(
                "class", "AppState",
                "arguments", ["@{App}", "@@state_path"]
            ),
            "manager.event", Map(
                "class", "EventManager"
            ),
            "IdGenerator", "UuidGenerator",
            "config_storage.modules", Map(
                "class", "JsonConfigStorage",
                "arguments", ["@@config.modules_file", "modules"]
            ),
            "config.modules", Map(
                "class", "PersistentConfig",
                "arguments", ["@config_storage.modules", "@{}", "module_config"]
            ),
            "factory.modules", Map(
                "class", "ModuleFactory",
                "arguments", ["@{}", "@StructuredData", "@config.modules"]
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
            "ModuleManager", Map(
                "class", "ModuleManager", 
                "arguments", [
                    "@{}", 
                    "@EventManager", 
                    "@Notifier",
                    "@Config",
                    "@config.modules",
                    "@definition_loader.modules"
                ]
            ),
            "Gdip", "Gdip",
            "Debugger", Map(
                "class", "Debugger",
                "calls", Map(
                    "method", "SetLogger",
                    "arguments", "@Logger"
                )
            ),
            "VersionChecker", "VersionChecker",
            "logger.file", Map(
                "class", "FileLogger", 
                "arguments", ["@@config.log_path", "@@config.logging_level", true]
            ),
            "Logger", Map(
                "class", "LoggerService",
                "arguments", ["@logger.file"]
            ),
            "manager.cache", Map(
                "class", "CacheManager", 
                "arguments", ["@Config", "@{}", "@EventManager", "@Notifier"]
            ),
            "ThemeFactory", Map(
                "class", "ThemeFactory",
                "arguments", ["@{}", "@@resources_dir", "@EventManager", "@IdGenerator", "@Logger"]
            ),
            "definition_loader.themes", Map(
                "class", "DirDefinitionLoader",
                "arguments", ["@StructuredData", "@@config.themes_dir", "", false, false, "", "theme"]
            ),
            "ThemeManager", Map(
                "class", "ThemeManager",
                "arguments", [
                    "@{}",
                    "@EventManager",
                    "@Notifier",
                    "@Config",
                    "@definition_loader.themes",
                    "Steampad"
                ]
            ),
            "notifier.toast", Map(
                "class", "ToastNotifier",
                "arguments", ["@{App}"]
            ),
            "Notifier", Map(
                "class", "NotificationService",
                "arguments", ["@{App}", "@notifier.toast"]
            ),
            "factory.gui", Map(
                "class", "GuiFactory",
                "arguments", ["@{}", "@ThemeManager", "@IdGenerator"]
            ),
            "manager.gui", Map(
                "class", "GuiManager",
                "arguments", [
                    "@{}", 
                    "@factory.gui",
                    "@State",
                    "@EventManager",
                    "@Notifier"
                ]
            ),
            "manager.installer", Map(
                "class", "InstallerManager",
                "arguments", ["@{}", "@EventManager", "@Notifier"]
            ),
            "EntityFactory", Map(
                "class", "EntityFactory",
                "arguments", ["@{}"]
            ),
            "installer.themes", Map(
                "class", "ThemeInstaller",
                "arguments", [
                    "@@version",
                    "@State",
                    "@CacheManager",
                    "file",
                    "@@themes.extra_themes",
                    "@@{tmp_dir}\Installers"
                ]
            ),
            "cache_state.file", Map(
                "class", "CacheState",
                "arguments", ["@{App}", "@@config.cache_dir", "File.json"]
            ),
            "cache.file", Map(
                "class", "FileCache",
                "arguments", ["@{App}", "@cache_state.file", "@@config.cache_dir", "File"]
            ),
            "StructuredData", Map(
                "class", "StructuredDataFactory",
                "arguments", "@@structured_data"
            )
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

        if (!config.Has("developer")) {
            config["developer"] := ""
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
            config["version"] := 1.0.0
        }

        this.appName := config["appName"]
        this.versionStr := config["version"]
        this.developer := config["developer"]
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
            this.Service("Shell")
        }
        
        OnError(ObjBindMethod(this, "OnException"))

        event := AppRunEvent(Events.APP_PRE_INITIALIZE, this, config)
        this.Service("manager.event").DispatchEvent(Events.APP_PRE_INITIALIZE, event)

        this.InitializeApp(config)

        event := AppRunEvent(Events.APP_POST_INITIALIZE, this, config)
        this.Service("manager.event").DispatchEvent(Events.APP_POST_INITIALIZE, event)

        event := AppRunEvent(Events.APP_POST_STARTUP, this, config)
        this.Service("manager.event").DispatchEvent(Events.APP_POST_STARTUP, event)

        event := AppRunEvent(Events.APP_PRE_RUN, this, config)
        this.Service("manager.event").DispatchEvent(Events.APP_PRE_RUN, event)

        this.RunApp(config)
    }

    LoadServices(config) {
        this.Services := ServiceContainer(SimpleDefinitionLoader(
            this.GetServiceDefinitions(config), 
            this.GetParameterDefinitions(config)
        ))
        
        this.Services.LoadDefinitions(MapDefinitionLoader(config))
        sdFactory := this.Service("StructuredData")
        serviceFile := this.Services.GetParameter("service_files.app")

        if (FileExist(serviceFile)) {
            this.Services.LoadDefinitions(FileDefinitionLoader(sdFactory, serviceFile))
        }

        this.Service("Config")
        this.InitializeTheme()
        this.InitializeModules(config)

        for index, moduleServiceFile in this.Service("ModuleManager").GetModuleServiceFiles() {
            if (FileExist(moduleServiceFile)) {
                this.Services.LoadDefinitions(FileDefinitionLoader(sdFactory, moduleServiceFile))
            } else {
                throw ModuleException("Module service file " . moduleServiceFile . " not found")
            }
        }
        
        ; Reload user config files to ensure they are the active values
        this.Service("Config").LoadConfig(true)

        ; Register early event subscribers (e.g. modules)
        this.Service("manager.event").RegisterServiceSubscribers(this.Services)

        this.Service("manager.event").Register(Events.APP_SERVICES_LOADED, "AppServices", ObjBindMethod(this, "OnServicesLoaded"))

        event := ServiceDefinitionsEvent(Events.APP_SERVICE_DEFINITIONS, "", "", config)
        this.Service("manager.event").DispatchEvent(Events.APP_SERVICE_DEFINITIONS, event)

        if (event.Services.Count || event.Parameters.Count) {
            this.Services.LoadDefinitions(SimpleDefinitionLoader(event.Services, event.Parameters))
        }

        serviceFile := this.Services.GetParameter("service_files.user")

        if (FileExist(serviceFile)) {
            this.Services.LoadDefinitions(FileDefinitionLoader(sdFactory, serviceFile))
        }

        ; Register any missing late-loading event subscribers
        this.Service("manager.event").RegisterServiceSubscribers(this.Services)

        event := AppRunEvent(Events.APP_SERVICES_LOADED, this, config)
        this.Service("manager.event").DispatchEvent(Events.APP_SERVICES_LOADED, event)
    }

    OnServicesLoaded(event, extra, eventName, hwnd) {
        this.Service("manager.cache")
        this.Service("manager.installer").RunInstallers(InstallerBase.INSTALLER_TYPE_REQUIREMENT)
    }

    InitializeModules(config) {
        includeFiles := this.Services.GetParameter("include_files")
        updated := this.Service("ModuleManager").UpdateModuleIncludes(includeFiles["modules"], includeFiles["module_tests"])

        if (updated) {
            message := A_IsCompiled ?
                "Your modules have been updated. Currently, you must recompile " this.appName . " yourself for the changes to take effect. Would you like to exit now (highly recommended)?" :
                "Your modules have been updated, and " this.appName . " must be restarted for the changes to take effect. Would you like to restart now?"

            response := this.app.Service("manager.gui").Dialog(Map(
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
        this.Service("Gdip", "manager.gui", "ThemeManager")
        this.themeReady := true
    }

    InitializeApp(config) {
        A_AllowMainWindow := false

        if (this.customTrayMenu) {
            A_TrayMenu.Delete()
            this.Service("manager.event").Register(Events.AHK_NOTIFYICON, "TrayClick", ObjBindMethod(this, "OnTrayIconRightClick"), 1)
        }
    }

    RunApp(config) {
        if (this.Config["check_updates_on_start"]) {
            this.CheckForUpdates(false)
        }

        if (this.Services.HasParameter("config_path") && !FileExist(this.Parameter("config_path"))) {
            this.InitialSetup(config)
        }
    }

    OpenApp() {
        mainWin := this.Parameter("config.main_window")

        if (mainWin) {
            if (this.Service("manager.gui").Has(mainWin)) {
                WinActivate("ahk_id " . this.Service("manager.gui")[mainWin].GetHwnd())
            } else {
                this.Service("manager.gui").OpenWindow(Map(
                    "type", mainWin,
                    "title", this.appName
                ))
            }
        }
    }

    ExitApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("manager.event").DispatchEvent(Events.APP_SHUTDOWN, event)

        if (this.Services.Has("Gdip")) {
            Gdip_Shutdown(this.Services.Get("Gdip").GetHandle())
        }

        ExitApp
    }

    RestartApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("manager.event").DispatchEvent(Events.APP_RESTART, event)

        if (this.Services.Has("Gdip")) {
            Gdip_Shutdown(this.Services.Get("Gdip").GetHandle())
        }

        Reload()
    }

    GetCmdOutput(command, trimOutput := true) {
        output := ""

        if (!this.Services.Has("Shell")) {
            throw AppException("The shell is disabled, so shell commands cannot currently be run.")
        }
        
        result := this.Service("Shell").Exec(A_ComSpec . " /C " . command).StdOut.ReadAll()

        if (trimOutput) {
            result := Trim(result, " `r`n`t")
        }

        return result
    }

    Service(name, params*) {
        if (Type(name) == "Array" || (params && params.Length)) {
            results := Map()

            if (Type(name) != "Array") {
                name := [name]
            }

            for index, arrName in name {
                results[arrName] := this.Service(arrName)
            }

            if (params && params.Length) {
                for index, arrName in params {
                    results[arrName] := this.Service(arrName)
                }
            }

            return results
        }

        return this.Services.Get(name)
    }

    Parameter(name) {
        return this.Services.GetParameter(name)
    }

    OnException(e, mode) {
        extra := (e.HasProp("Extra") && e.Extra != "") ? "`n`nExtra information:`n" . e.Extra : ""
        occurredIn := e.What ? " in " . e.What : ""
        developer := this.developer ? this.developer : "the developer(s)"

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

        if (this.Services.Has("Logger")) {
            this.Service("Logger").Error(errorText)
        }
        
        errorText .= "`n"

        return this.ShowError("Unhandled Exception", errorText, e, mode != "ExitApp")
    }

    ShowError(title, errorText, err, allowContinue := true) {
        try {
            if (this.themeReady) {
                btns := allowContinue ? "*&Continue|&Reload|&Exit" : "*&Reload|&Exit"

                this.Service("manager.gui").Dialog(Map(
                    "type", "ErrorDialog",
                    "title", "Unhandled Exception",
                    "text", errorText,
                    "buttons", btns
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
            if (this.customTrayMenu) {
                this.ShowTrayMenu()
                return 0
            }
        }
    }

    InitialSetup(config) {
        ; Override this to set config values as needed
    }

    CheckForUpdates(notify := true) {
        ; Optional method to override
    }

    ShowTrayMenu() {
        menuItems := []
        menuItems.Push(Map("label", "Open " . this.appName, "name", "OpenApp"))
        menuItems := this.SetTrayMenuItems(menuItems)
        menuItems.Push("")
        menuItems.Push(Map("label", "Restart", "name", "RestartApp"))
        menuItems.Push(Map("label", "Exit", "name", "ExitApp"))

        result := this.Service("manager.gui").Menu(menuItems, this)
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
}
