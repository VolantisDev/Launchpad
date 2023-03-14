class ParameterContainer extends ContainerBase {
    parametersObj := ""

    Parameters {
        get => this.parametersObj
    }
    
    __New(definitionLoader := "") {
        this.parametersObj := ParameterBag("", this.GetParameterContext())
        super.__New()

        if (definitionLoader) {
            this.LoadDefinitions(definitionLoader)
        }
    }

    GetParameterContext() {
        return DataContext(Map(
            "app", this.GetApp(),
            "container", this
        ))
    }

    LoadDefinitions(definitionLoader, replace := true, prefix := "") {
        parameters := definitionLoader.LoadParameterDefinitions()

        if (parameters) {
            for paramName, paramConfig in parameters {
                if (prefix) {
                    paramName := prefix . paramName
                }

                if (!this.Parameters.Has(paramName) || replace) {
                    this.Parameters.Set(paramName, paramConfig)
                }
            }
        }
    }

    Get(name) {
        return this.GetParameter(name)
    }

    resolveProperties(propertyDefinitions) {
        properties := Map()

        if (!propertyDefinitions) {
            propertyDefinitions := Map()
        }

        for propName, propDefinition in propertyDefinitions {
            properties[propName] := this.resolveDefinition(propDefinition)
        }

        return properties
    }

    resolveDefinition(definition) {
        return this.Parameters.expandValue(definition)
    }

    GetApp(definition := "") {
        appName := definition ? definition.GetName() : ""
        
        if (!appName) {
            appName := "AppBase"
        }

        if (this.Has(appName)) {
            return this.Get(appName)
        } else {
            return %appName%.Instance
        }
    }

    HasParameter(name) {
        return this.Parameters.Has(name)
    }

    GetParameter(name := "") {
        return this.Parameters.Get(name)
    }

    DeleteParameter(name) {
        if (!name) {
            throw ContainerException("You must specify a parameter to delete")
        }

        return this.Parameters.Remove(name)
    }

    SetParameter(name, value := "") {
        return this.Parameters.Set(name, value)
    }
}
