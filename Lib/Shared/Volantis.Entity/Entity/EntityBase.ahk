class EntityBase {
    idVal := ""
    entityTypeIdVal := ""
    parentEntityObj := ""
    parentEntityStorage := false
    container := ""
    app := ""
    eventMgr := ""
    dataObj := ""
    storageObj := ""
    idSanitizer := ""
    sanitizeId := true
    loaded := false
    merger := ""
    dataLayer := "data"
    cloner := ""

    Id {
        get => this.GetId()
        set => this.SetId(value)
    }

    EntityTypeId {
        get => this.entityTypeIdVal
        set => this.entityTypeIdVal := value
    }

    EntityType {
        get => this.GetEntityType()
        set => this.EntityTypeId := value
    }

    FieldData {
        Get => this.GetData().GetMergedData()
    }

    Name {
        get => this.GetValue("name")
        set => this.SetValue("name", value)
    }

    RawData {
        get => this.GetData().GetLayer(this.dataLayer)
        set => this.GetData().SetLayer(this.dataLayer, value)
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

    __New(id, entityTypeId, container, eventMgr, storageObj, idSanitizer := "", autoLoad := true, parentEntity := "", parentEntityStorage := false) {
        this.app := container.GetApp()
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
        this.parentEntityStorage := parentEntityStorage

        if (!parentEntity) {
            parentEntity := this.DiscoverParentEntity(container, eventMgr, id, storageObj, idSanitizer)
        }

        if (parentEntity) {
            this.SetParentEntity(parentEntity)
        }

        this._createEntityData()
        this.SetupEntity()

        if (autoLoad) {
            this.LoadEntity(false, true)
        }
    }

    static Create(container, eventMgr, id, entityTypeId, storageObj, idSanitizer, autoLoad := true, parentEntity := "", parentEntityStorage := false) {
        className := this.Prototype.__Class

        return %className%(
            id,
            entityTypeId,
            container,
            eventMgr,
            storageObj,
            idSanitizer,
            autoLoad,
            parentEntity,
            parentEntityStorage
        )
    }

    _createEntityData() {
        this.dataObj := EntityData(this, this._getLayerNames(), this._getLayerSources())
    }

    _getLayerNames() {
        ; "auto" and "data" are automatically added at the end of the array later.
        return ["defaults"]
    }

    _getLayerSources() {
        return Map(
            "defaults", ObjBindMethod(this, "InitializeDefaults"),
            "auto", ObjBindMethod(this, "AutoDetectValues"),
            "data", EntityStorageLayerSource(this.storageObj, this.GetStorageId())
        )
    }

    /**
     * Get an array of all IDs
     * 
     * List managed IDs and give modules a chance to add others.
     */
    ListEntities(includeManaged := true, includeExtended := true) {
        return this.container["entity_manager." . this.EntityTypeId]
            .ListEntities(includeManaged, includeExtended)
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

    GetEntityType() {
        ; @todo Inject entity type manager service
        return this.container.Get("manager.entity_type")[this.EntityTypeId]
    }

    InitializeDefaults(recurse := true) {
        defaults := Map(
            "name", this.Id
        )

        if (recurse) {
            for key, referencedEntity in this.GetReferencedEntities(true) {
                this.merger.Merge(defaults, referencedEntity.InitializeDefaults())
            }
        }

        return defaults
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
        return this.GetData().DeleteValue(key, this.dataLayer)
    }

    CreateSnapshot(name, recurse := true) {
        this.GetData().CreateSnapshot(name)

        if (recurse) {
            for index, entityObj in this.GetReferencedEntities(true) {
                if (entityObj.HasOwnDataStorage()) {
                    entityObj.GetData().CreateSnapshot(name, recurse)
                }
            }
        }

        return this
    }

    HasOwnDataStorage() {
        return this.dataObj
    }

    RestoreSnapshot(name, recurse := true) {
        this.GetData().RestoreSnapshot(name)

        if (recurse) {
            for index, entityObj in this.GetReferencedEntities(true) {
                if (entityObj.HasOwnDataStorage()) {
                    entityObj.GetData().RestoreSnapshot(name, recurse)
                }
            }
        }

        return this
    }

    GetStorageId() {
        return this.Id
    }

    LoadEntity(reload := false, recurse := false) {
        loaded := false

        if (!this.loaded || reload) {
            this.RefreshEntityData(true)
            this.CreateSnapshot("original")
            this.loaded := true
            loaded := true
        }

        if (recurse) {
            for index, entityObj in this.GetReferencedEntities(true) {
                entityObj.LoadEntity(reload, recurse)
            }
        }

        if (loaded) {
            event := EntityEvent(EntityEvents.ENTITY_LOADED, this.entityTypeId, this)
            this.eventMgr.DispatchEvent(event)
        }
    }

    RefreshEntityData(recurse := true, reloadUserData := false) {
        this.GetData().UnloadAllLayers(reloadUserData)

        if (recurse) {
            for index, entityObj in this.GetReferencedEntities(true) {
                entityObj.RefreshEntityData(recurse, reloadUserData)
            }
        }

        event := EntityRefreshEvent(EntityEvents.ENTITY_REFRESH, this.entityTypeId, this, recurse)
        this.eventMgr.DispatchEvent(event)
    }

    AutoDetectValues(recurse := true) {
        values := Map()

        if (recurse) {
            for key, referencedEntity in this.GetReferencedEntities(true) {
                this.merger.Merge(values, referencedEntity.AutoDetectValues(recurse))
            }
        }

        event := EntityDetectValuesEvent(EntityEvents.ENTITY_DETECT_VALUES, this.EntityTypeId, this, values)
        this.eventMgr.DispatchEvent(event)

        event := EntityDetectValuesEvent(EntityEvents.ENTITY_DETECT_VALUES_ALTER, this.EntityTypeId, this, event.Values)
        this.eventMgr.DispatchEvent(event)

        return event.Values
    }

    SaveEntity(recurse := true) {
        if (!this.dataObj) {
            return
        }

        alreadyExists := this.dataObj.HasData(true)

        event := EntityEvent(EntityEvents.ENTITY_PRESAVE, this.entityTypeId, this)
        this.eventMgr.DispatchEvent(event)
        
        this.GetData().SaveData()
        this.CreateSnapshot("original")

        if (recurse) {
            for index, entityObj in this.GetReferencedEntities(true) {
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

        event := EntityEvent(EntityEvents.ENTITY_SAVED, this.entityTypeId, this)
        this.eventMgr.DispatchEvent(event)
    }

    RestoreEntity(snapshot := "original") {
        dataObj := this.GetData()
        if (dataObj.HasSnapshot(snapshot)) {
            dataObj.RestoreSnapshot(snapshot)

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
        diff := this.GetData().DiffChanges("original", this.dataLayer)

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
            result := this.app["manager.gui"].Dialog(Map(
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
        this.GetData().DeleteUserValue(key)
    }

    GetEditorButtons(mode) {
        return (mode == "build")
            ? "*&Continue|&Skip"
            : "*&Save|&Cancel"
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

    GetAllChildEntityData() {
        return this.GetData().GetExtraData()
    }

    GetChildEntityData(entityTypeId, entityId) {
        dataKey := entityTypeId . "." . entityId

        childData := this.GetData().GetExtraData(dataKey)

        return childData ? childData : Map()
    }

    SetChildEntityData(entityTypeId, entityId, data) {
        dataKey := entityTypeId . "." . entityId

        if (!data) {
            data := Map()
        }

        this.GetData().SetExtraData(dataKey, data)

        return this
    }

    HasChildEntityData(entityTypeId, entityId) {
        dataKey := entityTypeId . "." . entityId

        return this.GetData().HasExtraData(dataKey)
    }

    DeleteChildEntityData(entityTypeId, entityId) {
        dataKey := entityTypeId . "." . entityId

        this.GetData().DeleteExtraData(dataKey)

        return this
    }
}
