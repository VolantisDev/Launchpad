class GameBase {
    key := ""
    config := ""
    pid := 0
    winId := 0
    isFinished := false

    __New(key, config := "") {
        if (config == "") {
            config := Map()
        }

        this.key := key
        this.config := config
    }

    RunGame(progress := "") {
        this.pid := this.GameIsRunning()
        isRunWait := (this.config["GameRunMethod"] == "RunWait")

        if (progress != "") {
            statusText := isRunWait ? "Starting and monitoring game..." : "Starting game..."
            progress.Increment(1, statusText)
        }

        if (this.pid == 0) {
            this.pid := this.RunGameAction(progress) ; Can change progress text but should not increment
        }

        result := this.WaitForGame(progress) ; this should always add 2 steps

        if (this.config["GameRunMethod"] == "Scheduled") {
            this.CleanupScheduledTask()
        }
        
        return result
    }

    GameIsRunning() {
        pid := ""

        if (this.config["GameProcessType"] == "Title") {
            pid := WinGetPID(this.config["GameProcessId"])
        } else if (this.config["GameProcessType"] == "Class") {
            pid := WinGetPID("ahk_class " . this.config["GameProcessId"]))
        } else { ; Default to Exe
            pid := ProcessExist(this.config["GameProcessId"])
        }

        if (pid == "") {
            pid := 0
        }

        this.pid := pid
        return pid
    }

    GameWindowIsOpen() {
        winId := 0

        if (this.config["GameProcessType"] == "Title") {
            winId := WinGetID(this.config["GameProcessId"])
        } else if (this.config["GameProcessType"] == "Class") {
            winId := WinGetID("ahk_class " . this.config["GameProcessId"])
        } else { ; Default to Exe
            pid := ProcessExist(this.config["GameProcessId"])
            winId := WinGetID("ahk_pid " . this.config["GameProcessId"])
        }

        if (winId == "") {
            winId := 0
        }

        this.winId := winId
        return winId
    }

    RunGameAction(progress := "") {
        runMethod := this.config["GameRunMethod"]
        if (runMethod == "Scheduled") {
            this.RunGameScheduled()
        } else { ; Assume Run or RunWait
            runCmd := this.config["GameRunMethod"]
            %runCmd%(this.GetRunCmd(),, "Hide")
        }

        return this.GameIsRunning()
    }

    RunGameScheduled() {
        taskName := "Launchpad\" . this.key
        runCmd := this.config["GameRunCmd"]
        currentTime := FormatTime(,"yyyyMMddHHmmss")
        runTime := FormatTime(DateAdd(currentTime, 2, "Seconds"), "HH:mm")
        cmd := "SCHTASKS /CREATE /SC ONCE /TN `"" . taskName . "`" /TR `"'" . runCmd . "'`" /ST " . runTime
        Run(cmd,, "Hide")
    }

    CleanupScheduledTask() {
        taskName := "Launchpad\" . this.key
        cmd := "SCHTASKS /DELETE /TN `"" . taskName . "`" /f"
        Run(cmd,, "Hide")
    }

    GetRunCmd() {
        return this.config["GameRunType"] == "Shortcut") ? this.config["GameShortcutSrc"] : this.config["GameRunCmd"]
    }

    WaitForGame(progress := "") {
        if (this.isFinished) {
            if (progress != "") {
                progress.Increment(2)
            }

            return true
        }

        winId := this.GameWindowIsOpen()

        if (this.winId == 0) {
            if (progress != "") {
                progress.Increment(1, "Waiting for game to open...")
            }

            winId := this.WaitForGameOpen()
        } else if (progress != "") {
            progress.Increment(1)
        }

        if (winId != 0) {
            if (progress != "") {
                progress.Increment(1, "Monitoring game...")
            }

            this.WaitForGameClose()
        } else if (progress != "") {
            progress.Increment(1)
        }

        this.isFinished := !this.GameIsRunning()
        return this.isFinished
    }

    WaitForGameOpen() {
        if (this.config["GameProcessType"] == "Title") {
            WinWait(this.config["GameProcessId"])
        } else if (this.config["GameProcessType"] == "Class") {
            WinWait("ahk_class " . this.config["GameProcessId"])
        } else { ; Default to Exe
            WinWait("ahk_exe " . this.config["GameProcessId"])
        }

        return this.GameWindowIsOpen()
    }

    WaitForGameClose() {
        if (this.config["GameProcessType"] == "Title") {
            WinWaitClose(this.config["GameProcessId"])
        } else if (this.config["GameProcessType"] == "Class") {
            WinWaitClose("ahk_class " . this.config["GameProcessId"])
        } else { ; Default to Exe
            WinWaitClose("ahk_exe " . this.config["GameProcessId"])
        }

        if (this.GameIsRunning()) {
            ProcessWaitClose(this.pid) ; @todo Figure out a good default timeout and how to handle that situation
        }

        return !this.GameIsRunning()
    }

    CountRunSteps() {
        return 3 ; Run, wait for open, wait for close
    }
}
