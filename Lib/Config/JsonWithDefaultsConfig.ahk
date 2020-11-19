; JSON configuration objects that can reference a default set of values which will be optionally merged in when reading the configuration
class JsonWithDefaultsConfig extends JsonConfig {
    defaults := {}
    defaultReferenceKey := "defaults"
    autoMerge := true

    __New(app, configPath := "", autoLoad := true, autoMerge := true) {
        this.autoMerge := autoMerge
        base.__New(app, configPath, autoLoad)
    }

    LoadConfig() {
        base.LoadConfig()

        if (this.autoMerge) {
            this.MergeConfig()
        }
    }

    MergeConfig() {
        Progress, Off
        Progress, M, Initializing..., Please wait while launcher data is loaded from configured sources., Loading Config

        count := 0
        for key, value in this.config[this.primaryConfigKey]
            count++
        Progress, R0-%count% M, Initializing..., Please wait while launcher data is loaded from configured sources., Loading Config

        count := 0
        for key, configItem in this.config[this.primaryConfigKey]
        {
            count++
            Progress, %count%,% "Loading data for " . key . "...", Please wait while launcher data is loaded from configured sources., Loading Config

            configItem := this.Dereference(key, configItem)
            this.config[this.primaryConfigKey][key] := this.MergeDefaults(key, configItem)
        }

        Progress, Off
    }

    Dereference(key, configItem) {
        if (!IsObject(configItem)) {
            newConfigItem := {}
            newConfigItem[this.defaultReferenceKey] := configItem
            configItem := newConfigItem
        }

        return configItem
    }

    MergeDefaults(key, configItem) {
        return this.MergeData(this.GetDefaultItem(key, configItem), configItem) 
    }

    MergeData(object1, object2) {
        newObject := object1

        for key, value in object2
        {
            newObject[key] := value
        }

        return newObject
    }

    GetDefaultItem(key, configItem) {
        defaults := {}

        if (this.defaults.HasKey(key)) {
            defaults := this.defaults[key]
        } else {
            defaults := this.LoadDefaultItemFromSource(key, configItem)
        }

        return defaults
    }

    LoadDefaultItemFromSource(key, configItem) {
        ; Load and optionally save the result to this.defaults to avoid loading it again if there are multiple instances.
        return {} 
    }
}
