class SettingsWindow extends LaunchpadGuiBase {
    availableThemes := Map()

    __New(app, windowKey := "", owner := "", parent := "") {
        this.availableThemes := app.Themes.GetAvailableThemes(true)
        super.__New(app, "Settings", windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        
        groupW := this.windowSettings["contentWidth"] - (this.margin * 2)

        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") and buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        openX := groupW - (buttonW * 2)
        tabs := this.guiObj.Add("Tab3", "x" . this.margin . " y" . this.margin . " h" . this.windowSettings["tabHeight"] . " +0x100", ["Launchers", "Assets", "Sources", "Appearance", "Advanced"])

        tabs.UseTab("Launchers", true)

        this.AddHeading("Launcher File")
        this.AddConfigLocationBlock("LauncherFile", "Reload")

        this.AddHeading("Launcher Directory")
        this.AddConfigLocationBlock("DestinationDir")

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
        ctl := this.guiObj.AddDDL("vThemeName xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"], this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        this.AddHelpText("Select a theme for Launchpad to use.")

        ; @todo finish this

        tabs.UseTab("Advanced", true)

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
        buttonW := (buttonSize.Has("w") and buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        buttonH := (buttonSize.Has("h") and buttonSize["h"] != "auto") ? buttonSize["h"] : 20

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
        this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.windowSettings["contentWidth"] . " +0x200 c" . this.themeObj.GetColor("accentDark"), locationText)
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

    AddSettingsButton(buttonLabel, ctlName, width := "", height := "", position := "xs y+m") {
        buttonSize := this.themeObj.GetButtonSize("s", true)

        if (width == "") {
            width := (buttonSize.Has("w") and buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        }

        if (height == "") {
            height := (buttonSize.Has("h") and buttonSize["h"] != "auto") ? buttonSize["h"] : 20
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

    OnOpenLauncherFile(btn, info) {
        this.app.Launchers.OpenLauncherFile()
    }

    OnChangeLauncherFile(btn, info) {
        this.app.Launchers.ChangeLauncherFile()
        this.SetText("LauncherFile", this.app.Config.LauncherFile, "Bold")
    }

    OnOpenDestinationDir(btn, info) {
        this.app.Launchers.OpenDestinationDir()
    }

    OnChangeDestinationDir(btn, info) {
        this.app.Launchers.ChangeDestinationDir()
        this.SetText("DestinationDir", this.app.Config.DestinationDir, "Bold")
    }

    OnOpenAssetsDir(btn, info) {
        this.app.Launchers.OpenAssetsDir()
    }

    OnChangeAssetsDir(btn, info) {
        this.app.Launchers.ChangeAssetsDir()
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
}
