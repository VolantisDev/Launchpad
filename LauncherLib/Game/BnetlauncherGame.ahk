class BnetlauncherGame extends Game {
    RunGame() {
        RunWait, % this.launcherGenDir . "\Vendor\Bnetlauncher\bnetlauncher.exe " . this.gameId, % this.workingDir
    }
}
