/*
    Customize the options that are used when creating GUIs by supplying a TypeMap. It might look like this:

    Map(
        "MainWindow", "CustomMainWindow",
        "SettingsWindow", Map(
            "class", "CustomSettingsWindow",
            "title", "Custom Settings Title"
        )
    )
*/
class GuiFactory {
    container := ""
    themeMgr := ""
    idGeneratorObj := ""
    typeMap := Map()
    defaultOwner := ""

    __New(container, themeMgr, idGeneratorObj, typeMap := "", defaultOwner := "") {
        this.container := container
        this.themeMgr := themeMgr
        this.idGeneratorObj := idGeneratorObj
        this.defaultOwner := defaultOwner

        if (typeMap) {
            this.SetTypes(typeMap)
        }
    }

    SetTypes(typeMap) {
        for guiType, typeInfo in typeMap {
            this.SetType(guiType, typeInfo)
        }
    }

    SetType(guiType, typeInfo) {
        if (Type(typeInfo) == "String") {
            typeInfo := Map("class", typeInfo)
        }

        this.typeMap[guiType] := typeInfo
    }

    CreateGui(config, params*) {
        className := this.GetGuiClass(config, params*)

        return %className%(
            this.container,
            this.themeMgr[],
            this.GetGuiConfig(config, params*),
            params*
        )
    }

    GetGuiType(config, params*) {
        guiType := ""

        if (config) {
            if (Type(config) == "String") {
                guiType := config
            } else if (config.Has("type")) {
                guiType := config["type"]
            }
        }

        if (!guiType) {
            throw AppException("Could not determine GUI class for window")
        }

        return guiType
    }

    GetGuiClass(config, params*) {
        guiType := this.GetGuiType(config, params*)
        guiClass := guiType

        if (Type(config) == "Map" && config.Has("class")) {
            guiClass := config["class"]
        } else if (this.typeMap.Has(guiType)) {
            if (Type(this.typeMap[guiType]) == "String") {
                guiClass := this.typeMap[guiType]
            } else if (this.typeMap[guiType].Has("class")) {
                guiClass := this.typeMap[guiType]["class"]
            }
        }

        if (!HasMethod(%guiClass%)) {
            throw AppException("GUI class " . guiClass . " is not callable")
        }

        return guiClass
    }

    GetDefaultGuiConfig() {
        return Map(
            "type", "",
            "title", "",
            "id", "",
            "ownerOrParent", this.defaultOwner,
            "child", false,
            "icon", "",
            "unique", false ; The GUI ID will be auto-generated if not set
        )
    }

    GetGuiConfig(config, params*) {
        newConfig := this.GetDefaultGuiConfig()
        guiType := this.GetGuiType(config, params*)
        newConfig["type"] := guiType

        typeConfig := this.typeMap.Has(guiType) ? this.typeMap[guiType] : Map()

        for key, val in typeConfig {
            newConfig[key] := val
        }

        if (Type(config) == "Map") {
            for key, val in config {
                newConfig[key] := val
            }
        }

        if (!newConfig.Has("id") || !newConfig["id"]) {
            if (newConfig.Has("unique") && newConfig["unique"]) {
                newConfig["id"] := this.CreateGuiId(config, params*)
            } else {
                newConfig["id"] := guiType
            }
        }

        if (newConfig["id"] == newConfig["ownerOrParent"]) {
            newConfig["ownerOrParent"] := ""
            newCOnfig["child"] := false
        }

        return newConfig
    }

    GetGuiId(config, params*) {
        config := this.GetGuiCOnfig(config, params*)
        return config["id"]
    }

    CreateGuiId(config, params*) {
        return this.idGeneratorObj.Generate()
    }
}
