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

    Version {
        get => this.versionStr
        set => this.versionStr := value
    }

    Config {
        get => this.configObj
        set => this.configObj := value
    }

    IdGen {
        get => this.Services.Get("IdGenerator")
        set => this.Services.Set("IdGenerator", value)
    }

    Modules {
        get => this.Services.Get("ModuleManager")
        set => this.Services.Set("ModuleManager", value)
    }

    Notifications {
        get => this.Services.Get("NotificationService")
        set => this.Services.Set("NotificationService", value)
    }

    Themes {
        get => this.Services.Get("ThemeManager")
        set => this.Services.Set("ThemeManager", value)
    }

    Events {
        get => this.Services.Get("EventManager")
        set => this.Services.Set("EventManager", value)
    }

    Cache {
        get => this.Services.Get("CacheManager")
        set => this.Services.Set("CacheManager", value)
    }

    GuiManager {
        get => this.Services.Get("GuiManager")
        set => this.Services.Set("GuiManager", value)
    }

    State {
        get => this.stateObj
        set => this.stateObj := value
    }

    Installers {
        get => this.Services.Get("InstallerManager")
        set => this.Services.Set("InstallerManager", value)
    }

    Services {
        get => this.serviceContainerObj
        set => this.serviceContainerObj := value
    }

    Logger {
        get => this.Services.Get("LoggerService")
        set => this.Services.Set("LoggerService", value)
    }

    VersionChecker {
        get => this.Services.Get("VersionChecker")
        set => this.Services.Set("VersionChecker", value)
    }

    __New(config := "") {
        global appVersion

        if (!config) {
            config := Map()
        }

        if (!config.Has("appName") || !config["appName"]) {
            SplitPath(A_ScriptName,,,, appName)
            config["appName"] := appName
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

        ; @todo Create any services required for initialization
        services := Map()
        services["IdGenerator"] := UuidGenerator.new()
        services["VersionChecker"] := VersionChecker.new()
        services["EventManager"] := EventManager.new()
        this.Services := ServiceContainer.new(services)
        
        this.errorCallback := ObjBindMethod(this, "OnException")
        OnError(this.errorCallback)

        this.InitializeApp(config)
    }

    GetCaches() {
        return Map()
    }

    LoadAppConfig(config) {
        configFile := A_ScriptDir . "\" . this.appName . ".ini"

        if (config.Has("configFile") && config["configFile"]) {
            configFile := config["configFile"]
        }

        configClass := "AppConfig"

        if (config.Has("configClass") && config["configClass"]) {
            configClass := config["configClass"]
        }

        return %configClass%.new(this, configFile)
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

        return %stateClass%.new(this, stateFile)
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

        errorText .= "`n"

        return this.ShowError("Unhandled Exception", errorText, e, mode != "ExitApp")
    }

    ShowError(title, errorText, err, allowContinue := true) {
        try {
            result := "Exit"

            if (this.GuiManager) {
                btns := allowContinue ? "*&Continue|&Exit" : "*&Exit"
                result := this.GuiManager.Dialog("ErrorDialog", err, "Unhandled Exception", errorText, "", "", btns)
            } else {
                this.ShowUnthemedError(title, err.Message, err, "", allowContinue)
            }

            if (result == "Exit") {
                ExitApp
            }
        } catch (ex) {
            this.ShowUnthemedError(title, errorText, err, ex, allowContinue)
        }

        return allowContinue ? -1 : 1
    }

    ShowUnthemedError(title, errorText, err, displayErr := "", allowContinue := true) {
        otherErrorInfo := (displayErr && err != displayErr) ? "`n`nThe application could not show the usual error dialog because of another error:`n`n" . displayErr.File . ": " . displayErr.Line . ": " . displayErr.What . ": " . displayErr.Message : ""
        MsgBox(errorText . otherErrorInfo, "Error")
    }

    InitializeApp(config) {
        this.LoadServices(config)
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

        this.Services.Set("LoggerService", LoggerService.new(FileLogger.new(logPath, loggingLevel, true)))
        this.Services.Set("ModuleManager", ModuleManager.new(this))

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

        this.Services.Set("CacheManager", CacheManager.new(this, this.Config.CacheDir, this.GetCaches()))
        this.Services.Set("ThemeManager", ThemeManager.new(this, themesDir, resourcesDir, defaultTheme))
        this.Services.Set("NotificationService", NotificationService.new(this, ToastNotifier.new(this)))
        this.Services.Set("GuiManager", GuiManager.new(this))
        this.Services.Set("InstallerManager", InstallerManager.new(this))
    }

    ExitApp() {
        ExitApp
    }
}
