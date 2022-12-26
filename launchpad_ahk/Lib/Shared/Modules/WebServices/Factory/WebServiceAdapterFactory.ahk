class WebServiceAdapterFactory {
    container := ""
    
    __New(container) {
        this.container := container
    }

    CreateWebServiceAdapter(webService, definition) {
        adapterTypes := this.container.GetParameter("web_services.adapter_types")

        if (!definition.Has("adapterType") || !definition["adapterType"]) {
            definition["adapterType"] := "json"
        }

        if (adapterTypes.Has(definition["adapterType"])) {
            defaults := adapterTypes[definition["adapterType"]]

            if (Type(defaults) == "String") {
                defaults := Map("class", defaults)
            }

            for key, val in defaults {
                if (!definition.Has(key)) {
                    definition[key] := val
                }
            }
        }

        if (!definition.Has("class")) {
            throw AppException("Adapter class not known.")
        }

        adapterClass := definition["class"]

        if (!HasMethod(%adapterClass%)) {
            throw AppException("Adapter class " . adapterClass . " was not found.")
        }

        return %adapterClass%.Create(this.container, webService, definition)
    }
}
