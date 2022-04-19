class GameBase {
    app := ""
    key := ""
    config := ""
    launcherConfig := ""
    exeProcess := ""
    pid := 0
    launchTime := ""
    winId := 0
    loadingWinId := 0
    isOpen := false
    isFinished := false
    loopSleep := 250
    isLoadingWindowRunning := false
    isLoadingWindowFinished := false
    overlayStarted := false
    relaunchWaitSeconds := 1

    __New(app, key, config := "") {
        this.launchTime := A_Now

        if (config == "") {
            config := Map()
        }

        this.launcherConfig := app.Service("config.app")
        InvalidParameterException.CheckTypes("GameBase", "app", app, "AppBase", "key", key, "", "config", config, "Map")
        this.app := app
        this.key := key
        this.config := config
        this.exeProcess := this.GetExeProcess()
    }

    Log(message, level := "Debug") {
        if (this.app.Services.Has("logger") && this.launcherConfig["LoggingLevel"] != "None") {
            this.app.Service("logger").Log(this.key . ": " . message, level)
        }
    }

    /**
    * IMPLEMENTED METHODS
    */

    GetExeProcess() {
        if (this.exeProcess == "") {
            exe := ""

            if (this.config.Has("GameExe") && this.config["GameExe"] != "") {
                SplitPath(this.config["GameExe"], &exe)
            }

            this.exeProcess := ExeProcess(exe)
        }
        
        return this.exeProcess
    }

    RunGame(progress := "") {
        this.pid := this.GameIsRunning()
        isRunWait := (this.config["GameRunMethod"] == "RunWait")

        if (progress != "") {
            statusText := isRunWait ? "Starting and monitoring game..." : "Starting game..."
            progress.IncrementValue(1, statusText)
        }

        this.Log("Running game...", "Info")

        if (this.launcherConfig["EnableOverlay"]) {
            this.overlayCallbackObj := ObjBindMethod(this, "OverlayCallback")
            SetTimer(this.overlayCallbackObj, 500)
        }

        loadingWinId := 0

        if (this.config["GameHasLoadingWindow"]) {
            loadingWinId := this.LoadingWindowIsOpen()
        } else {
            this.isLoadingWindowFinished := true
        }

        if (this.pid == 0 && !loadingWinId) {
            this.pid := this.RunGameAction(progress)
        }

        if (progress != "") {
            progress.IncrementValue(1, this.config["GameHasLoadingWindow"] ? "Waiting for loading screen..." : "Waiting for game window...")
        }

        while (!this.isFinished) {
            if (this.isOpen) {
                winId := this.GameWindowIsOpen()

                if (!winId) {
                    if (!this.GameIsRunning() && !this.WaitForGameOpen(this.relaunchWaitSeconds)) {
                        progress.SetDetailText("Game window closed.")
                        Sleep(500)
                        this.isFinished := true
                        this.isOpen := false
                    }
                }
            } else {
                if (!this.isLoadingWindowFinished) {
                    loadingWinId := this.LoadingWindowIsOpen()

                    if (loadingWinId) {
                        if (progress != "") {
                            progress.SetDetailText("Game is loading...")
                        }

                        ; TODO: Get this timeout value from somewhere
                        timeoutVal := 60
                        WinWaitClose("ahk_id " . loadingWinId,, timeoutVal)
                        loadingWinId := this.LoadingWindowIsOpen()

                        if (!loadingWinId) {
                            this.isLoadingWindowFinished := true
                            progress.SetDetailText("Loading window closed.")
                        }
                    }
                }

                if (this.isLoadingWindowFinished) {
                    winId := this.GameWindowIsOpen()

                    if (winId != 0) {
                        this.pid := this.GameIsRunning()

                        if (progress != "") {
                            progress.IncrementValue(1, "Monitoring game...")
                        }

                        this.isOpen := true
                    }
                }
            }

            Sleep(this.loopSleep)
        }

        this.Log("Finished running game.", "Info")

        if (progress != "") {
            progress.IncrementValue(1, "Game finished.")
        }

        if (this.launcherConfig["EnableOverlay"] && this.overlayStarted) {
            this.StopOverlay()
            this.overlayStarted := false
        }
        
        this.CleanupAfterRun(progress)
        return true
    }

    OverlayCallback() {
        static conditions := AndGroup([
            SteamIsOpenCondition(this.app, true),
            SteamOverlayAttachedCondition(A_Now, this.app)
        ])

        if (this.isOpen) {
            if (this.launcherConfig["ForceOverlay"]) {
                this.StartOverlay()
                return
            }

            if (conditions.Evaluate()) {
                SetTimer(this.overlayCallbackObj, 0)
                return
            }

            if (DateDiff(A_Now, this.launchTime, "S") >= this.launcherConfig["OverlayWait"]) {
                this.StartOverlay()
                return
            }
        }
    }

    StartOverlay() {
        SetTimer(this.overlayCallbackObj, 0)
        this.Log("Starting Launchpad Overlay...")
        this.app.Service("manager.overlay").Start(this.launcherConfig["OverlayHotkey"])
        this.overlayStarted := true
    }

    StopOverlay() {
        if (this.overlayStarted) {
            this.Log("Shutting down Launchpad Overlay...")
            this.app.Service("manager.overlay").Close()
        }
    }

    CleanupAfterRun(progress := "") {
        if (this.config["GameRunMethod"] == "Scheduled") {
            if (progress != "") {
                progress.SetDetailText("Cleaning up scheduled task.")
            }

            this.Log("Closing overlay if running...")
            this.app.Service("manager.overlay").Close()
            this.Log("Cleaning up scheduled task(s)...")
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
            ; TODO: Replace title excludes with a better way to exclude the launcher window itself
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

        if (this.config["GameHasLoadingWindow"]) {
            if (this.config["GameLoadingWindowProcessType"] == "Title") {
                winId := WinExist(this.config["GameLoadingWindowProcessId"])
            } else if (this.config["GameLoadingWindowProcessType"] == "Class") {
                winId := WinExist("ahk_class " . this.config["GameLoadingWindowProcessId"])
            } else { ; Default to Exe
                winId := WinExist("ahk_exe " . this.config["GameLoadingWindowProcessId"])
            }
        }

        if (winId == "") {
            winId := 0
        }

        this.loadingWinId := winId
        return winId
    }

    RunGameAction(progress := "") {
        runMethod := this.config["GameRunMethod"]

        this.launchTime := A_Now

        this.pid := 0
        
        if (runMethod == "Scheduled") {
            this.RunGameScheduled()
        } else if (runMethod == "Macro") {
            this.RunGameMacro()
        } else {
            this.pid := this.RunGameRun()
        }

        if (runMethod != "RunWait" && this.config["GameReplaceProcess"]) {
            this.pid := this.ReplaceGameProcess()
        }

        if (this.pid == 0) {
            this.pid := this.GameIsRunning()
        }

        return this.pid
    }

    ReplaceGameProcess() {
        this.Log("Replacing existing game process...")
        newPid := this.exeProcess.ReplaceProcess(this.launchTime)

        if (!newPid) {
            throw OperationFailedException("Could not replace game process.")
        }

        this.pid := newPid
        return newPid
    }

    RunGameScheduled() {
        this.RunScheduledTask("Launchpad\" . this.key, this.config["GameRunCmd"])
    }

    RunScheduledTask(taskname, runCmd) {
        this.Log("Running scheduled task " . runCmd)
        currentTime := FormatTime(,"yyyyMMddHHmmss")
        runTime := FormatTime(DateAdd(currentTime, 0, "Seconds"), "HH:mm")
        RunWait("SCHTASKS /CREATE /SC ONCE /TN `"" . taskName . "`" /TR `"'" . runCmd . "'`" /ST " . runTime . " /f",, "Hide")
        RunWait("SCHTASKS /RUN /TN `"" . taskName . "`"",, "Hide")
        Run("SCHTASKS /DELETE /TN `"" . taskName . "`" /f",, "Hide")
    }

    RunGameRun() {
        runCmd := this.config["GameRunMethod"]
        pid := ""
        this.Log("Running task with " . runCmd)
        %runCmd%(this.GetRunCmd(), this.config["GameWorkingDir"], "Hide", &pid)
        return pid
    }

    RunGameMacro() {
        ; TODO: Implement definable macro steps to automate running a game without writing code
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
            if (winId == 0 && loadingWinId == 0) {
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
        ; TODO: Run a loop that checks for both the loading screen and the game window
        if (this.config["GameLoadingWindowProcessType"] == "Title") {
            WinWait(this.config["GameLoadingWindowProcessId"],,, " - Launchpad")
        } else if (this.config["GameLoadingWindowProcessType"] == "Class") {
            WinWait("ahk_class " . this.config["GameLoadingWindowProcessId"],,, " - Launchpad")
        } else { ; Default to Exe
            WinWait("ahk_exe " . this.config["GameLoadingWindowProcessId"],,, " - Launchpad")
        }

        return this.LoadingWindowIsOpen()
    }

    WaitForGameOpen(timeout := "") {
        if (this.config["GameProcessType"] == "Title") {
            WinWait(this.config["GameProcessId"],, timeout, " - Launchpad")
        } else if (this.config["GameProcessType"] == "Class") {
            WinWait("ahk_class " . this.config["GameProcessId"],, timeout, " - Launchpad")
        } else { ; Default to Exe
            WinWait("ahk_exe " . this.config["GameProcessId"],, timeout, " - Launchpad")
        }

        return this.GameWindowIsOpen()
    }

    WaitForGameClose() {
        closed := false

        while (!closed) {
            if (this.config["GameProcessType"] == "Title") {
                WinWaitClose(this.config["GameProcessId"],,, " - Launchpad")
            } else if (this.config["GameProcessType"] == "Class") {
                WinWaitClose("ahk_class " . this.config["GameProcessId"],,, " - Launchpad")
            } else { ; Default to Exe
                WinWaitClose("ahk_exe " . this.config["GameProcessId"],,, " - Launchpad")
            }

            if (this.GameIsRunning()) {
                ProcessWaitClose(this.pid)
            }

            if (!this.WaitForGameOpen(this.relaunchWaitSeconds)) {
                closed := true
            }
        }

        return !this.GameIsRunning()
    }

    CountRunSteps() {
        steps := 4 ; Run, wait for open, wait for close, cleanup
        return steps
    }

    __Delete() {
        this.StopOverlay()
        super.__Delete()
    }

    WaitForColor(checkColors, winTitle, xOffset, yOffset, sleepTime := 250, timeout := 30) {
        if (!HasBase(checkColors, Array.Prototype)) {
            checkColors := [checkColors]
        }

        colorFound := false
        pixelCoordMode := A_CoordModePixel
        CoordMode("Pixel", "Window")
        maxTries := (timeout * 1000) / sleepTime
        currentTry := 0

        while (!colorFound) {
            currentTry++

            if (currentTry >= maxTries) {
                break
            }

            if (!WinActive(winTitle)) {
                WinActivate(winTitle)
            }

            WinGetClientPos(,,, &winH, winTitle)
            checkX := xOffset
            checkY := winH + yOffset
            pixelColor := PixelGetColor(checkX, checkY)
            rgbColor := SubStr(pixelColor, 3)

            for index, checkColor in checkColors {
                if (StrUpper(rgbColor) == StrUpper(checkColor)) {
                    colorFound := true
                    break
                }
            }

            if (!colorFound) {
                Sleep(sleepTime)
            }
        }

        CoordMode("Pixel", pixelCoordMode)
        return colorFound
    }
}
