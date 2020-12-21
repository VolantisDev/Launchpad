class EntityBase {
    app := ""
    keyVal := ""
    defaultDataSourceKey := ""
    dataSourcePath := ""
    mergedConfigVal := ""
    configPrefix := "Launcher"
    unmergedConfigVal := Map()
    configObj := ""
    initialDefaults := Map()
    dataSourceDefaults := ""
    requiredConfigKeysVal := []
    originalObj := ""
    children := Map()
    parentEntity := ""

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

    ; The directory where dependencies which have been installed for this entity can be accessed
    DependenciesDir {
        get => this.GetConfigValue("DependenciesDir", false)
        set => this.SetConfigValue("DependenciesDir", value, false)
    }

    __New(app, key, configObj, requiredConfigKeys := "", defaultDataSourceKey := "", parentEntity := "") {
        InvalidParameterException.CheckTypes("EntityBase", "app", app, "Launchpad", "key", key, "String", "configObj", configObj, "Map", "defaultDataSourceKey", defaultDataSourceKey, "")
        
        if (defaultDataSourceKey == "") {
            defaultDataSourceKey := app.Config.DataSourceKey
        }

        if (parentEntity != "") {
            InvalidParameterException.CheckTypes("EntityBase", "parentEntity", parentEntity, "EntityBase")
        }

        InvalidParameterException.CheckEmpty("EntityBase", "key", key, "defaultDataSourceKey", defaultDataSourceKey)

        this.app := app
        this.keyVal := key
        this.defaultDataSourceKey := defaultDataSourceKey
        this.configObj := configObj
        this.parentEntity := parentEntity
        this.unmergedConfigVal := configObj.Clone()
        this.initialDefaults := this.InitializeDefaults()
        this.InitializeRequiredConfigKeys(requiredConfigKeys)
    }

    /**
    * UTILITY METHODS
    */

    StoreOriginal(update := false) {
        if (this.originalObj == "" || update) {
            this.originalObj := this.Clone()
            this.originalObj.unmergedConfigVal := this.unmergedConfigVal.Clone()
            this.originalObj.mergedConfigVal := this.mergedConfigVal.Clone()
            this.originalObj.children := Map()

            for key, child in this.children {
                this.originalObj.children[key] := child.StoreOriginal(update)
            }
        }

        return this.originalObj
    }

    RestoreFromOriginal() {
        if (this.originalObj != "") {
            for name, val in this.originalObj.OwnProps() {
                if (name != "Original" and name != "ConfigObject")
                this.%name% := this.originalObj.%name%
            }

            ; @todo make sure this restores the children properly
        }
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

    /**
    * CONFIG METHODS
    */

    GetConfigValue(key, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        value := ""

        if (this.unmergedConfigVal.Has(key)) {
            value := this.unmergedConfigVal[key]
        } else if (this.Config.Has(key)) {
            value := this.Config[key]
        } else {
            value := this.GetDefaultValue(key, false)
        }

        return value
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

    GetDefaultDependenciesDir() {
        return this.app.appDir . "\Vendor"
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

    MergeItemDefault(key) {
        mergedConfig := this.MergeDefaultsIntoConfig(this.UnmergedConfig)

        if (mergedConfig.Has(key)) {
            this.Config[key] := mergedConfig[key]
        }

        return this.Config[key]
    }

    MergeEntityDefaults(update := false) {
        if (update or this.mergedConfigVal == "") {
            this.initialDefaults := this.InitializeDefaults()
            this.Config := this.MergeDefaultsIntoConfig(this.UnmergedConfig)
        }

        this.Config := this.SetDependentValues(this.Config)
        this.Config := this.ExpandPlaceholders(this.Config)

        this.AutoDetectValues()
        

        for key, child in this.children {
            child.MergeEntityDefaults(update)
        }
        
        return this.Config
    }

    SetDependentValues(config) {
        ; Override this to set default values for items that depend on other values
        return config
    }

    ExpandPlaceholders(config) {
        ; Override this to send additional variables through ExpandPlaceholders() or stop this functionality if not needed.
        for key, value in config {
            if (Type(config[key]) == "String") {
                config[key] := this.ExpandPlaceholderInValue(config[key])
            }
        }

        return config
    }

    ExpandPlaceholderInValue(value) {
        for varName, varVal in this.Config {
            value := StrReplace(value, "{{" . varName . "}}", varVal)
        }

        return value
    }

    GetDataSourceItemKey() {
        return this.Key
    }

    GetDataSourceItemPath() {
        return this.dataSourcePath
    }

    Edit(mode := "config", owner := "MainWindow") {
        this.StoreOriginal(true)
        result := this.LaunchEditWindow(mode, owner)

        if (result == "Cancel" || result == "Skip") {
            this.RestoreFromOriginal()
            return Map()
        }

        modified := this.CountModifiedValues(true)

        if (mode == "config") {
            this.SaveModifiedData()
        }

        return modified
    }

    CountModifiedValues(includeChildren := false) {
        modifiedValues := 0

        if (this.originalObj == "") {
            modifiedValues := this.UnmergedConfig.Count
        } else {
            for key, val in this.UnmergedConfig {
                if (!this.originalObj.UnmergedConfig.Has(key) || val != this.originalObj.UnmergedConfig[key]) {
                    modifiedValues++
                }
            }

            for key, val in this.originalObj.UnmergedConfig {
                if (!this.UnmergedConfig.Has(key)) {
                    modifiedValues++
                }
            }
        }

        if (includeChildren) {
            for key, child in this.children {
                modifiedValues := modifiedValues + child.CountModifiedValues(includeChildren)
            }
        }

        return modifiedValues
    }

    GetModifiedData(includeChildren := false) {
        modifiedData := Map()

        if (this.originalObj == "") {
            modifiedData := this.UnmergedConfig
        } else {
            for key, val in this.UnmergedConfig {
                if (!this.originalObj.UnmergedConfig.Has(key) || val != this.originalObj.UnmergedConfig[key]) {
                    modifiedData[key] := val
                }
            }
        }

        if (includeChildren) {
            for key, child in this.children {
                for modifiedKey, modifiedVal in child.GetModifiedData(includeChildren) {
                    modifiedData[modifiedKey] := modifiedVal
                }
            }
        }

        return modifiedData
    }

    SaveModifiedData() {
        for key, val in this.GetModifiedData() {
            this.configObj[key] := val
        }

        if (this.originalObj) {
            for key, val in this.originalObj.UnmergedConfig {
                if (!this.UnmergedConfig.Has(key) and this.configObj.Has(key)) {
                    this.configObj.Delete(key)
                }
            }
        }

        for key, child in this.children {
            child.SaveModifiedData()
        }
    }

    AggregateDataSourceDefaults() {
        if (this.dataSourceDefaults == "") {
            dataSources := this.GetAllDataSources()

            defaults := this.parentEntity != "" ? this.parentEntity.AggregateDataSourceDefaults() : Map()

            for index, dataSource in dataSources {
                defaults := this.MergeFromObject(defaults, this.GetDataSourceDefaults(dataSource))
            }

            this.dataSourceDefaults := defaults

            this.OverrideChildDefaults(defaults)

            for key, child in this.children {
                child.AggregateDataSourceDefaults()
            }
        }

        return this.dataSourceDefaults
    }

    OverrideChildDefaults(defaults) {

    }

    GetAllDatasources() {
        dataSources := Map()

        if (this.DataSourceKeys != "") {
            dataSourceKeys := (Type(this.DataSourceKeys) == "Array") ? this.DataSourceKeys : [this.DataSourceKeys]

            for index, dataSourceKey in dataSourceKeys {
                dataSource := this.app.DataSources.GetItem(dataSourceKey)

                if (dataSource != "") {
                    dataSources[dataSourceKey] := dataSource
                }
            }
        }

        return dataSources
    }

    GetDataSourceDefaults(dataSource) {
        defaults := Map()
        dsData := dataSource.ReadJson(this.GetDataSourceItemKey(), this.GetDataSourceItemPath())

        if (dsData != "" and dsData.Has("Defaults")) {
            defaults := this.MergeFromObject(defaults, dsData["Defaults"], false)
            defaults := this.MergeAdditionalDataSourceDefaults(defaults, dsData)
        }

        return defaults
    }

    MergeAdditionalDataSourceDefaults(defaults, dataSourceData) {
        return defaults
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
        defaults["DependenciesDir"] := this.GetDefaultDependenciesDir()
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

    GetMergedDefaults() {
        return this.MergeFromObject(this.AggregateDataSourceDefaults(), this.initialDefaults, false)
    }

    MergeDefaultsIntoConfig(config) {
        merged := this.MergeFromObject(Map(), config)
        return this.MergeFromObject(merged, this.GetMergedDefaults(), false)
    }

    RevertToDefault(field) {
        if (this.UnmergedConfig.Has(field)) {
            this.UnmergedConfig.Delete(field)
        }

        mergedDefaults := this.GetMergedDefaults()
        if (mergedDefaults.Has(field)) {
            this.Config[field] := mergedDefaults[field]
        }
    }

    LaunchEditWindow(mode, owner) {
        return "Cancel"
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
