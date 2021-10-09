class ManagedGameEntity extends ManagedEntityBase {
    configPrefix := "Game"
    defaultType := "Default"
    defaultClass := "SimpleGame"
    dataSourcePath := "game-types"

    ; Whether or not the game has a loading window to watch for.
    HasLoadingWindow {
        get => this.GetConfigValue("HasLoadingWindow")
        set => this.SetConfigValue("HasLoadingWindow", value)
    }

    ; Which method to use to wait for the game's loading window to open, if the LoadingWindowProcessId is set. This lets Launchpad know when the game is loading.
    ; - "Exe" (Waits for the game's .exe process to start if it hasn't already, and then waits for it to stop again. This is the default if the game type is not RunWait)
    ; - "Title" (Waits for the game's window title to open if it isn't already, and then waits for it to close again)
    ; - "Class" (Wait's for the game's window class to open if it isn't already, and then waits for it to close again)
    LoadingWindowProcessType {
        get => this.GetConfigValue("LoadingWindowProcessType")
        set => this.SetConfigValue("LoadingWindowProcessType", value)
    }

    ; This value's type is dependent on the GameProcessType above. It can often be detected from other values, and is not needed if the GameRunType is RunWait.
    ; - Exe - This value will default to the GameExe unless overridden
    ; - Title - This value will default to the game's Key unless overridden
    ; - Class - This value should be set to the game's window class
    LoadingWindowProcessId {
        get => this.GetConfigValue("LoadingWindowProcessId")
        set => this.SetConfigValue("LoadingWindowProcessId", value)
    }

    GetBlizzardProductKey() {
        productKey := this.LauncherSpecificId

        if (this.HasConfigValue("BlizzardProductId", true, false)) {
            productKey := this.GetConfigValue("BlizzardProductId")
        }

        return productKey
    }

    ShouldDetectShortcutSrc(extraConfig) {
        detectShortcut := false

        shortcutSrc := this.ShortcutSrc

        if (extraConfig != "" && extraConfig.Has("GameShortcutSrc")) {
            shortcutSrc := extraConfig["GameShortcutSrc"]
        }

        usesShortcut := this.UsesShortcut

        if (extraConfig != "" && extraConfig.Has("GameUsesShortcut")) {
            usesShortcut := extraConfig["GameUsesShortcut"]
        }

        if (!shortcutSrc && usesShortcut) {
            runType := this.RunType

            if (extraConfig != "" && extraConfig.Has("GameRunType")) {
                runType := extraConfig["GameRunType"]
            }

            detectShortcut := (this.RunType == "Shortcut" or this.RunCmd == "")
        }

        return detectShortcut
    }

    InitializeDefaults() {
        defaults := super.InitializeDefaults()
        defaults[this.configPrefix . "HasLoadingWindow"] := false
        defaults[this.configPrefix . "LoadingWindowProcessType"] := "Exe"
        defaults[this.configPrefix . "LoadingWindowProcessId"] := ""
        return defaults
    }

    AutoDetectValues() {
        detectedValues := super.AutoDetectValues()
        exeKey := this.configPrefix . "Exe"

        if (!detectedValues.Has(exeKey)) {
            detectedValues[exeKey] := this.Exe ? this.Exe : this.Key . ".exe"
        }

        if (!detectedValues.Has(this.configPrefix . "ProcessId") || !detectedValues[this.configPrefix . "ProcessId"]) {
            detectedValues[this.configPrefix . "ProcessId"] := detectedValues[exeKey]
        }

        if (detectedValues.Has(this.configPrefix . "ProcessType")) {
            detectedValues[this.configPrefix . "LoadingWindowProcessType"] := detectedValues[this.configPrefix . "ProcessType"]
        }

        if (!this.LoadingWindowProcessId) {
            detectedValues[this.configPrefix . "LoadingWindowProcessId"] := detectedValues[exeKey]
        }

        if (this.ShouldDetectShortcutSrc(detectedValues)) {
            basePath := this.AssetsDir . "\" . this.Key
            shortcutSrc := ""         

            if (FileExist(basePath . ".lnk")) {
                shortcutSrc := basePath . ".lnk"
            } else if (FileExist(basePath . ".url")) {
                shortcutSrc := basePath . ".url"
            } else if (this.Exe != "") {
                shortcutSrc := this.LocateExe()
            }

            if (shortcutSrc != "") {
                detectedValues[this.configPrefix . "ShortcutSrc"] := shortcutSrc
            }
        }

        detectedValues["WindowTitle"] := this.keyVal

        return detectedValues
    }

    LaunchEditWindow(mode, owner := "", parent := "") {
        return this.app.Service("GuiManager").Dialog("ManagedGameEditor", this, mode, owner, parent)
    }
}
