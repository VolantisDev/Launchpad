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
        services["EventManager"] := EventManager.new()
        this.Services := ServiceContainer.new(services)
        
        this.errorCallback := ObjBindMethod(this, "OnException")
        OnError(this.errorCallback)

        this.InitializeApp(config)
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

    VersionIsOutdated(latestVersion, installedVersion) {
        splitLatestVersion := StrSplit(latestVersion, ".")
        splitInstalledVersion := StrSplit(installedVersion, ".")

        for (index, numPart in splitInstalledVersion) {
            latestVersionPart := splitLatestVersion.Has(index) ? splitLatestVersion[index] : 0

            if ((latestVersionPart + 0) > (numPart + 0)) {
                return true
            } else if ((latestVersionPart + 0) < (numPart + 0)) {
                return false
            } 
        }

        return false
    }

    OnException(e, mode) {
        extra := (e.HasProp("Extra") && e.Extra != "") ? "`n`nExtra information:`n" . e.Extra : ""
        occurredIn := e.What ? " in " . e.What : ""
        developer := this.developer ? this.developer : "the developer(s)"

        errorText := this.appName . " has experienced an unhandled exception. You can find the details below, and submit the error to " . developer . " to be fixed."
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
            result := "Exit Launchpad"

            if (this.GuiManager) {
                btns := allowContinue ? "*&Continue|&Exit " . this.appName : "*&Exit " . this.appName
                result := this.GuiManager.Dialog("ErrorDialog", err, "Unhandled Exception", errorText, "", "", btns)
            } else {
                ; @todo No GUI manager... what now?
            }

            if (result == "Exit Launchpad") {
                ExitApp
            }
        } catch (ex) {
            MsgBox("Launchpad had an error, and could not show the usual error dialog because of another error:`n`n" . ex.File . ": " . ex.Line . ": " . ex.What . ": " . ex.Message . "`n`nThe original error will follow in another message.")
            MsgBox(err.File . ": " . err.Line . ": " . err.What . ": " . err.Message)
        }

        return allowContinue ? -1 : 1
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

        this.Services.Set("ThemeManager", ThemeManager.new(this, themesDir, resourcesDir, this.Events, this.IdGen))
        this.Services.Set("NotificationService", NotificationService.new(this, ToastNotifier.new(this)))
        this.Services.Set("GuiManager", GuiManager.new(this))
        this.Services.Set("InstallerManager", InstallerManager.new(this))
    }

    ExitApp() {
        ExitApp
    }
}
