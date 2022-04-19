class EntityBase {
    idVal := ""
    entityTypeIdVal := ""
    parentEntityObj := ""
    container := ""
    eventMgr := ""
    dataObj := ""
    storageObj := ""
    idSanitizer := ""
    sanitizeId := true
    loaded := false
    merger := ""
    cloner := ""

    Id {
        get => this.GetId()
        set => this.SetId(value)
    }

    EntityTypeId {
        get => this.entityTypeIdVal
    }

    EntityType {
        get => this.GetEntityType()
    }

    FieldData {
        Get => this.GetData().GetMergedData()
    }

    Name {
        get => this.GetValue("name")
        set => this.SetValue("name", value)
    }

    UnmergedFieldData {
        get => this.GetData().GetLayer("config")
        set => this.GetData().SetLayer("config", value)
    }

    ParentEntity {
        get => this.GetParentEntity()
        set => this.SetParentEntity(value)
    }

    __Item[key := ""] {
        get => this.GetValue(key)
        set => this.SetValue(key, value)
    }

    __Enum(numberOfVars) {
        return this.GetAllValues().__Enum(numberOfVars)
    }

    __New(id, entityTypeId, container, eventMgr, storageObj, idSanitizer := "", autoLoad := true, parentEntity := "") {
        this.idSanitizer := idSanitizer
        
        if (this.sanitizeId && this.idSanitizer) {
            idVal := this.idSanitizer.Process(id)
        }

        this.idVal := id
        this.entityTypeIdVal := entityTypeId
        this.container := container
        this.eventMgr := eventMgr
        this.storageObj := storageObj
        this.merger := container.Get("merger.list")
        this.cloner := container.Get("cloner.list")

        if (!parentEntity) {
            parentEntity := this.DiscoverParentEntity(container, eventMgr, id, storageObj, idSanitizer)
        }

        if (parentEntity) {
            this.SetParentEntity(parentEntity)
        }

        this.dataObj := this._createEntityData()

        this.SetupEntity()

        if (this.storageObj.HasData(this) && autoLoad) {
            this.LoadEntity(false, true)
        }
    }

    static Create(container, eventMgr, id, entityTypeId, storageObj, idSanitizer, parentEntity := "") {
        className := this.Prototype.__Class

        return %className%(
            id,
            entityTypeId,
            container,
            eventMgr,
            storageObj,
            idSanitizer,
            parentEntity
        )
    }

    DiscoverParentEntity(container, eventMgr, id, storageObj, idSanitizer) {
        return ""
    }

    GetParentEntity() {
        return this.parentEntityObj
    }

    SetParentEntity(parentEntity) {
        this.parentEntityObj := parentEntity
    }

    SetupEntity() {
        event := EntityEvent(EntityEvents.ENTITY_PREPARE, this.entityTypeId, this)
        this.eventMgr.DispatchEvent(event)
    }

    GetAllValues(raw := false) {
        return this.GetData().GetMergedData(!raw)
    }

    GetEntityTypeId() {
        return this.entityTypeId
    }

    GetEntityType() {
        return this.container.Get("manager.entity_type")[this.EntityTypeId]
    }

    _createEntityData() {
        return LayeredEntityData(Map(), this.InitializeDefaults(), this.getEntityLayers())
    }

    InitializeDefaults() {
        return Map(
            "name", this.Id
        )
    }

    getEntityLayers() {
        layers := []

        event := EntityLayersEvent(EntityEvents.ENTITY_CUSTOM_DATA_LAYERS, this.entityTypeId, this, layers)
        this.eventMgr.DispatchEvent(event)

        event := EntityLayersEvent(EntityEvents.ENTITY_CUSTOM_DATA_LAYERS_ALTER, this.entityTypeId, this, event.Layers)
        this.eventMgr.DispatchEvent(event)

        return event.Layers
    }

    populateEntityLayers(layeredData) {
        layeredData.SetLayer("auto", this.AutoDetectValues())

        event := EntityDataEvent(EntityEvents.ENTITY_CUSTOM_DATA_POPULATE, this.entityTypeId, this, layeredData)
        this.eventMgr.DispatchEvent(event)

        event := EntityDataEvent(EntityEvents.ENTITY_CUSTOM_DATA_ALTER, this.entityTypeId, this, layeredData)
        this.eventMgr.DispatchEvent(event)
    }

    GetData() {
        return this.dataObj
    }

    GetValue(key) {
        if (key == "id") {
            return this.GetId()
        }

        return this.GetData().GetValue(key)
    }

    SetValue(key, value) {
        if (key == "id") {
            this.SetId(value)
        } else {
            this.GetData().SetValue(key, value)
        }
    }

    GetId() {
        return this.idVal
    }

    SetId(newId) {
        throw EntityException("Setting the ID is not supported by this entity.")
    }

    HasId(negate := false) {
        hasId := !!(this.GetId())

        return negate ? !hasId : hasId
    }

    Has(key, allowEmpty := true) {
        return this.GetData().HasValue(key, "", allowEmpty)
    }

    DeleteValue(key) {
        return this.GetData().DeleteValue(key, "config")
    }

    GetRawValues(process := true) {
        return this.GetData().GetMergedData(process)
    }

    CreateSnapshot(name) {
        this.GetData().CreateSnapshot(name)
        return this
    }

    RestoreSnapshot(name) {
        this.GetData().RestoreSnapshot(name)
        return this
    }

    GetStorageId() {
        return this.Id
    }

    LoadEntity(reload := false, recurse := false) {
        loaded := false

        if (!this.loaded || reload) {
            if (this.storageObj.HasData(this.GetStorageId())) {
                this.GetData().SetLayer("config", this.storageObj.LoadData(this.GetStorageId()))
            }
            
            this.RefreshEntityData(false)
            this.CreateSnapshot("original")
        
            this.loaded := true
            loaded := true
        }

        if (recurse) {
            for index, entityObj in this.GetReferencedEntities() {
                entityObj.LoadEntity(reload, recurse)
            }
        }

        if (loaded) {
            event := EntityEvent(EntityEvents.ENTITY_LOADED, this.entityTypeId, this)
            this.eventMgr.DispatchEvent(event)
        }
    }

    RefreshEntityData(recurse := true) {
        this.populateEntityLayers(this.GetData())

        if (recurse) {
            for index, entityObj in this.GetReferencedEntities() {
                entityObj.RefreshEntityData(recurse)
            }
        }

        event := EntityRefreshEvent(EntityEvents.ENTITY_REFRESH, this.entityTypeId, this, recurse)
        this.eventMgr.DispatchEvent(event)
    }

    AutoDetectValues() {
        return Map()
    }

    SaveEntity(recurse := true) {
        alreadyExists := this.storageObj.HasData(this)

        event := EntityEvent(EntityEvents.ENTITY_PRESAVE, this.entityTypeId, this)
        this.eventMgr.DispatchEvent(event)
        
        this.storageObj.SaveData(this.GetStorageId(), this.GetData().GetLayer("config"))
        this.CreateSnapshot("original")

        if (recurse) {
            for index, entityObj in this.GetReferencedEntities() {
                entityObj.SaveEntity(recurse)
            }
        }

        if (alreadyExists) {
            event := EntityEvent(EntityEvents.ENTITY_UPDATED, this.entityTypeId, this)
            this.eventMgr.DispatchEvent(event)
        } else {
            event := EntityEvent(EntityEvents.ENTITY_CREATED, this.entityTypeId, this)
            this.eventMgr.DispatchEvent(event)
        }
    }

    RestoreEntity(snapshot := "original") {
        if (this.GetData().HasSnapshot(snapshot)) {
            this.GetData().RestoreSnapshot(snapshot)

            event := EntityEvent(EntityEvents.ENTITY_RESTORED, this.entityTypeId, this)
            this.eventMgr.DispatchEvent(event)
        }
    }

    DeleteEntity() {
        if (this.storageObj.HasData(this.GetStorageId())) {
            event := EntityEvent(EntityEvents.ENTITY_PREDELETE, this.entityTypeId, this)
            this.eventMgr.DispatchEvent(event)

            this.storageObj.DeleteData(this.GetStorageId())

            event := EntityEvent(EntityEvents.ENTITY_DELETED, this.entityTypeId, this)
            this.eventMgr.DispatchEvent(event)
        }
    }

    Validate() {
        validateResult := Map("success", true, "invalidKeys", [])

        event := EntityValidateEvent(EntityEvents.ENTITY_VALIDATE, this.entityTypeId, this, validateResult)
        this.eventMgr.DispatchEvent(event)
        
        return event.ValidateResult
    }

    IsModified(recurse := false) {
        changes := this.DiffChanges(recurse)

        return !!(changes.GetAdded().Count || changes.GetModified().Count || changes.GetDeleted().Count)
    }

    DiffChanges(recursive := true) {
        diff := this.GetData().DiffChanges("original", "config")

        if (recursive) {
            diffs := [diff]

            for index, referencedEntity in this.GetReferencedEntities(true) {
                diffs.Push(referencedEntity.DiffChanges(recursive))
            }

            diff := DiffResult.Combine(diffs)
        }

        return diff
    }

    GetReferencedEntities(onlyChildren := false) {
        return []
    }

    Edit(mode := "config", owner := "") {
        this.LoadEntity()
        editMode := mode == "child" ? "config" : mode
        result := this.LaunchEditWindow(editMode, owner)
        fullDiff := ""

        if (result == "Cancel" || result == "Skip") {
            this.RestoreEntity()
        } else {
            fullDiff := this.DiffChanges(true)

            if (mode == "config" && fullDiff.HasChanges()) {
                this.SaveEntity()
            }
        }

        if (!fullDiff) {
            fullDiff := DiffResult(Map(), Map(), Map())
        }

        return fullDiff
    }

    LaunchEditWindow(mode, ownerOrParent := "") {
        result := "Cancel"

        while (mode) {
            result := this.app.Service("manager.gui").Dialog(Map(
                "type", "SimpleEntityEditor",
                "mode", mode,
                "child", !!(ownerOrParent),
                "ownerOrParent", ownerOrParent
            ), this)

            reloadPrefix := "mode:"

            if (result == "Simple") {
                mode := "simple"
            } else if (result == "Advanced") {
                mode := "config"
            } else if (result && InStr(result, reloadPrefix) == 1) {
                mode := SubStr(result, StrLen(reloadPrefix) + 1)
            } else {
                mode := ""
            }
        }

        return result
    }

    RevertToDefault(key) {
        this.GetData().DeleteValue(key, "config")
    }

    GetEditorButtons(mode) {
        buttonDefs := ""

        if (mode == "config") {
            buttonDefs := "*&Save|&Cancel"
        } else if (mode == "build") {
            buttonDefs := "*&Continue|&Skip"
        }

        return buttonDefs
    }

    GetEditorDescription(mode) {
        text := ""

        if (mode == "config") {
            text := "The details entered here will be saved and used for all future builds."
        } else if (mode == "build") {
            text := "The details entered here will be used for this build only."
        }

        return text
    }
}
