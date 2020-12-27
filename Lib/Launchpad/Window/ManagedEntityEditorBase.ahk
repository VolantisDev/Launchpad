/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class ManagedEntityEditorBase extends EntityEditorBase {
    __New(app, entityObj, title, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "ManagedEntityEditor"
        }

        if (owner == "") {
            owner := "LauncherEditor"
        }

        super.__New(app, entityObj, title, mode, windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        prefix := this.entityObj.configPrefix
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources", "Advanced"])

        tabs.UseTab("General", true)
        this.AddEntityTypeSelect(prefix . " Type", "Type", this.entityObj.EntityType, this.entityObj.ListEntityTypes(), "", "You can select from the available entity types if the default doesn't work for your use case.")
        this.AddTextBlock("Exe", prefix . " Executable", true, "The launcher's main .exe file, not including any path information.", true)
        this.AddTextBlock("WindowTitle", prefix . " Window Title", true, "The part of the main launcher window's title which identifies it uniquely.", true)
        
        tabs.UseTab("Sources", true)
        this.AddLocationBlock(prefix . " Install Directory", "InstallDir", "Clear", true, true, true)
        this.AddHelpText("Select the launcher's installation folder, or use default for auto-detection.")

        tabs.UseTab("Advanced", true)
        
        tabs.UseTab()
    }

    OnDefaultExe(ctlObj, info) {
        return this.SetDefaultValue("Exe", !!(ctlObj.Value), true)
    }

    OnDefaultWindowTitle(ctlObj, info) {
        return this.SetDefaultValue("WindowTitle", !!(ctlObj.Value), true)
    }

    OnDefaultInstallDir(ctlObj, info) {
        isDefault := !!(ctlObj.Value)
        this.guiObj["ChangeInstallDir"].Opt("Hidden" . isDefault)
        this.guiObj["OpenInstallDir"].Opt("Hidden" . isDefault)
        this.guiObj["ClearInstallDir"].Opt("Hidden" . isDefault)
        return this.SetDefaultValue("InstallDir", isDefault, true, "Not set")
    }

    OnTypeChange(ctlObj, info) {
        this.entityObj.EntityType := ctlObj.Value
        this.entityObj.UpdateDataSourceDefaults()
    }

    OnExeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.Exe := ctlObj.Value
    }

    OnWindowTitleChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.WindowTitle := ctlObj.Value
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
        val := this.entityObj.GetConfigValue("InstallDir")

        if (val) {
            Run val
        }
    }

    OnClearInstallDir(ctlObj, info) {
        this.entityObj.SetConfigValue("InstallDir", "")
    }
}
