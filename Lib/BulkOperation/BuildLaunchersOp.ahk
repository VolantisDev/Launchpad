class BuildLaunchersOp extends LauncherGameOpBase {
    builder := ""
    updateExisting := false
    verb := "building"
    verbProper := "Building"
    verbPast := "built"
    verbPastProper := "Built"

    __New(app, launcherGames := "", builder := "", updateExisting := false, owner := "") {
        if (builder == "") {
            builder := app.Config.BuilderKey
        }

        this.updateExisting := updateExisting

        this.builder := IsObject(builder) ? builder : app.Builders.GetBuilder(builder)

        super.__New(app, launcherGames, owner)
    }

    ProcessLauncherGame(launcherGame) {
        exists := launcherGame.LauncherExists()
        success := true
        message := "Launcher skipped."

        if (this.updateExisting or !exists) {
            detailText := exists ? "Rebuilding launcher..." : "Building launcher..."

            if (this.useProgress) {
                this.progress.SetDetailText(launcherGame.Key . ": " . detailText)
            }

            success := this.Builder.Build(launcherGame)

            if (success) {
                 message := exists ? "Rebuilt launcher successfully." : "Built launcher successfully."
            } else {
                message := "Failed to build launcher."
            }

            if (this.useProgress) {
                this.progress.SetDetailText(launcherGame.Key . ": " . message)
            }
        }

        return success
    }
}
