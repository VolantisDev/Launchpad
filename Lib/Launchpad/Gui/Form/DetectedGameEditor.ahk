﻿class DetectedGameEditor extends FormGuiBase {
    detectedGameObj := ""
    newValues := Map()
    missingFields := Map()
    knownGames := ""
    launcherTypes := ""
    gameTypes := ""
 
    __New(container, themeObj, config, detectedGameObj) {
        this.detectedGameObj := detectedGameObj
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Detected Game Editor"
        defaults["text"] := "These values were detected automatically. You may customize them below. Blanking out a value will cause the entity to use the default (or retain its existing value)."
        defaults["buttons"] := "*&Save|&Cancel"
        return defaults
    }

    Create() {
        super.Create()

        this.knownPlatforms := []
        this.knownGames := []
        this.launcherTypes := []
        this.gameTypes := []

        ; @todo replace this, or at least refactor it to live somewhere else
        if (this.container.Has("entity_manager.web_service")) {
            mgr := this.container["entity_manager.web_service"]

            if (mgr.Has("launchpad_api") && mgr["launchpad_api"]["Enabled"]) {
                webService := mgr["launchpad_api"]
                knownMap := Map(
                    "platform", "knownPlatforms",
                    "game", "knownGames",
                    "managed_launcher", "launcherTypes",
                    "managed_game", "gameTypes"
                )
    
                for entityTypeId, varName in knownMap {
                    results := webService.AdapterRequest("", Map(
                        "adapterType", "entity_list",
                        "entityType", entityTypeId
                    ), "read", true)

                    if (results) {
                        for , idList in results {
                            if (idList) {
                                for , id in idList {
                                    exists := false

                                    for , item in %varName% {
                                        if (item == id) {
                                            exists := true
                                            break
                                        }
                                    }

                                    if (!exists) {
                                        this.%varName%.Push(id)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    GetTitle() {
        return super.GetTitle() . ": " . this.detectedGameObj.key
    }

    Controls() {
        super.Controls()
        this.Add("ComboBoxControl", "vId", "Id", this.detectedGameObj.Id, this.knownGames, "OnIdChange", "You can change the detected game key here, which will become the name of your launcher. Your existing launchers, and all launchers known about via the API, can be selected to match this game up with one of those items.")
        this.Add("SelectControl", "vLauncherType", "Launcher Type", this.detectedGameObj.launcherType, this.launcherTypes, "OnLauncherTypeChange", "This tells " . this.app.appName . " how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".`n`nYou can customize the details of the launcher type after it is added.")
        this.Add("SelectControl", "vGameType", "Game Type", this.detectedGameObj.gameType, this.gameTypes, "OnGameTypeChange", "This tells " . this.app.appName . " how to launch your game. Most games can use 'default', but launchers can support different game types.`n`nYou can customize the details of the game type after it is added.")
        this.Add("LocationBlock", "", "Install Dir", this.detectedGameObj.installDir, "InstallDir", "", true, "This is the directory that the game is installed in, if it could be detected.")
        this.Add("ComboBoxControl", "vExe", "Exe", this.detectedGameObj.exeName, this.detectedGameObj.possibleExeNames, "OnExeChange", "The main Exe, if detected, should be pre-selected. You may change it to be the name (or path) of another exe, or select another one of the detected .exe files from the list (if more than one was found).")
        this.AddTextBlock("Launcher-Specific ID", "PlatformRef", this.detectedGameObj.platformRef, "This is typically the ID which the game platform or launcher uses when referring to the game internally. Changing this value could cause issues with game launching.")
    }

    AddTextBlock(heading, field, existingVal := "", helpText := "") {
        this.AddHeading(heading)

        ctl := this.guiObj.AddEdit("v" . field . " xs y+m w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), existingVal)
        ctl.OnEvent("Change", "On" . field . "Change")

        if (helpText) {
            ctl.ToolTip := helpText
        }

        return ctl
    }

    OnIdChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["key"] := ctl.Text
    }

    OnLauncherTypeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["launcherType"] := ctl.Text
    }

    OnGameTypeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["gameType"] := ctl.Text
    }

    GetValue(key) {
        val := this.detectedGameObj.%key%

        if (this.newValues.Has(key)) {
            val := this.newValues[key]
        }

        return val
    }

    OnInstallDirMenuClick(btn) {
        if (btn == "ChangeInstallDir") {
            existingVal := this.GetValue("installDir")

            if (existingVal) {
                existingVal := "*" . existingVal
            }

            key := this.GetValue("key")
            dir := DirSelect(existingVal, 2, key . ": Select the installation directory")

            if (dir) {
                this.newValues["installDir"] := dir
                this.guiObj["InstallDir"].Text := dir
            }
        } else if (btn == "OpenInstallDir") {
            installDir := this.detectedGameObj.installDir

            if (this.newValues.Has("installDir")) {
                installDir := this.newValues["installDir"]
            }
            
            if (installDir && DirExist(installDir)) {
                Run(installDir)
            }
        } else if (btn == "ClearInstallDir") {
            this.newValues["installDir"] := ""
            this.guiObj["InstallDir"].Text := ""
        }
    }

    OnExeChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["exeName"] := ctl.Text
    }

    OnPlatformRefChange(ctl, info) {
        this.guiObj.Submit(false)
        this.newValues["platformRef"] := ctl.Text
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Save") {
            for key, value in this.newValues {
                this.detectedGameObj.%key% := value
            }
        }

        return result
    }
}
