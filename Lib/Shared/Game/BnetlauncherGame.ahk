class BnetlauncherGame extends GameBase {
    GetRunCmd() {
        return this.config["DependenciesDir"] . "\BnetLauncher\bnetlauncher.exe " . this.config["LauncherSpecificId"]
    }
}
