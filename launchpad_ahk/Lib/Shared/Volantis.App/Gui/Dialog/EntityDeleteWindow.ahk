class EntityDeleteWindow extends FormGuiBase {
    entityObj := ""
    entityManager := ""
    missingFields := Map()
 
    __New(container, themeObj, config, entityObj, entityManager) {
        this.entityObj := entityObj
        this.entityManager := entityManager
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Delete " . this.entityObj.Id
        defaults["text"] := "This will delete the '" . this.entityObj.Id . "' entity from Launchpad and cannot be undone."
        defaults["buttons"] := "*&Delete|&Cancel"
        return defaults
    }

    GetTitle() {
        return this.entityObj.Id . " - " . super.GetTitle()
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Delete") {
            this.entityManager.RemoveEntity(this.entityObj.Id)
        }

        return result
    }
}
