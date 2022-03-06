class LaunchpadLauncher extends AppBase {
    GetParameterDefinitions(config) {
        parameters := super.GetParameterDefinitions(config)

        for key, val in config["launchpadLauncherConfig"] {
            parameters["config." . key] := val
        }

        parameters["launcher_key"] := config["launcherKey"]
        parameters["launcher_config"] := config["launcherConfig"]
        parameters["game_config"] := config["gameConfig"]
        parameters["platforms"] := config["platforms"]

        return parameters
    }

    GetServiceDefinitions(config) {
        services := super.GetServiceDefinitions(config)

        services["Config"] := Map(
            "class", "RuntimeConfig",
            "arguments", [
                ContainerRef(),
                ParameterRef("config_key")
            ]
        )

        services["State"] := Map(
            "class", "LaunchpadLauncherState",
            "arguments", [AppRef(), ParameterRef("state_path")]
        )

        services["OverlayManager"] := Map(
            "class", "OverlayManager",
            "arguments", [
                this.appDir, 
                ParameterRef("config")
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
                ServiceRef("manager.gui"),
                ServiceRef("Game"),
                ParameterRef("config"), 
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
