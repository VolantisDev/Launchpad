class SettingsWindow extends LaunchpadGuiBase {
    availableThemes := Map()
    logLevels := ["None", "Error", "Warning", "Info", "Debug"]

    __New(app, windowKey := "", owner := "", parent := "") {
        this.availableThemes := app.Themes.GetAvailableThemes(true)
        super.__New(app, "Settings", windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        
        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        openX := this.windowSettings["contentWidth"] - (this.margin * 2) - (buttonW * 2)
        tabsW := this.windowSettings["contentWidth"]
        tabs := this.guiObj.Add("Tab3", "x" . this.margin . " y+" . this.margin . " w" . tabsW . " +0x100", ["Launchers", "Assets", "Sources", "Appearance", "Advanced"])

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

        this.AddHeading("Logging Level")
        chosen := this.GetItemIndex(this.logLevels, this.app.Config.LoggingLevel)
        ctl := this.guiObj.AddDDL("vLoggingLevel xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.logLevels)
        ctl.OnEvent("Change", "OnLoggingLevelChange")

        tabs.UseTab()

        closeW := 100
        closeX := this.margin + (this.windowSettings["contentWidth"] / 2) - (closeW / 2)

        this.AddSettingsButton("&Done", "CloseButton", closeW, 30, "x" . closeX)
    }

    AddConfigLocationBlock(settingName, extraButton := "") {
        location := this.app.Config.%settingName% ? this.app.Config.%settingName% : "Not selected"

        this.AddLocationText(location, settingName)

        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        buttonH := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : 20

        position := "xs y+m"
        btn := this.AddButton(position . " w" . buttonW . " h" . buttonH . " vChange" . settingName, "Change")
        btn := this.AddButton("x+m yp w" . buttonW . " h" . buttonH . " vOpen" . settingName, "Open")

        if (extraButton != "") {
            btn := this.AddButton("x+m yp w" . buttonW . " h" . buttonH . " v" . extraButton . settingName, extraButton)
        }
    }

    AddLocationText(locationText, ctlName) {
        position := "xs y+m"
        this.SetFont("", "Bold")
        ctl := this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.windowSettings["contentWidth"] . " +0x200 +0x100 c" . this.themeObj.GetColor("linkText"), locationText)
        ctl.ToolTip := locationText
        this.SetFont()
    }

    AddConfigCheckBox(checkboxText, settingName) {
        isChecked := this.app.Config.%settingName%
        this.AddCheckBox(checkboxText, settingName, isChecked, false, "OnSettingsCheckBox")
    }

    OnSettingsCheckBox(chk, info) {
        this.guiObj.Submit(false)
        ctlName := chk.Name
        this.app.Config.%ctlName% := chk.Value
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
