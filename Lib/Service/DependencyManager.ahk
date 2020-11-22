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
            progress := this.app.GuiManager.ProgressIndicator(this.initializeTitle, this.initializeText, owner, true, "0-100", 0, "Initializing...")

            listingInstance := ApiListing.new(this.app, "dependencies")

            if (listingInstance.Exists()) {
                listing := listingInstance.Read()
                progress.SetRange("0-" . listing["items"].Length)

                for index, key in listing["items"] {
                    progress.IncrementValue(1, key . ": Discovering...")

                    item := ApiDependency.new(this.app, key)

                    if (item.Exists()) {
                        this.dependencies[key] := item.Read()
                    }
                }
            }

            progress.Finish()
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

        progress := this.app.GuiManager.ProgressIndicator(this.updateTitle, this.updateText, owner, true, "0-100", 0, "Initializing...")
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
            progress := this.app.GuiManager.ProgressIndicator(this.updateTitle, this.updateText, owner, true, "0-1", 0, "Initializing...")
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