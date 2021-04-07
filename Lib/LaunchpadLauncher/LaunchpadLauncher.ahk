class LaunchpadLauncher extends AppBase {
    Launcher {
        get => this.Services.Get("Launcher")
        set => this.Services.Set("Launcher", value)
    }

    Game {
        get => this.Services.Get("Game")
        set => this.Services.Set("Game", value)
    }

    __New(config) {
        config["logPath"] := config["launchpadLauncherConfig"]["LogPath"]
        config["loggingLevel"] := config["launchpadLauncherConfig"]["LoggingLevel"]
        super.__New(config)
    }

    RunApp(config) {
        super.RunApp(config)
        this.Launcher.LaunchGame()
    }

    LoadServices(config) {
        super.LoadServices(config)

        gameClass := config["gameConfig"]["GameClass"]
        this.Game := %gameClass%.new(this, config["launcherKey"], config["gameConfig"], config["launcherConfig"])

        launcherClass := config["launcherConfig"]["LauncherClass"]
        this.Launcher := %launcherClass%.new(this, config["launcherKey"], config["launcherConfig"])
    }

    ExitApp() {
        super.ExitApp()
    }
}
