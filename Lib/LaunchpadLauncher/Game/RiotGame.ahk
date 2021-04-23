class RiotGame extends SimpleGame {
    GetRunCmd() {
        launcherPath := "`"" . this.app.Service("Launcher").config["LauncherInstallDir"] . "\" . this.app.Service("Launcher").config["LauncherExe"] . "`""
        
        if (launcherPath != "") {
            gameKey := this.config["GameLauncherSpecificId"]
            launcherPath .= " --launch-product=" . gameKey . " --launch-patchline=live"
        }

        return launcherPath
    }
}
