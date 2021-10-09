class ManagedLauncherEditor extends ManagedEntityEditorBase {
    closeMethods := ["Prompt", "Wait", "Auto", "AutoPolite", "AutoKill"]

    __New(app, themeObj, guiId, entityObj, mode := "config", owner := "", parent := "") {
        super.__New(app, themeObj, guiId, entityObj, "Managed Launcher Editor", mode, owner, parent)
    }

    CustomTabControls() {
        ctl := this.AddEntityCtl("", "LauncherCloseBeforeRun", true, "BasicControl", "CheckBox", "Close launcher before run")
        ctl.ctl.ToolTip := "If selected, the launcher will be closed before attempting to run the game. This can be useful to ensure the process starts under " . this.app.appName . "'s process instead of the existing launcher's process."
        ctl := this.AddEntityCtl("", "LauncherCloseAfterRun", true, "BasicControl", "CheckBox", "Close launcher after run")
        ctl.ctl.ToolTip := "If selected, the launcher will be closed after the game closes. This can be useful to ensure Steam or other applications know you are done playing the game."
        this.AddEntityCtl("Launcher Close Method", "LauncherCloseMethod", true, "SelectControl", this.closeMethods, "", "Prompt: Show a prompt that allows the user to either trigger a recheck or cancel waiting for the launcher to close`nWait: Waits up to WaitTimeout seconds for the launcher to close on its own.`nAuto: Make one polite close attempt, wait a bit, then kill the process if it is still running.`nAutoPolite: Attempt to close the launcher politely, but do not forcefully kill it if it's still running.`nAutoKill: Automatically close the launcher by force without a polite attempt.")
        ctl := this.AddEntityCtl("Launcher Wait Timeout", "LauncherWaitTimeout", true, "EditControl", 1, "", "How many seconds to wait for the launcher to close before giving up.")
        ctl.ctl.Opt("Number")
        ctl := this.AddEntityCtl("Launcher Polite Close Wait", "LauncherPoliteCloseWait", true, "EditControl", 1, "", "How many seconds to give the launcher to close after asking politely before forcefully killing it (if applicable)")
        ctl.ctl.Opt("Number")
    }

    ExtraTabControls(tabs) {
        tabs.UseTab("Delays")
        ctl := this.AddEntityCtl("Close Launcher Pre-Delay", "LauncherClosePreDelay", true, "EditControl", 1, "", "How many MS to wait before closing the launcher, which can be useful to allow time for cloud saves to sync")
        ctl.ctl.Opt("Number")
        ctl := this.AddEntityCtl("Close Launcher Post-Delay", "LauncherClosePostDelay", true, "EditControl", 1, "", "How many MS to wait after closing the launcher, which can be useful to allow time for helper processes to fully exit")
        ctl.ctl.Opt("Number")
        ctl := this.AddEntityCtl("Kill Launcher Pre-Delay", "LauncherKillPreDelay", true, "EditControl", 1, "", "How many MS to wait before forcefully killing the launcher. This is in addition to any existing delays.")
        ctl.ctl.Opt("Number")
        ctl := this.AddEntityCtl("Kill Launcher Post-Delay", "LauncherKillPostDelay", true, "EditControl", 1, "", "How many MS to wait after forcefully killing the launcher. This is in addition to any existing delays.")
        ctl.ctl.Opt("Number")
        ctl := this.AddEntityCtl("Launcher Recheck Delay", "LauncherRecheckDelay", true, "EditControl", 1, "", "How many MS to wait between " . this.app.appName . " checking if the launcher is running or not. Lower numbers increase " . this.app.appName . "'s responsiveness, but use more CPU.")
        ctl.ctl.Opt("Number")
    }

    GetTabNames() {
        tabNames := super.GetTabNames()
        tabNames.Push("Delays")
        return tabNames
    }

    OnLauncherInstallDirMenuClick(btn) {
        this.OnDirMenuClick("LauncherInstallDir", btn, "Select the launcher's installation directory")
    }

    OnLauncherWorkingDirMenuClick(btn) {
        this.OnDirMenuClick("LauncherWorkingDir", btn, "Select the launcher's working directory")
    }

    OnLauncherExeMenuClick(btn) {
        this.OnFileMenuClick("LauncherExe", btn, "Select the launcher's executable file", "Executables (*.exe)")
    }

    OnLauncherShortcutSrcMenuClick(btn) {
        this.OnFileMenuClick("LauncherShortcutSrc", btn, "Select a shortcut file or .exe that will launch the application", "Shortcuts (*.lnk; *.url; *.exe)")
    }
}
