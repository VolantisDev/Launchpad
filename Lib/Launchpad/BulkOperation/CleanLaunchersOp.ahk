class CleanLaunchersOp extends LauncherGameOpBase {
    builder := ""
    updateExisting := false
    verb := "cleaning"
    verbProper := "Cleaning"
    verbPast := "cleaned"
    verbPastProper := "Cleaned"

    __New(app, launcherEntities := "", builder := "", owner := "") {
        if (builder == "") {
            builder := app.Config.BuilderKey
        }

        this.builder := IsObject(builder) ? builder : app.Builders.GetBuilder(builder)

        super.__New(app, launcherEntities, owner)
    }

    ProcessLauncherGame(launcherEntityObj) {
        if (this.useProgress) {
            this.progress.SetDetailText(launcherEntityObj.Key . ": Cleaning launcher...")
        }

        cleaned := this.builder.Clean(launcherEntityObj)

        message := cleaned ? "Cleaned successfully." : "Cleaning not required."

        if (this.useProgress) {
            this.progress.SetDetailText(launcherEntityObj.Key . ": " . message)
        }

        return true
    }
}
