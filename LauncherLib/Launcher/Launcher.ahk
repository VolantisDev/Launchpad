class Launcher {
    appDir := ""
    key := ""
    name := ""
    launcherType := {}
    game := {}
    options := {}
    launcherExe := ""
    
    __New(appDir, key, launcherType, game, options := "") {
        if (options == "") {
            options := {}
        }
        
        this.appDir := appDir
        this.key := key
        this.name := launcherType.hasKey("name") ? launcherType.name : "Game Launcher"
        this.launcherType := launcherType
        this.game := game

        if (!options.hasKey("runThenWait")) {
            options.runThenWait := true
        }

        this.options := options
    }

    RunLauncher() {
        this.LaunchGame()
        this.ExitLauncher()
    }

    ExitLauncher() {
        Exit
    }

    LaunchGame() {
        this.game.RunGame()

        if (this.options.runThenWait) {
            this.game.WaitForClose()
        }
    }
}
