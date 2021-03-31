class EntityDeleteWindow extends FormGuiBase {
    entityObj := ""
    entityManager := ""
    missingFields := Map()
    dataSource := ""
 
    __New(app, themeObj, windowKey, entityObj, entityManager, owner := "", parent := "") {
        InvalidParameterException.CheckTypes("EntityDeleteWindow", "entityObj", entityObj, "EntityBase")
        this.entityObj := entityObj
        this.entityManager := entityManager
        super.__New(app, themeObj, windowKey, "Delete " . entityObj.Key, this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "This will delete the '" . this.entityObj.Key . "' entity from " . this.app.appName . " and cannot be undone."
    }

    GetButtonsDefinition() {
        return "*&Delete|&Cancel"
    }

    GetTitle(title) {
        return super.GetTitle(this.entityObj.Key . " - " . title)
    }

    Controls() {
        super.Controls()
    }

    ProcessResult(result, submittedData := "") {
        if (result == "Delete") {
            this.entityManager.RemoveEntity(this.entityObj.Key)
            this.entityManager.SaveModifiedEntities()
        }

        return result
    }
}
