class ImportShortcutForm extends LauncherCreateFormBase {
    shortcutSrc := ""
    gameKey := ""
    shortcutExt := ""
    defaultPlatform := ""

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        this.AskShortcutSrc()
        super.__New(app, themeObj, windowKey, "Import Shortcut", owner, parent)
    }

    GetTextDefinition() {
        return "Select an existing shortcut and platform, and Launchpad will create a launcher for your game. You can modify or add the launcher details after it's added."
    }

    Controls() {
        super.Controls()
        this.Add("LocationBlock", "", "Shortcut", this.shortcutSrc, "ShortcutSrc", "", true, "Select the shortcut file that launches the game")
        this.Add("SelectControl", "", "Platform", "", this.knownPlatforms, this.defaultPlatform, "Select the platform that this game is run through.")
    }

    GetLauncherKey() {
        return this.gameKey
    }

    GetLauncherConfig() {
        platformKey := Trim(this.guiObj["Platform"].Text)
        config := Map("Platform", platformKey)
        platform := this.app.Service("PlatformManager").GetItem(platformKey)

        if (platform) {
            config["LauncherType"] := platform.platform.launcherType
            config["GameType"] := platform.platform.gameType
        }

        lowerExt := StrLower(this.shortcutExt)

        if (lowerExt == "lnk") {
            FileGetShortcut(this.shortcutSrc, target, dir, args,, iconSrc, iconNum)
            runCmd := target

            if (args) {
                runCmd := '"' . runCmd . '" ' . args
            }

            config["GameExe"] := target
            config["GameRunCmd"] := runCmd
            config["GameInstallDir"] := dir
            config["IconSrc"] := iconSrc
        } else if (lowerExt == "url") {
            url := IniRead(this.shortcutSrc, "InternetShortcut", "URL")

            if (url) {
                config["GameRunCmd"] := url
            }
        }

        return config
    }

    AskShortcutSrc() {
        existingVal := this.shortcutSrc

        if (!existingVal) {
            existingVal := A_Desktop
        }

        selectedFile := FileSelect(33, existingVal, "Select Game Shortcut", "Shortcuts (*.lnk; *.url)")
        
        if (selectedFile) {
            SplitPath(selectedFile,,,shortcutExt, shortcutName)
            this.shortcutSrc := selectedFile
            this.gameKey := shortcutName
            this.shortcutExt := shortcutExt
        }
    }

    OnShortcutSrcMenuClick(btn) {
        if (btn == "ChangeShortcutSrc") {
            this.AskShortcutSrc()

            if (this.shortcutSrc) {
                this.guiObj["ShortcutSrc"].Text := this.shortcutSrc
            }
        } else if (btn == "OpenShortcutSrc") {
            if (this.shortcutSrc) {
                Run(this.shortcutSrc)
            }
        } else if (btn == "ClearShortcutSrc") {
            this.shortcutSrc := ""
            this.guiObj["ShortcutSrc"].Text := ""
        }
    }
}
