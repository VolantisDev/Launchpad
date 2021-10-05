class StructuredFileDefinitionLoader extends StructuredDataDefinitionLoader {
    serviceStructuredData := ""
    parameterStructuredData := ""

    __New(serviceFile, parametersFile := "", servicesKey := "", parametersKey := "") {
        this.serviceStructuredData := this.LoadStructuredData(serviceFile)

        if (parametersFile) {
            this.parameterStructuredData := this.LoadStructuredData(parametersFile)
        }

        super.__New(
            this.LoadStructuredData(serviceFile), 
            this.LoadStructuredData(parametersFile),
            servicesKey,
            parametersKey
        )
    }

    LoadStructuredData(filePaths) {
        throw MethodNotImplementedException("StructuredFileDefinitionLoader", "LoadStructuredData")
    }
}
