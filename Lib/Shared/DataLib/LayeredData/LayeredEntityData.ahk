class LayeredEntityData extends LayeredDataBase {
    dataSources := ""
    dsKey := ""
    dsPath := ""

    __New(config, defaults := "", dsData := "", autoData := "", parentDefaults := "", parentData := "") {
        if (defaults == "") {
            defaults := Map()
        }

        if (dsData == "") {
            dsData := Map()
        }

        if (autoData == "") {
            autoData := Map()
        }

        if (parentDefaults == "") {
            parentDefaults := Map()
        }

        if (parentData == "") {
            parentData := Map()
        }

        processors := [PlaceholderExpander.new(this)]
        super.__New(processors, "defaults", defaults, "parentDefaults", parentDefaults, "auto", autoData, "ds", dsData, "parent", parentData, "config", config)
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

    SetParentDefaults(defaults) {
        this.layers["parentDefaults"] := defaults
    }

    SetParentConfig(defaults) {
        this.layers["parent"] := defaults
    }
}
