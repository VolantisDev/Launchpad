class OverlayManager extends AppServiceBase {
    exeName := "LaunchpadOverlay.exe"
    pid := 0
    launchTime := ""
    additionalModifiers := []
    isShown := false

    __New(app) {
        this.launchTime := A_Now
        super.__New(app)
    }

    IsRunning() {
        return !!(this.GetPid())
    }

    GetPid() {
        pid := 0
        detectHidden := A_DetectHiddenWindows
        DetectHiddenWindows(true)
        pid := WinExist("ahk_exe " . this.exeName)
        DetectHiddenWindows(detectHidden)
        this.pid := pid
        return pid
    }

    Start(overlayHotkey := "Alt+Shift+Tab") {
        pid := this.GetPid()

        if (!pid) {
            config := this.app.Service("LauncherConfig")
            resourcesDir := config["ResourcesDir"]
            path := resourcesDir . "\LaunchpadLauncher\" . this.exeName

            if (FileExist(path)) {
                Run(path, this.app.appDir,, pid)
                this.pid := pid
                WinWait("ahk_pid " . pid)
                WinHide("ahk_pid " . pid)
            } else {
                ; TODO Log an error about not being able to launch the overlay
            }
        }

        keys := StrSplit(overlayHotkey, "+")
        removeLength := 1
        initialCombo := keys[1]

        if (keys.Length > 1) {
            initialCombo .= " & " . keys[2]
            removeLength += 1
        }

        keys.RemoveAt(1, removeLength)
        this.additionalModifiers := keys

        ; TODO: Use dynamic hotkey passed in from config
        hotkeys := "+{Tab}"
        Hotkey(hotkeys, ObjBindMethod(this, "ToggleOverlay"))
    }

    ToggleOverlay(*) {
        if (this.isShown) {
            Send(hotkeys)
            this.Hide()
        } else {
            this.Show()
            Send(hotkeys)
        }
    }

    Show() {
        if (!this.pid) {
            this.Start()
        }

        WinShow("ahk_pid " . this.pid)
        this.isShown := true
    }

    Hide() {
        if (this.pid) {
            WinHide("ahk_pid " . this.pid)
        }

        this.isShown := false
    }

    Close() {
        if (this.pid) {
            WinClose("ahk_pid" . this.pid)
            this.pid := 0
            this.isShown := false
        }
    }

    __Delete() {
        this.Close()
        super.__Delete()
    }
}
