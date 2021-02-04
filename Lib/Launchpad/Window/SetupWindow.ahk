class SetupWindow extends LaunchpadFormGuiBase {
    availableThemes := Map()

    __New(app, windowKey := "", owner := "", parent := "") {
        super.__New(app, "Setup", this.GetTextDefinition(), windowKey, owner, parent, "*&Start|&Exit")
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
        this.AddDescription("Launchpad has a growing number of themes available to fit in with the platform or aesthetic of your choice. Choose your main theme below. You can also choose a unique theme for each launcher later.")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config.ThemeName)
        ctl := this.guiObj.AddDDL("vThemeName xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for Launchpad to use."

        this.AddHeading("Launcher Directory")
        this.AddDescription("Launchpad will create a separate .exe file for every game you configure.`n`nYou can store your launchers in any folder you wish, and you can change this setting at any time.")
        this.AddConfigLocationBlock("DestinationDir")

        this.AddHeading("Platforms")
        this.AddDescription("Launchpad has detected the following game platforms on your computer. Check the ones you wish to enable Launchpad to detect your games from.`n`nThis can be changed from the Platforms window later.")
        this.AddPlatformCheckboxes()

        this.AddHeading("Detect Games")
        this.AddDescription("Launchpad can detect your installed games from your selected platforms automatically. You can do this at any time from the 'Detect Games' option in the Tools menu.")
        this.AddCheckBox("Detect my games now", "DetectGames", true, false)

        closeW := 100
        closeX := this.margin + (this.windowSettings["contentWidth"] / 2) - (closeW / 2)
    }

    AddConfigLocationBlock(settingName, extraButton := "", inGroupBox := false) {
        location := this.app.Config.%settingName% ? this.app.Config.%settingName% : "Not selected"

        this.AddLocationText(location, settingName, inGroupBox)

        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        buttonH := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : 20

        position := inGroupBox ? "xs+" . this.margin . " y+m" : "xs y+m"
        btn := this.AddButton(position . " w" . buttonW . " h" . buttonH . " vChange" . settingName, "Change")
        btn := this.AddButton("x+m yp w" . buttonW . " h" . buttonH . " vOpen" . settingName, "Open")

        if (extraButton != "") {
            btn := this.AddButton("x+m yp w" . buttonW . " h" . buttonH . " v" . extraButton . settingName, extraButton)
        }
    }

    AddLocationText(locationText, ctlName, inGroupBox := true) {
        position := "xs"

        if (inGroupBox) {
            position .= "+" . this.margin
        }

        position .= " y+m"

        this.SetFont("", "Bold")
        ctl := this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.windowSettings["contentWidth"] . " +0x200 +0x100 c" . this.themeObj.GetColor("linkText"), locationText)
        ctl.ToolTip := locationText
        this.SetFont()
    }

    AddPlatformCheckboxes() {
        if (!this.app.Platforms._componentsLoaded) {
            this.app.Platforms.LoadComponents()
        }

        for key, platform in this.app.Platforms.Entities {
            if (platform.IsInstalled) {
                 this.AddCheckBox(platform.GetDisplayName(), "PlatformToggle" . key, platform.IsEnabled, false, "OnPlatformToggle")
            }
        }
    }

    OnPlatformToggle(chk, info) {
        this.guiObj.Submit(false)
        len := StrLen("PlatformToggle")
        name := SubStr(chk.Name, len + 1)

        if (this.app.Platforms.Entities.Has(name)) {
            platform := this.app.Platforms.Entities[name]
            platform.IsEnabled := !!(chk.Value)
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

    OnOpenDestinationDir(btn, info) {
        this.app.Config.OpenDestinationDir()
    }

    OnChangeDestinationDir(btn, info) {
        this.app.Config.ChangeDestinationDir()
        this.SetText("DestinationDir", this.app.Config.DestinationDir, "Bold")
    }

    OnThemeNameChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.ThemeName := this.availableThemes[ctl.Value]
        this.app.Themes.LoadMainTheme()
    }

    ProcessResult(result) {
        if (result == "Start") {
            this.app.Platforms.SaveModifiedEntities()

            if (!FileExist(A_ScriptDir . "\Launchpad.ini")) {
                FileAppend("", A_ScriptDir . "\Launchpad.ini")
            }

            if (this.guiObj["DetectGames"].Value) {
                result := "Detect"
            }
        }

        return result
    }
}
