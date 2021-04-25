class LayeredEntityData extends LayeredDataBase {
    __New(config, defaults := "") {
        if (defaults == "") {
            defaults := Map()
        }

        processors := []
        processors.Push(PlaceholderExpander(this))

        params := []
        params.Push("defaults", defaults)
        params.Push("ds", Map())
        params.Push("auto", Map())
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

    SetParentConfig(data) {
        this.layers["parent"] := data
    }
}
