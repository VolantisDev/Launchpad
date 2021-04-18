class LaunchpadLauncher extends AppBase {
    __New(config) {
        config["logPath"] := config["launchpadLauncherConfig"]["LogPath"]
        config["loggingLevel"] := config["launchpadLauncherConfig"]["LoggingLevel"]
        super.__New(config)
    }

    LoadServices(config) {
        super.LoadServices(config)
        this.Services.Set("Platforms", config["platforms"])
        this.Services.Set("LauncherConfig", config["launchpadLauncherConfig"])
        this.Services.Set("OverlayManager", OverlayManager.new(this))

        gameClass := config["gameConfig"]["GameClass"]
        this.Services.Set("Game", %gameClass%.new(this, config["launcherKey"], config["gameConfig"], config["launcherConfig"]))

        launcherClass := config["launcherConfig"]["LauncherClass"]
        this.Services.Set("Launcher", %launcherClass%.new(this, config["launcherKey"], config["launcherConfig"]))
    }

    RunApp(config) {
        super.RunApp(config)
        this.Service("Launcher").LaunchGame()
    }

    RestartApp() {
        game := this.Service("Game")

        if (game) {
            game.StopOverlay()
        }

        super.RestartApp()
    }

    ExitApp() {
        game := this.Service("Game")

        if (game) {
            game.StopOverlay()
        }

        super.ExitApp()
    }
}
