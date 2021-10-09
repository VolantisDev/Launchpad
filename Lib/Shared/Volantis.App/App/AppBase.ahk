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
    mainWindowKey := "MainWindow"
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
        SplitPath(A_ScriptFullPath,,,, &scriptName)

        resourcesDir := this.appDir . "\Resources"

        if (config.Has("resourcesDir") && config["resourcesDir"]) {
            resourcesDir := config["resourcesDir"]
        }

        themeName := "Steampad"
        
        if (config.Has("themeName") && config["themeName"]) {
            themeName := config["themeName"]
        }

        return Map(
            "config_path", this.appDir . "\" . this.appName . ".json",
            "config_key", "config",
            "config.theme_name", themeName,
            "config.themes_dir", this.appDir . "\Resources\Themes",
            "config.cache_dir", this.tmpDir . "\Cache",
            "config.flush_cache_on_exit", false,
            "config.check_updates_on_start", false,
            "config.logging_level", "error",
            "config.modules_file", this.dataDir . "\Modules.json",
            "config.log_path", this.dataDir . "\" . this.appName . "Log.txt",
            "config.module_dirs", [this.dataDir . "\Modules"],
            "state_path", this.dataDir . "\" . this.appName . "State.json",
            "service_files.app", this.appDir . "\" . scriptName . ".services.json",
            "service_files.user", this.dataDir . "\" . scriptName . ".services.json",
            "include_files.modules", this.dataDir . "\ModuleIncludes.ahk",
            "include_files.module_tests", this.dataDir . "\ModuleIncludes.test.ahk",
            "resources.dir", resourcesDir,
            "themes.extra_themes", [],
            "module_config.modules", Map(),
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
                "props", Map("CurrentDirectory", this.appDir)
            ),
            "config_storage.app_config", Map(
                "class", "JsonConfigStorage",
                "arguments", ParameterRef("config_path")
            ),
            "Config", Map(
                "class", "AppConfig",
                "arguments", [
                    ServiceRef("config_storage.app_config"), 
                    ContainerRef(), 
                    ParameterRef("config_key")
                ]
            ),
            "State", Map(
                "class", "AppState",
                "arguments", [AppRef(), ParameterRef("state_path")]
            ),
            "EventManager", Map(
                "class", "EventManager"
            ),
            "IdGenerator", "UuidGenerator",
            "config_storage.modules", Map(
                "class", "JsonConfigStorage",
                "arguments", [ParameterRef("config.modules_file"), "Modules"]
            ),
            "config.modules", Map(
                "class", "PersistentConfig",
                "arguments", [
                    ServiceRef("config_storage.modules"), 
                    ContainerRef(), 
                    "module_config"
                ]
            ),
            "ModuleManager", Map(
                "class", "ModuleManager", 
                "arguments", [
                    AppRef(), 
                    ServiceRef("EventManager"), 
                    ServiceRef("IdGenerator"), 
                    ServiceRef("config.modules"),
                    this.dataDir, 
                    ParameterRef("config.module_dirs"), 
                    this.GetDefaultModules(config)
                ]
            ),
            "Gdip", "Gdip",
            "Debugger", Map(
                "class", "Debugger",
                "calls", Map(
                    "method", "SetLogger",
                    "arguments", ServiceRef("Logger")
                )
            ),
            "VersionChecker", "VersionChecker",
            "logger.file", Map(
                "class", "FileLogger", 
                "arguments", [
                    ParameterRef("config.log_path"), 
                    ParameterRef("config.logging_level"), 
                    true
                ]
            ),
            "Logger", Map(
                "class", "LoggerService",
                "arguments", [ServiceRef("logger.file")]
            ),
            "CacheManager", Map(
                "class", "CacheManager", 
                "arguments", [
                    ContainerRef(), 
                    ServiceRef("EventManager"), 
                    ServiceRef("Notifier")
                ]
            ),
            "ThemeFactory", Map(
                "class", "ThemeFactory",
                "arguments", [
                    ContainerRef(), 
                    ParameterRef("resources.dir"),
                    ServiceRef("EventManager"),
                    ServiceRef("IdGenerator"),
                    ServiceRef("Logger")
                ]
            ),
            "definition_loader.themes", Map(
                "class", "DirDefinitionLoader",
                "arguments", [
                    ServiceRef("StructuredData"), 
                    ParameterRef("config.themes_dir"), 
                    "",
                    false,
                    false, 
                    "",
                    "theme"
                ]
            ),
            "ThemeManager", Map(
                "class", "ThemeManager",
                "arguments", [
                    ContainerRef(),
                    ServiceRef("EventManager"),
                    ServiceRef("Notifier"),
                    ServiceRef("Config"),
                    ServiceRef("definition_loader.themes"),
                    "Steampad"
                ]
            ),
            "notifier.toast", Map(
                "class", "ToastNotifier",
                "arguments", [AppRef()]
            ),
            "Notifier", Map(
                "class", "NotificationService",
                "arguments", [AppRef(), ServiceRef("notifier.toast")]
            ),
            "GuiManager", Map(
                "class", "GuiManager",
                "arguments", [
                    AppRef(), 
                    ServiceRef("ThemeManager"), 
                    ServiceRef("IdGenerator"), 
                    ServiceRef("State")
                ]
            ),
            "InstallerManager", Map(
                "class", "InstallerManager",
                "arguments", [
                    ContainerRef(),
                    ServiceRef("EventManager"),
                    ServiceRef("Notifier")
                ]
            ),
            "EntityFactory", Map(
                "class", "EntityFactory",
                "arguments", [ContainerRef()]
            ),
            "installer.themes", Map(
                "class", "ThemeInstaller",
                "arguments", [
                    this.Version,
                    ServiceRef("State"),
                    ServiceRef("CacheManager"),
                    "file",
                    ParameterRef("themes.extra_themes"),
                    this.tmpDir . "\Installers"
                ]
            ),
            "cache_state.file", Map(
                "class", "CacheState",
                "arguments", [
                    AppRef(), 
                    ParameterRef("config.cache_dir"), 
                    "File.json"
                ]
            ),
            "cache.file", Map(
                "class", "FileCache",
                "arguments", [
                    AppRef(), 
                    ServiceRef("cache_state.file"), 
                    ParameterRef("config.cache_dir"), 
                    "File"
                ]
            ),
            "StructuredData", Map(
                "class", "StructuredDataFactory",
                "arguments", [ParameterRef("structured_data")]
            )
        )
    }

    GetModuleDirs() {

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
        this.Service("EventManager").DispatchEvent(Events.APP_PRE_INITIALIZE, event)

        this.InitializeApp(config)

        event := AppRunEvent(Events.APP_POST_INITIALIZE, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_POST_INITIALIZE, event)

        event := AppRunEvent(Events.APP_POST_STARTUP, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_POST_STARTUP, event)

        event := AppRunEvent(Events.APP_PRE_RUN, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_PRE_RUN, event)

        this.RunApp(config)
    }

    LoadServices(config) {
        defaultServices := this.GetServiceDefinitions(config)
        defaultParameters := this.GetParameterDefinitions(config)
        this.Services := ServiceContainer(SimpleDefinitionLoader(defaultServices, defaultParameters))
        this.Services.LoadDefinitions(MapDefinitionLoader(config))

        serviceFile := this.Services.GetParameter("service_files.app")

        if (FileExist(serviceFile)) {
            this.Services.LoadDefinitions(FileDefinitionLoader(serviceFile))
        }

        this.Service("Config")
        this.InitializeTheme()
        this.InitializeModules(config)

        serviceFiles := this.Service("ModuleManager").GetModuleServiceFiles()

        for index, moduleServiceFile in serviceFiles {
            if (FileExist(serviceFile)) {
                this.Services.LoadDefinitions(FileDefinitionLoader(moduleServiceFile))
            }
        }

        this.Service("EventManager").Register(Events.APP_SERVICES_LOADED, "AppServices", ObjBindMethod(this, "OnServicesLoaded"))

        event := ServiceDefinitionsEvent(Events.APP_SERVICE_DEFINITIONS, "", "", config)
        this.Service("EventManager").DispatchEvent(Events.APP_SERVICE_DEFINITIONS, event)

        if (event.Services.Count || event.Parameters.Count) {
            this.Services.LoadDefinitions(SimpleDefinitionLoader(event.Services, event.Parameters))
        }

        serviceFile := this.Services.GetParameter("service_files.user")

        if (FileExist(serviceFile)) {
            this.Services.LoadDefinitions(FileDefinitionLoader(serviceFile))
        }

        event := AppRunEvent(Events.APP_SERVICES_LOADED, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_SERVICES_LOADED, event)
    }

    OnServicesLoaded(event, extra, eventName, hwnd) {
        this.Service("CacheManager")
        this.Service("InstallerManager").RunInstallers(InstallerBase.INSTALLER_TYPE_REQUIREMENT)
    }

    InitializeModules(config) {
        includeFiles := this.Services.GetParameter("include_files")
        updated := this.Service("ModuleManager").UpdateModuleIncludes(includeFiles["modules"], includeFiles["module_tests"])

        if (updated) {
            message := A_IsCompiled ?
                "Your modules have been updated. Currently, you must recompile " this.appName . " yourself for the changes to take effect. Would you like to exit now (highly recommended)?" :
                "Your modules have been updated, and " this.appName . " must be restarted for the changes to take effect. Would you like to restart now?"

            response := this.app.Service("GuiManager").Dialog("DialogBox", "Module Includes Updated", message)
        
            if (response == "Yes") {
                if (A_IsCompiled) {
                    this.ExitApp()
                } else {
                    this.RestartApp()
                }
            }
        }

        this.Service("ModuleManager").LoadComponents()
    }

    InitializeTheme() {
        this.Service("Gdip")
        guiManagerObj := this.Service("GuiManager")
        themeManagerObj := this.Service("ThemeManager")

        if (guiManagerObj and themeManagerObj) {
            this.themeReady := true
        }
    }

    InitializeApp(config) {
        A_AllowMainWindow := false

        if (this.customTrayMenu) {
            A_TrayMenu.Delete()
            this.Service("EventManager").Register(Events.AHK_NOTIFYICON, "TrayClick", ObjBindMethod(this, "OnTrayIconRightClick"), 1)
        }
    }

    RunApp(config) {
        if (this.Config["check_updates_on_start"]) {
            this.CheckForUpdates(false)
        }

        if (!FileExist(this.Parameter("config_path"))) {
            this.InitialSetup(config)
        }
    }

    OpenApp() {
        if (this.mainWindowKey) {
            if (this.Service("GuiManager").WindowExists(this.mainWindowKey)) {
                WinActivate("ahk_id " . this.Service("GuiManager").GetWindow("MainWindow").GetHwnd())
            } else {
                this.Service("GuiManager").OpenWindow(this.mainWindowKey)
            }
        }
    }

    ExitApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("EventManager").DispatchEvent(Events.APP_SHUTDOWN, event)

        if (this.Services.Has("Gdip")) {
            Gdip_Shutdown(this.Services.Get("Gdip").GetHandle())
        }

        ExitApp
    }

    RestartApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("EventManager").DispatchEvent(Events.APP_RESTART, event)

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

    GetDefaultModules(config) {
        modules := Map()
        modules["Auth"] := "Auth"
        return modules
    }

    Service(name) {
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
            if (this.Services.Has("GuiManager") && this.themeReady) {
                btns := allowContinue ? "*&Continue|&Reload|&Exit" : "*&Reload|&Exit"
                this.Service("GuiManager").Dialog("ErrorDialog", err, "Unhandled Exception", errorText, "", "", btns)
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

        result := this.Service("GuiManager").Menu("MenuGui", menuItems, this)
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
