/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherWizard extends LaunchpadFormGuiBase {
    knownGames := ""
    launcherTypes := ""
    dataSource := ""

    __New(app, windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "LauncherWizard"
        }

        this.dataSource := app.DataSources.GetItem()

        if (owner == "") {
            owner := "ManageWindow"
        }

        super.__New(app, "Launcher Wizard", this.GetTextDefinition(), windowKey, owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "To start with, simply choose a game key and a launcher type. You can edit many details later if desired."
    }

    GetButtonsDefinition() {
        return "*&Save|&Cancel"
    }

    Controls() {
        super.Controls()
        this.AddComboBox("Key", "Key", "", this.knownGames, "Select an existing game from the API, or enter a custom game key to create your own. If choosing an existing game, most advanced values can be loaded from the API.")
        this.AddEntityTypeSelect("Launcher", "LauncherType", "Default", this.launcherTypes, "", "This tells Launchpad how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".")
        ; @todo Add a few other common fields here, like Icon
    }

    Create() {
        super.Create()
        this.knownGames := this.dataSource.ReadListing("game-keys")
        this.knownPlatforms := this.dataSource.ReadListing("platforms")
        this.launcherTypes := this.dataSource.ReadListing("launcher-types")
    }

    OnKeyChange(ctlObj, info) {
        
    }

    OnLauncherTypeChange(ctlObj, info) {
        
    }

    ProcessResult(result) {
        entity := ""

        if (result == "Save") {
            config := Map("LauncherType", this.guiObj["LauncherType"].Text)
            key := this.guiObj["Key"].Text
            entity := LauncherEntity.new(this.app, key, config)
        }

        return entity
    }
}
