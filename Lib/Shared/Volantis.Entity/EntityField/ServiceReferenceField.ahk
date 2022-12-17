class ServiceReferenceField extends EntityFieldBase {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)

        defaults["servicePrefix"] := ""
        defaults["widget"] := "select"
        defaults["selectOptionsCallback"] := ObjBindMethod(this, "GetServiceSelectOptions")
        defaults["selectConditions"] := []
        
        return defaults
    }

    GetValidators(value) {
        validators := super.GetValidators(value)

        if (value) {
            ; @todo Add a ServiceExists condition
        }
        
        return validators
    }

    GetValue(index := "") {
        value := super.GetValue(index)

        if (!HasBase(value, Array.Prototype)) {
            value := [value]
        }

        newValues := []

        for singleIndex, singleValue in value {
            if (Type(singleValue) != "String") {
                serviceObj := singleValue
            } else {
                serviceObj := this._getService(singleValue)
            }

            if (serviceObj) {
                newValues.Push(serviceObj)
            }
        }

        value := newValues

        if (!this.multiple || index) {
            value := value.Length ? value[1] : ""
        }

        return value
    }

    _getService(serviceId) {
        serviceId := this._getServiceId(serviceId)
        ; Override if the service ID needs to be expanded or if the service should come from somewhere else
        serviceObj := ""

        if (this.container.Has(serviceId)) {
            serviceObj := this.container.Get(serviceId)
        } else {
            throw EntityException("Referenced service " . serviceId . " not found.")
        }

        return serviceObj
    }

    SetValue(value, index := "") {
        if (index || !this.multiple || !HasBase(value, Array.Prototype)) {
            value := this._getServiceId(singleValue)
        } else {
            newValues := []

            for singleIndex, singleValue in value {
                newValues[singleIndex] = this._getServiceId(singleValue)
            }

            value := newValues
        }

        super.SetValue(value, index)
    }

    _getServiceId(value) {
        if (this.Definition["servicePrefix"] && InStr(value, this.Definition["servicePrefix"]) != 1) {
            value := this.Definition["servicePrefix"] . value
        }

        return value
    }

    _getSelectQuery() {
        return this.container.Query(this.Definition["servicePrefix"], ContainerQuery.RESULT_TYPE_NAMES, false, true)
    }

    GetServiceSelectOptions() {
        query := this._getSelectQuery()
        conditions := this.Definition["selectConditions"]

        if (conditions) {
            if (Type(conditions) != "Array") {
                conditions := [conditions]
            }

            for index, condition in conditions {
                query.Condition(condition)
            }
        }

        options := query.Execute()

        if (!this.Definition["required"]) {
            options.InsertAt(1, "")
        }

        return options
    }
}
