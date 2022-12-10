class EntitySelectEntityFieldWidget extends SelectEntityFieldWidget {
    GetDefaultDefinition(definition) {
        defaults := super.GetDefaultDefinition(definition)
        defaults["selectButton"] := false
        defaults["selectButtonText"] := "Edit",
        defaults["selectButtonHandler"] := ObjBindMethod(this, "OnEditEntity"),
        defaults["entityFormMode"] := "child"
        return defaults
    }

    OnEditEntity(ctlObj, info) {
        entityId := this.GetWidgetValue()
        entityTypeId := this.entityObj.GetField(this.fieldId).Definition["entityType"]
        diff := ""

        if (entityId && entityTypeId) {
            manager := this.container.Get("manager.entity_type").GetManager(entityTypeId)
            entityObj := manager[entityId]
            diff := entityObj.Edit(this.Definition["entityFormMode"], this.guiObj.guiId)

            if (diff) {
                event := EntityReferenceEvent(EntityEvents.ENTITY_VALIDATE, this.entityObj.entityTypeId, this.entityObj, this.fieldId, entityTypeId, entityObj)
                this.eventMgr.DispatchEvent(event)

                if (this.Definition["refreshEntityOnChange"]) {
                    this.entityObj.RefreshEntityData()
                }
            }
        }
    }
}
