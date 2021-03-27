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
        this.AddDescription("Launchpad has a growing number of themes available to fit in with the platform or aesthetic of your choice. Choose the primary theme for Launchpad to use below.")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config.ThemeName)
        ctl := this.guiObj.AddDDL("vThemeName xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for Launchpad to use."

        this.AddHeading("Launcher Directory")
        this.AddDescription("Launchpad will create a separate .exe file for every game you configure. You can store these launchers in any folder you wish.")
        this.AddConfigLocationBlock("DestinationDir")

        this.AddHeading("Platforms")
        this.AddDescription("Launchpad has detected the following game platforms on your computer. Check the ones you wish Launchpad to detect your installed games from.")
        this.AddPlatformCheckboxes()

        this.AddHeading("Detect Games")
        this.AddDescription("Launchpad can detect your installed games automatically right away, or you can do it later from the Tools menu.")
        this.AddCheckBox("Detect my games now", "DetectGames", true, false)

        closeW := 100
        closeX := this.margin + (this.windowSettings["contentWidth"] / 2) - (closeW / 2)
    }

    AddConfigLocationBlock(settingName, extraButton := "", inGroupBox := false, helpText := "") {
        location := this.app.Config.%settingName% ? this.app.Config.%settingName% : "Not selected"
        btnWidth := 20
        btnHeight := 20

        ctl := this.AddLocationText(location, settingName, inGroupBox, this.windowSettings["contentWidth"] - btnWidth - (this.margin/2))

        if (helpText) {
            ctl.ToolTip := helpText
        }

        menuItems := []
        menuItems.Push(Map("label", "Change", "name", "Change" . settingName))
        menuItems.Push(Map("label", "Open", "name", "Open" . settingName))

        if (extraButton) {
            menuItems.Push(Map("label", extraButton, "name", StrReplace(extraButton, " ", "") . settingName))
        }

        btn := this.AddButton("w" . btnWidth . " h" . btnHeight . " x+" (this.margin/2) . " yp", "arrowDown", "OnLocationOptions", "symbol")
        btn.MenuItems := menuItems
        btn.Tooltip := "Change options"
    }

    OnLocationOptions(btn, info) {
        this.app.GuiManager.Menu("MenuGui", btn.MenuItems, this, this.windowKey)
    }

    AddLocationText(locationText, ctlName, inGroupBox := true, width := "") {
        if (width == "") {
            width := this.windowSettings["contentWidth"]
        }

        position := "xs"

        if (inGroupBox) {
            position .= "+" . this.margin
        }

        position .= " y+m"

        this.SetFont("", "Bold")
        ctl := this.guiObj.AddText("v" . ctlName . " " . position . " w" . width . " +0x200 +0x100 c" . this.themeObj.GetColor("linkText"), locationText)
        ctl.ToolTip := locationText
        this.SetFont()
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

    OnOpenDestinationDir(btn, info) {
        if (btn.HasProp("Menu")) {
            btn.Menu.Close()
        }

        this.app.Config.OpenDestinationDir()
    }

    OnChangeDestinationDir(btn, info) {
        if (btn.HasProp("Menu")) {
            btn.Menu.Close()
        }
        
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
