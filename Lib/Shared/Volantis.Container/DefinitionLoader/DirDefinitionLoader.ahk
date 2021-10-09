class DirDefinitionLoader extends StructuredDataDefinitionLoader {
    serviceDir := ""
    fileSuffix := ""
    sdFactory := ""
    recursive := ""
    ignoreInvalid := ""

    __New(sdFactory, serviceDir, fileSuffix := "", recursive := false, ignoreInvalid := true, servicesKey := "", parametersKey := "") {
        this.sdFactory := sdFactory
        this.serviceDir := serviceDir
        this.fileSuffix := fileSuffix
        this.recursive := recursive
        this.ignoreInvalid := ignoreInvalid

        this.servicesKey := servicesKey ? servicesKey : "services"
        this.parametersKey := parametersKey ? parametersKey : "parameters"

        data := this.LoadStructuredData(serviceDir)

        super.__New(
            data,
            data,
            servicesKey,
            parametersKey
        )
    }
    
    LoadStructuredData(dirPath) {
        if (!dirPath) {
            throw FileSystemException("Dir path " . dirPath . " must be specified")
        }

        if (!DirExist(dirPath)) {
            throw ContainerException("Definition directory " . dirPath . " not found")
        }

        data := Map()

        if (this.servicesKey) {
            data[this.servicesKey] := Map()
        }

        if (this.parametersKey) {
            data[this.parametersKey] := Map()
        }

        opts := this.recursive ? "FR" : "F"
        pattern := dirPath . "\*"

        if (this.fileSuffix) {
            pattern .= this.fileSuffix
        }

        Loop Files pattern, opts {
            try {
                fileSuffix := this.fileSuffix

                if (!fileSuffix && A_LoopFileExt) {
                    fileSuffix := "." . A_LoopFileExt
                }

                componentName := SubStr(A_LoopFileName, 1, -StrLen(fileSuffix))
                loader := FileDefinitionLoader(
                    this.sdFactory,
                    A_LoopFileFullPath,
                    true, 
                    "", 
                    this.servicesKey, 
                    this.parametersKey
                )
                loaderServices := loader.LoadServiceDefinitions()
                loaderParameters := loader.LoadParameterDefinitions()
                
                if (loaderServices && loaderServices.Count) {
                    data[this.servicesKey][componentName] := loaderServices
                }

                if (loaderParameters && loaderParameters.Count) {
                    data[this.parametersKey][componentName] := loaderParameters
                }
            } catch as er {
                if (!this.ignoreInvalid) {
                    throw DataException("Structured data file " . A_LoopFileFullPath . " could not be loaded")
                }
            }
        }

        return this.sdFactory.Create("basic", data)
    }
}
