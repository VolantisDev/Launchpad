class LauncherLauncher extends Launcher {
    launcherExe := ""

    __New(appDir, key, launcherType, game, options := {}) {
        this.launcherExe := launcherType.hasKey("exe") ? launcherType.exe : ""

        if (!options.hasKey("waitAfterClose")) {
            options.waitAfterClose := 5000
        }

        if (!options.hasKey("waitBehavior")) {
            options.waitBehavior := "sleep"
        }

        if (!options.hasKey("waitSleep")) {
            options.waitSleep := 5000
        }

        if (!options.hasKey("autoKillLauncher")) {
            options.autoKillLauncher := false
        }

        if (!options.hasKey("autoKillLauncherDelay")) {
            options.autoKillLauncherDelay := 1000
        }

        if (!options.hasKey("closeLauncherBefore")) {
            options.closeLauncherBefore := false
        }

        if (!options.hasKey("closeLauncherAfter")) {
            options.closeLauncherAfter := false
        }

        if (!options.hasKey("closeLauncherDelay")) {
            options.closeLauncherDelay := 10000 ; Override to leave time for cloud sync
        }

        base.__New(appDir, key, launcherType, game, options)
    }

    WaitLoopHandler() {
        if (this.options.autoKillLauncher) {
            Process, Close, % this.launcherExe
            Sleep, % this.options.autoKillLauncherDelay
        } else {
            if (this.options.waitBehavior == "prompt") {
                MsgBox, 5, % this.name . " Running", % this.name . " is currently running. Please shut it down to continue.", 5

                IfMsgBox Cancel
                {
                    return true
                }
            } else {
                Sleep, % this.options.waitSleep
            }
        }

        return false
    }

    WaitForClose() {
        Loop {
            Process, Exist, % this.launcherExe

            if (ErrorLevel != 0) {
                done := this.WaitLoopHandler()
                if (done) {
                    Break
                }
            } else {
                Sleep,% this.options.waitAfterClose
                Break
            }
        }

        return true
    }

    LaunchGame() {
        if (this.options.closeLauncherBefore) {
            this.WaitForClose()
        }

        base.LaunchGame()
        
        if (this.options.closeLauncherAfter) {
            Sleep,% this.options.closeLauncherDelay
            this.WaitForClose()
        }
    }
}
