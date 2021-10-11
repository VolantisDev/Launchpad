/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class EntityEditorBase extends FormGuiBase {
    entityObj := ""
    missingFields := Map()
    dataSource := ""
 
    __New(container, themeObj, config, entityObj) {
        this.entityObj := entityObj
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["mode"] := "config" ; config, build
        defaults["title"] := container.GetApp().appName
        defaults["text"] := this.GetTextDefinition(config)
        defaults["buttons"] := this.GetButtonsDefinition(config)
        return defaults
    }

    GetTextDefinition(config) {
        text := ""

        if (config["mode"] == "config") {
            text := "The details entered here will be saved to your Launchers file and used for all future builds."
        } else if (config["mode"] == "build") {
            text := "The details entered here will be used for this build only."
        }

        return text
    }

    GetButtonsDefinition(config) {
        buttonDefs := ""

        if (config["mode"] == "config") {
            buttonDefs := "*&Save|&Cancel"
        } else if (config["mode"] == "build") {
            buttonDefs := "*&Continue|&Skip"
        }

        return buttonDefs
    }

    GetTitle() {
        return this.entityObj.Key . " - " . super.GetTitle()
    }

    Controls() {
        super.Controls()
    }

    AddEntityCtl(heading, fieldName, showDefaultCheckbox, params*) {
        return this.Add("EntityControl", "", heading, this.entityObj, fieldName, showDefaultCheckbox, params*)
    }

    Create() {
        super.Create()
        this.dataSource := this.app.Service("DataSourceManager")["api"]
    }
}
