class ValidateLaunchersOp extends LauncherGameOpBase {
    mode := ""
    launcherFileObj := ""
    verb := "validating"
    verbProper := "Validating"
    verbPast := "validated"
    verbPastProper := "Validated"

    __New(app, launcherGames := "", mode := "", launcherFileObj := "", owner := "") {
        if (mode == "") {
            mode := "config"
        }

        this.mode := mode

        if (launcherFileObj == "") {
            launcherFileObj := app.Launchers.GetLauncherConfig()
        }

        this.launcherFileObj := launcherFileObj

        super.__New(app, launcherGames, owner)
    }

    ProcessLauncherGame(launcherGame) {
        if (this.useProgress) {
            this.progress.SetDetailText(launcherGame.Key . ": Validating...")
        }

        result := launcherGame.Validate()

        if (!result["success"]) {
            result := launcherGame.Edit(this.launcherFileObj, this.mode, this.owner)
        }

        message := result["success"] ? "Validation successful." : "Validateion failed."
        
        if (this.useProgress) {
            this.progress.SetDetailText(launcherGame.Key . ": " . message)
        }

        return result["success"]
    }
}
