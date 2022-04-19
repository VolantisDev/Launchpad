class ServiceReferenceField extends EntityFieldBase {
    ReferencedObject {
        get => this.GetValue()
    }

    GetValidators(value) {
        validators := super.GetValidators(value)

        if (value) {
            ; @todo Add a ServiceExists condition
        }
        
        return validators
    }

    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)

        defaults["servicePrefix"] := ""
        defaults["widget"] := "select"
        defaults["selectOptionsCallback"] := ObjBindMethod(this, "GetEntitySelectOptions")
        defaults["selectConditions"] := []
        
        return defaults
    }

    GetValue() {
        serviceObj := ""
        serviceId := super.GetValue()

        if (serviceId ) {
            if (Type(serviceId) != "String") {
                serviceObj := serviceId
            } else {
                serviceObj := this._getService(serviceId)
            }
        }

        return serviceObj
    }

    _getService(serviceId) {
        ; Override if the service ID needs to be expanded or if the service should come from somewhere else
        serviceObj := ""

        if (this.container.Has(serviceId)) {
            serviceObj := this.container.Get(serviceId)
        } else {
            throw EntityException("Referenced service " . serviceId . " not found.")
        }

        return serviceObj
    }

    SetValue(value) {
        super.SetValue(this._getServiceId(value))
    }

    _getServiceId(value) {
        if (InStr(value, this.Definition["servicePrefix"]) != 1) {
            value := this.Definition["servicePrefix"] . value
        }

        return value
    }

    _getSelectQuery() {
        return this.container.Query(ContainerQuery.RESULT_TYPE_NAMES)
    }

    GetEntitySelectOptions() {
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

        return query.Execute()
    }
}
