class PlatformEditor extends EntityEditorBase {
    __New(app, themeObj, guiId, entityObj, mode := "config", owner := "", parent := "") {
        if (owner == "") {
            owner := "PlatformsWindow"
        }

        super.__New(app, themeObj, guiId, entityObj, "Platform Editor", mode, owner, parent)
    }

    Controls() {
        super.Controls()
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources"])

        tabs.UseTab("General", true)
        ctl := this.AddEntityCtl("", "IsEnabled", true, "BasicControl", "CheckBox", "Enable Platform")
        ctl.ctl.ToolTip := "Whether or not " . this.app.appName . " should utilize this platform at all."
        ctl := this.AddEntityCtl("", "DetectGames", true, "BasicControl", "CheckBox", "Enable Game Detection")
        ctl.ctl.ToolTip := "Whether or not " . this.app.appName . " should detect games installed from this platform"
        ctl := this.AddEntityCtl("", "IsInstalled", true, "BasicControl", "CheckBox", "Platform Is Installed")
        ctl.ctl.ToolTip := "Whether or not the platform is currently installed. Usually " . this.app.appName . " can detect this automatically."

        tabs.UseTab("Sources", true)
        this.AddEntityCtl("Install Directory", "InstallDir", true, "LocationBlock", "InstallDir", "Clear", true, "Select the platform installation directory.")
        this.AddEntityCtl("Exe Path", "ExePath", true, "LocationBlock", "ExePath", "Clear", true, "Select the platform's .exe file.")
        this.AddEntityCtl("Icon Source", "IconSrc", true, "LocationBlock", "IconSrc", "Clear", false, "Select the icon source to use for this platform.")

        tabs.UseTab()
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
            filePath := FileSelect(1,, this.entityObj.Key . ": Select the .exe that will launch this platform.", "Exe (*.exe)")

            if (filePath) {
                this.entityObj.SetConfigValue("ExePath", filePath, false)
                this.guiObj["ExePath"].Text := filePath
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
            filePath := FileSelect(1,, this.entityObj.Key . ": Select icon or .exe retrieve icon from.", "Icons (*.ico; *.exe)")

            if (filePath) {
                this.entityObj.SetConfigValue("IconSrc", filePath, false)
                this.guiObj["IconSrc"].Text := filePath
            }
        } else if (btn == "ClearIconSrc") {
            if (this.entityObj.UnmergedConfig.Has("IconSrc")) {
                this.entityObj.UnmergedConfig.Delete("IconSrc")
                this.guiObj["IconSrc"].Text := this.entityObj.IconSrc
            }
        }
    }
}
