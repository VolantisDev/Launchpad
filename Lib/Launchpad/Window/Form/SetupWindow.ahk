class SetupWindow extends FormGuiBase {
    availableThemes := Map()

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        super.__New(app, themeObj, windowKey, "Setup", this.GetTextDefinition(), owner, parent, "*&Start|&Exit")
    }

    Create() {
        super.Create()
        this.availableThemes := this.app.Themes.GetAvailableThemes(true)
    }

    GetTextDefinition() {
        return "
        (
        Welcome to Launchpad, your game launching multitool!

        This setup screen will help get you up and running quickly. You can always change your settings later.
        )"
    }

    AddDescription(text) {
        return this.guiObj.AddText("w" . this.windowSettings["contentWidth"], text)
    }

    Controls() {
        super.Controls()

        this.AddHeading("Theme")
        this.AddDescription(this.app.appName . " has a growing number of themes available to fit in with the platform or aesthetic of your choice. Choose the primary theme for La" . this.app.appName . "unchpad to use below.")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config.ThemeName)
        ctl := this.guiObj.AddDDL("vThemeName xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for " . this.app.appName . " to use."

        this.AddConfigLocationBlock("Launcher Directory", "DestinationDir", "", this.app.appName . " will create a separate .exe file for every game you configure. You can store these launchers in any folder you wish.")

        this.AddHeading("Platforms")
        this.AddDescription(this.app.appName . " has detected the following game platforms on your computer. Check the ones you wish " . this.app.appName . " to detect your installed games from.")
        this.AddPlatformCheckboxes()

        this.AddHeading("Detect Games")
        this.AddDescription(this.app.appName . " can detect your installed games automatically right away, or you can do it later from the Tools menu.")
        this.AddCheckBox("Detect my games now", "DetectGames", true, false)

        closeW := 100
        closeX := this.margin + (this.windowSettings["contentWidth"] / 2) - (closeW / 2)
    }

    AddConfigLocationBlock(heading, settingName, extraButton := "", helpText := "") {
        location := this.app.Config.%settingName% ? this.app.Config.%settingName% : "Not selected"
        this.Add("LocationBlock", "", heading, settingName, location, extraButton, true, helpText)
    }

    AddPlatformCheckboxes() {
        if (!this.app.Platforms._componentsLoaded) {
            this.app.Platforms.LoadComponents()
        }

        for key, platform in this.app.Platforms.Entities {
            if (platform.IsInstalled) {
                 this.AddCheckBox(platform.GetDisplayName(), "PlatformToggle" . key, platform.DetectGames, false, "OnPlatformToggle")
            }
        }
    }

    OnPlatformToggle(chk, info) {
        this.guiObj.Submit(false)
        len := StrLen("PlatformToggle")
        name := SubStr(chk.Name, len + 1)

        if (this.app.Platforms.Entities.Has(name)) {
            platform := this.app.Platforms.Entities[name]
            platform.DetectGames := !!(chk.Value)
            platform.SaveModifiedData()
        }
    }

    SetText(ctlName, ctlText, fontStyle := "") {
        this.guiObj.SetFont(fontStyle)
        this.guiObj[ctlName].Text := ctlText
        this.SetFont()
    }

    OnCloseButton(btn, info) {
        this.Close()
    }

    OnDestinationDirMenuClick(btn) {
        if (btn == "ChangeDestinationDir") {
            this.app.Config.ChangeDestinationDir()
            this.SetText("DestinationDir", this.app.Config.DestinationDir, "Bold")
        } else if (btn == "OpenDestinationDir") {
            this.app.Config.OpenDestinationDir()
        }
    }

    OnThemeNameChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.ThemeName := this.availableThemes[ctl.Value]
        this.app.Themes.LoadMainTheme()
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Start") {
            this.app.Platforms.SaveModifiedEntities()

            if (!FileExist(this.app.appDir . "\" . this.app.appName . ".ini")) {
                FileAppend("", this.app.appDir . "\" . this.app.appName . ".ini")
            }

            if (this.guiObj["DetectGames"].Value) {
                result := "Detect"
            }
        }

        if (result == "Exit") {
            this.app.ExitApp()
        }

        return result
    }
}
