class EntityDeleteWindow extends LaunchpadFormGuiBase {
    entityObj := ""
    entityManager := ""
    missingFields := Map()
    dataSource := ""
 
    __New(app, entityObj, entityManager, windowKey := "", owner := "", parent := "") {
        InvalidParameterException.CheckTypes("EntityDeleteWindow", "entityObj", entityObj, "EntityBase")
        this.entityObj := entityObj
        this.entityManager := entityManager

        if (windowKey == "") {
            windowKey := "EntityDelete"
        }

        if (owner == "") {
            owner := "MainWindow"
        }

        super.__New(app, "Delete " . entityObj.Key, this.GetTextDefinition(), windowKey, owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "This will delete the '" . this.entityObj.Key . "' entity from Launchpad and cannot be undone."
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

    ProcessResult(result) {
        if (result == "Delete") {
            this.entityManager.RemoveEntity(this.entityObj.Key)
            this.entityManager.SaveModifiedEntities()
        }

        return result
    }
}
