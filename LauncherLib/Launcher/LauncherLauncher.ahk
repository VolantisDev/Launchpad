#Include Launcher.ahk

class LauncherLauncher extends Launcher {
    launcherExe := ""

    __New(appDir, key, launcherType, game, options := "") {
        if (options == "") {
            options := Map()
        }
        
        this.launcherExe := launcherType.Has("exe") ? launcherType["exe"] : ""

        if (!options.Has("waitAfterClose")) {
            options["waitAfterClose"] := 5000
        }

        if (!options.Has("waitBehavior")) {
            options["waitBehavior"] := "sleep"
        }

        if (!options.Has("waitSleep")) {
            options["waitSleep"] := 5000
        }

        if (!options.Has("autoKillLauncher")) {
            options["autoKillLauncher"] := false
        }

        if (!options.Has("autoKillLauncherDelay")) {
            options["autoKillLauncherDelay"] := 1000
        }

        if (!options.Has("closeLauncherBefore")) {
            options["closeLauncherBefore"] := false
        }

        if (!options.Has("closeLauncherAfter")) {
            options["closeLauncherAfter"] := false
        }

        if (!options.Has("closeLauncherDelay")) {
            options["closeLauncherDelay"] := 10000 ; Override to leave time for cloud sync
        }

        super.__New(appDir, key, launcherType, game, options)
    }

    WaitLoopHandler() {
        if (this.options["autoKillLauncher"]) {
            ProcessClose(this.launcherExe)
            Sleep(this.options["autoKillLauncherDelay"])
        } else {
            if (this.options["waitBehavior"] == "prompt") {
                result := MsgBox(this.name . " is currently running. Please shut it down to continue.", this.name . " Running", 5)

                if (result == "Cancel") {
                    return true
                }
            } else {
                Sleep(this.options["waitSleep"])
            }
        }

        return false
    }

    WaitForClose() {
        Loop {
            pid := ProcessExist(this.launcherExe)

            if (pid != 0) {
                done := this.WaitLoopHandler()

                if (done) {
                    Break
                }
            } else {
                Sleep(this.options["waitAfterClose"])
                Break
            }
        }

        return true
    }

    LaunchGame() {
        if (this.options["closeLauncherBefore"]) {
            this.WaitForClose()
        }

        super.LaunchGame()
        
        if (this.options["closeLauncherAfter"]) {
            Sleep(this.options["closeLauncherDelay"])
            this.WaitForClose()
        }
    }
}
