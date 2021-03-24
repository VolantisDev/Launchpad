class CleanLaunchersOp extends LauncherBuilderOpBase {
    verb := "cleaning"
    verbProper := "Cleaning"
    verbPast := "cleaned"
    verbPastProper := "Cleaned"

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
