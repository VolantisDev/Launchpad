class LauncherBase {
    key := ""
    game := ""
    config := ""
    pid := 0

    __New(key, launcherType, game, config := "") {
        if (config == "") {
            config := Map()
        }

        this.key := key
        this.game := game
        this.config := config
    }

    LaunchGame() {
        if (this.config["LauncherCloseBeforeRun"]) {
            this.CloseLauncher("BeforeRun")
        }

        result := this.LaunchGameAction()

        if (this.config["LauncherCloseAfterRun"]) {
            this.CloseLauncher("AfterRun")
        }

        return result
    }

    LaunchGameAction() {
        return this.game.RunGame()
    }

    CloseLauncher(eventName) {
        if (this.LauncherIsRunning()) {
            return true
        }

        if (this.config["LauncherClosePreDelay"] > 0) {
            Sleep(this.config["LauncherClosePreDelay"] * 1000)
        }

        closed := this.CloseLauncherAction()

        if (closed and this.config["LauncherClosePostDelay"] > 0) {
            Sleep(this.config["LauncherClosePostDelay"] * 1000)
        }

        return closed
    }

    CloseLauncherAction() {
        closed := false

        if (this.config["CloseMethod"] == "Wait") {
            closed := this.WaitForLauncherToClose()
        } else if (this.config["CloseMethod"] == "Auto") {
            closed := this.AutoCloseLauncher(true)
        } else if (this.config["CloseMethod"] == "AutoPolite") {
            closed := this.AutoCloseLauncher()
        } else if (this.config["CloseMethod"] == "AutoKill") {
            closed := this.KillLauncher()
        } else { ; Default to "Prompt"
            closed := this.PromptForLauncherToClose()
        }

        return closed
    }

    LauncherIsRunning() {
        pid := ""

        if (this.config["LauncherProcessType"] == "Title") {
            pid := WinGetPID(this.config["ProcessId"])
        } else if (this.config["LauncherProcessType"] == "Class") {
            pid := WinGetPID("ahk_class " . this.config["ProcessId"]))
        } else { ; Default to Exe
            pid := ProcessExist(this.config["ProcessId"])
        }

        if (pid == "") {
            pid := 0
        }

        this.pid := pid
        return pid
    }

    WaitForLauncherToClose() {
        isRunning := this.LauncherIsRunning()

        if (isRunning) {
            startTime := FormatTime(,"yyyyMMddHHmmss")

            Loop {
                isRunning := this.LauncherIsRunning()

                If (!isRunning) {
                    break
                }

                if (DateDiff(FormatTime(,"yyyyMMddHHmmss"), startTime, "Seconds") >= this.config["WaitTimeout"]) {
                    break
                }

                this.WaitLoopAction()
            }
        }
        
        return isRunning
    }

    WaitLoopAction() {
        if (this.config["RecheckDelay"] > 0) {
            Sleep(this.config["RecheckDelay"] * 1000)
        }
    }

    AutoCloseLauncher(force := false) {
        isRunning := this.LauncherIsRunning()

        if (isRunning) {
            this.AutoCloseAction()
        }

        isRunning := this.LauncherIsRunning()

        if (isRunning and force) {
            isRunning := this.KillLauncher()
        }
        
        return KillLauncher
    }

    AutoCloseAction() {
        if (this.pid > 0) {
            WinClose("ahk_pid " . this.pid, "", this.config["PoliteCloseWait"])
        }
    }

    KillLauncher() {
        isRunning := this.LauncherIsRunning()

        if (isRunning) {
            if (this.config["LauncherKillPreDelay"] > 0) {
                Sleep(this.config["LauncherKillPreDelay"] * 1000)
                isRunning := this.LauncherIsRunning()
            }

            if (isRunning) {
                this.KillLauncherAction()

                if (this.config["LauncherKillPostDelay"] > 0) {
                    Sleep(this.config["LauncherKillPostDelay"] * 1000)
                }

                isRunning := this.LauncherIsRunning()
            }
        }

        return isRunning
    }

    KillLauncherAction() {
        if (this.pid > 0) {
            ProcessClose(this.pid)
        }
    }

    PromptForLauncherToClose() {
        ; @todo Implement GUI class and instantiate it here
    }
}
