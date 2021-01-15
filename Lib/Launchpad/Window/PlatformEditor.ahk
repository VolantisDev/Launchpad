class PlatformEditor extends EntityEditorBase {
    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "PlatformEditor"
        }

        if (owner == "") {
            owner := "PlatformsWindow"
        }

        super.__New(app, entityObj, "Platform Editor", mode, windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources"])

        tabs.UseTab("General", true)
        this.AddCheckBoxBlock("IsEnabled", "Enable Platform", true, "Whether or not Launchpad should use this platform when detecting games or performing other operations.")
        this.AddCheckBoxBlock("IsInstalled", "Platform Is Installed", true, "Whether or not the platform is currently installed. Usually Launchpad can detect this automatically.")

        tabs.UseTab("Sources", true)
        this.AddLocationBlock("Install Directory", "InstallDir", "Clear", true, true)
        this.AddLocationBlock("Exe Path", "ExePath", "Clear", true, true)
        this.AddLocationBlock("Icon Source", "IconSrc", "Clear", true, true)

        tabs.UseTab()
    }

    OnDefaultIsEnabled(ctl, info) {
        return this.SetDefaultValue("IsEnabled", !!(ctl.Value))
    }

    OnDefaultIsInstalled(ctl, info) {
        return this.SetDefaultValue("IsInstalled", !!(ctl.Value))
    }

    OnDefaultInstallDir(ctl, info) {
        return this.SetDefaultLocationValue(ctl, "InstallDir")
    }

    OnDefaultExePath(ctl, info) {
        return this.SetDefaultLocationValue(ctl, "ExePath")
    }

    OnDefaultIconSrc(ctl, info) {
        return this.SetDefaultLocationValue(ctl, "IconSrc")
    }

    OnIsEnabledChange(ctl, info) {
        this.guiObj.Submit(false)
        this.entityObj.IsEnabled := ctl.Value
    }

    OnIsInstalledChange(ctl, info) {
        this.guiObj.Submit(false)
        this.entityObj.IsInstalled := ctl.Value
    }

    OnChangeInstallDir(ctlObj, info) {
        existingVal := this.entityObj.GetConfigValue("InstallDir")

        if existingVal {
            existingVal := "*" . existingVal
        }

        dir := DirSelect(existingVal, 2, this.entityObj.configPrefix . ": Select the installation directory")

        if (dir) {
            this.entityObj.SetConfigValue("InstallDir", dir)
            this.guiObj["InstallDir"].Text := dir
        }
    }

    OnOpenInstallDir(ctlObj, info) {
        val := this.entityObj.InstallDir

        if (val) {
            Run val
        }
    }

    OnClearInstallDir(ctlObj, info) {
        this.entityObj.SetConfigValue("InstallDir", "")
    }

    OnChangeExePath(ctlObj, info) {
        existingVal := this.entityObj.GetConfigValue("ExePath", false)
        file := FileSelect(1,, this.entityObj.Key . ": Select the .exe that will launch this platform.", "Exe (*.exe)")

        if (file) {
            this.entityObj.SetConfigValue("ExePath", file, false)
            this.guiObj["ExePath"].Text := file
        }
    }

    OnOpenExePath(ctlObj, info) {
        val := this.entityObj.ExePath

        if (val) {
            Run val
        }
    }

    OnClearExePath(ctlObj, info) {
        this.entityObj.SetConfigValue("ExePath", "")
    }

    OnChangeIconSrc(btn, info) {
        existingVal := this.entityObj.GetConfigValue("IconSrc", false)
        file := FileSelect(1,, this.entityObj.Key . ": Select icon or .exe retrieve icon from.", "Icons (*.ico; *.exe)")

        if (file) {
            this.entityObj.SetConfigValue("IconSrc", file, false)
            this.guiObj["IconSrc"].Text := file
        }
    }

    OnOpenIconSrc(btn, info) {
        if (this.entityObj.IconSrc) {
            Run this.entityObj.IconSrc
        }
    }

    OnClearIconSrc(btn, info) {
        if (this.entityObj.UnmergedConfig.Has("IconSrc")) {
            this.entityObj.UnmergedConfig.Delete("IconSrc")
            this.guiObj["IconSrc"].Text := this.entityObj.IconSrc
        }
    }
}
