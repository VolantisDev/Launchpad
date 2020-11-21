class BnetlauncherGame extends Game {
    RunGame() {
        return RunWait(this.appDir . "\Vendor\bnetlauncher\bnetlauncher.exe " . this.options.gameId)
    }
}
