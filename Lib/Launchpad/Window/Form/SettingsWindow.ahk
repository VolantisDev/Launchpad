class SettingsWindow extends GuiBase {
    availableThemes := Map()
    logLevels := ["None", "Error", "Warning", "Info", "Debug"]

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        if (owner == "") {
            owner := "ManageWindow"
        }

        this.availableThemes := app.Themes.GetAvailableThemes(true)
        super.__New(app, themeObj, windowKey, "Settings", owner, parent)
    }

    Controls() {
        super.Controls()
        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        tabs := this.AddTabs("SettingsTabs", ["Launchers", "Platforms", "Backups", "Appearance", "Cache", "Advanced"], "x" . this.margin . " y+" . this.margin)

        tabs.UseTab("Launchers", true)

        this.AddHeading("Launcher File")
        this.AddConfigLocationBlock("LauncherFile", "Reload")

        this.AddHeading("Launcher Directory")
        this.AddConfigLocationBlock("DestinationDir")

        this.AddHeading("Assets Directory")
        this.AddConfigLocationBlock("AssetsDir")

        this.AddHeading("Launcher Settings")
        this.AddConfigCheckBox("Create desktop shortcuts for launchers", "CreateDesktopShortcuts")
        this.AddConfigCheckBox("Rebuild existing launchers when building all launchers", "RebuildExistingLaunchers")
        this.AddConfigCheckBox("Use advanced launcher editor by default", "UseAdvancedLauncherEditor")
        this.AddConfigCheckBox("Clean launchers automatically when building", "CleanLaunchersOnBuild")
        this.AddConfigCheckBox("Clean launchers automatically when exiting Launchpad", "CleanLaunchersOnExit")

        tabs.UseTab("Platforms", true)

        this.AddButton("xs y+" . this.margin . " w200 h25", "Manage Platforms", "OnManagePlatforms")

        this.AddHeading("Platforms File")
        this.AddConfigLocationBlock("PlatformsFile", "Reload")

        tabs.UseTab("Backups")

        this.AddButton("xs y+" . this.margin . " w200 h25", "Manage Backups", "OnManageBackups")

        this.AddHeading("Backup Dir")
        this.AddConfigLocationBlock("BackupDir", "&Manage")

        this.AddHeading("Backups File")
        this.AddConfigLocationBlock("BackupsFile")

        this.AddHeading("Backups to Keep")
        ctl := this.AddEdit("BackupsToKeep", this.app.Config.BackupsToKeep, "y+" . this.margin, 100)
        ctl.OnEvent("Change", "OnBackupsToKeepChange")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] " y+" . this.margin, "Note: This can be overridden for individual backups in the Backup Manager.")

        this.AddHeading("Backup Options")
        this.AddConfigCheckbox("Automatically back up config files", "AutoBackupConfigFiles")

        tabs.UseTab("Appearance", true)

        this.AddHeading("Theme")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config.ThemeName)
        ctl := this.guiObj.AddDDL("vThemeName xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for Launchpad to use."

        this.AddButton("xs y+" . this.margin . " w250 h25", "Reload Launchpad", "OnReload")

        tabs.UseTab("Cache", true)

        this.AddHeading("Cache Dir")
        this.AddConfigLocationBlock("CacheDir", "&Flush")

        this.AddHeading("Cache Settings")
        this.AddConfigCheckBox("Flush cache on exit (Recommended only for debugging)", "FlushCacheOnExit")

        tabs.UseTab("Advanced", true)

        this.AddHeading("Updates")
        this.AddConfigCheckBox("Check for updates on start", "CheckUpdatesOnStart")

        this.AddHeading("Logging Level")
        chosen := this.GetItemIndex(this.logLevels, this.app.Config.LoggingLevel)
        ctl := this.guiObj.AddDDL("vLoggingLevel xs y+m Choose" . chosen . " w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), this.logLevels)
        ctl.OnEvent("Change", "OnLoggingLevelChange")

        this.AddHeading("API Endpoint")
        this.AddConfigLocationBlock("ApiEndpoint")

        this.AddHeading("API Settings")
        this.AddConfigCheckBox("Enable API login for enhanced functionality", "ApiAuthentication")
        this.AddConfigCheckBox("Automatically initiate API login when needed", "ApiAutoLogin")

        tabs.UseTab()

        closeW := 100
        closeX := this.margin + this.windowSettings["contentWidth"] - closeW

        this.AddSettingsButton("&Done", "CloseButton", closeW, 30, "x" . closeX, "dialog")
    }

    OnManageBackups(btn, info) {
        this.app.GuiManager.OpenWindow("ManageBackupsWindow")
    }

    OnManagePlatforms(btn, info) {
        this.app.GuiManager.OpenWindow("PlatformsWindow")
    }

    AddConfigLocationBlock(settingName, extraButton := "", helpText := "") {
        location := this.app.Config.%settingName% ? this.app.Config.%settingName% : "Not selected"
        btnWidth := 20
        btnHeight := 20

        ctl := this.AddLocationText(location, settingName, this.windowSettings["contentWidth"] - btnWidth - (this.margin/2))

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
        result := this.app.GuiManager.Menu("MenuGui", btn.MenuItems, this.windowKey, "", btn)

        if (result) {
            callback := "On" . result
            this.%callback%()
        }
    }

    AddLocationText(locationText, ctlName, width := "") {
        if (width == "") {
            width := this.windowSettings["contentWidth"]
        }

        position := "xs y+m"
        this.SetFont("", "Bold")
        ctl := this.guiObj.AddText("v" . ctlName . " " . position . " w" . width . " +0x200 +0x100 c" . this.themeObj.GetColor("linkText"), locationText)
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

    AddSettingsButton(buttonLabel, ctlName, width := "", height := "", position := "xs y+m", buttonStyle := "normal") {
        buttonSize := this.themeObj.GetButtonSize("s", true)

        if (width == "") {
            width := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        }

        if (height == "") {
            height := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : 20
        }

        btn := this.AddButton("v" . ctlName . " " . position . " w" . width . " h" . height, buttonLabel, "", buttonStyle)
    }

    SetText(ctlName, ctlText, fontStyle := "") {
        this.guiObj.SetFont(fontStyle)
        this.guiObj[ctlName].Text := ctlText
        this.SetFont()
    }

    OnCloseButton(btn, info) {
        this.Close()

        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").PopulateListView()
        }
    }

    OnReloadLauncherFile(btn, info) {
        this.app.Launchers.ReloadLauncherFile()
    }

    OnReloadPlatformsFile(btn, info) {
        this.app.Platforms.ReloadPlatformsFile()
    }

    OnOpenLauncherFile() {
        this.app.Config.OpenLauncherFile()
    }

    OnOpenPlatformsFile() {
        this.app.Config.OpenPlatformsFile()
    }

    OnChangeLauncherFile() {
        this.app.Config.ChangeLauncherFile()
        this.SetText("LauncherFile", this.app.Config.LauncherFile, "Bold")
    }

    OnChangePlatformsFile() {
        this.app.Config.ChangePlatformsFile()
        this.SetText("PlatformsFile", this.app.Config.PlatformsFile, "Bold")
    }

    OnOpenDestinationDir() {
        this.app.Config.OpenDestinationDir()
    }

    OnChangeDestinationDir() {
        this.app.Config.ChangeDestinationDir()
        this.SetText("DestinationDir", this.app.Config.DestinationDir, "Bold")
    }

    OnApiTokenChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.ApiToken := ctl.Text
    }

    OnOpenAssetsDir() {
        this.app.Config.OpenAssetsDir()
    }

    OnChangeAssetsDir() {
        this.app.Config.ChangeAssetsDir()
        this.SetText("AssetsDir", this.app.Config.AssetsDir, "Bold")
    }

    OnOpenApiEndpoint() {
        this.app.DataSources.GetItem("api").Open()
    }

    OnChangeApiEndpoint() {
        this.app.DataSources.GetItem("api").ChangeApiEndpoint("", "")
        this.SetText("ApiEndpoint", this.app.Config.ApiEndpoint, "Bold")
    }

    OnFlushCache(btn, info) {
        this.app.Cache.FlushCaches()
    }

    OnOpenCacheDir() {
        this.app.Cache.OpenCacheDir()
    }

    OnChangeCacheDir() {
        this.app.Cache.ChangeCacheDir()
        this.SetText("TxtCacheDir", this.app.Config.CacheDir, "Bold")
    }

    OnOpenBackupDir() {
        this.app.Backups.OpenBackupDir()
    }

    OnChangeBackupDir() {
        this.app.Backups.ChangeBackupDir()
        this.SetText("TxtBackupDir", this.app.Config.BackupDir, "Bold")
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

    OnBackupsToKeepChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.BackupsToKeep := ctl.Text
    }
}
