class BnetlauncherGame extends Game {
    RunGame() {
        RunWait, % this.appDir . "\Vendor\bnetlauncher\bnetlauncher.exe " . this.gameId
    }
}
