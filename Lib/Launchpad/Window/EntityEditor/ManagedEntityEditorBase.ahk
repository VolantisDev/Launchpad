/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class ManagedEntityEditorBase extends EntityEditorBase {
    runTypes := ["Command", "Shortcut"]
    processTypes := ["Exe", "Title", "Class"]
    runMethods := ["Run", "Scheduled", "RunWait"]
    locateMethods := ["Search", "Registry", "BlizzardProductDb"]
    regViews := ["32"]
    entityTypeName := ""

    __New(app, themeObj, windowKey, entityObj, title, mode := "config", owner := "", parent := "") {
        if (owner == "") {
            owner := "LauncherEditor"
        }

        if (this.entityTypeName == "") {
            this.entityTypeName := entityObj.configPrefix
        }

        if (A_Is64bitOS) {
            this.regViews.Push("64")
        }

        super.__New(app, themeObj, windowKey, entityObj, title, mode, owner, parent)
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
        this.AddEntityCtl(prefix . " Executable", prefix . "Exe", true, "LocationBlock", prefix . "Exe", "Clear", true, "The main .exe file, not including any path information.")
        this.AddTextBlock("WindowTitle", prefix . " Window Title", true, "The part of the main window's title which identifies it uniquely.", true)
        this.CustomTabControls()

        tabs.UseTab("Sources", true)
        this.AddEntityCtl(prefix . " Install Directory", prefix . "InstallDir", true, "LocationBlock", prefix . "InstallDir", "Clear", true, "Select the installation folder, or use default for auto-detection.")
        this.AddEntityCtl(prefix . " Working Directory", prefix . "WorkingDir", true, "LocationBlock", prefix . "WorkingDir", "Clear", true, "Optionally, set a working directory to run from. This is not often required.")
        this.AddEntityCtl(prefix . " Install Locate Method", prefix . "LocateMethod", true, "SelectControl", this.locateMethods, "On" . prefix . "LocateMethodChange", "Search: Searches a list of possible directories (Defaulting to some common possibilities) for the .exe file and uses that directory`nRegistry: Looks for the provided registry key and uses its value as the install path if present`nBlizzardProductDb: Searches for LauncherSpecificId within the Blizzard product.db file if present")
        
        this.AddTextBlock("LauncherSpecificId", prefix . " Launcher-Specific ID", true, "If required, an ID that the launcher uses to reference this item", true)
        
        tabs.UseTab("Registry", true)
        this.AddEntityCtl("Locate Registry View", prefix . "LocateRegView", true, "SelectControl", this.regViews, "On" . prefix . "LocateRegViewChange", "The registry view to use when locating the install dir")
        this.AddTextBlock("LocateRegKey", "Locate Registry Key", true, "The registry key to look up the install dir within. Path parts should be separated with backslashes and must start with one of: HKEY_LOCAL_MACHINE, HKEY_USERS, HKEY_CURRENT_USER, HKEY_CLASSES_ROOT, HKEY_CURRENT_CONFIG, or the abbreviation of one of those. To read from a remote registry, prefix the root path with two backslashes and the computer name.`n`nSimple example: HKLM\Path\To\Key`nRemote example: \\OTHERPC\HKLM\Path\To\Key", true)
        this.AddTextBlock("LocateRegValue", "Locate Registry Value", true, "The name of the registry value to look up within the specified key.`n`nExample: InstallPath", true)
        this.AddCheckBoxBlock("LocateRegStripQuotes", "Strip quotes from registry value", true, "", true)
        
        tabs.UseTab("Running", true)
        this.AddEntityCtl(prefix . " Run Type", prefix . "RunType", true, "SelectControl", this.runTypes, "On" . prefix . "RunTypeChange")
        this.AddTextBlock("RunCmd", prefix . " Run Command", true, "", true)
        this.AddEntityCtl(prefix . " Shortcut", prefix . "ShortcutSrc", true, "LocationBlock", prefix . "ShortcutSrc", "Clear", true, "Select the shortcut that will launch the program.")
        this.AddEntityCtl(prefix . " Run Method", prefix . "RunMethod", true, "SelectControl", this.runMethods, "On" . prefix . "RunMethodChange", "RunWait: The simplest method when it works, runs a process and waits for it to complete in one command`nRun: The most compatible method, runs a process and then separately waits for it to start`nScheduled: Helpful to avoid " . this.app.appName . " owning the process, this creates a scheduled task that will run the process immediately and then delete itself")

        tabs.UseTab("Process", true)
        ctl := this.AddEntityCtl(prefix . " Process Detection Type", prefix . "ProcessType", true, "SelectControl", this.processTypes, "On" . prefix . "ProcessTypeChange", "Exe: Use the .exe filename to detect this item's process`nTitle: Use all or part of the window title to detect this item's process`nClass: Use the window class name to detect this item's process")
        ctl.AddDependentField(prefix . "ProcessId")
        ctl := this.AddTextBlock(prefix . "ProcessId", prefix . " Process ID", true, "This value depends on the Process Type selected above, and can often be determined automatically.", false)
        ctl := this.AddNumberBlock("ProcessTimeout", "Process Timeout", true, "How long to wait when detecting this items' process", true)
        this.AddCheckBoxBlock("ReplaceProcess", "Replace process after launching", true, "After the process is detected, immediately kill and re-launch it so that " . this.app.appName . " is its parent process.", true)
        
        ;tabs.UseTab()
        this.ExtraTabControls(tabs)
        tabs.UseTab()
    }

    CustomTabControls() {
        ; Assume no custom tab controls unless overridden.
    }

    ExtraTabControls(tabs) {
        ; Assume no extra tab controls unless overridden.
    }

    OnDefaultWindowTitle(ctlObj, info) {
        return this.SetDefaultValue("WindowTitle", !!(ctlObj.Value), true)
    }

    OnDefaultRunCmd(ctlObj, info) {
        return this.SetDefaultValue("RunCmd", !!(ctlObj.Value), true)
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

    OnDefaultProcessId(ctlObj, info) {
        return this.SetDefaultValue("ProcessId", !!(ctlObj.Value), true)
    }

    OnDefaultLauncherSpecificId(ctlObj, info) {
        return this.SetDefaultValue("LauncherSpecificId", !!(ctlObj.Value), true)
    }

    OnTypeChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.EntityType := ctlObj.Text
        this.entityObj.UpdateDataSourceDefaults()
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

    OnDirMenuClick(field, btn, text := "") {
        if (text == "") {
            text := "Select the directory"
        }

        if (btn == "Change" . field) {
            existingVal := this.entityObj.GetConfigValue(field)

            if existingVal {
                existingVal := "*" . existingVal
            }

            dir := DirSelect(existingVal, 2, this.entityObj.configPrefix . ": " . text)

            if (dir) {
                this.entityObj.SetConfigValue(field, dir)
                this.guiObj[field].Text := dir
            }
        } else if (btn == "Open" .field) {
            val := this.entityObj.GetConfigValue(field)

            if (val) {
                Run val
            }
        } else if (btn == "Clear" . field) {
            this.entityObj.SetConfigValue(field, "")
            this.guiObj[field].Text := ""
        }
    }

    OnRunCmdChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.RunCmd := ctlObj.Text
    }

    OnFileMenuClick(field, btn, text := "", selector := "") {
        if (text == "") {
            text := "Select the file"
        }

        if (selector == "") {
            selector := "All Files (*.*)"
        }

        if (btn == "Change" . field) {
            existingVal := this.entityObj.GetConfigValue(field)

            if (!existingVal) {
                existingVal := this.entityObj.GetConfigValue(field)
            }

            file := FileSelect(1, existingVal, text, selector)

            if (file) {
                this.entityObj.SetConfigValue(field, file)
                this.guiObj[field].Text := file
            }
        } else if (btn == "Open" . field) {
            val := this.entityObj.GetConfigValue(field)

            if (val) {
                Run val
            }
        } else if (btn == "Clear" . field) {
            this.entityObj.SetConfigValue(field, "")
            this.guiObj[field].Text := ""
        }
    }
}
