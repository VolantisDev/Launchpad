; TODO: Automatically return properties from the entity data or an exception if they don't exist
class EntityBase {
    keyVal := ""
    configObj := ""
    requiredConfigKeysVal := []
    configPrefix := ""
    entityData := ""
    parentEntity := ""
    children := Map()
    originalObj := ""
    sanitizeKey := true

    /**
    * BASE SETTINGS
    * 
    * These are the main pieces of data that is interacted with and that all of the other settings are pulled from.
    */

    ; The ID used to refer to the entity, typically the entity's name, but it should only contain characters valid in a filename.
    ; It will be used for the name of directories and most files related to the entity.
    ; 
    ; If this key matches the DataSourceKey, then a shortcut can be used such that 
    Key {
        get => this.keyVal
        set => this.keyVal := value
    }

    ; Configuration that has often been merged with defaults from external sources.
    ; This is the object that most of the other values in this class come from, but it can contain custom items too.
    Config {
        get => this.entityData.GetMergedData()
    }

    ; The unmodified original configuration from the entity.
    ; When editing the entity, this is where the raw updated configuration is stored before it's actually saved.
    UnmergedConfig {
        get => this.entityData.GetLayer("config")
        set => this.entityData.SetLayer("config", value)
    }
    
    ; The object that was originally passed in. This is left unmodified until modified values are actually "saved" at which point they will be copied back into this object.
    ConfigObject {
        get => this.configObj
        set => this.configObj := value
    }

    ; Gets tor sets the configuration keys that are required to have a valid value before this entity is considered valid.
    RequiredConfigKeys {
        get => this.requiredConfigKeysVal
        set => this.requiredConfigKeysVal := value
    }

    ; Wherever the entity's name is displayed, this value will be used.
    ; It defaults to the key if it is not set, which is usually sufficient.
    DisplayName {
        get => this.GetConfigValue("DisplayName", false)
        set => this.SetConfigValue("DisplayName", value, false)
    }

    __New(key, configObj, parentEntity := "", requiredConfigKeys := "") {
        InvalidParameterException.CheckTypes(
            "EntityBase", 
            "key", key, "String", 
            "configObj", configObj, "Map"
        )
    
        if (parentEntity != "") {
            InvalidParameterException.CheckTypes("EntityBase", "parentEntity", parentEntity, "EntityBase")
        }

        InvalidParameterException.CheckEmpty("EntityBase", "key", key)

        if (this.sanitizeKey) {
            ; TODO Load the sanitizer from the container
            sanitizer := StringSanitizer()
            key := sanitizer.Process(key)
        }

        this.keyVal := key
        this.configObj := configObj
        this.parentEntity := parentEntity
        this.entityData := this.createLayeredData()

        this.initializeRequiredConfigKeys(requiredConfigKeys)
    }

    static CreateEntity(container, key, configObj, parentEntity := "", requiredConfigKeys := "") {
        className := this.Prototype.__Class

        return %className%(
            key, 
            configObj, 
            parentEntity, 
            requiredConfigKeys
        )
    }

    createLayeredData() {
        layeredData := LayeredEntityData(this.configObj.Clone(), this.InitializeDefaults(), this.getEntityLayers())
        this.entityData := layeredData
        this.populateEntityLayers(layeredData)
        layeredData.SetAutoDetectedDefaults(this.AutoDetectValues())
        layeredData.StoreOriginal()
        return layeredData
    }

    getEntityLayers() {
        return []
    }

    poplateEntityLayers(layeredData) {

    }

    StoreOriginal(recursive := true, update := false) {
        this.entityData.StoreOriginal(update)

        for index, child in this.children {
            child.StoreOriginal(recursive, update)
        }
    }

    RestoreFromOriginal(recursive := true) {
        this.entityData.RestoreFromOriginal()

        for index, child in this.children {
            child.RestoreFromOriginal(recursive)
        }
    }

    ; NOTICE: Object not yet fully loaded. Might not be safe to call this.entityData
    InitializeDefaults() {
        return Map(
            "DisplayName", this.keyVal,
        )
    }

    AutoDetectValues() {
        return Map()
    }

    initializeRequiredConfigKeys(requiredConfigKeys := "") {
        if (requiredConfigKeys != "") {
            this.AddRequiredConfigKeys(requiredConfigKeys)
        }

        if (this.Config.Has("RequiredConfigKeys")) {
            this.AddRequiredConfigKeys(this.Config["RequiredConfigKeys"])
        }
    }

