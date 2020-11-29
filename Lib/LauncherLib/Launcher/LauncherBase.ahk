class LauncherBase {
    key := ""
    game := ""
    config := ""
    pid := 0
    progress := ""

    __New(key, game, config := "") {
        if (config == "") {
            config := Map()
        }

        this.key := key
        this.game := game
        this.config := config

        if (this.config["LauncherShowProgress"]) {
            this.CreateProgressGui()
        }
    }

    CreateProgressGui() {
        if (this.progress == "") {
            progressTitle := StrReplace(this.config["LauncherProgressTitle"], "{g}", this.config["DisplayName"])
            progressText := StrReplace(this.config["LauncherProgressText"], "{g}", this.config["DisplayName"])
            this.progress := ProgressIndicator.new(progressTitle, progressText, "", false, this.CountLaunchSteps())
        }
    }

    CountLaunchSteps() {
        launchSteps := 0

        if (this.config["LauncherCloseBeforeRun"]) {
            launchSteps++
        }

        if (this.config["LauncherCloseAfterRun"]) {
            launchSteps++
        }

        return launchSteps + this.game.CountRunSteps()
    }

    LaunchGame() {
        if (this.progress != "") {
            this.progress.Show()
            this.progress.SetDetailText("Initializing launcher...")
        }
        

        if (this.config["LauncherCloseBeforeRun"]) {
            if (this.progress != "") {
                this.progress.IncrementValue(1, "Closing existing game launcher...")
            }

            this.CloseLauncher("BeforeRun")
        }

        result := this.LaunchGameAction()

        if (this.config["LauncherCloseAfterRun"]) {
            if (this.progress != "") {
                this.progress.IncrementValue(1, "Closing existing game launcher...")
            }

            this.CloseLauncher("AfterRun")
        }

        if (this.progress != "") {
            this.progress.Finish()
        }

        return result
    }

    LaunchGameAction() {
        return this.game.RunGame(this.progress)
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
            pid := WinGetPID(this.config["LauncherProcessId"])
        } else if (this.config["LauncherProcessType"] == "Class") {
            pid := WinGetPID("ahk_class " . this.config["LauncherProcessId"])
        } else { ; Default to Exe
            pid := ProcessExist(this.config["LauncherProcessId"])
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
        
        return isRunning
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
