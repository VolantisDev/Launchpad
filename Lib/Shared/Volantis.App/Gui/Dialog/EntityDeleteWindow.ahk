class EntityDeleteWindow extends FormGuiBase {
    entityObj := ""
    entityManager := ""
    missingFields := Map()
    dataSource := ""
 
    __New(container, themeObj, config, entityObj, entityManager) {
        this.entityObj := entityObj
        this.entityManager := entityManager
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Delete " . this.entityObj.Key
        defaults["text"] := "This will delete the '" . this.entityObj.Key . "' entity from Launchpad and cannot be undone."
        defaults["buttons"] := "*&Delete|&Cancel"
        return defaults
    }

    GetTitle() {
        return this.entityObj.Key . " - " . super.GetTitle()
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Delete") {
            this.entityManager.RemoveEntity(this.entityObj.Key)
            this.entityManager.SaveModifiedEntities()
        }

        return result
    }
}
