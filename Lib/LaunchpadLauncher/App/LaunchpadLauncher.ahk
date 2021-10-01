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

    GetServiceDefinitions(config) {
        services := super.GetServiceDefinitions(config)

        if (!services.Has("OverlayManager") || !services["OverlayManager"]) {
            services["OverlayManager"] := Map(
                "class", "OverlayManager",
                "arguments", [
                    this.appDir, 
                    ParameterRef("launchpad_launcher_config")
                ]
            )
        }

        if (!services.Has("Game") || !services["Game"]) {
            services["Game"] := Map(
                "class", config["gameConfig"]["GameClass"],
                "arguments", [
                    AppRef(), 
                    ParameterRef("launcher_key"), 
                    ParameterRef("game_config")
                ]
            )
        }

        if (!services.Has("Launcher") || !services["Launcher"]) {
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
        }
        
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
