class WebServiceAdapterManager {
    container := ""
    parameterPrefix := ""
    adapterFactory := ""
    entityTypeMgr := ""
    eventMgr := ""
    adapters := Map()

    __New(container, parameterPrefix, adapterFactory, entityTypeMgr, eventMgr) {
        this.container := container
        this.parameterPrefix := parameterPrefix
        this.adapterFactory := adapterFactory
        this.entityTypeMgr := entityTypeMgr
        this.eventMgr := eventMgr
    }

    AdapterRequest(params, filters, operation := "read", multiple := false, webService := "") {
        if (!params) {
            params := Map()
        }

        if (!filters) {
            filters := Map()
        }

        if (Type(filters) == "String") {
            filters := Map("dataType", filters)
        }

        results := Map()

        for adapterKey, adapter in this.GetAdapters(filters, operation, 0, webService) {
            result := adapter.SendRequest(operation, params)

            if (result) {
                if (!multiple) {
                    results := result

                    break
                }
                
                results[adapterKey] := result
            }

            if (IsNumber(multiple) && results.Count >= multiple) {
                break
            }
        }

        return results
    }

    HasAdapters(filters := "", operation := "", webService := "") {
        return !!(this.GetAdapterIds(filters, operation, 1, webService).Length)
    }

    GetAdapters(filters := "", operation := "", limit := 0, webService := "") {
        adapterIds := this.GetAdapterIds(filters, operation, limit, webService)

        adapters := Map()

        for , adapterId in adapterIds {
            adapters[adapterId] := this.GetAdapter(adapterId)
        }

        return adapters
    }

    GetAdapter(id) {
        adapter := ""
        
        if (this.adapters.Has(id)) {
            adapter := this.adapters[id]
        }

        if (!adapter && InStr(id, ".")) {
            idParts := StrSplit(id, ".")
            webServiceId := idParts[1]
            adapterKey := idParts[2]
            
            webService := this.entityTypeMgr.GetManager("web_service")[webServiceId]

            if (webService["Enabled"]) {
                param := this.parameterPrefix . webService["Provider"]["id"] . "." . adapterKey

                if (this.container.HasParameter(param)) {
                    adapter := this.adapterFactory.CreateWebServiceAdapter(webService, this.container.GetParameter(param))
                    this.adapters[id] := adapter
                }
            }
        }

        return adapter
    }

    HasAdapter(id) {
        exists := this.adapters.Has(id)

        if (!exists) {
            idParts := StrSplit(id, ".")
            webServiceId := idParts[1]
            adapterKey := idParts[2]
            webService := this.entityTypeMgr.GetManager("web_service")[webServiceId]
            param := this.parameterPrefix . webService["Provider"]["id"] . "." . id
            exists := this.container.HasParameter(param)
        }

        return exists
    }

    GetAdapterIds(filters := "", operation := "", limit := 0, webService := "") {
        if (!filters) {
            filters := Map()
        }

        if (Type(filters) == "String") {
            filters := Map("dataType", filters)
        }

        adapterIds := []
        weights := this._getFilterWeights(filters)

        for webServiceId, webService in this._getWebServicesForOperation(webService) {
            providerId := webService["Provider"]["id"]
            paramKey := "web_services.adapters." . providerId

            if (this.container.HasParameter(paramKey)) {
                adapterData := this.container.GetParameter(this.parameterPrefix . providerId)

                for weightIndex, weight in weights {
                    filters["weight"] := weight
        
                    for key, definition in adapterData {
                        adapterId := webServiceId . "." . key
                        adapter := this.GetAdapter(adapterId)
                        definition := adapter.definition
                        include := (!operation || adapter.SupportsOperation(operation))
            
                        if (include) {
                            for filterKey, filterVal in filters {
                                if (!definition.Has(filterKey)) {
                                    include := false
                
                                    break
                                }
            
                                include := this._filterValue(definition[filterKey], filterVal)
            
                                if (!include) {
                                    break
                                }
                            }
                        }
            
                        if (include) {
                            adapterIds.Push(adapterId)
        
                            if (limit && adapterIds.Length >= limit) {
                                break 2
                            }
                        }
                    }
                }
            }
        }

        return adapterIds
    }

    _getWebServicesForOperation(webService) {
        webServices := ""

        if (webService) {
            webServices := Type(webService == "String") ? Map(webService["id"], webService) : webService
        } else {
            webServices := this.entityTypeMgr.GetManager("web_service")
                .EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
                .Condition(IsTrueCondition(), "Enabled")
                .Execute()
        }

        return webServices
    }

    _getFilterWeights(filters) {
        weights := filters.Has("weight") 
            ? filters["weight"]
            : ""
        
        if (!weights) {
            weights := []

            startingWeight := -10
            maxWeight := 10

            Loop (maxWeight - startingWeight) {
                weights.Push(startingWeight + A_Index - 1)
            }
        }

        if (Type(weights) == "String") {
            weights := [weights]
        }

        return weights
    }

    _filterArrayValues(definitionArray, filterArray) {
        include := !filterArray || !!definitionArray

        if (include) {
            if (Type(filterArray) == "String") {
                filterArray := [filterArray]
            }
    
            if (Type(definitionArray) == "String") {
                definitionArray := [definitionArray]
            }

            for , val in filterArray {
                definitionHasVal := false

                for , definitionVal in definitionArray {
                    definitionHasVal := this._filterValue(definitionVal, val)

                    if (definitionVal == val) {
                        definitionHasVal := true

                        break
                    }
                }

                if (!definitionHasVal) {
                    include := false

                    break
                }
            }
        }

        return include
    }

    _filterMapValues(definitionMap, filterMap) {
        include := !filterMap || !!definitionMap

        if (include) {
            if (Type(filterMap) == "String") {
                filterMap := [filterMap]
            }
    
            if (Type(definitionMap) == "String") {
                definitionMap := [definitionMap]
            }

            for key, val in filterMap {
                exists := definitionMap.Has(key)

                if (exists) {
                    exists := this._filterValue(definitionMap[key], val)
                }

                if (!exists) {
                    include := false

                    break
                }
            }
        }

        return include
    }

    _filterValue(definitionVal, filterVal) {
        include := false

        if (Type(filterVal) == "Array") {
            include := this._filterArrayValues(definitionVal, filterVal)
        } else if (Type(filterVal) == "Map") {
            include := this._filterMapValues(definitionVal, filterVal)
        } else {
            include := (definitionVal == filterVal)
        }

        return include
    }
}
