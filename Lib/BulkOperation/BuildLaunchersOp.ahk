class BuildLaunchersOp extends LauncherGameOpBase {
    builder := ""
    updateExisting := false
    verb := "building"
    verbProper := "Building"
    verbPast := "built"
    verbPastProper := "Built"

    __New(app, launcherEntities := "", builder := "", updateExisting := false, owner := "") {
        if (builder == "") {
            builder := app.Config.BuilderKey
        }

        this.updateExisting := updateExisting

        this.builder := IsObject(builder) ? builder : app.Builders.GetBuilder(builder)

        super.__New(app, launcherEntities, owner)
    }

    ProcessLauncherGame(launcherEntityObj) {
        exists := launcherEntityObj.LauncherExists()
        success := true
        message := "Launcher skipped."

        if (this.updateExisting or !exists) {
            detailText := exists ? "Rebuilding launcher..." : "Building launcher..."

            if (this.useProgress) {
                this.progress.SetDetailText(launcherEntityObj.Key . ": " . detailText)
            }

            success := this.Builder.Build(launcherEntityObj)

            if (success) {
                 message := exists ? "Rebuilt launcher successfully." : "Built launcher successfully."
            } else {
                message := "Failed to build launcher."
            }

            if (this.useProgress) {
                this.progress.SetDetailText(launcherEntityObj.Key . ": " . message)
            }
        }

        return success
    }
}
