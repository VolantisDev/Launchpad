class LaunchpadBuildOp extends BulkOperationBase {
    progressTitle := "Building Launchpad"
    progressText := "Please wait while Launchpad is built."
    successMessage := "Ran {n} builder(s) successfully."
    failedMessage := "{n} builder(s) failed to run due to errors."
    builders := ""

    __New(app, builders, owner := "") {
        if (Type(builders) != "Map") {
            builders := Map("Builder", builders)
        }

        this.builders := builders
        super.__New(app, owner)
    }

    RunAction() {
        if (this.useProgress) {
            this.progress.SetRange(0, this.builders.Count)
        }

        version := this.app.Version

        for key, builder in this.builders {
            this.StartItem(key, key . ": Building...")
            this.results[key] := builder.Build(version)
            this.FinishItem(key, true, key . ": Finished building")
        }
    }
}
