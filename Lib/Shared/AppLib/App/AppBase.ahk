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
        get => this.Services.Get("Config")
        set => this.Services.Set("Config", value)
    }

    State {
        get => this.Services.Get("State")
        set => this.Services.Set("State", value)
    }

    Logger {
        get => this.Services.Get("Logger")
        set => this.Services.Set("Logger", value)
    }

    Debugger {
        get => this.Services.Get("Debugger")
        set => this.Services.Set("Debugger", value)
    }

    __New(config := "") {
        AppBase.Instance := this

        if (config && config.Has("console") && config["console"]) {
            this.AllocConsole()
        }

        if (config && config.Has("trayIcon") && config["trayIcon"]) {
            TraySetIcon(config["trayIcon"])
        }
        
        this.Startup(config)
        
        event := AppRunEvent(Events.APP_POST_STARTUP, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_POST_STARTUP, event)

        event := AppRunEvent(Events.APP_PRE_INITIALIZE, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_PRE_INITIALIZE, event)

        this.InitializeApp(config)

        event := AppRunEvent(Events.APP_POST_INITIALIZE, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_POST_INITIALIZE, event)

        event := AppRunEvent(Events.APP_PRE_RUN, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_PRE_RUN, event)

        this.RunApp(config)

        event := AppRunEvent(Events.APP_POST_RUN, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_POST_RUN, event)
    }

    AllocConsole() {
        DllCall("AllocConsole")

        if (WinExist("ahk_id " . DllCall("GetConsoleWindow", "ptr"))) {
            WinHide()
        }
    }

    Startup(config) {
        global appVersion

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
            config["version"] := appVersion
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

        coreServices := this.GetCoreServiceDefinitions(config)
        parameters := this.GetParameterDefinitions(config)
        this.Services := ServiceContainer(coreServices, parameters)

        this.Service("Shell")
        this.Service("ModuleManager")

        services := this.GetServiceDefinitions(config)

        event := ServiceDefinitionsEvent(Events.APP_SERVICE_DEFINITIONS, services, config)
        this.Service("EventManager").DispatchEvent(Events.APP_SERVICE_DEFINITIONS, event)
        services := event.Services

        event := ServiceDefinitionsEvent(Events.APP_SERVICE_DEFINITIONS_ALTER, services, config)
        this.Service("EventManager").DispatchEvent(Events.APP_SERVICE_DEFINITIONS_ALTER, event)
        services := event.Services

        this.Services.AddDefinitions(services)

        this.InitializeTheme()

        this.errorCallback := ObjBindMethod(this, "OnException")
        OnError(this.errorCallback)
    }

    GetParameterDefinitions(config) {
        parameters := config.Has("parameters") ? config["parameters"] : Map()

        if (!parameters.Has("config_path") || !parameters["config_path"]) {
            parameters["config_path"] := this.appDir . "\" . this.appName . ".ini"
        }

        if (!parameters.Has("state_path") || !parameters["state_path"]) {
            parameters["state_path"] := this.dataDir . "\" . this.appName . "State.json"
        }

        return parameters
    }

    /*
    Core services are required for basic things such as events and modules to work, so they load earlier.
    */
    GetCoreServiceDefinitions(config) {
        services := (config.Has("coreServices") && config["coreServices"]) ? config["coreServices"] : Map()

        if ((!services.Has("Shell") || !services["Shell"]) && (!config.Has("useShell") || config["useShell"])) {
            shell := Map()

            if (config.Has("shell") && config["shell"]) {
                shell["service"] := config["shell"]
            } else {
                shell["com"] := "WScript.Shell"
            }

            shell["props"] := Map("CurrentDirectory", this.appDir)
            services["Shell"] := shell
        }

        if (!services.Has("Config") || !services["Config"]) {
            services["Config"] := Map(
                "class", "AppConfig",
                "arguments", [AppRef(), ParameterRef("config_path")]
            )
        }

        if (!services.Has("State") || !services["State"]) {
            services["State"] := Map(
                "class", "AppState",
                "arguments", [AppRef(), ParameterRef("state_path")]
            )
        }

        if (!services.Has("EventManager") || !services["EventManager"]) {
            services["EventManager"] := Map(
                "class", "EventManager"
            )
        }

        if (!services.Has("IdGenerator") || !services["IdGenerator"]) {
            services["IdGenerator"] := "UuidGenerator"
        }

        if (!services.Has("ModuleManager") || !services["ModuleManager"]) {
            moduleConfigPath := this.dataDir . "\Modules.json"
            moduleDirs := config.Has("moduleDirs") ? config["moduleDirs"] : []

            services["ModuleManager"] := Map(
                "class", "ModuleManager", 
                "arguments", [
                    AppRef(), 
                    ServiceRef("EventManager"), 
                    ServiceRef("IdGenerator"), 
                    this.dataDir . "/Modules.json", 
                    moduleConfigPath, 
                    moduleDirs, 
                    this.GetDefaultModules(config)
                ]
            )
        }

        return services
    }

    ; TODO: Rewrite core services as several layers of JSON files that merge together
    GetServiceDefinitions(config) {
        services := (config.Has("services") && config["services"]) ? config["services"] : Map()

        if (!services.Has("Gdip") || !services["Gdip"]) {
            services["Gdip"] := "Gdip"
        }

        if (!services.Has("Debugger") || !services["Debugger"]) {
            calls := [
                Map("method", "SetLogger", "arguments", [ServiceRef("Logger")])
            ]

            services["Debugger"] := Map(
                "class", "Debugger", 
                "calls", calls
            )
        }

        if (!services.Has("VersionChecker") || !services["VersionChecker"]) {
            services["VersionChecker"] := "VersionChecker"
        }

        if (!services.Has("logger.file") || !services["logger.file"]) {
            logPath := this.dataDir . "\" . this.appName . "Log.txt"

            if (config.Has("logPath") && config["logPath"]) {
                logPath := config["logPath"]
            }

            loggingLevel := this.Config.HasProp("LoggingLevel") ? this.Config.LoggingLevel : "error"

            if (config.Has("loggingLevel") && config["loggingLevel"]) {
                loggingLevel := config["loggingLevel"]
            }

            services["logger.file"] := Map(
                "class", "FileLogger", 
                "arguments", [logPath, loggingLevel, true]
            )
        }

        if (!services.Has("Logger") || !services["Logger"]) {
            services["Logger"] := Map(
                "class", "LoggerService", 
                "arguments", [ServiceRef("logger.file")]
            )
        }

        if (!services.Has("CacheManager") || !services["CacheManager"]) {
            cacheDir := this.tmpDir . "\Cache"

            if (this.Config.HasProp("CacheDir") && this.Config.CacheDir) {
                cacheDir := this.Config.CacheDir
            }

            services["CacheManager"] := Map(
                "class", "CacheManager", 
                "arguments", [AppRef(), cacheDir, this.GetCaches()]
            )
        }

        if (!services.Has("ThemeManager") || !services["ThemeManager"]) {
            themesDir := this.appDir . "\Resources\Themes"

            if (config.Has("themesDir") && config["themesDir"]) {
                themesDir := config["themesDir"]
            }

            resourcesDir := this.appDir . "\Resources"

            if (config.Has("resourcesDir") && config["resourcesDir"]) {
                resourcesDir := config["resourcesDir"]
            }

            defaultTheme := ""
            
            if (config.Has("themeName") && config["themeName"]) {
                defaultTheme := config["themeName"]
            }

            services["ThemeManager"] := Map(
                "class", "ThemeManager",
                "arguments", [ServiceRef("EventManager"), this.Config, ServiceRef("IdGenerator"), ServiceRef("Logger"), themesDir, resourcesDir, defaultTheme]
            )
        }

        if (!services.Has("notifier.toast") || !services["notifier.toast"]) {
            services["notifier.toast"] := Map(
                "class", "ToastNotifier",
                "arguments", [AppRef()]
            )
        }

        if (!services.Has("Notifier") || !services["Notifier"]) {
            services["Notifier"] := Map(
                "class", "NotificationService",
                "arguments", [AppRef(), ServiceRef("notifier.toast")]
            )
        }

        if (!services.Has("GuiManager") || !services["GuiManager"]) {
            services["GuiManager"] := Map(
                "class", "GuiManager",
                "arguments", [AppRef(), ServiceRef("ThemeManager"), ServiceRef("IdGenerator"), this.State]
            )
        }

        if (!services.Has("InstallerManager") || !services["InstallerManager"]) {
            services["InstallerManager"] := Map(
                "class", "InstallerManager",
                "arguments", [AppRef()]
            )
        }

        if (!services.Has("EntityFactory") || !services["EntityFactory"]) {
            services["EntityFactory"] := Map(
                "class", "EntityFactory",
                "arguments", [ContainerRef()]
            )
        }

        return services
    }

    InitializeTheme() {
        this.Service("Gdip")
        guiManagerObj := this.Service("GuiManager")
        themeManagerObj := this.Service("ThemeManager")

        if (guiManagerObj and themeManagerObj) {
            this.themeReady := true
        }
    }

    GetDefaultModules(config) {
        modules := Map()
        modules["Auth"] := "Auth"
        return modules
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

    GetCaches() {
        return Map()
    }

    Service(name) {
        return this.Services.Get(name)
    }

    OnException(e, mode) {
        extra := (e.HasProp("Extra") && e.Extra != "") ? "`n`nExtra information:`n" . e.Extra : ""
        occurredIn := e.What ? " in " . e.What : ""
        developer := this.developer ? this.developer : "the developer(s)"

        errorText := this.appName . " has experienced an unhandled exception. You can find the details below."
        errorText .= "`n`n" . e.Message . extra
        errorText .= "`n`nOccurred in: " . e.What
        
        if (e.File) {
            errorText .= "`nFile: " . e.File . " (Line " . e.Line . ")"
        }

        if (this.Services.Has("Logger")) {
            this.Logger.Error(errorText)
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
        } catch Error as ex {
            this.ShowUnthemedError(title, errorText, err, ex, allowContinue)
        }

        return allowContinue ? -1 : 1
    }

    ShowUnthemedError(title, errorText, err, displayErr := "", allowContinue := true) {
        otherErrorInfo := (displayErr && err != displayErr) ? "`n`nThe application could not show the usual error dialog because of another error:`n`n" . displayErr.File . ": " . displayErr.Line . ": " . displayErr.What . ": " . displayErr.Message : ""
        MsgBox(errorText . otherErrorInfo, "Error")
    }

    InitializeApp(config) {
        A_AllowMainWindow := false

        if (this.customTrayMenu) {
            A_TrayMenu.Delete()
            this.Service("EventManager").Register(Events.AHK_NOTIFYICON, "TrayClick", ObjBindMethod(this, "OnTrayIconRightClick"), 1)
        }
    }

    RunApp(config) {
        if (this.Config.HasProp("CheckUpdatesOnStart") && this.Config.CheckUpdatesOnStart) {
            this.CheckForUpdates(false)
        }

        if (!FileExist(this.Config.ConfigPath)) {
            this.InitialSetup(config)
        }
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
        ; Optional method to override
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

    OpenApp() {
        if (this.mainWindowKey) {
            if (this.Service("GuiManager").WindowExists(this.mainWindowKey)) {
                WinActivate("ahk_id " . this.Service("GuiManager").GetWindow("MainWindow").GetHwnd())
            } else {
                this.Service("GuiManager").OpenWindow(this.mainWindowKey)
            }
        }
    }

    __Delete() {
        this.ExitApp()
        super.__Delete()
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
}
