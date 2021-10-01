#WinActivateForce

class OverlayManager {
    exeName := "LaunchpadOverlay.exe"
    hwnd := 0
    tid := 0
    launchTime := ""
    additionalModifiers := []
    isShown := false
    lastWin := ""
    lastWinTid := 0
    appDir := ""
    launcherConfig := ""

    __New(appDir, launcherConfig) {
        this.appDir := appDir
        this.launcherConfig := launcherConfig
        this.launchTime := A_Now
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
            resourcesDir := this.launcherConfig["ResourcesDir"]
            path := resourcesDir . "\LaunchpadOverlay\" . this.exeName

            if (FileExist(path)) {
                Run(path, this.appDir,, &pid)
                this.hwnd := WinWait("ahk_pid " . pid)
                ;this.tid := DllCall("GetWindowThreadProcessId", "UInt", this.hwnd, "UInt", 0)
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

        activeHwnd := WinExist("A")

        if (!this.lastWin || this.lastWin != activeHwnd) {
            ;this.lastWinTid := DllCall("GetWindowThreadProcessId", "UInt", activeHwnd, "UInt", 0)
            this.lastWin := activeHwnd
            ;DllCall("SetParent", "UInt", this.hwnd, "UInt", activeHwnd)
            ;DllCall("AttachThreadInput", "UInt", this.tid, "UInt", this.lastWinTid, "Int", true)
        }
        
        detectHidden := A_DetectHiddenWindows
        DetectHiddenWindows(true)
        WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " . activeHwnd)
        WinShow("ahk_id " . this.hwnd)
        WinMove(winX, winY, winW, winH, "ahk_id " . this.hwnd)
        ;DllCall("SetFocus", "UInt", this.hwnd)
        WinActivate("ahk_id " . this.hwnd)
        DetectHiddenWindows(detectHidden)
        this.isShown := true
    }

    Hide() {
        if (this.hwnd) {
            detectHidden := A_DetectHiddenWindows
            DetectHiddenWindows(true)
            WinHide("ahk_id " . this.hwnd)
            ;DllCall("SetFocus", "UInt", this.lastWin)
            WinActivate("ahk_id " . this.lastWin)
            DetectHiddenWindows(detectHidden)
        }

        ;if (this.lastWinTid) {
        ;    DllCall("AttachThreadInput", "UInt", this.tid, "UInt", this.lastWinTid, "Int", false)
        ;}

        this.isShown := false
    }

    Close() {
        if (this.hwnd) {
            detectHidden := A_DetectHiddenWindows
            DetectHiddenWindows(true)

            try {
                ;if (this.lastWinTid) {
                ;    DllCall("AttachThreadInput", "UInt", this.tid, "UInt", this.lastWinTid, "Int", false)
                ;}

                ProcessClose("LaunchpadOverlay.exe")
            } catch Error as ex {
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
