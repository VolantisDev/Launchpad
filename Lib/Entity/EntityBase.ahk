class EntityBase {
    app := ""
    keyVal := ""
    defaultDataSourceKey := ""
    mergedConfigVal := ""
    configPrefix := "Launcher"
    unmergedConfigVal := Map()
    configObj := ""
    initialDefaults := Map()
    requiredConfigKeysVal := Array()
    originalObj := ""

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

    ; Configuration that has often been merged with defaults from external sources. If it has not been merged, it returns the UnmergedConfig.
    ; This is the object that most of the other values in this class come from, but it can contain custom items too.
    Config {
        get => this.mergedConfigVal != "" ? this.mergedConfigVal : this.UnmergedConfig
        set => this.mergedConfigVal := value
    }

    ConfigObject {
        get => this.configObj
        set => this.configObj := value
    }

    ; The unmodified original configuration from the entity.
    ; When editing the entity, this is where the raw updated configuration is stored.
    UnmergedConfig {
        get => this.unmergedConfigVal
        set => this.unmergedConfigVal := value
    }

    ; This retains a copy of the entity before any modifications were made during editing so that it can be compared later.
    ; This is populated prior to editing a entity, and deleted after the editing operation is completed.
    ; For example, if the key is changed, this will ensure the original item will be removed when the revised item is saved with a new key.
    Original[] {
        get => (this.originalObj != "") ? this.originalObj : this.StoreOriginal()
        set => this.originalObj := value
    }

    ; The data source keys to load defaults from, in order.
    ; The default datasource is "api" which connects to the default api endpoint (Which can be any HTTP location compatible with Launchpad's "LauncherDB" JSON format)
    DataSourceKeys {
        get => this.GetDataSourceKeys()
        set => this.SetConfigValue("DataSourceKeys", value, false)
    }

    ; The key that is used to look up the entity's data from configured external datasources.
    ; It defaults to the key which is usually sufficient, but it can be overridden by setting this value.
    ; Addtionally, multiple copies of the same datasource entity can exist by giving them different keys but using the same DataSourceKey
    DataSourceItemKey {
        get => this.GetConfigValue("DataSourceItemKey", false)
        set => this.SetConfigValue("DataSourceItemKey", value, false)
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

    ; The directory where any required assets for this entity will be saved.
    AssetsDir {
        get => this.GetConfigValue("AssetsDir", false)
        set => this.SetConfigValue("AssetsDir", value, false)
    }

    __New(app, key, configObj, requiredConfigKeys := "", defaultDataSourceKey := "") {
        this.app := app
        this.keyVal := key
        this.defaultDataSourceKey := (defaultDataSourceKey != "") ? defaultDataSourceKey : app.Config.DataSourceKey
        this.configObj := configObj
        this.unmergedConfigVal := configObj.Clone()
        this.initialDefaults := this.InitializeDefaults()
        this.InitializeRequiredConfigKeys(requiredConfigKeys)
    }

    /**
    * UTILITY METHODS
    */

    StoreOriginal(update := false) {
        if (update or this.originalObj == "") {
            this.originalObj := this.Clone()
            this.originalObj.configVal := this.unmergedConfigVal.Clone()
        }
        
        return this.originalObj
    }

    RestoreFromOriginal() {
        if (this.originalObj != "") {
            for name, val in this.Original.OwnProps() {
                if (name != "Original" and name != "ConfigObject")
                this.%name% := this.Original.%name%
            }
        }
    }

    MergeFromObject(mainObject, defaults, overwriteKeys := false) {
        for key, value in defaults {
            if (overwriteKeys or !mainObject.Has(key)) {
                mainObject[key] := value
            }
        }

        return mainObject
    }

    /**
    * CONFIG METHODS
    */

    GetConfigValue(key, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        return this.unmergedConfigVal.Has(key) ? this.unmergedConfigVal[key] : this.GetDefaultValue(key, false)
    }

    SetConfigValue(key, value, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        if (this.unmergedConfigVal == "") {
            this.unmergedConfigVal := Map()
        }

        this.unmergedConfigVal[key] := value
    }

    DeleteConfigValue(key, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        if (this.unmergedConfigVal.Has(key)) {
            this.unmergedConfigVal.Delete(key)
        }
    }

    ConfigKeyExists(key, checkMerged := true, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        config := checkMerged ? this.MergedConfig : this.UnmergedConfig
        return (config.Has(key) and config[key] != "")
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

    GetDefaultValue(key, addPrefix := false) {
        if (addPrefix) {
            key := this.configPrefix . key
        }

        defaultValue := ""

        if (this.initialDefaults.Has(key)) {
            defaultValue := this.initialDefaults[key]
        }

        return defaultValue
    }

    GetDataSourceKeys() {
        keys := this.GetConfigValue("DataSourceKeys", false)

        if (!Type(keys) == "Array") {
            keys := [keys]
        }

        return keys
    }

    GetDefaultAssetsDir() {
        return this.app.Config.AssetsDir . "\" . this.Key
    }

    /**
    * ENTITY ACTIONS
    */

    Validate() {
        validateResult := Map("success", true, "invalidKeys", Array())

        for index, requiredKey in this.RequiredConfigKeys {
            if (!this.HasProp(requiredKey) or this.%requiredKey% == "") {
                validateResult["success"] := false
                validateResult["invalidKeys"].push(requiredKey)
            }
        }

        return validateResult
    }

    MergeEntityDefaults(update := false) {
        if (update or this.mergedConfigVal == "") {
            this.initialDefaults := this.InitializeDefaults() ; Ensure defaults are up-to-date
            this.Config := this.MergeDefaultsIntoConfig(this.UnmergedConfig)
        }
        
        return this.Config
    }

    Edit(mode := "config", owner := "MainWindow") {
        this.StoreOriginal()
        result := this.LaunchEditWindow(mode, owner)

        if (result == "Cancel" || result == "Skip") {
            this.ManagedLauncher := this.Original.ManagedLauncher
            return false
        }

        valid := this.Validate()

        if (valid and mode == "config") {
            this.SaveModifiedData()
        }

        return valid
    }

    GetModifiedData() {
        modifiedData := Map()

        if (this.originalObj == "") {
            modifiedData := this.UnmergedConfig
        } else {
            for key, val in this.UnmergedConfig {
                if (!this.Original.UnmergedConfig.Has(key) || val != this.Original.UnmergedConfig[key]) {
                    modifiedData[key] := val
                }
            }
        }

        return modifiedData
    }

    SaveModifiedData() {
        this.configObj.SetValues(this.GetModifiedData())
    }

    /**
    * ENTITY HOOKS
    */

    InitializeDefaults() {
        defaults := Map()
        defaults["DataSourceKeys"] := this.defaultDataSourceKey
        defaults["DataSourceItemKey"] := this.Key
        defaults["DisplayName"] := this.Key
        defaults["AssetsDir"] := this.GetDefaultAssetsDir()
        return defaults
    }

    InitializeRequiredConfigKeys(requiredConfigKeys := "") {
        if (requiredConfigKeys != "") {
            this.AddRequiredConfigKeys(requiredConfigKeys)
        }

        if (this.Config.Has("RequiredConfigKeys")) {
            this.AddRequiredConfigKeys(this.Config["RequiredConfigKeys"])
        }
    }

    AutoDetectValues() {
    }

    MergeDefaultsIntoConfig(config) {
        return this.MergeFromObject(Map(), this.initialDefaults)
    }

    LaunchEditWindow(mode, owner) {
        return "Cancel"
    }

    GetAssetPath(filePath) {
        return this.AssetsDir . "\" . filePath
    }
}
