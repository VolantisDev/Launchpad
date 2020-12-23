class LayeredEntityData extends LayeredDataBase {
    dataSources := ""
    dsKey := ""
    dsPath := ""

    __New(config, defaults := "", dsData := "", autoData := "") {
        if (defaults == "") {
            defaults := Map()
        }

        if (dsData == "") {
            dsData := Map()
        }

        if (autoData == "") {
            autoData := Map()
        }

        processors := [PlaceholderExpander.new(this)]
        super.__New(processors, "defaults", defaults, "auto", autoData, "ds", dsData, "config", config)
    }

    SetDefaults(defaults) {
        this.layers["defaults"] := defaults
    }

    SetAutoDetectedDefaults(defaults) {
        this.layers["auto"] := defaults
    }

    SetDataSourceDefaults(defaults) {
        this.layers["ds"] := defaults
    }
}
