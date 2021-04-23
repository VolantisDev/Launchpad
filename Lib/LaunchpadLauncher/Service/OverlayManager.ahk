#WinActivateForce

class OverlayManager extends AppServiceBase {
    exeName := "LaunchpadOverlay.exe"
    hwnd := 0
    launchTime := ""
    additionalModifiers := []
    isShown := false
    lastWin := ""

    __New(app) {
        this.launchTime := A_Now
        super.__New(app)
    }

    IsRunning() {
        return !!(this.GetHwnd())
    }

    GetHwnd() {
        detectHidden := A_DetectHiddenWindows
        DetectHiddenWindows(true)
        this.hwnd := WinExist("ahk_exe " . this.exeName)
        DetectHiddenWindows(detectHidden)
        return this.hwnd
    }

    Start(overlayHotkey := "^Tab") {
        hwnd := this.GetHwnd()

        if (!hwnd) {
            config := this.app.Service("LauncherConfig")
            resourcesDir := config["ResourcesDir"]
            path := resourcesDir . "\LaunchpadOverlay\" . this.exeName

            if (FileExist(path)) {
                Run(path, this.app.appDir,, pid)
                this.hwnd := WinWait("ahk_pid " . pid)
                WinHide("ahk_id " . this.hwnd)
            } else {
                ; TODO Log an error about not being able to launch the overlay
            }
        }

        Hotkey(overlayHotkey, ObjBindMethod(this, "ToggleOverlay"))
    }

    ToggleOverlay(*) {
        if (this.isShown) {
            this.Hide()
        } else {
            this.Show()
        }
    }

    Show() {
        if (!this.hwnd) {
            this.Start()
        }

        attach := false

        activeHwnd := WinExist("A")

        if (!this.lastWin || this.lastWin != activeHwnd) {
            this.lastWin := activeHwnd
            DllCall("SetParent", "UInt", this.hwnd, "UInt", activeHwnd)
            attach := true
        }
        
        detectHidden := A_DetectHiddenWindows
        DetectHiddenWindows(true)
        WinGetPos(winX, winY, winW, winH, "ahk_id " . activeHwnd)
        WinShow("ahk_id " . this.hwnd)
        WinMove(winX, winY, winW, winH, "ahk_id " . this.hwnd)
        ;WinActivate("ahk_id " . this.hwnd)
        DetectHiddenWindows(detectHidden)
        this.isShown := true
    }

    Hide() {
        if (this.hwnd) {
            detectHidden := A_DetectHiddenWindows
            DetectHiddenWindows(true)
            WinHide("ahk_id " . this.hwnd)
            DetectHiddenWindows(detectHidden)

            ;if (this.lastWin) {
                ; WinActivate("ahk_id " . this.lastWin)
                ; this.lastWin := ""
            ;}
        }

        this.isShown := false
    }

    Close() {
        if (this.hwnd) {
            detectHidden := A_DetectHiddenWindows
            DetectHiddenWindows(true)

            try {
                ProcessClose("LaunchpadOverlay.exe")
            } catch ex {
                ; Ignore failure
            }
            
            DetectHiddenWindows(detectHidden)
            this.hwnd := 0
            this.isShown := false
        }
    }

    __Delete() {
        this.Close()
        super.__Delete()
    }
}
