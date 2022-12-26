class RiotGame extends SimpleGame {
    GetRunCmd() {
        launcherPath := "`"" . this.app["Launcher"].config["LauncherInstallDir"] . "\" . this.app["Launcher"].config["LauncherExe"] . "`""
        
        if (launcherPath != "") {
            gameKey := this.config["GamePlatformRef"]
            launcherPath .= " --launch-product=" . gameKey . " --launch-patchline=live"
        }

        return launcherPath
    }
}
