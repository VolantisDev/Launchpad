class ManagedGameEntity extends ManagedEntityBase {
    configPrefix := "Game"
    defaultType := "Default"
    defaultClass := "SimpleGame"
    dataSourcePath := "game-types"

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        definitions["HasLoadingWindow"] := Map(
            "type", "boolean",
            "description", "Whether or not the game has a loading window to watch for.",
            "storageKey", this.configPrefix . "HasLoadingWindow",
            "default", false
        )

        ; - "Exe" (Waits for the game's .exe process to start if it hasn't already, and then waits for it to stop again. This is the default if the game type is not RunWait)
        ; - "Title" (Waits for the game's window title to open if it isn't already, and then waits for it to close again)
        ; - "Class" (Wait's for the game's window class to open if it isn't already, and then waits for it to close again)
        definitions["LoadingWindowProcessType"] := Map(
            "description", "Which method to use to wait for the game's loading window to open.",
            "help", "This lets Launchpad know when the game is loading. Only used if a LoadingWindowProcessId is set",
            "storageKey", this.configPrefix . "LoadingWindowProcessType",
            "default", "Exe",
            "widget", "select",
            "selectOptionsCallback", ObjBindMethod(this, "ListProcessTypes")
        )

        ; - Exe - This value will default to the GameExe unless overridden
        ; - Title - This value will default to the game's Key unless overridden
        ; - Class - This value should be set to the game's window class
        definitions["LoadingWindowProcessId"] := Map(
            "storageKey", this.configPrefix . "LoadingWindowProcessId",
            "help", "This value's type is dependent on the GameProcessType above. It can often be detected from other values, and is not needed if the GameRunType is RunWait."
        )

        return definitions
    }

    GetBlizzardProductKey() {
        productKey := this["LauncherSpecificId"]

        if (this.HasConfigValue("BlizzardProductId", true, false)) {
            productKey := this.GetConfigValue("BlizzardProductId")
        }

        return productKey
    }

    ShouldDetectShortcutSrc(extraConfig) {
        detectShortcut := false

        shortcutSrc := this["ShortcutSrc"]

        if (extraConfig != "" && extraConfig.Has("GameShortcutSrc")) {
            shortcutSrc := extraConfig["GameShortcutSrc"]
        }

        usesShortcut := this["UsesShortcut"]

        if (extraConfig != "" && extraConfig.Has("GameUsesShortcut")) {
            usesShortcut := extraConfig["GameUsesShortcut"]
        }

        if (!shortcutSrc && usesShortcut) {
            runType := this["RunType"]

            if (extraConfig != "" && extraConfig.Has("GameRunType")) {
                runType := extraConfig["GameRunType"]
            }

            detectShortcut := (this["RunType"] == "Shortcut" or this["RunType"] == "")
        }

        return detectShortcut
    }

    AutoDetectValues() {
        detectedValues := super.AutoDetectValues()
        exeKey := this.configPrefix . "Exe"

        if (!detectedValues.Has(exeKey)) {
            detectedValues[exeKey] := this["Exe"] ? this["Exe"] : this.Id . ".exe"
        }

        if (!detectedValues.Has(this.configPrefix . "ProcessId") || !detectedValues[this.configPrefix . "ProcessId"]) {
            detectedValues[this.configPrefix . "ProcessId"] := detectedValues[exeKey]
        }

        if (detectedValues.Has(this.configPrefix . "ProcessType")) {
            detectedValues[this.configPrefix . "LoadingWindowProcessType"] := detectedValues[this.configPrefix . "ProcessType"]
        }

        if (!this["LoadingWindowProcessId"]) {
            detectedValues[this.configPrefix . "LoadingWindowProcessId"] := detectedValues[exeKey]
        }

        if (this.ShouldDetectShortcutSrc(detectedValues)) {
            basePath := this["AssetsDir"] . "\" . this.Id
            shortcutSrc := ""         

            if (FileExist(basePath . ".lnk")) {
                shortcutSrc := basePath . ".lnk"
            } else if (FileExist(basePath . ".url")) {
                shortcutSrc := basePath . ".url"
            } else if (this["Exe"] != "") {
                shortcutSrc := this.LocateExe()
            }

            if (shortcutSrc != "") {
                detectedValues[this.configPrefix . "ShortcutSrc"] := shortcutSrc
            }
        }

        detectedValues["WindowTitle"] := this.Id

        return detectedValues
    }
}
