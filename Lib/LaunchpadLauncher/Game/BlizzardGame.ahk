class BlizzardGame extends SimpleGame {
    GetRunCmd() {
        launcherPath := this.app.Service("Launcher").config["LauncherInstallDir"] . "\" . this.app.Service("Launcher").config["LauncherExe"]
        
        if (launcherPath != "") {
            gameKey := this.config["GameLauncherSpecificId"]
            launcherPath .= " --game=" . gameKey . " --gamepath=`"" . this.config["GameInstallDir"] . "`" --productcode=" . gameKey
        }

        return launcherPath
    }

    RunGameRun() {
        pid := super.RunGameRun()
        winTitle := this.app.Service("Launcher").config["LauncherWindowTitle"]

        if (!WinExist(winTitle)) {
            WinWait(winTitle)
        }

        if (WinExist(winTitle)) {
            Sleep(1500)
            winTitle := "ahk_id " . WinGetID(winTitle)
            WinActivate(winTitle)
            mouseCoordMode := A_CoordModeMouse

            ; Save original mouse position
            CoordMode("Mouse", "Screen")
            MouseGetPos(mouseX, mouseY)

            ; Click the Play button
            CoordMode("Mouse", "Window")
            WinGetClientPos(,,, winH, winTitle)
            buttonX := 100
            buttonY := winH - 100
            Click(buttonX . " " . buttonY)

            ; Return mouse pointer to original position
            CoordMode("Mouse", "Screen")
            MouseMove(mouseX, mouseY)

            CoordMode("Mouse", mouseCoordMode)
        }
    }

    CleanupAfterRun(progress := "") {
        winTitle := this.app.Service("Launcher").config["LauncherWindowTitle"]
        if (WinExist(winTitle)) {
            WinClose("ahk_id" . WinGetID(winTitle))
        }
        
        super.CleanupAfterRun(progress)
    }
}
