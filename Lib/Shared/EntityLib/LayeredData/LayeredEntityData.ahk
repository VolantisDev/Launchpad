class LayeredEntityData extends LayeredDataBase {
    __New(config, defaults := "", additionalLayers := "") {
        if (defaults == "") {
            defaults := Map()
        }

        processors := []
        processors.Push(StringSanitizer())
        processors.Push(PlaceholderExpander(this))


        params := [
            "defaults", defaults
        ]

        if (additionalLayers) {
            for index, layer in additionalLayers {
                params.Push(layer, Map())
            }
        }

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
}
