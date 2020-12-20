class ManagedGameEntity extends ManagedEntityBase {
    configPrefix := "Game"
    defaultType := "Default"
    defaultClass := "SimpleGame"
    dataSourcePath := "Types/Games"

    ; If the game is known to its launcher by a specific ID, it should be stored here.
    LauncherSpecificId {
        get => this.GetConfigValue("LauncherSpecificId", false)
        set => this.SetConfigValue("LauncherSpecificId", value, false)
    }

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
        return this.config.Has("GameBlizzardProductId") ? this.config["GameBlizzardProductId"] : this.LauncherSpecificId
    }

    AutoDetectValues() {
        if (this.ShouldDetectShortcutSrc()) {
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
                this.ShortcutSrc := shortcutSrc
            }
        }
    }

    ShouldDetectShortcutSrc() {
        detectShortcut := false

        if (this.ShortcutSrc == "" and this.UsesShortcut) {
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

    SetDependentValues(config) {
        exeKey := this.configPrefix . "Exe"
        if (!config.Has(exeKey) or config[exeKey] == "") {
            config[exeKey] := config[exeKey] := this.Key . ".exe"
        }

        return super.SetDependentValues(config)
    }

    LaunchEditWindow(mode, owner := "", parent := "") {
        return this.app.Windows.ManagedGameEditor(this, mode, owner, parent)
    }
}
