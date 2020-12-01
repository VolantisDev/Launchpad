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

        if (this.ShortcutSrc == "") {
            usesShortcutIsSet := this.UnmergedConfig.Has("GameUsesShortcut")

            if (usesShortcutIsSet and this.UnmergedConfig["GameUsesShortcut"]) {
                detectShortcut := true
            }

            if (this.RunType == "Shortcut" or this.RunCmd == "") {
                detectShortcut := true
            }
        }

        return detectShortcut
    }
}
