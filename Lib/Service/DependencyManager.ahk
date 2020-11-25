class DependencyManager extends ServiceBase {
    dependencies := Map()
    initialized := false
    updateTitle := "Updating Dependencies"
    updateText := "Please wait while dependencies are updated."
    initializeTitle := "Initializing Dependencies"
    initializeText := "Please wait while dependencies are initialized."

    __New(app) {
        super.__New(app)
    }

    InitializeDependencies(owner := "MainWindow") {
        if (!this.initialized) {
            listing := this.app.DataSources.GetDataSource("api").ReadListing("dependencies")
            progress := this.app.Windows.ProgressIndicator(this.initializeTitle, this.initializeText, owner, true, "0-" . listing.Length, 0, "Initializing...")

            for index, key in listing {
                progress.IncrementValue(1, key . ": Discovering...")

                item := this.app.DataSources.ReadJson(key, "dependencies")

                if (item != "") {
                    this.dependencies[key] := item
                    progress.SetDetailText(key . ": Finished")
                } else {
                    progress.SetDetailText(key . ": Not found")
                }
            }

            progress.Finish()

            this.initialized := true
        }
    }

    CountDependencies(owner := "MainWindow") {
        if (!this.initialized) {
            this.InitializeDependencies(owner)
        }

        return this.dependencies.Count
    }

    UpdateDependencies(force := false, owner := "MainWindow") {
        if (!this.initialized) {
            this.InitializeDependencies(owner)
        }

        progress := this.app.Windows.ProgressIndicator(this.updateTitle, this.updateText, owner, true, "0-100", 0, "Initializing...")
        updated := 0

        itemCount := this.CountDependencies(owner)
        if (itemCount > 0) {
            progress.SetRange("0-" . itemCount)

            for key, dependencyConfig in this.dependencies {
                if (this.UpdateDependency(key, force, owner, progress)) {
                    updated++
                }
            }
        }

        progress.Finish()

        if (updated > 0 or force) {
            this.app.Notifications.Info("Updated " . updated . " dependencies.")
        }
    }

    UpdateDependency(key, force := false, owner := "MainWindow", progress := "") {
        if (!this.initialized) {
            this.InitializeDependencies(owner)
        }

        manageProgress := (progress == "")

        if (manageProgress) {
            progress := this.app.Windows.ProgressIndicator(this.updateTitle, this.updateText, owner, true, "0-1", 0, "Initializing...")
        }

        updated := false
        dependencyName := key

        if (this.dependencies.Has(key)) {
            dependencyInstance := this.GetDependency(key)
            dependencyName := this.dependencies[key]["name"]
            progress.IncrementValue(1, dependencyName . ": Discovering...")

            if (dependencyInstance.NeedsUpdate(force)) {
                installed := dependencyInstance.IsInstalled()
                statusText := installed ? "Updating" : "Installing"
                progress.SetDetailText(dependencyName . ": " . statusText . "...")
                result := installed ? dependencyInstance.Update(force) : dependencyInstance.Install()
                updated := true
            }
        }

        if (manageProgress) {
            progress.Finish()
        }

        if (manageProgress and updated) {
            this.app.Notifications.Info("Updated dependency: " . dependencyName . ".")
        }

        return updated
    }

    GetDependency(key) {
        result := ""

        if (this.dependencies.Has(key)) {
            dependencyClass := this.dependencies[key]["class"]
            result :=  %dependencyClass%.new(this.app, key, this.dependencies[key])
        }
        
        return result
    }
}
