class BuildLaunchersOp extends LauncherBuilderOpBase {
    updateExisting := false
    verb := "building"
    verbProper := "Building"
    verbPast := "built"
    verbPastProper := "Built"

    __New(app, launcherEntities := "", builder := "", updateExisting := false, owner := "") {
        this.updateExisting := !!(updateExisting)
        super.__New(app, launcherEntities, builder, owner)
    }

    ProcessLauncherGame(launcherEntityObj) {
        exists := launcherEntityObj.LauncherExists()
        success := true
        message := "Launcher skipped."

        if (this.updateExisting or launcherEntityObj.IsOutdated) {
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
