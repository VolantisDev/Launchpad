#Include Launcher.ahk

class ThinLauncher extends Launcher {
    LaunchGame() {
        super.LaunchGame()
        this.ExitLauncher()
    }
}
