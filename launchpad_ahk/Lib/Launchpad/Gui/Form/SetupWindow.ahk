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
        this.availableThemes := this.app["manager.theme"].GetAvailableThemes()
    }

    AddDescription(text) {
        return this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " y+5", text)
    }

    Controls() {
        super.Controls()

        this.AddHeading("Theme")
        this.AddDescription(this.app.appName . " has a growing number of themes available to fit in with the platform or aesthetic of your choice. Choose the primary theme for " . this.app.appName . " to use.")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config["theme_name"])
        ctl := this.guiObj.AddDDL("vtheme_name xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select the primary theme for " . this.app.appName . " to use."

        this.AddHeading("Launcher Directory")
        this.AddConfigLocationBlock("", "destination_dir", "", this.app.appName . " will create a separate .exe file for every game you configure. You can store these launchers in any folder you wish.")

        this.AddHeading("Platforms")

        installedPlatforms := this.GetInstalledPlatforms()

        if (installedPlatforms.Count) {
            this.AddDescription("Your discovered game platforms are below. Check the ones you wish to allow " . this.app.appName . " to detect installed games from.")
            this.AddPlatformCheckboxes(installedPlatforms)
        } else {
            this.AddDescription(this.app.appName . " couldn't find any game platforms on your computer to detect installed games from. You can always configure them later.")
        }

        this.AddHeading("Detect Games")

        if (installedPlatforms.Count) {
            this.AddDescription(this.app.appName . " can detect your installed games automatically right now if you wish. You can also do it anytime by clicking the + icon at the bottom of the main Launchpad window.")
            this.Add("BasicControl", "vDetectGames", "", true, "CheckBox", "Detect my games now")
        } else {
            this.AddDescription(this.app.appName . " can detect your installed games automatically if you install and enable any supported game platforms, such as Steam, Epic Games, Battle.net, and more. You can find the Detect Games feature by clicking the + icon at the bottom of the Launchpad window anytime.")
        }
    }

    GetInstalledPlatforms() {
        platformMgr := this.app["entity_manager.platform"]
        platformQuery := platformMgr.EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
            .Condition(IsTrueCondition(), "IsInstalled")
        return platformQuery.Execute()
    }

    AddConfigLocationBlock(heading, settingName, extraButton := "", helpText := "") {
        location := this.app.Config[settingName] ? this.app.Config[settingName] : "Not selected"
        this.Add("LocationBlock", "", heading, location, settingName, extraButton, true, helpText)
    }

    AddPlatformCheckboxes(installedPlatforms) {
        for key, platform in installedPlatforms {
            ctl := this.Add("BasicControl", "vPlatformToggle" . key, "", platform["DetectGames"], "CheckBox", platform.GetName())
            ctl.RegisterHandler("Click", "OnPlatformToggle")
        }
    }

    OnPlatformToggle(chk, info) {
        this.guiObj.Submit(false)
        len := StrLen("PlatformToggle")
        name := SubStr(chk.Name, len + 1)
        platformMgr := this.app["entity_manager.platform"]

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
            this.app["config.app"].SaveConfig()
            this.app["entity_manager.platform"].SaveModifiedEntities()

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
