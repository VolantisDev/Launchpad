class SetupWindow extends FormGuiBase {
    availableThemes := Map()

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Setup"
        defaults["buttons"] := "*&Start|&Exit"
        defaults["text"] := "
        (
        Welcome to Launchpad, the game launching multitool!

        This setup screen will help get you up and running quickly. You can always change your settings later.
        )"
        return defaults
    }

    Create() {
        super.Create()
        this.availableThemes := this.app.Service("manager.theme").GetAvailableThemes()
    }

    AddDescription(text) {
        return this.guiObj.AddText("w" . this.windowSettings["contentWidth"], text)
    }

    Controls() {
        super.Controls()

        this.AddHeading("Theme")
        this.AddDescription(this.app.appName . " has a growing number of themes available to fit in with the platform or aesthetic of your choice. Choose the primary theme for La" . this.app.appName . "unchpad to use below.")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config["theme_name"])
        ctl := this.guiObj.AddDDL("vtheme_name xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for " . this.app.appName . " to use."

        this.AddConfigLocationBlock("Launcher Directory", "destination_dir", "", this.app.appName . " will create a separate .exe file for every game you configure. You can store these launchers in any folder you wish.")

        this.AddHeading("Platforms")
        this.AddDescription(this.app.appName . " has detected the following game platforms on your computer. Check the ones you wish " . this.app.appName . " to detect your installed games from.")
        this.AddPlatformCheckboxes()

        this.AddHeading("Detect Games")
        this.AddDescription(this.app.appName . " can detect your installed games automatically right away, or you can do it later from the Tools menu.")
        this.Add("BasicControl", "vDetectGames", "", true, "CheckBox", "Detect my games now")

        closeW := 100
        closeX := this.margin + (this.windowSettings["contentWidth"] / 2) - (closeW / 2)
    }

    AddConfigLocationBlock(heading, settingName, extraButton := "", helpText := "") {
        location := this.app.Config[settingName] ? this.app.Config[settingName] : "Not selected"
        this.Add("LocationBlock", "", heading, location, settingName, extraButton, true, helpText)
    }

    AddPlatformCheckboxes() {
        platformMgr := this.app.Service("entity_manager.platform")
        platformMgr.LoadComponents(false)

        for key, platform in platformMgr {
            if (platform["IsInstalled"]) {
                ctl := this.Add("BasicControl", "vPlatformToggle" . key, "", platform["DetectGames"], "CheckBox", platform.GetName())
                ctl.RegisterHandler("Click", "OnPlatformToggle")
            }
        }
    }

    OnPlatformToggle(chk, info) {
        this.guiObj.Submit(false)
        len := StrLen("PlatformToggle")
        name := SubStr(chk.Name, len + 1)
        platformMgr := this.app.Service("entity_manager.platform")

        if (platformMgr.Has(name)) {
            platform := platformMgr[name]
            platform["DetectGames"] := !!(chk.Value)
            platform.SaveEntity()
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
            this.SetText("DestinationDir", this.app.Config["destination_dir"], "Bold")
        } else if (btn == "OpenDestinationDir") {
            this.app.Config.OpenDestinationDir()
        }
    }

    OnThemeNameChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config["theme_name"] := this.availableThemes[ctl.Value]
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Start") {
            this.app.Service("config.app").SaveConfig()
            this.app.Service("entity_manager.platform").SaveModifiedEntities()

            if (submittedData.DetectGames) {
                result := "Detect"
            }
        }

        if (result == "Exit") {
            this.app.ExitApp()
        }

        return result
    }
}
