class EntityFormFactory {
    container := ""

    __New(container) {
        this.container := container
    }

    CreateEntityForm(entityObj, guiObj, formMode := "config") {
        return SimpleEntityForm(
            entityObj,
            guiObj,
            formMode
        )
    }
}
