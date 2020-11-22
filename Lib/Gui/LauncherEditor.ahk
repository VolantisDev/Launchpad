/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditor extends FormWindow {
    contentWidth := 500
    launcherGame := ""
    mode := "save" ; Options: config, build
    missingFields := Map()

    __New(app, launcherGame, owner := "", windowKey := "", mode := "config") {
        this.launcherGame := launcherGame
        this.mode := mode

        if (owner == "") {
            owner := "MainWindow"
        }

        super.__New(app, "Launcher Editor", this.GetTextDefinition(), owner, windowKey, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        text := ""

        if (this.mode == "config") {
            text := "The details entered here will be saved to your Launchers file and used for all future builds."
        } else if (this.mode == "build") {
            text := "The details entered here will be used for this build only."
        }

        return text
    }

    GetButtonsDefinition() {
        return this.duringBuild ? "*&Continue|&Skip" : "*&Save|&Cancel"
    }

    GetTitle(title) {
        return super.GetTitle(launcherGame["key"] . " - " . title)
    }

    Controls() {
        super.Controls()

        
    }
}
