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
    entityFormFactory := ""
    entityForm := ""
 
    __New(container, themeObj, config, entityObj) {
        this.entityFormFactory := container.Get("entity_form_factory." . entityObj.EntityTypeId)
        this.entityObj := entityObj
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaultConfig := Map(
            "mode", "config",
            "iconField", "IconSrc"
        )

        if (config) {
            config := this.merger.Merge(defaultConfig, config)
        } else {
            config := defaultConfig
        }

        mode := config["mode"]
        defaults := super.GetDefaultConfig(container, config)
        defaults["mode"] := mode ; config, build
        defaults["title"] := container.GetApp().appName
        defaults["text"] := this.entityObj.GetEditorDescription(mode)
        defaults["buttons"] := this.entityObj.GetEditorButtons(mode)
        defaults["iconField"] := config["iconField"]

        if (this.entityObj.HasField(defaults["iconField"])) {
            defaults["icon"] := this.entityObj[defaults["iconField"]]
        }
        
        defaults["icon"]
        return defaults
    }

    GetTitle() {
        return this.entityObj.Id . " - " . super.GetTitle()
    }

    GetEntityForm() {
        if (!this.entityForm) {
            this.entityForm := this.entityFormFactory.CreateEntityForm(
                this.entityObj,
                this,
                this.config["mode"]
            )
        }

        return this.entityForm
    }

    GetGuiParameters() {
        return GuiControlParameters.FromGui(this)
    }

    Controls() {
        super.Controls()
        this.GetEntityForm().RenderEntityForm(this.GetGuiParameters())
    }

    AddEntityCtl(heading, fieldName, showDefaultCheckbox, params*) {
        return this.Add("EntityControl", "", heading, this.entityObj, fieldName, showDefaultCheckbox, params*)
    }

    Create() {
        super.Create()
        this.dataSource := this.app.Service("manager.data_source").GetDefaultDataSource()
    }
}
