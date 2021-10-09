class GuiFactory {
    app := ""
    container := ""
    themeMgr := ""
    idGeneratorObj := ""
    typeMap := Map()

    __New(container, themeMgr, idGeneratorObj, typeMap := "") {
        this.container := container
        this.app := container.GetApp()
        this.themeMgr := themeMgr
        this.idGeneratorObj := idGeneratorObj

        if (typeMap) {
            this.SetTypes(typeMap)
        }
    }

    SetTypes(typeMap) {
        for guiType, className in typeMap {
            this.SetType(guiType, className)
        }
    }

    SetType(guiType, className) {
        this.typeMap[guiType] := className
    }

    CreateGui(guiType, guiId := "", params*) {
        className := this.GetGuiClass(guiType, params*)

        if (!guiId) {
            guiId := this.GetGuiId(guiType, params*)
        }

        return %className%(
            this.app,
            this.themeMgr[""],
            guiId,
            params*
        )
    }

    CreateServiceDefinition(guiType, guiId := "", params*) {
        arguments := [this.app, this.themeMgr[""], guiId]

        if (!guiId) {
            guiId := this.CreateGuiId(guiType, params*)
        }

        for index, param in params {
            arguments.Push(param)
        }

        return Map(
            "class", this.GetGuiClass(guiType, params*),
            "arguments", arguments
        )
    }

    GetGuiClass(guiType, params*) {
        return this.typeMap.Has(guiType) ? this.typeMap[guiType] : guiType
    }

    CreateGuiId(guiType, params*) {
        return this.idGeneratorObj.Generate()
    }
}
