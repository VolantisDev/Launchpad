class BlizzardGame extends SimpleGame {
    GetRunCmd() {
        launcherPath := this.launcherConfig["LauncherInstallDir"] . "\" . this.launcherConfig["LauncherExe"]
        
        if (launcherPath != "") {
            gameKey := this.config["GameBlizzardProductKey"]
            launcherPath .= " --game=" . gameKey . " --gamepath=`"" . this.config["GameInstallDir"] . "`" --productcode=" . gameKey
        }

        return launcherPath
    }

    RunGameRun() {
        pid := super.RunGameRun()
        winTitle := this.launcherConfig["LauncherWindowTitle"]

        if (!WinExist(winTitle)) {
            WinWait(winTitle)
        }

        if (WinExist(winTitle)) {
            Sleep(500)
            WinActivate("ahk_id " . WinGetID(winTitle))
            Send("{Enter}")
        }
    }
}
