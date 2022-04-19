class SelectEntityFieldWidget extends EntityFieldWidgetBase {
    valueMap := ""
    valueArray := ""
    
    GetDefaultDefinition(definition) {
        defaults := super.GetDefaultDefinition(definition)
        defaults["controlClass"] := "SelectControl"
        defaults["selectOptions"] := ""
        defaults["selectOptionsCallback"] := ""
        defaults["selectOptionsInternal"] := ""
        defaults["selectHandler"] := ""
        defaults["selectButton"] := false
        defaults["selectButtonText"] := "",
        defaults["selectButtonHandler"] := ""
        defaults["selectButtonOpts"] := ""
        defaults["controlParams"] := [
            "{{param.selectOptionsInternal}}",
            "{{param.selectHandler}}",
            "{{param.description}}",
            "{{param.selectButtonText}}",
            "{{param.selectButtonHandler}}",
            "{{param.selectButtonOpts}}"
        ]
        return defaults
    }

    InitializeDefinition(definition) {
        this.valueArray := this.GetSelectOptions(definition)
        definition["selectOptionsInternal"] := this.valueArray
        return super.InitializeDefinition(definition)
    }

    GetSelectOptions(definition := "") {
        if (!definition) {
            definition := this.definition
        }
        options := ""
        
        if (definition.Has("selectOptions") && definition["selectOptions"]) {
            options := definition["selectOptions"]
        } else if (definition.Has("selectOptionsCallback") && HasMethod(definition["selectOptionsCallback"])) {
            options := definition["selectOptionsCallback"]()
        }

        if (!options) {
            options := []
        }

        if (Type(options) == "Map") {
            this.valueMap := options

            newOptions := []

            for id, name in options {
                newOptions.Push(name)
            }

            options := newOptions
        }

        this.valueArray := options

        return options
    }

    GetSelectedId(value) {
        if (this.valueMap) {
            for id, val in this.valueMap {
                if (val == value) {
                    value := id
                    break
                }
            }
        }

        return value
    }

    RenderWidget(guiControlParams) {
        super.RenderWidget(guiControlParams)
    }

    GetWidgetValue(submitGui := false) {
        value := super.GetWidgetValue(submitGui)

        if (this.valueArray && IsNumber(value)) {
            value := this.valueArray[value]
        }

        if (this.valueMap) {
            for key, val in this.valueMap {
                if (val == value) {
                    value := key
                    break
                }
            }
        }

        return value
    }

    SetWidgetValue(value) {
        if (this.valueMap && this.valueMap.Has(value)) {
            value := this.valueMap[value]
        }

        if (this.valueArray && !IsNumber(value)) {
            for index, val in this.valueArray {
                if (value == val) {
                    value := index
                    break
                }
            }
        }

        super.SetWidgetValue(value)
    }
}
