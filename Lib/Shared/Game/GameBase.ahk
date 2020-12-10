class GameBase {
    key := ""
    config := ""
    pid := 0
    launchTime := ""
    winId := 0
    loadingWinId := 0
    isFinished := false

    __New(key, config := "") {
        if (config == "") {
            config := Map()
        }

        InvalidParameterException.CheckTypes("GameBase", "key", key, "", "config", config, "Map")
        this.key := key
        this.config := config
    }

    /**
    * IMPLEMENTED METHODS
    */

    RunGame(progress := "") {
        pid := this.GameIsRunning()
        isRunWait := (this.config["GameRunMethod"] == "RunWait")

        if (progress != "") {
            statusText := isRunWait ? "Starting and monitoring game..." : "Starting game..."
            progress.IncrementValue(1, statusText)
        }

        if (pid == 0 && !this.LoadingWindowIsOpen()) {
            pid := this.RunGameAction(progress) ; Can change progress text but should not increment
        }

        result := this.WaitForGame(progress) ; this should always add 3 steps

        if (progress != "") {
            progress.IncrementValue(1, "Game finished.")
        }
        
        this.CleanupAfterRun(progress)
        return result
    }

    CleanupAfterRun(progress := "") {
        if (this.config["GameRunMethod"] == "Scheduled") {
            if (progress != "") {
                progress.SetDetailText("Cleaning up scheduled task.")
            }

            this.CleanupScheduledTask()
        }
    }

    GameIsRunning() {
        pid := 0

        winId := this.GameWindowIsOpen()
        if (winId > 0) {
            pid := WinGetPID("ahk_id " . winId)
        }

        if (!pid) {
            pid := 0
        }

        this.pid := pid
        return pid
    }

    GameWindowIsOpen() {
        winId := 0

        if (this.config["GameProcessType"] == "Title") {
            winId := WinExist(this.config["GameProcessId"],, " - Launchpad")
        } else if (this.config["GameProcessType"] == "Class") {
            winId := WinExist("ahk_class " . this.config["GameProcessId"],, " - Launchpad")
        } else { ; Default to Exe
            winId := WinExist("ahk_exe " . this.config["GameProcessId"],, " - Launchpad")
        }

        if (winId == "") {
            winId := 0
        }

        this.winId := winId
        return winId
    }

    LoadingWindowIsOpen() {
        winId := 0

        if (this.config["GameLoadingWindowProcessType"] == "Title") {
            winId := WinExist(this.config["GameLoadingWindowProcessId"])
        } else if (this.config["GameLoadingWindowProcessType"] == "Class") {
            winId := WinExist("ahk_class " . this.config["GameLoadingWindowProcessId"])
        } else { ; Default to Exe
            winId := WinExist("ahk_exe " . this.config["GameLoadingWindowProcessId"])
        }

        if (winId == "") {
            winId := 0
        }

        this.loadingWinId := winId
        return (winId > 0)
    }

    RunGameAction(progress := "") {
        runMethod := this.config["GameRunMethod"]

        this.launchTime := A_Now
        
        if (runMethod == "Scheduled") {
            this.RunGameScheduled()
        } else { ; Assume Run or RunWait
            runCmd := this.config["GameRunMethod"]
            %runCmd%(this.GetRunCmd(), this.config["GameWorkingDir"], "Hide", this.pid)
        }

        if (runMethod != "RunWait" and this.config["GameReplaceProcess"]) {
            this.ReplaceGameProcess()
        }

        return this.GameIsRunning()
    }

    ReplaceGameProcess() {
        ; @todo wait for game process to exist using LocateGameProcess()
        ; @todo get existing process info
        ; @todo kill existing process
        ; @todo launch new process under Launchpad.exe with existing process info
    }

    LocateGameProcess() {
        ;wmi := ComObjGet("winmgmts:")
        ;queryEnum := wmi.ExecQuery("SELECT ProcessId, CreationDate FROM Win32_Process WHERE CreationDate > '{0}' AND Name LIKE '{1}%'")
        ; @todo finish the above
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
        return (this.config["GameRunType"] == "Shortcut") ? this.config["GameShortcutSrc"] : this.config["GameRunCmd"]
    }

    WaitForGame(progress := "") {
        if (this.isFinished) {
            if (progress != "") {
                progress.IncrementValue(2)
            }

            return true
        }

        winId := this.GameWindowIsOpen()
        loadingWinId := this.LoadingWindowIsOpen()

        if (progress != "") {
            progress.IncrementValue(1, this.config["GameHasLoadingWindow"] ? "Waiting for loading screen..." : "Waiting for game window...")
        }

        if (this.config["GameHasLoadingWindow"]) {
            if (winId == 0 and loadingWinId == 0) {
                loadingWinId := this.WaitForLoadingWindow()
            }

            if (progress != "") {
                progress.SetDetailText("Game is loading...")
            }
        }

        winId := this.GameWindowIsOpen()

        if (winId == 0) {
            winId := this.WaitForGameOpen()
        }

        if (winId != 0) {
            if (progress != "") {
                progress.IncrementValue(1, "Monitoring game...")
            }

            this.WaitForGameClose()

            if (progress != "") {
                progress.SetDetailText("Game window closed.")
                Sleep(1000)
            }

           
        } else if (progress != "") {
            progress.IncrementValue(1)
        }

        this.isFinished := !this.GameIsRunning()
        return this.isFinished
    }

    WaitForLoadingWindow() {
        ; @todo Run this in a loop that checks for both the loading screen and the game window
        if (this.config["GameLoadingWindowProcessType"] == "Title") {
            WinWait(this.config["GameLoadingWindowProcessId"],,, " - Launchpad")
        } else if (this.config["GameLoadingWindowProcessType"] == "Class") {
            WinWait("ahk_class " . this.config["GameLoadingWindowProcessId"],,, " - Launchpad")
        } else { ; Default to Exe
            WinWait("ahk_exe " . this.config["GameLoadingWindowProcessId"],,, " - Launchpad")
        }

        return this.LoadingWindowIsOpen()
    }

    WaitForGameOpen() {
        if (this.config["GameProcessType"] == "Title") {
            WinWait(this.config["GameProcessId"],,, " - Launchpad")
        } else if (this.config["GameProcessType"] == "Class") {
            WinWait("ahk_class " . this.config["GameProcessId"],,, " - Launchpad")
        } else { ; Default to Exe
            WinWait("ahk_exe " . this.config["GameProcessId"],,, " - Launchpad")
        }

        return this.GameWindowIsOpen()
    }

    WaitForGameClose() {
        if (this.config["GameProcessType"] == "Title") {
            WinWaitClose(this.config["GameProcessId"],,, " - Launchpad")
        } else if (this.config["GameProcessType"] == "Class") {
            WinWaitClose("ahk_class " . this.config["GameProcessId"],,, " - Launchpad")
        } else { ; Default to Exe
            WinWaitClose("ahk_exe " . this.config["GameProcessId"],,, " - Launchpad")
        }

        if (this.GameIsRunning()) {
            ProcessWaitClose(this.pid) ; @todo Figure out a good default timeout and how to handle that situation
        }

        return !this.GameIsRunning()
    }

    CountRunSteps() {
        steps := 4 ; Run, wait for open, wait for close, cleanup
        return steps
    }
}