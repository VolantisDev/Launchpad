class CleanLaunchersOp extends LauncherGameOpBase {
    builder := ""
    updateExisting := false
    verb := "building"
    verbProper := "Building"
    verbPast := "built"
    verbPastProper := "Built"

    __New(app, launcherGames := "", builder := "", owner := "") {
        if (builder == "") {
            builder := app.Config.BuilderKey
        }

        this.builder := IsObject(builder) ? builder : app.Builders.GetBuilder(builder)

        super.__New(app, launcherGames, owner)
    }

    ProcessLauncherGame(launcherGame) {
        if (this.useProgress) {
            this.progress.SetDetailText(launcherGame.Key . ": Cleaning launcher...")
        }

        cleaned := this.builder.Clean(launcherGame)

        message := cleaned ? "Cleaned successfully." : "Cleaning not required."

        if (this.useProgress) {
            this.progress.SetDetailText(launcherGame.Key . ": " . message)
        }

        return true
    }
}
