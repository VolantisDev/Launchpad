class BlizzardGame extends SimpleGame {
    playButtonXOffset := 100
    playButtonYOffset := -100
    playButtonColors := ["0074E0", "148EFF"]

    GetRunCmd() {
        launcherPath := this.app["Launcher"].config["LauncherInstallDir"] . "\" . this.app["Launcher"].config["LauncherExe"]
        
        if (launcherPath != "") {
            gameKey := this.config["GameLauncherSpecificId"]
            launcherPath .= " --game=" . gameKey . " --gamepath=`"" . this.config["GameInstallDir"] . "`" --productcode=" . gameKey
        }

        return launcherPath
    }

    RunGameRun() {
        pid := super.RunGameRun()
        winTitle := this.app["Launcher"].config["LauncherWindowTitle"]

        if (!WinExist(winTitle)) {
            WinWait(winTitle)
        }

        if (WinExist(winTitle)) {
            winTitle := "ahk_id " . WinGetID(winTitle)
            buttonReady := this.WaitForColor(this.playButtonColors, winTitle, this.playButtonXOffset, this.playButtonYOffset)

            if (!buttonReady) {
                throw AppException("Play button does not seem to be available. Please check your Battle.net client and try again.")
            }

            WinActivate(winTitle)
            mouseCoordMode := A_CoordModeMouse

            ; Save original mouse position
            CoordMode("Mouse", "Screen")
            MouseGetPos(&mouseX, &mouseY)

            ; Click the Play button
            CoordMode("Mouse", "Window")
            WinGetClientPos(,,, &winH, winTitle)
            buttonX := this.playButtonXOffset
            buttonY := winH + this.playButtonYOffset
            Click(buttonX . " " . buttonY)

            ; Return mouse pointer to original position
            CoordMode("Mouse", "Screen")
            MouseMove(mouseX, mouseY)

            CoordMode("Mouse", mouseCoordMode)
        }
    }

    CleanupAfterRun(progress := "") {
        winTitle := this.app["Launcher"].config["LauncherWindowTitle"]
        if (WinExist(winTitle)) {
            WinClose("ahk_id" . WinGetID(winTitle))
        }
        
        super.CleanupAfterRun(progress)
    }
}
