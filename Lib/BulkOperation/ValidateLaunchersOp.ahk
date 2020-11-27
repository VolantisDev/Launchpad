class ValidateLaunchersOp extends LauncherGameOpBase {
    mode := ""
    verb := "validating"
    verbProper := "Validating"
    verbPast := "validated"
    verbPastProper := "Validated"

    __New(app, launcherEntities := "", mode := "", owner := "") {
        if (mode == "") {
            mode := "config"
        }

        this.mode := mode
        super.__New(app, launcherEntities, owner)
    }

    ProcessLauncherGame(launcherEntityObj) {
        if (this.useProgress) {
            this.progress.SetDetailText("Validating " . launcherEntityObj.Key . "...")
        }

        result := launcherEntityObj.Validate()

        if (!result["success"]) {
            result := launcherEntityObj.Edit(this.mode, this.owner)
        }

        message := !result["success"] ? "Validateion failed." : "Validation successful."
        
        if (this.useProgress) {
            this.progress.SetDetailText(launcherEntityObj.Key . ": " . message)
        }

        return result["success"]
    }
}
