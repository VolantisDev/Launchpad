class LaunchpadLauncher extends AppBase {
    LauncherConfig := Map()
    Platforms := Map()

    __New(config) {
        config["logPath"] := config["launchpadLauncherConfig"]["LogPath"]
        config["loggingLevel"] := config["launchpadLauncherConfig"]["LoggingLevel"]
        this.LauncherConfig := config["launchpadLauncherConfig"]
        this.Platforms := config["platforms"]
        super.__New(config)
    }

    GetParameterDefinitions(config) {
        return Map(
            "launcher_key", config["launcherKey"]
            "launchpad_launcher_config", config["launchpadLauncherConfig"],
            "launcher_config", config["launcherConfig"],
            "game_config", config["gameConfig"]
        )
    }

    GetServiceDefinitions(config) {
        services := super.GetServiceDefinitions(config)

        services["Config"] := Map(
            "class", "LaunchpadLauncherConfig",
            "arguments", [
                AppRef(), 
                ParameterRef("launchpad_launcher_config"), 
                ParameterRef("launcher_config"), 
                ParameterRef("game_config"), 
                ParameterRef("config_path")
            ]
        )

        services["State"] := Map(
            "class", "LaunchpadLauncherState",
            "arguments", [
                AppRef(), 
                ParameterRef("state_path")
            ]
        )

        services["OverlayManager"] := Map(
            "class", "OverlayManager",
            "arguments", [
                this.appDir, 
                ParameterRef("launchpad_launcher_config")
            ]
        )

        services["Game"] := Map(
            "class", config["gameConfig"]["GameClass"],
            "arguments", [
                AppRef(), 
                ParameterRef("launcher_key"), 
                ParameterRef("game_config")
            ]
        )

        services["Launcher"] := Map(
            "class", config["launcherConfig"]["LauncherClass"],
            "arguments", [
                ParameterRef("launcher_key"),
                ServiceRef("GuiManager"),
                ServiceRef("Game"),
                ParameterRef("launchpad_launcher_config"), 
                ParameterRef("launcher_config"),
                ServiceRef("Logger")
            ]
        )
        
        return services
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
