class LayeredEntityData extends LayeredDataBase {
    __New(config, defaults := "") {
        if (defaults == "") {
            defaults := Map()
        }

        processors := []
        processors.Push(PlaceholderExpander.new(this))

        params := []
        params.Push("defaults", defaults)
        params.Push("parentDefaults", Map())
        params.Push("childDefaults", Map())
        params.Push("auto", Map())
        params.Push("ds", Map())
        params.Push("parent", Map())
        params.Push("config", config)

        super.__New(processors, params*)
    }

    SetDefaults(data) {
        this.layers["defaults"] := data
    }

    SetAutoDetectedDefaults(data) {
        this.layers["auto"] := data
    }

    SetDataSourceDefaults(data) {
        this.layers["ds"] := data
    }

    SetParentDefaults(data) {
        this.layers["parentDefaults"] := data
    }

    SetChildDefaults(data) {
        this.layers["childDefaults"] := data
    }

    SetParentConfig(data) {
        this.layers["parent"] := data
    }
}
