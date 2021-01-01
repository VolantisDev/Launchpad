/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class ManagedEntityEditorBase extends EntityEditorBase {
    runTypes := ["Command", "Shortcut"]
    processTypes := ["Exe", "Title", "Class"]
    runMethods := ["RunWait", "Run", "Scheduled"]
    locateMethods := ["Search", "Registry", "BlizzardProductDb"]
    regViews := ["32"]
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

        if (this.Is64BitOs()) {
            this.regViews.Push("64")
        }

        super.__New(app, entityObj, title, mode, windowKey, owner, parent)
    }

    Is64BitOs() {
        return FileExist("C:\Program Files (x86)") ; @todo Make this better
    }

    GetTabNames() {
        return [this.entityTypeName, "Sources", "Registry", "Running", "Process"]
    }

    Controls() {
        super.Controls()
        prefix := this.entityObj.configPrefix

        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", this.GetTabNames())

        tabs.UseTab(this.entityTypeName, true)
        this.AddEntityTypeSelect(prefix . " Type", "Type", this.entityObj.EntityType, this.entityObj.ListEntityTypes(), "", "You can select from the available entity types if the default doesn't work for your use case.")
        this.AddTextBlock("Exe", prefix . " Executable", true, "The main .exe file, not including any path information.", true)
        this.AddTextBlock("WindowTitle", prefix . " Window Title", true, "The part of the main window's title which identifies it uniquely.", true)
        this.CustomTabControls()

        tabs.UseTab("Sources", true)
        this.AddLocationBlock(prefix . " Install Directory", "InstallDir", "Clear", true, true, true, "Select the installation folder, or use default for auto-detection.")
        this.AddLocationBlock(prefix . " Working Directory", "WorkingDir", "Clear", true, true, true, "Optionally, set a working directory to run from. This is not often required.")
        this.AddSelect(prefix . " Install Locate Method", "LocateMethod", this.entityObj.LocateMethod, this.locateMethods, true, "", "", "Search: Searches a list of possible directories (Defaulting to some common possibilities) for the .exe file and uses that directory`nRegistry: Looks for the provided registry key and uses its value as the install path if present`nBlizzardProductDb: Searches for LauncherSpecificId within the Blizzard product.db file if present", true)
        this.AddTextBlock("LauncherSpecificId", prefix . " Launcher-Specific ID", true, "If required, an ID that the launcher uses to reference this item", true)
        
        tabs.UseTab("Registry", true)
        this.AddSelect("Locate Registry View", "LocateRegView", this.entityObj.LocateRegView, this.regViews, true, "", "", "The registry view to use when locating the install dir", true)
        this.AddTextBlock("LocateRegKey", "Locate Registry Key", true, "The registry key to look up the install dir within. Path parts should be separated with backslashes and must start with one of: HKEY_LOCAL_MACHINE, HKEY_USERS, HKEY_CURRENT_USER, HKEY_CLASSES_ROOT, HKEY_CURRENT_CONFIG, or the abbreviation of one of those. To read from a remote registry, prefix the root path with two backslashes and the computer name.`n`nSimple example: HKLM\Path\To\Key`nRemote example: \\OTHERPC\HKLM\Path\To\Key", true)
        this.AddTextBlock("LocateRegValue", "Locate Registry Value", true, "The name of the registry value to look up within the specified key.`n`nExample: InstallPath", true)
        this.AddCheckBoxBlock("LocateRegStripQuotes", "Strip quotes from registry value", true, "", true)
        
        tabs.UseTab("Running", true)
        this.AddSelect(prefix . " Run Type", "RunType", this.entityObj.RunType, this.runTypes, true, "", "", "", true)
        ctl := this.AddTextBlock("RunCmd", prefix . " Run Command", true)
        ctl := this.AddLocationBlock(prefix . " Shortcut", "ShortcutSrc", "Clear", true, true, true)
        this.AddSelect(prefix . " Run Method", "RunMethod", this.entityObj.RunMethod, this.runMethods, true, "", "", "RunWait: The simplest method when it works, runs a process and waits for it to complete in one command`nRun: The most compatible method, runs a process and then separately waits for it to start`nScheduled: Helpful to avoid Launchpad owning the process, this creates a scheduled task that will run the process immediately and then delete itself", true)

        tabs.UseTab("Process", true)
        ctl := this.AddSelect(prefix . " Process Detection Type", "ProcessType", this.entityObj.ProcessType, this.processTypes, true, "", "", "Exe: Use the .exe filename to detect this item's process`nTitle: Use all or part of the window title to detect this item's process`nClass: Use the window class name to detect this item's process", true)
        ctl := this.AddTextBlock("ProcessId", prefix . " Process ID", true, "This value depends on the Process Type selected above, and can often be determined automatically.", true)
        ctl := this.AddNumberBlock("ProcessTimeout", "Process Timeout", true, "How long to wait when detecting this items' process", true)
        this.AddCheckBoxBlock("ReplaceProcess", "Replace process after launching", true, "After the process is detected, immediately kill and re-launch it so that Launchpad is its parent process.", true)
        
        tabs.UseTab()
        this.ExtraTabControls(tabs)
        tabs.UseTab()
    }

    CustomTabControls() {
        ; Assume no custom tab controls unless overridden.
    }

    ExtraTabControls(tabs) {
        ; Assume no extra tab controls unless overridden.
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

    OnDefaultRunType(ctlObj, info) {
        return this.SetDefaultSelectValue("RunType", this.runTypes, !!(ctlObj.Value), true)
    }

    OnDefaultLocateMethod(ctlObj, info) {
        return this.SetDefaultSelectValue("LocateMethod", this.locateMethods, !!(ctlObj.Value), true)
    }

    OnDefaultLocateRegView(ctlObj, info) {
        return this.SetDefaultSelectValue("LocateRegView", this.regViews, !!(ctlObj.Value), true)
    }

    OnDefaultLocateRegStripQuotes(ctlObj, info) {
        return this.SetDefaultValue("LocateRegStripQuotes", !!(ctlObj.Value), true)
    }

    OnDefaultReplaceProcess(ctlObj, info) {
        return this.SetDefaultValue("ReplaceProcess", !!(ctlObj.Value), true)
    }

    OnDefaultProcessTimeout(ctlObj, info) {
        return this.SetDefaultValue("ProcessTimeout", !!(ctlObj.Value), true)
    }

    OnDefaultLocateRegKey(ctlObj, info) {
        return this.SetDefaultValue("LocateRegKey", !!(ctlObj.Value), true)
    }

    OnDefaultLocateRegValue(ctlObj, info) {
        return this.SetDefaultValue("LocateRegValue", !!(ctlObj.Value), true)
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

    OnDefaultRunMethod(ctlObj, info) {
        return this.SetDefaultSelectValue("RunMethod", this.runMethods, !!(ctlObj.Value), true)
    }

    OnDefaultProcessType(ctlObj, info) {
        val := this.SetDefaultSelectValue("ProcessType", this.processTypes, !!(ctlObj.Value), true)
        this.entityObj.UpdateDataSourceDefaults()
        this.guiObj["ProcessId"].Value := this.entityObj.ProcessId
        return val
    }

    OnDefaultProcessId(ctlObj, info) {
        return this.SetDefaultValue("ProcessId", !!(ctlObj.Value), true)
    }

    OnDefaultLauncherSpecificId(ctlObj, info) {
        return this.SetDefaultValue("LauncherSpecificId", !!(ctlObj.Value), false)
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

    OnProcessIdChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ProcessId := ctlObj.Value
    }

    OnWindowTitleChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.WindowTitle := ctlObj.Value
    }

    OnLauncherSpecificIdChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LauncherSpecificId := ctlObj.Value
    }

    OnLocateRegKeyChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LocateRegKey := ctlObj.Value
    }

    OnLocateRegValueChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LocateRegValue := ctlObj.Value
    }

    OnLocateRegStripQuotesChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LocateRegStripQuotes := !!(ctlObj.Value)
    }

    OnReplaceProcessChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ReplaceProcess := !!(ctlObj.Value)
    }

    OnProcessTimeoutChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ProcessTimeout := ctlObj.Value
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

    OnLocateMethodChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.LocateMethod := ctlObj.Text
    }

    OnProcessTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.ProcessType := ctlObj.Text
        this.entityObj.UpdateDataSourceDefaults()
        this.guiObj["ProcessId"].Value := this.entityObj.ProcessId
    }

    OnLocateRegViewChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entitObj.LocateRegView := ctlObj.Text
    }

    OnRunMethodChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.RunMethod := ctlObj.Text
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
