class RiotGame extends SimpleGame {
    GetRunCmd() {
        launcherPath := "`"" . this.launcherConfig["LauncherInstallDir"] . "\" . this.launcherConfig["LauncherExe"] . "`""
        
        if (launcherPath != "") {
            gameKey := this.config["GameLauncherSpecificId"]
            launcherPath .= " --launch-product=" . gameKey . " --launch-patchline=live"
        }

        MsgBox(launcherPath)

        return launcherPath
    }
}
