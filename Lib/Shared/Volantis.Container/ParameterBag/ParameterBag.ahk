class ParameterBag {
    parameters := Map()
    contextObj := ""
    keySeparator := "."
    tokenReplacer := ""
    merger := ""
    shallowMerger := ""
    cloner := ""

    __Item[key] {
        get => this.Get(key)
        set => this.Set(key, value)
    }

    Count {
        get => this.CountParameters()
    }

    Context {
        get => this.contextObj
        set => this.contextObj := value
    }

    __Enum(numberOfVars) {
        return this.parameters.__Enum(numberOfVars)
    }

    __New(parameters := "", contextObj := "") {
        this.merger := ListMerger(true)
        this.shallowMerger := ListMerger(false)
        this.cloner := ListCloner(true)
        
        if (!contextObj) {
            contextObj := DataContext()
        }

        this.SetContext(contextObj)
        defaults := this.GetDefaultParameters()

        if (defaults && defaults.Count) {
            this.Add(defaults)
        }

        if (!parameters) {
            parameters := Map()
        }

        if (this.ValidateParameterMap(parameters) && parameters.Count) {
            this.Add(parameters)
        }
    }

    Clone() {
        cloned := super.Clone()
        cloned.parameters := this.cloner.Clone(cloned.parameters)
        cloned.Context["param"] := cloned.parameters
        return cloned
    }

    resolveKey(key) {
        if (!HasBase(key, Array.Prototype)) {
            if (this.keySeparator) {
                key := StrSplit(key, this.keySeparator)
            } else {
                key := [key]
            }
        }

        return key
    }

    flattenKey(key) {
        flatKey := ""

        if (HasBase(key, Array.Prototype)) {
            for index, keyPart in key {
                if (flatKey) {
                    flatKey .= this.keySeparator
                }

                flatKey .= keyPart
            }
        } else {
            flatKey := key
        }

        return flatKey
    }

    GetDefaultParameters() {
        return ""
    }

    SetContext(contextObj) {
        if (!contextObj.Has("param") || !contextObj["param"]) {
            contextObj["param"] := this
        }

        this.Context := contextObj
        return this
    }

    ExpandValue(value) {
        if (HasBase(value, Map.Prototype) || HasBase(value, Array.Prototype)) {
            for key, val in value {
                value[key] := this.ExpandValue(val)
            }
        } else {
            value := this.resolveReferences(value)
            value := this.expandReferences(value)
            value := this.replaceTokens(value)
        }

        return value
    }

    replaceTokens(value) {
        if (!this.tokenReplacer) {
            this.tokenReplacer := TokenReplacer(this.Context, "", ".")
        }

        return this.tokenReplacer.Process(value)
    }

    expandReferences(val) {
        if (HasBase(val, ContainerRefBase.Prototype)) {
            reference := val

            if (reference.HasBase(AppRef.Prototype)) {
                val := this.Context.Has("app") ? this.Context["app"] : ""
            } else if (reference.HasBase(ContainerRef.Prototype)) {
                val := this.Context.Has("container") ? this.Context["container"] : ""
            } else if (reference.HasBase(DataRef.Prototype)) {
                val := this.replaceTokens("{{" . reference.GetName() . "}}")

                if (Type(val) == "String" && reference.GetStringTemplate()) {
                    val := StrReplace(reference.GetStringTemplate(), "@@", val)
                }
            } else if (reference.HasBase(ParameterRef.Prototype)) {
                val := this.Context["param"]
                val := val[reference.GetName()]

                if (Type(val) == "String" && reference.GetStringTemplate()) {
                    val := StrReplace(reference.GetStringTemplate(), "@@", val)
                }
            } else if (reference.HasBase(ServiceRef.Prototype)) {
                val := this.Context["container"][reference.GetName()]

                method := reference.GetMethod()

                if (method) {
                    if (!HasMethod(val, method)) {
                        throw ContainerException("Service " . reference.GetName() . " does not have method " . method)
                    }
    
                    val := ObjBindMethod(val, method)
                }
            } else {
                throw ContainerException("Unable to expand unknown reference type " . Type(val))
            }
        }

        return val
    }

    /**
     * Convert an input value to a reference object
     */
    resolveReferences(value) {
        refType := ""
        args := []
        pattern := ""
        template := false
        argsIndex := 1

        if (value == "@{}") {
            refType := "Container"
        } else if (SubStr(value, 1, 2) == "@{") {
            pattern := "^@{([^}]+)}$"
        } else if (InStr(value, "@@{")) {
            pattern := "^([^@]*)@@{([^}]+)}(.*)$"
            refType := "Parameter"
            template := true
            argsIndex := 2
        } else if (SubStr(value, 1, 2) == "@@") {
            pattern := "^@@([^}]+)$"
            refType := "Parameter"
        } else if (SubStr(value, 1, 1) == "@") {
            pattern := "^@(.+)$"
            refType := "Service"
        }

        if (pattern && RegExMatch(value, pattern, &matches)) {
            args := StrSplit(matches[argsIndex], ":", " `t")

            if (template) {
                args.Push(matches[1] . "@@" . matches[3])
            }
        }

        if (args.Length && !refType) {
            refType := args[1]
            args.RemoveAt(1)
        }

        if (refType) {
            className := refType . "Ref"

            if (!HasMethod(%className%)) {
                throw ContainerException("Reference type " . className . " does not exist")
            }

            value := %className%(args*)
        }

        return value
    }

    All(key := "") {
        if (!key) {
            return this.parameters
        }

        val := this.Get(key)
        this.ValidateParameterMap(val)

        return val
    }

    Keys() {
        keys := []

        for key, val in this.All() {
            keys.Push(key)
        }

        return keys
    }

    Replace(parameters := "") {
        if (!parameters) {
            parameters := Map()
        }

        if (this.ValidateParameterMap(parameters)) {
            this.parameters := Map()
            this.Add(parameters)
        }
    }

    Merge(key, value, deep := true) {
        key := this.resolveKey(key)

        if (this.Has(key)) {
            merger := deep ? this.merger : this.shallowMerger
            value := merger.Merge(this.Get(key), value)
        }

        this.Set(key, value)
    }

    ValidateParameterMap(parameters) {
        return (HasBase(parameters, Map.Prototype) || HasBase(parameters, ParameterBag.Prototype))
    }

    Add(parameters, merge := true) {
        if (this.ValidateParameterMap(parameters)) {
            for key, val in parameters {
                if (merge) {
                    this.Merge(key, val)
                } else {
                    this.Set(key, val)
                }
            }
        }
        
        return this
    }

    Get(key, default := "") {
        val := default

        if (Type(key) == "String" && this.parameters.Has(key)) {
            val := this.parameters[key]
        } else {
            tokens := this.resolveKey(key)
            context := this.All()

            for index, token in tokens {
                if (!context.Has(token)) {
                    throw ContainerException("Parameter not found: " . key)
                }

                context := context[token]
            }

            val := context
        }

        return this.ExpandValue(val)
    }

    Set(key, value) {
        if (Type(key) == "String" && this.parameters.Has(key)) {
            this.parameters[key] := value
        } else {
            tokens := this.resolveKey(key)
            context := this.All()
            lastToken := tokens.Pop()

            for index, token in tokens {
                if (!context.Has(token)) {
                    context[token] := Map()
                }

                context := context[token]
            }

            context[lastToken] := value
        }
    }

    Has(key) {
        if (Type(key) == "String" && this.parameters.Has(key)) {
            return this.parameters.Has(key)
        }

        exists := false
        tokens := this.resolveKey(key)
        context := this.All()

        for index, token in tokens {
            if (HasBase(context, Map.Prototype) && context.Has(token)) {
                context := context[token]
                exists := true
            } else {
                exists := false
                break
            }
        }

        return exists
    }

    Remove(key) {
        if (this.parameters.Has(key)) {
            this.parameters.Delete(key)
        } else {
            tokens := this.resolveKey(key)
            context := this.All()
            lastToken := tokens.Pop()

            for index, token in tokens {
                if (!context.Has(token)) {
                    throw ContainerException("Parameter not found: " . key)
                }

                context := context[token]
            }

            if (context && context.Has(lastToken)) {
                context.Delete(lastToken)
            } else {
                throw ContainerException("Parameter not found: " . key)
            }
        }

        return this
    }

    CountParameters() {
        return this.parameters.Count
    }
}