    AddRequiredConfigKeys(configKeys, addPrefix := false) {
        for index, requiredKey in configKeys {
            if (!this.ConfigKeyIsRequired(requiredKey)) {
                if (addPrefix) {
                    requiredKey := this.configPrefix . requiredKey
                }

                this.requiredConfigKeysVal.push(requiredKey)
            }
        }
    }

    ConfigKeyIsRequired(key, addPrefix := false) {
        isRequired := false

        if (addPrefix) {
            key := this.configPrefix . key
        }

        for index, requiredKey in this.requiredConfigKeysVal {
            if (key == requiredKey) {
                isRequired := true
                break
            }
        }

        return isRequired
    }

    MergeFromObject(mainObject, defaults, overwriteKeys := false) {
        for key, value in defaults {
            if (overwriteKeys or !mainObject.Has(key)) {
                if (value == "true" or value == "false") {
                    mainObject[key] := (value == "true")
                } else {
                    mainObject[key] := value
                }
            }
        }

        return mainObject
    }

    GetConfigValue(key, usePrefix := true, processValue := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }
        
        return this.entityData.GetValue(key, processValue)
    }

    SetConfigValue(key, value, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        this.entityData.SetValue(key, value, "config")
        return this
    }

    HasConfigValue(key, usePrefix := true, allowEmpty := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        return this.entityData.HasValue(key, "", allowEmpty)
    }

    DeleteConfigValue(key, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        this.entityData.DeleteValue(key, "config")
        return this
    }

    /**
    * ENTITY ACTIONS
    */

    Validate() {
        validateResult := Map("success", true, "invalidKeys", Array())

        for index, requiredKey in this.RequiredConfigKeys {
            if (!this.entityData.HasValue(requiredKey, "", false)){
                validateResult["success"] := false
                validateResult["invalidKeys"].push(requiredKey)
            }
        }

        for key, child in this.children {
            childValidateResult := child.Validate()

            if (!childValidateResult["success"]) {
                validateResult["success"] := false

                for index, invalidKey in childValidateResult["invalidKeys"] {
                    validateResult["invalidKeys"].Push(invalidKey)
                }
            }
        }

        return validateResult
    }

    DiffChanges(recursive := true) {
        diff := this.entityData.DiffChanges("config")

        if (!recursive) {
            return diff
        }

        added := Map()
        modified := Map()
        deleted := Map()

        diffs := [diff]

        for index, child in this.children {
            diffs.Push(child.DiffChanges(recursive))
        }

        for index, diff in diffs {
            for key, item in diff.GetAdded() {
                if (!added.Has(key) && !modified.Has(key) && !deleted.Has(key)) {
                    added[key] := item
                }
            }

            for key, item in diff.GetModified() {
                if (!added.Has(key) && !modified.Has(key) && !deleted.Has(key)) {
                    modified[key] := item
                }
            }

            for key, item in diff.GetDeleted() {
                if (!added.Has(key) && !modified.Has(key) && !deleted.Has(key)) {
                    deleted[key] := item
                }
            }
        }

        return DiffResult(added, modified, deleted)
    }

    /*
        Default modes:
            - config - saves changes
            - validate - diffs without saving
            - child - similar to config but doesn't save
    */
    Edit(mode := "config", owner := "") {
        this.StoreOriginal()
        editMode := mode == "child" ? "config" : mode
        result := this.LaunchEditWindow(editMode, owner)
        fullDiff := ""

        if (result == "Cancel" || result == "Skip") {
            this.RestoreFromOriginal()
        } else {
            fullDiff := this.DiffChanges(true)

            if (mode == "config" && fullDiff.HasChanges()) {
                this.SaveModifiedData()
                this.StoreOriginal(true, true)
            }
        }

        if (fullDiff == "") {
            fullDiff := DiffResult(Map(), Map(), Map())
        }

        return fullDiff
    }

    LaunchEditWindow(mode, owner) {
        return "Cancel"
    }

    SaveModifiedData() {
        diff := this.DiffChanges(false)

        if (diff != "" && diff.HasChanges()) {
            for key, val in diff.GetAdded() {
                this.configObj[key] := val
            }

            for key, val in diff.GetModified() {
                this.configObj[key] := val
            }

            for key, val in diff.GetDeleted() {
                if (this.configObj.Has(key)) {
                    this.configObj.Delete(key)
                }
            }
        }

        for key, child in this.children {
            child.SaveModifiedData()
        }
    }

    RevertToDefault(field) {
        this.entityData.DeleteValue(field, "config")
    }

    GetAssetPath(filePath) {
        return this.AssetsDir . "\" . filePath
    }

    DereferenceKey(key, map) {
        if (map.Has(key) && Type(map[key]) == "String") {
            key := this.DereferenceKey(map[key], map)
        }

        return key
    }
}
