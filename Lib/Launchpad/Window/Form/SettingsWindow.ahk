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

        this.AddConfigLocationBlock("Launcher File", "LauncherFile", "Reload")
        this.AddConfigLocationBlock("Launcher Directory", "DestinationDir")
        this.AddConfigLocationBlock("Assets Directory", "AssetsDir")

        this.AddHeading("Launcher Settings")
        this.AddConfigCheckBox("Create desktop shortcuts for launchers", "CreateDesktopShortcuts")
        this.AddConfigCheckBox("Rebuild existing launchers when building all launchers", "RebuildExistingLaunchers")
        this.AddConfigCheckBox("Use advanced launcher editor by default", "UseAdvancedLauncherEditor")
        this.AddConfigCheckBox("Clean launchers automatically when building", "CleanLaunchersOnBuild")
        this.AddConfigCheckBox("Clean launchers automatically when exiting Launchpad", "CleanLaunchersOnExit")

        tabs.UseTab("Platforms", true)

        this.AddButton("xs y+" . this.margin . " w200 h25", "Manage Platforms", "OnManagePlatforms")
        this.AddConfigLocationBlock("Platforms File", "PlatformsFile", "Reload")

        tabs.UseTab("Backups")

        this.AddButton("xs y+" . this.margin . " w200 h25", "Manage Backups", "OnManageBackups")
        this.AddConfigLocationBlock("Backup Dir", "BackupDir", "&Manage")
        this.AddConfigLocationBlock("Backups File", "BackupsFile")

        this.AddHeading("Backups to Keep")
        ctl := this.AddEdit("BackupsToKeep", this.app.Config.BackupsToKeep, "y+" . this.margin, 100)
        ctl.OnEvent("Change", "OnBackupsToKeepChange")
        this.guiObj.AddText("w" . this.windowSettings["contentWidth"] " y+" . this.margin, "Note: This can be overridden for individual backups in the Backup Manager.")

        this.AddHeading("Backup Options")
        this.AddConfigCheckbox("Automatically back up config files", "AutoBackupConfigFiles")

        tabs.UseTab("Appearance", true)

        this.AddHeading("Theme")
        chosen := this.GetItemIndex(this.availableThemes, this.app.Config.ThemeName)
        ctl := this.guiObj.AddDDL("vThemeName xs y+m Choose" . chosen . " w250 c" . this.themeObj.GetColor("editText"), this.availableThemes)
        ctl.OnEvent("Change", "OnThemeNameChange")
        ctl.ToolTip := "Select a theme for Launchpad to use."

        this.AddButton("xs y+" . this.margin . " w250 h25", "Reload Launchpad", "OnReload")

        tabs.UseTab("Cache", true)

        this.AddConfigLocationBlock("Cache Dir", "CacheDir", "&Flush")

        this.AddHeading("Cache Settings")
        this.AddConfigCheckBox("Flush cache on exit (Recommended only for debugging)", "FlushCacheOnExit")

        tabs.UseTab("Advanced", true)

        this.AddHeading("Updates")
        this.AddConfigCheckBox("Check for updates on start", "CheckUpdatesOnStart")

        this.AddHeading("Logging Level")
        chosen := this.GetItemIndex(this.logLevels, this.app.Config.LoggingLevel)
        ctl := this.guiObj.AddDDL("vLoggingLevel xs y+m Choose" . chosen . " w200 c" . this.themeObj.GetColor("editText"), this.logLevels)
        ctl.OnEvent("Change", "OnLoggingLevelChange")

        this.AddConfigLocationBlock("API Endpoint", "ApiEndpoint")

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

    AddConfigLocationBlock(heading, settingName, extraButton := "", helpText := "") {
        location := this.app.Config.%settingName% ? this.app.Config.%settingName% : "Not selected"
        this.Add("LocationBlock", "", heading, settingName, location, extraButton, true, helpText)
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

    OnLauncherFileMenuClick(btn) {
        if (btn == "ChangeLauncherFile") {
            this.app.Config.ChangeLauncherFile()
            this.SetText("LauncherFile", this.app.Config.LauncherFile, "Bold")
        } else if (btn == "OpenLauncherFile") {
            this.app.Config.OpenLauncherFile()
        } else if (btn == "ReloadLauncherFile") {
            this.app.Launchers.ReloadLauncherFile()
        }
    }

    OnBackupsFileMenuClick(btn) {
        if (btn == "ChangeBackupsFile") {
            this.app.Config.ChangeBackupsFile()
            this.SetText("BackupsFile", this.app.Config.LauncherFile, "Bold")
        } else if (btn == "OpenBackupsFile") {
            this.app.Config.OpenBackupsFile()
        } else if (btn == "ReloadBackupsFile") {
            this.app.Launchers.ReloadBackupsFile()
        }
    }

    OnPlatformsFileMenuClick(btn) {
        if (btn == "ChangePlatformsFile") {
            this.app.Config.ChangePlatformsFile()
            this.SetText("PlatformsFile", this.app.Config.PlatformsFile, "Bold")
        } else if (btn == "OpenPlatformsFile") {
            this.app.Config.OpenPlatformsFile()
        } else if (btn == "ReloadPlatformsFile") {
            this.app.Platforms.ReloadPlatformsFile()
        }
    }

    OnDestinationDirMenuClick(btn) {
        if (btn == "ChangeDestinationDir") {
            this.app.Config.ChangeDestinationDir()
            this.SetText("DestinationDir", this.app.Config.DestinationDir, "Bold")
        } else if (btn == "OpenDestinationDir") {
            this.app.Config.OpenDestinationDir()
        }
    }

    OnApiTokenChange(ctl, info) {
        this.guiObj.Submit(false)
        this.app.Config.ApiToken := ctl.Text
    }

    OnAssetsDirMenuClick(btn) {
        if (btn == "ChangeAssetsDir") {
            this.app.Config.ChangeAssetsDir()
            this.SetText("AssetsDir", this.app.Config.AssetsDir, "Bold")
        } else if (btn == "OpenAssetsDir") {
            this.app.Config.OpenAssetsDir()
        }
    }

    OnApiEndpointMenuClick(btn) {
        if (btn == "ChangeApiEndpoint") {
            this.app.DataSources.GetItem("api").ChangeApiEndpoint("", "")
            this.SetText("ApiEndpoint", this.app.Config.ApiEndpoint, "Bold")
        } else if (btn == "OpenApiEndpoint") {
            this.app.DataSources.GetItem("api").Open()
        }
    }

    OnCacheDirMenuClick(btn) {
        if (btn == "ChangeCacheDir") {
            this.app.Cache.ChangeCacheDir()
            this.SetText("CacheDir", this.app.Config.CacheDir, "Bold")
        } else if (btn == "OpenCacheDir") {
            this.app.Cache.OpenCacheDir()
        } else if (btn == "FlushCacheDir") {
            this.app.Cache.FlushCaches()
        }
    }

    OnBackupDirMenuClick(btn) {
        if (btn == "ChangeBackupDir") {
            this.app.Backups.ChangeBackupDir()
            this.SetText("BackupDir", this.app.Config.BackupDir, "Bold")
        } else if (btn == "OpenBackupDir") {
            this.app.Backups.OpenBackupDir()
        }
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
