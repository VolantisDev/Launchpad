class SetupWindow extends LaunchpadFormGuiBase {
    availableThemes := Map()

    __New(app, windowKey := "", owner := "", parent := "") {
        this.availableThemes := app.Themes.GetAvailableThemes(true)
        super.__New(app, "Setup", this.GetDescription(), windowKey, owner, parent)
    }

    GetDescription() {
        return "
        (
        Welcome to Launchpad, your game launching multitool!

        This setup screen will help get you up and running quickly. You can always change these settings later, and you can revisit this screen at any time from the Tools menu if you wish to start fresh.
        )"
    }

    AddDescription(text) {
        return this.guiObj.AddText("w" . this.windowSettings["contentWidth"], text)
    }

    Controls() {
        super.Controls()

        this.AddHeading("Launcher Directory")
        this.AddDescription("Launchpad will create a separate .exe file for every game you configure. This lets you add each game directly to the platform of your choice.`n`nYou can store your launchers in any folder you wish, and if you ever forget you can view or open the directory right from Launchpad.")
        this.AddConfigLocationBlock("DestinationDir")

        this.AddHeading("Platforms")
        this.AddDescription("Launchpad can detect your installed games from various game platforms to make it simple to create launchers for them.`n`nThe platforms that were detected are shown below. Check the ones you wish to enable (you can always enable and disable them later).`n`nIf you have a primary platform you wish to bring all your other games into (e.g. Steam), it's recommended to leave that platform disabled here.")
        this.AddPlatformCheckboxes()
        
        groupW := this.windowSettings["contentWidth"] - (this.margin * 2)

        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        openX := groupW - (buttonW * 2)
        tabs := this.guiObj.Add("Tab3", "x" . this.margin . " y" . this.margin . " +0x100", ["Launchers", "Assets", "Sources", "Appearance", "Advanced"])

        tabs.UseTab("Launchers", true)

        this.AddHeading("Launcher File")
        this.AddConfigLocationBlock("LauncherFile", "Reload")

        this.AddHeading("Launcher Directory")
        

        this.AddHeading("Launcher Settings")
        this.AddConfigCheckBox("Create individual launcher directories", "CreateIndividualDirs")
        this.AddConfigCheckBox("Rebuild existing launchers", "RebuildExistingLaunchers")
        this.AddConfigCheckBox("Clean launchers on build", "CleanLaunchersOnBuild")
        this.AddConfigCheckBox("Clean launchers on exit", "CleanLaunchersOnExit")

        tabs.UseTab("Assets", true)

        this.AddHeading("Assets Directory")
        this.AddConfigLocationBlock("AssetsDir")

        this.AddHeading("Asset Settings")
        this.AddConfigCheckBox("Copy assets to launcher directory", "CopyAssets")

        tabs.UseTab("Sources", true)

        this.AddHeading("API Endpoint")
        this.AddConfigLocationBlock("ApiEndpoint")

        tabs.UseTab("Appearance", true)

        this.AddHeading("Theme")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config.ThemeName)
        ctl := this.guiObj.AddDDL("vThemeName xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for Launchpad to use."

        ; @todo finish this

        tabs.UseTab("Advanced", true)

        this.AddHeading("Platforms File")
        this.AddConfigLocationBlock("PlatformsFile", "Reload")

        this.AddHeading("Cache Dir")
        this.AddConfigLocationBlock("CacheDir", "&Flush")

        this.AddHeading("Cache Settings")
        this.AddConfigCheckBox("Flush cache on exit", "FlushCacheOnExit")

        tabs.UseTab()

        closeW := 100
        closeX := this.margin + (this.windowSettings["contentWidth"] / 2) - (closeW / 2)

        this.AddSettingsButton("&Done", "CloseButton", closeW, 30, "x" . closeX)
    }

    AddConfigLocationBlock(settingName, extraButton := "", inGroupBox := true) {
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
        this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("linkText"), locationText)
        this.SetFont()
    }

    AddConfigCheckBox(checkboxText, settingName, inGroupBox := true) {
        isChecked := this.app.Config.%settingName%
        this.AddCheckBox(checkboxText, settingName, isChecked, inGroupBox, "OnSettingsCheckBox")
    }

    OnSettingsCheckBox(chk, info) {
        this.guiObj.Submit(false)
        ctlName := chk.Name
        this.app.Config.%ctlName% := chk.Value
    }

    AddPlatformCheckboxes() {
        if (!this.app.Platforms._componentsLoaded) {
            this.app.Platforms.LoadComponents()
        }

        for key, platform in this.app.Platforms.Platforms {
            if (platform.IsInstalled) {
                 this.AddCheckBox(platform.GetDisplayName(), "PlatformToggle" . key, platform.IsEnabled, false, "OnPlatformToggle")
            }
        }
    }

    OnPlatformToggle(chk, info) {
        this.guiObj.Submit(false)
        len := StrLen("PlatformToggle")
        name := SubStr(chk.Name, len + 1)

        if (this.app.Platforms.Platforms.Has(name)) {
            platform := this.app.Platforms.Platforms[name]
            platform.IsEnabled := !!(chk.Value)
            platform.SaveModifiedData()
        }
    }

    AddSettingsButton(buttonLabel, ctlName, width := "", height := "", position := "xs y+m") {
        buttonSize := this.themeObj.GetButtonSize("s", true)

        if (width == "") {
            width := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        }

        if (height == "") {
            height := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : 20
        }

        btn := this.AddButton("v" . ctlName . " " . position . " w" . width . " h" . height, buttonLabel)
    }

    SetText(ctlName, ctlText, fontStyle := "") {
        this.guiObj.SetFont(fontStyle)
        this.guiObj[ctlName].Text := ctlText
        this.SetFont()
    }

    OnCloseButton(btn, info) {
        this.Close()
    }

    OnReloadLauncherFile(btn, info) {
        this.app.Launchers.ReloadLauncherFile()
    }

    OnReloadPlatformsFile(btn, info) {
        this.app.Platforms.ReloadPlatformsFile()
    }

    OnOpenLauncherFile(btn, info) {
        this.app.Config.OpenLauncherFile()
    }

    OnOpenPlatformsFile(btn, info) {
        this.app.Config.OpenPlatformsFile()
    }

    OnChangeLauncherFile(btn, info) {
        this.app.Config.ChangeLauncherFile()
        this.SetText("LauncherFile", this.app.Config.LauncherFile, "Bold")
    }

    OnChangePlatformsFile(btn, info) {
        this.app.Config.ChangePlatformsFile()
        this.SetText("PlatformsFile", this.app.Config.PlatformsFile, "Bold")
    }

    OnOpenDestinationDir(btn, info) {
        this.app.Config.OpenDestinationDir()
    }

    OnChangeDestinationDir(btn, info) {
        this.app.Config.ChangeDestinationDir()
        this.SetText("DestinationDir", this.app.Config.DestinationDir, "Bold")
    }

    OnOpenAssetsDir(btn, info) {
        this.app.Config.OpenAssetsDir()
    }

    OnChangeAssetsDir(btn, info) {
        this.app.Config.ChangeAssetsDir()
        this.SetText("AssetsDir", this.app.Config.AssetsDir, "Bold")
    }

    OnOpenApiEndpoint(btn, info) {
        this.app.DataSources.GetItem("api").Open()
    }

    OnChangeApiEndpoint(btn, info) {
        this.app.DataSources.GetItem("api").ChangeApiEndpoint(, "SettingsWindow")
        this.SetText("ApiEndpoint", this.app.Config.ApiEndpoint, "Bold")
    }

    OnFlushCache(btn, info) {
        this.app.Cache.FlushCaches()
    }

    OnOpenCacheDir(btn, info) {
        this.app.Cache.OpenCacheDir()
    }

    OnChangeCacheDir(btn, info) {
        this.app.Cache.ChangeCacheDir()
        this.SetText("TxtCacheDir", this.app.Config.CacheDir, "Bold")
    }

    OnThemeNameChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.ThemeName := this.availableThemes[ctl.Value]
        this.app.Themes.LoadMainTheme()
    }

    OnLoggingLevelChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.LoggingLevel := ctl.Text
    }
}
