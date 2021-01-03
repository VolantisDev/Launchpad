class LauncherBase {
    eventManager := ""
    idGenerator := ""
    key := ""
    game := ""
    config := ""
    pid := 0
    progress := ""

    __New(key, game, config := "") {
        this.eventManager := EventManager.new()
        this.idGenerator := UuidGenerator.new()

        if (config == "") {
            config := Map()
        }

        InvalidParameterException.CheckTypes("LauncherBase", "key", key, "", "game", game, "GameBase", "config", config, "Map")
        this.key := key
        this.game := game
        this.config := config

        if (this.config["ShowProgress"]) {
            this.CreateProgressGui()
        }
    }

    /**
    * IMPLEMENTED METHODS
    */

    CreateProgressGui() {
        if (this.progress == "") {
            progressTitle := StrReplace(this.config["ProgressTitle"], "{g}", this.config["DisplayName"])
            progressText := StrReplace(this.config["ProgressText"], "{g}", this.config["DisplayName"])
            themeObj := JsonTheme.new(this.config["ThemeName"], this.config["ThemesDir"], this.eventManager, this.idGenerator, true)
            this.progress := ProgressIndicator.new(progressTitle, themeObj, progressText, "", "", "", false, this.CountLaunchSteps())
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
        if (!this.LauncherIsRunning()) {
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

        if (this.config["LauncherCloseMethod"] == "Wait") {
            closed := this.WaitForLauncherToClose()
        } else if (this.config["LauncherCloseMethod"] == "Auto") {
            closed := this.AutoCloseLauncher(true)
        } else if (this.config["LauncherCloseMethod"] == "AutoPolite") {
            closed := this.AutoCloseLauncher()
        } else if (this.config["LauncherCloseMethod"] == "AutoKill") {
            closed := this.KillLauncher()
        } else { ; Default to "Prompt"
            closed := this.PromptForLauncherToClose()
        }

        return closed
    }

    LauncherIsRunning() {
        pid := ""

        if (this.config["LauncherProcessId"] != "") {
            if (this.config["LauncherProcessType"] == "Title") {
                hwnd := WinExist(this.config["LauncherProcessId"],, " - Launchpad")
                if (hwnd) {
                    pid := WinGetPID("ahk_id " . hwnd)
                }
            } else if (this.config["LauncherProcessType"] == "Class") {
                hwnd := WinExist("ahk_class " . this.config["LauncherProcessId"],, " - Launchpad")
                if (hwnd) {
                    pid := WinGetPID("ahk_id " . hwnd)
                }
            } else { ; Default to Exe
                pid := ProcessExist(this.config["LauncherProcessId"])
            }
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
        if (this.config["LauncherRecheckDelay"] > 0) {
            Sleep(this.config["LauncherRecheckDelay"] * 1000)
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
        if (this.pid > 0 and WinExist("ahk_pid " . this.pid)) {
            WinClose("ahk_pid " . this.pid, "", this.config["LauncherPoliteCloseWait"])
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
        if (this.pid > 0 and ProcessExist(this.pid)) {
            ProcessClose(this.pid)
        }
    }

    PromptForLauncherToClose() {
        ; @todo Implement GUI class and instantiate it here
    }
}
