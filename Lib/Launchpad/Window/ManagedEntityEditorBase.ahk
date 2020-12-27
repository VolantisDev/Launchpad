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
        this.AddLocationBlock(prefix . " Working Directory", "WorkingDir", "Clear", true, true, true)
        this.AddHelpText("Optionally, set a working directory for the launcher to run from. This is not often required.")


        ; @todo LocateMethod
        ; @todo LocateRegView
        ; @todo LocateRegKey
        ; @todo LocateRegValue
        ; @todo LocateRegStripQuotes


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
        return this.SetDefaultLocationValue(ctlObj, "InstallDir", true)
    }

    OnDefaultWorkingDir(ctlObj, info) {
        return this.SetDefaultLocationValue(ctlObj, "WorkingDir", true)
    }

    SetDefaultLocationValue(ctlObj, fieldName, includePrefix := false) {
        isDefault := !!(ctlObj.Value)
        this.guiObj["Change" . fieldName].Opt("Hidden" . isDefault)
        this.guiObj["Open" . fieldName].Opt("Hidden" . isDefault)
        this.guiObj["Clear" . fieldName].Opt("Hidden" . isDefault)
        return this.SetDefaultValue(fieldName, isDefault, includePrefix, "Not set")
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

    OnChangeWorkingDir(ctlObj, info) {
        existingVal := this.entityObj.GetConfigValue("WorkingDir")

        if (existingVal) {
            existingVal := "*" . existingVal
        }

        dir := DirSelect(existingVal, 2, this.entityObj.configPrefix . ": Select the working directory")

        if (dir) {
            this.entityObj.SetConfigValue("WorkingDir", dir)
            this.guiObj["WorkingDir"].Text := dir
        }
    }

    OnOpenWorkingDir(ctlObj, info) {
        val := this.entityObj.GetConfigValue("WorkingDir")

        if (val) {
            Run val
        }
    }

    OnClearWorkingDir(ctlObj, info) {
        this.entityObj.SetConfigValue("WorkingDir", "")
    }
}
