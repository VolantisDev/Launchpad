class FileDefinitionLoader extends StructuredDataDefinitionLoader {
    sdFactory := ""
    ignoreInvalid := ""

    __New(sdFactory, serviceFile, ignoreInvalid := false, parametersFile := "", servicesKey := "", parametersKey := "") {
        this.sdFactory := sdFactory
        this.ignoreInvalid := ignoreInvalid

        data := this.LoadStructuredData(serviceFile)
        parameterData := parametersFile ? this.LoadStructuredData(parametersFile) : data

        super.__New(
            data, 
            parameterData,
            servicesKey,
            parametersKey
        )
    }

    LoadStructuredData(filePath) {
        if (!FileExist(filePath)) {
            throw ContainerException("Structured data file " . filePath . " does not exist")
        }

        sd := ""

        try {
            sd := this.sdFactory.FromFile(filePath)
        } catch as er {
            if (!this.ignoreInvalid) {
                throw ContainerException("Structured data file " . filePath . " could not be loaded")
            }
        }

        return sd
    }
}
