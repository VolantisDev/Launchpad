﻿/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherWizard extends FormGuiBase {
    knownGames := ""
    knownPlatforms := ""
    dataSource := ""

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        this.dataSource := app.DataSources.GetItem()
        super.__New(app, themeObj, windowKey, "Launcher Wizard", this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
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
        this.AddSelect("Platform", "Platform", "", this.knownPlatforms, false, "", "", "Select the platform that this game is run through.", false)
        ; @todo Add a few other common fields here, like Icon
    }

    Create() {
        super.Create()
        this.knownGames := this.dataSource.ReadListing("game-keys")
        this.knownPlatforms := this.dataSource.ReadListing("platforms")
    }

    OnKeyChange(ctlObj, info) {
        
    }

    OnPlatformChange(ctlObj, info) {
        
    }

    ProcessResult(result) {
        entity := ""

        if (result == "Save") {
            platformKey := Trim(this.guiObj["Platform"].Text)
            config := Map("Platform", platformKey)
            platform := this.app.Platforms.GetItem(platformKey)
            if (platform) {
                config["LauncherType"] := platform.platform.launcherType
                config["GameType"] := platform.platform.gameType
            }
            key := this.guiObj["Key"].Text
            entity := LauncherEntity.new(this.app, key, config)
            ;MsgBox(entity.entityData.DebugData())
        }

        return entity
    }
}
