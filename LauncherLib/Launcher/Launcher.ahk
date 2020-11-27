class Launcher {
    appDir := ""
    key := ""
    name := ""
    launcherType := Map()
    game := ""
    options := Map()
    launcherExe := ""
    
    __New(appDir, key, launcherType, game, options := "") {
        if (options == "") {
            options := Map()
        }
        
        this.appDir := appDir
        this.key := key
        this.name := launcherType.Has("name") ? launcherType["name"] : "Game Launcher"
        this.launcherType := launcherType
        this.game := game

        if (!options.Has("runThenWait")) {
            options["runThenWait"] := false
        }

        this.options := options
    }

    RunLauncher() {
        this.LaunchGame()
        this.ExitLauncher()
    }

    ExitLauncher() {
        ExitApp
    }

    LaunchGame() {
        this.game.RunGame()
    }
}
