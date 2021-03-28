/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class ImportShortcutForm extends FormGuiBase {
    knownGames := ""
    knownPlatforms := ""
    dataSource := ""
    shortcutSrc := ""
    gameKey := ""
    shortcutExt := ""

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        this.dataSource := app.DataSources.GetItem()
        this.AskShortcutSrc()
        super.__New(app, themeObj, windowKey, "Import Shortcut", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "Select an existing shortcut and platform, and Launchpad will create a launcher for your game. You can modify or add the launcher details after it's added."
    }

    GetButtonsDefinition() {
        return "*&Save|&Cancel"
    }

    Controls() {
        super.Controls()
        this.AddLocationBlock("Shortcut", "ShortcutSrc", this.shortcutSrc, "", true, "Select the shortcut file that launches the game")
        this.AddSelect("Platform", "Platform", "", this.knownPlatforms, false, "", "", "Select the platform that this game is run through.", false)
    }

    Create() {
        super.Create()
        this.knownGames := this.dataSource.ReadListing("game-keys")
        this.knownPlatforms := this.dataSource.ReadListing("platforms")
    }

    OnPlatformChange(ctlObj, info) {
        
    }

    ProcessResult(result) {
        entity := ""

        if (result == "Save" && this.shortcutSrc && this.gameKey && this.shortcutExt) {
            platformKey := Trim(this.guiObj["Platform"].Text)
            config := Map("Platform", platformKey)
            platform := this.app.Platforms.GetItem(platformKey)

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

            entity := LauncherEntity.new(this.app, this.gameKey, config)
        }

        return entity
    }

    AddLocationBlock(heading, field, location, extraButton := "", showOpen := true, helpText := "") {
        this.AddHeading(heading)
        btnWidth := 20
        btnHeight := 20
        ctl := this.AddLocationText(location, field, "xs y+m", this.windowSettings["contentWidth"] - btnWidth - (this.margin/2))

        if (helpText) {
            ctl.ToolTip := helpText
        }
    
        menuItems := []
        menuItems.Push(Map("label", "Change", "name", "Change" . field))

        if (showOpen) {
            menuItems.Push(Map("label", "Open", "name", "Open" . field))
        }

        if (extraButton) {
            menuItems.Push(Map("label", extraButton, "name", StrReplace(extraButton, " ", "") . field))
        }

        btn := this.AddButton("w" . btnWidth . " h" . btnHeight . " x+" (this.margin/2) . " yp", "arrowDown", "OnLocationOptions", "symbol")
        btn.MenuItems := menuItems
        btn.Tooltip := "Change options"
    }

    OnLocationOptions(btn, info) {
        this.app.GuiManager.Menu("MenuGui", btn.MenuItems, this, this.windowKey)
    }

    AddLocationText(locationText, ctlName, position := "xs y+m", width := "") {
        if (!width) {
            width := this.windowSettings["contentWidth"]
        }

        ;this.guiObj.SetFont("Bold")
        ctl := this.guiObj.AddText("v" . ctlName . " " . position . " w" . width . " +0x200 c" . this.themeObj.GetColor("linkText"), locationText)
        ;this.guiObj.SetFont()
        return ctl
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

    OnChangeShortcutSrc(btn, info) {
        this.AskShortcutSrc()

        if (this.shortcutSrc) {
            this.guiObj["ShortcutSrc"].Text := this.shortcutSrc
        }
    }

    OnOpenShortcutSrc(btn, info) {
        if (this.shortcutSrc) {
            Run(this.shortcutSrc)
        }
    }
}
