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

    Version {
        get => this.versionStr
        set => this.versionStr := value
    }

    Config {
        get => this.configObj
        set => this.configObj := value
    }

    State {
        get => this.stateObj
        set => this.stateObj := value
    }

    Services {
        get => this.serviceContainerObj
        set => this.serviceContainerObj := value
    }

    Logger {
        get => this.Services.Get("LoggerService")
        set => this.Services.Set("LoggerService", value)
    }

    Debugger {
        get => this.Services.Get("Debugger")
        set => this.Services.Set("Debugger", value)
    }

    __New(config := "") {
        this.Startup(config)
        event := AppRunEvent(Events.APP_POST_STARTUP, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_POST_STARTUP, event)

        event := AppRunEvent(Events.APP_PRE_LOAD_SERVICES, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_PRE_LOAD_SERVICES, event)
        this.LoadServices(config)
        event := AppRunEvent(Events.APP_POST_LOAD_SERVICES, this, config)
        this.Service("EventManager").DispatchEvent(Events.APP_POST_LOAD_SERVICES, event)

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

        this.configObj := this.LoadAppConfig(config)
        this.stateObj := this.LoadAppState(config)

        services := (config.Has("services") && config["services"]) ? config["services"] : Map()


        if (!services.Has("Shell") || !services["Shell"]) {
             shell := ""

            if (!config.Has("useShell") || config["useShell"]) {
                if (config.Has("shell") && config["shell"]) {
                    shell := config["shell"]
                } else {
                    shell := ComObject("WScript.Shell")
                }

                shell.CurrentDirectory := this.appDir
            }

            services["Shell"] := shell
        }

        if (!services.Has("Gdip") || !services["Gdip"]) {
            services["Gdip"] := Gdip_Startup()
        }

        if (!services.Has("Debugger") || !services["Debugger"]) {
            services["Debugger"] := Debugger()
        }
        
        if (!services.Has("IdGenerator") || !services["IdGenerator"]) {
            services["IdGenerator"] := UuidGenerator()
        }

        if (!services.Has("VersionChecker") || !services["VersionChecker"]) {
            services["VersionChecker"] := VersionChecker()
        }

        if (!services.Has("EventManager") || !services["EventManager"]) {
            services["EventManager"] := EventManager()
        }

        this.Services := ServiceContainer(services)
        this.Services.Set("ModuleManager", ModuleManager(this).LoadModules(config))
        this.errorCallback := ObjBindMethod(this, "OnException")
        OnError(this.errorCallback)
    }

    GetDefaultModules(config) {
        modules := Map()
        modules["Auth"] := "AuthModule"
        return modules
    }

    GetCmdOutput(command, trimOutput := true) {
        output := ""

        if (!this.Services.Exists("Shell")) {
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

    LoadAppConfig(config) {
        configFile := this.appDir . "\" . this.appName . ".ini"

        if (config.Has("configFile") && config["configFile"]) {
            configFile := config["configFile"]
        }

        configClass := "AppConfig"

        if (config.Has("configClass") && config["configClass"]) {
            configClass := config["configClass"]
        }

        return %configClass%(this, configFile)
    }

    LoadAppState(config) {
        stateFile := this.dataDir . "\" . this.appName . "State.json"

        if (config.Has("stateFile") && config["stateFile"]) {
            stateFile := config["stateFile"]
        }

        stateClass := "AppState"

        if (config.Has("stateClass") && config["stateClass"]) {
            stateClass := config["stateClass"]
        }

        return %stateClass%(this, stateFile)
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

        if (this.Services.Exists("LoggerService")) {
            this.Logger.Error(errorText)
        }
        
        errorText .= "`n"

        return this.ShowError("Unhandled Exception", errorText, e, mode != "ExitApp")
    }

    ShowError(title, errorText, err, allowContinue := true) {
        try {
            if (this.Services.Exists("GuiManager")) {
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
    
    LoadServices(config) {
        logPath := this.dataDir . "\" . this.appName . "Log.txt"

        if (config.Has("logPath") && config["logPath"]) {
            logPath := config["logPath"]
        }

        loggingLevel := this.Config.HasProp("LoggingLevel") ? this.Config.LoggingLevel : "error"

        if (config.Has("loggingLevel") && config["loggingLevel"]) {
            loggingLevel := config["loggingLevel"]
        }

        this.Services.Set("LoggerService", LoggerService(FileLogger(logPath, loggingLevel, true)))
        this.Debugger.SetLogger(this.Logger)

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

        cacheDir := this.tmpDir . "\Cache"

        if (this.Config.HasProp("CacheDir") && this.Config.CacheDir) {
            cacheDir := this.Config.CacheDir
        }

        this.Services.Set("CacheManager", CacheManager(this, cacheDir, this.GetCaches()))
        this.Services.Set("ThemeManager", ThemeManager(this, themesDir, resourcesDir, defaultTheme))
        this.Services.Set("NotificationService", NotificationService(this, ToastNotifier(this)))
        this.Services.Set("GuiManager", GuiManager(this))
        this.Services.Set("InstallerManager", InstallerManager(this))
    }

    __Delete() {
        this.ExitApp()
        super.__Delete()
    }

    ExitApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("EventManager").DispatchEvent(Events.APP_SHUTDOWN, event)

        if (this.Services.Exists("Gdip")) {
            Gdip_Shutdown(this.Services.Get("Gdip"))
        }

        ExitApp
    }

    RestartApp() {
        event := AppRunEvent(Events.APP_SHUTDOWN, this)
        this.Service("EventManager").DispatchEvent(Events.APP_RESTART, event)

        if (this.Services.Exists("Gdip")) {
            Gdip_Shutdown(this.Services.Get("Gdip"))
        }

        Reload()
    }
}
