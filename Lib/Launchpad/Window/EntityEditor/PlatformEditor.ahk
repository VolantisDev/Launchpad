class PlatformEditor extends EntityEditorBase {
    __New(app, themeObj, windowKey, entityObj, mode := "config", owner := "", parent := "") {
        if (owner == "") {
            owner := "PlatformsWindow"
        }

        super.__New(app, themeObj, windowKey, entityObj, "Platform Editor", mode, owner, parent)
    }

    Controls() {
        super.Controls()
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources"])

        tabs.UseTab("General", true)
        this.AddCheckBoxBlock("IsEnabled", "Enable Platform", true, "Whether or not " . this.app.appName . " should utilize this platform at all.")
        this.AddCheckBoxBlock("DetectGames", "Enable Game Detection", true, "Whether or not " . this.app.appName . " should detect games installed from this platform")
        this.AddCheckBoxBlock("IsInstalled", "Platform Is Installed", true, "Whether or not the platform is currently installed. Usually " . this.app.appName . " can detect this automatically.")

        tabs.UseTab("Sources", true)
        this.AddEntityCtl("Install Directory", "InstallDir", true, "LocationBlock", "InstallDir", "Clear", true, "Select the platform installation directory.")
        this.AddEntityCtl("Exe Path", "ExePath", "LocationBlock", true, "ExePath", "Clear", true, "Select the platform's .exe file.")
        this.AddEntityCtl("Icon Source", "IconSrc", "LocationBlock", true, "IconSrc", "Clear", true, "Select the icon source to use for this platform.")

        tabs.UseTab()
    }

    OnDefaultIsEnabled(ctl, info) {
        return this.SetDefaultValue("IsEnabled", !!(ctl.Value))
    }

    OnDefaultDetectGames(ctl, info) {
        return this.SetDefaultValue("DetectGames", !!(ctl.Value))
    }

    OnDefaultIsInstalled(ctl, info) {
        return this.SetDefaultValue("IsInstalled", !!(ctl.Value))
    }

    OnIsEnabledChange(ctl, info) {
        this.guiObj.Submit(false)
        this.entityObj.IsEnabled := ctl.Value
    }

    OnDetectGamesChange(ctl, info) {
        this.guiObj.Submit(false)
        this.entityObj.DetectGames := ctl.Value
    }

    OnIsInstalledChange(ctl, info) {
        this.guiObj.Submit(false)
        this.entityObj.IsInstalled := ctl.Value
    }

    OnInstallDirMenuClick(btn) {
        if (btn == "ChangeInstallDir") {
            existingVal := this.entityObj.GetConfigValue("InstallDir")

            if existingVal {
                existingVal := "*" . existingVal
            }

            dir := DirSelect(existingVal, 2, this.entityObj.configPrefix . ": Select the installation directory")

            if (dir) {
                this.entityObj.SetConfigValue("InstallDir", dir)
                this.guiObj["InstallDir"].Text := dir
            }
        } else if (btn == "OpenInstallDir") {
            val := this.entityObj.InstallDir

            if (val) {
                Run val
            }
        } else if (btn == "ClearInstallDir") {
            this.entityObj.SetConfigValue("InstallDir", "")
        }
    }

    OnExePathMenuClick(btn) {
        if (btn == "ChangeExePath") {
            existingVal := this.entityObj.GetConfigValue("ExePath", false)
            file := FileSelect(1,, this.entityObj.Key . ": Select the .exe that will launch this platform.", "Exe (*.exe)")

            if (file) {
                this.entityObj.SetConfigValue("ExePath", file, false)
                this.guiObj["ExePath"].Text := file
            }
        } else if (btn == "OpenExePath") {
            val := this.entityObj.ExePath

            if (val) {
                Run val
            }
        } else if (btn == "ClearExePath") {
            this.entityObj.SetConfigValue("ExePath", "")
        }
    }

    OnIconSrcMenuClick(btn) {
        if (btn == "ChangeIconSrc") {
            existingVal := this.entityObj.GetConfigValue("IconSrc", false)
            file := FileSelect(1,, this.entityObj.Key . ": Select icon or .exe retrieve icon from.", "Icons (*.ico; *.exe)")

            if (file) {
                this.entityObj.SetConfigValue("IconSrc", file, false)
                this.guiObj["IconSrc"].Text := file
            }
        } else if (btn == "OpenIconSrc") {
            if (this.entityObj.IconSrc) {
                ; TODO: Determine what it means to open an icon
            }
        } else if (btn == "ClearIconSrc") {
            if (this.entityObj.UnmergedConfig.Has("IconSrc")) {
                this.entityObj.UnmergedConfig.Delete("IconSrc")
                this.guiObj["IconSrc"].Text := this.entityObj.IconSrc
            }
        }
    }
}
