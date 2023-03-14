class FileModuleInfo extends ParameterModuleInfo {
    structuredData := ""
    infoKey := ""
    filePath := ""

    __New(filePath, structuredData, container, key, infoKey := "module") {
        this.filePath := filePath
        this.structuredData := structuredData
        this.infoKey := infoKey

        super.__New(container, key)
    }

    SetDefaults() {
        super.SetDefaults()

        if (!this.moduleInfo.Has("file") || !this.moduleInfo["file"]) {
            this.moduleInfo["file"] := this.filePath
        }

        if (!this.moduleInfo.Has("dir") || !this.moduleInfo["dir"]) {
            SplitPath(this.moduleInfo["file"],, &dir)
            this.moduleInfo["dir"] := dir
        }
    }

    LoadParameters() {
        parameters := super.LoadParameters()

        if (!FileExist(this.filePath)) {
            throw ModuleException("Module info file " . this.filePath . " not found")
        }

        moduleData := this.structuredData.FromFile(this.filePath).Obj

        if (moduleData.Has(this.infoKey)) {
            for key, val in moduleData[this.infoKey] {
                parameters[key] := val
            }
        }

        return parameters
    }
}
