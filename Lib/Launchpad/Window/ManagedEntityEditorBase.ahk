/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class ManagedEntityEditorBase extends EntityEditorBase {
    runTypes := ["Command", "Shortcut"]
    entityTypeName := ""

    __New(app, entityObj, title, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "ManagedEntityEditor"
        }

        if (owner == "") {
            owner := "LauncherEditor"
        }

        if (this.entityTypeName == "") {
            this.entityTypeName := entityObj.configPrefix
        }

        super.__New(app, entityObj, title, mode, windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        prefix := this.entityObj.configPrefix

        tabNames := ["General", "Sources", "Running", "Process"]

        if (this.entityTypeName) {
            tabNames.InsertAt(1, this.entityTypeName)
        }

        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", tabNames)

        if (this.entityTypeName) {
            tabs.UseTab(this.entityTypeName, true)
            this.CustomTabControls()
        }

        tabs.UseTab("General", true)
        this.AddEntityTypeSelect(prefix . " Type", "Type", this.entityObj.EntityType, this.entityObj.ListEntityTypes(), "", "You can select from the available entity types if the default doesn't work for your use case.")
        this.AddTextBlock("Exe", prefix . " Executable", true, "The main .exe file, not including any path information.", true)
        this.AddTextBlock("WindowTitle", prefix . " Window Title", true, "The part of the main window's title which identifies it uniquely.", true)
        
        tabs.UseTab("Sources", true)
        this.AddLocationBlock(prefix . " Install Directory", "InstallDir", "Clear", true, true, true)
        this.AddHelpText("Select the installation folder, or use default for auto-detection.")
        this.AddLocationBlock(prefix . " Working Directory", "WorkingDir", "Clear", true, true, true)
        this.AddHelpText("Optionally, set a working directory to run from. This is not often required.")
        
        tabs.UseTab("Running", true)
        this.AddSelect(prefix . " Run Type", "RunType", this.entityObj.RunType, this.runTypes, true, "", "", "", true)
        ctl := this.AddTextBlock("RunCmd", prefix . " Run Command", true)
        ctl := this.AddLocationBlock(prefix . " Shortcut", "ShortcutSrc", "Clear", true, true, true)
        ; @todo RunMethod

        tabs.UseTab("Process", true)
        ; @todo ProcessType
        ; @todo ProcessId
        ; @todo ProcessTimeout
        ; @todo ReplaceProcess

        ; @todo LocateMethod
        ; @todo LocateRegView
        ; @todo LocateRegKey
        ; @todo LocateRegValue
        ; @todo LocateRegStripQuotes
        
        tabs.UseTab()
    }

    CustomTabControls() {
        ; Assume no custom tab controls unless overridden.
    }

    OnDefaultExe(ctlObj, info) {
        return this.SetDefaultValue("Exe", !!(ctlObj.Value), true)
    }

    OnDefaultWindowTitle(ctlObj, info) {
        return this.SetDefaultValue("WindowTitle", !!(ctlObj.Value), true)
    }

    OnDefaultRunCmd(ctlObj, info) {
        return this.SetDefaultValue("RunCmd", !!(ctlObj.Value), true)
    }

    OnDefaultInstallDir(ctlObj, info) {
        return this.SetDefaultLocationValue(ctlObj, "InstallDir", true)
    }

    OnDefaultWorkingDir(ctlObj, info) {
        return this.SetDefaultLocationValue(ctlObj, "WorkingDir", true)
    }

    OnDefaultShortcutSrc(ctlObj, info) {
        return this.SetDefaultLocationValue(ctlObj, "ShortcutSrc", true)
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

    OnRunTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.RunType := ctlObj.Text
    }

    OnRunCmdChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.RunCmd := ctlObj.Text
    }

    OnChangeShortcutSrc(btn, info) {
        existingVal := this.entityObj.GetConfigValue("ShortcutSrc")
        file := FileSelect(1,, this.prefix . ": Select a shortcut file or .exe that will launch the application", "Shortcuts (*.lnk; *.url; *.exe)")

        if (file) {
            this.entityObj.SetConfigValue("ShortcutSrc", file, true)
            this.guiObj["ShortcutSrc"].Text := file
        }
    }

    OnOpenShortcutSrc(btn, info) {
        if (this.entityObj.ShortcutSrc) {
            Run this.entityObj.ShortcurSrc
        }
    }

    OnClearShortcutSrc(btn, info) {
        if (this.entityObj.UnmergedConfig.Has("ShortcutSrc")) {
            this.entityObj.UnmergedConfig.Delete("ShortcutSrc")
            this.guiObj["ShortcutSrc"].Text := this.entityObj.ShortcutSrc
        }
    }
}
