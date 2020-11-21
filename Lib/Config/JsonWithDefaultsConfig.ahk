#Include JsonConfig.ahk

; JSON configuration objects that can reference a default set of values which will be optionally merged in when reading the configuration
class JsonWithDefaultsConfig extends JsonConfig {
    defaults := Map()
    defaultReferenceKey := "defaults"
    autoMerge := true

    __New(app, configPath := "", autoLoad := true, autoMerge := true) {
        this.autoMerge := autoMerge
        super.__New(app, configPath, autoLoad)
    }

    LoadConfig() {
        super.LoadConfig()

        if (this.autoMerge) {
            this.MergeConfig()
        }
    }

    MergeConfig() {
        progressText := "Please wait while your configuration is processed."
        itemCount := this.config[this.primaryConfigKey].Count
        progress := this.app.GuiManager.ProgressIndicator("Loading Config", progressText, this.app.GuiManager.GetGuiObj("MainWindow"), false, "0-" . itemCount, 0, "Initializing...")

        count := 1
        for key, configItem in this.config[this.primaryConfigKey]
        {
            progress.SetValue(count, key . ": Loading config...")
            configItem := this.Dereference(key, configItem)
            this.config[this.primaryConfigKey][key] := this.MergeDefaults(key, configItem)
            count++
        }

        progress.Finish()
    }

    Dereference(key, configItem) {
        if (!IsObject(configItem)) {
            newConfigItem := Map()
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
        return (this.defaults.Has(key)) ? this.defaults[key] : this.LoadDefaultItemFromSource(key, configItem)
    }

    LoadDefaultItemFromSource(key, configItem) {
        ; Load and optionally save the result to this.defaults to avoid loading it again if there are multiple instances.
        return Map()
    }
}
