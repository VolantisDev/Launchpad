class ValidateLaunchersOp extends LauncherGameOpBase {
    mode := ""
    verb := "validating"
    verbProper := "Validating"
    verbPast := "validated"
    verbPastProper := "Validated"

    __New(app, launcherEntities := "", mode := "", owner := "") {
        InvalidParameterException.CheckTypes("ValidateLaunchersOp", "mode", mode, "")
        this.mode := mode != "" ? mode : "config"
        super.__New(app, launcherEntities, owner)
    }

    ProcessLauncherGame(launcherEntityObj) {
        if (this.useProgress) {
            this.progress.SetDetailText("Validating " . launcherEntityObj.Key . "...")
        }

        result := launcherEntityObj.Validate()

        if (!result["success"]) {
            diff := launcherEntityObj.Edit(this.mode, this.owner)

            if (diff != "" and diff.HasChanges()) {
                result := launcherEntityObj.Validate()
            }
        }

        message := !result["success"] ? "Validateion failed." : "Validation successful."
        
        if (this.useProgress) {
            this.progress.SetDetailText(launcherEntityObj.Key . ": " . message)
        }

        return result["success"]
    }
}
