class BuildLaunchersOp extends LauncherBuilderOpBase {
    updateExisting := false
    verb := "building"
    verbProper := "Building"
    verbPast := "built"
    verbPastProper := "Built"
    skipped := 0

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
                this.progress.SetDetailText(launcherEntityObj.Id . ": " . detailText)
            }

            success := this.Builder.Build(launcherEntityObj)

            if (success) {
                message := exists ? "Rebuilt launcher successfully." : "Built launcher successfully."
            } else {
                message := "Failed to build launcher."
            }

            if (this.useProgress) {
                this.progress.SetDetailText(launcherEntityObj.Id . ": " . message)
            }
        } else {
            this.skipped++
        }

        return success
    }

    RunAction() {
        super.RunAction()

        if (this.skipped > 0) {
            this.successCount -= this.skipped
        }
    }
}
