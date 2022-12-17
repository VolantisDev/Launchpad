class WebServicesEventSubscriber extends EventSubscriberBase {
    adapterMgr := ""
    
    __New(container, adapterMgr) {
        this.adapterMgr := adapterMgr

        super.__New(container)
    }

    GetEventSubscribers() {
        return Map(
            Events.APP_POST_STARTUP, [
                ObjBindMethod(this, "OnPostStartup")
            ],
            Events.APP_MENU_ITEMS_LATE, [
                ObjBindMethod(this, "OnMenuItemsLate")
            ],
            Events.APP_MENU_PROCESS_RESULT, [
                ObjBindMethod(this, "OnMenuProcessResult")
            ],
            EntityEvents.ENTITY_DATA_LAYERS, [
                ObjBindMethod(this, "EntityDataLayers")
            ],
            EntityEvents.ENTITY_LAYER_SOURCES, [
                ObjBindMethod(this, "EntityLayerSources")
            ],
            Events.APP_GET_RELEASE_INFO, [
                ObjBindMethod(this, "GetReleaseInfo")
            ],
            EntityEvents.ENTITY_FIELD_GROUPS, [
                ObjBindMethod(this, "EntityFieldGroups")
            ],
            EntityEvents.ENTITY_FIELD_DEFINITIONS, [
                ObjBindMethod(this, "EntityFieldDefinitions")
            ],
            EntityEvents.ENTITY_DETECT_VALUES, [
                ObjBindMethod(this, "EntityDetectValues")
            ],
            EntityEvents.ENTITY_LIST_ENTITIES, [
                ObjBindMethod(this, "ListEntities")
            ]
        )
    }

    OnPostStartup(event, extra, eventName, hwnd) {
        webServices := this.container["entity_manager.web_service"]
            .EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
            .Condition(IsTrueCondition(), "Enabled")
            .Condition(IsTrueCondition(), "AutoLogin")
            .Execute()

        for key, webService in webServices {
            webService.Login()
        }
    }

    OnMenuItemsLate(event, extra, eventName, hwnd) {
        event.MenuItems.Push(Map(
            "label", "Provide &Feedback", 
            "name", "ProvideFeedback"
        ))
    }

    OnMenuProcessResult(event, extra, eventName, hwnd) {
        if (!event.IsFinished) {
            if (event.Result == "ProvideFeedback") {
                this.container["manager.gui"].Dialog(Map("type", "FeedbackWindow"))
                event.IsFinished := true
            }
        }
    }

    _getEntityLayerKey(webService, adapterId) {
        return webService["id"] . "." . adapterId
    }

    EntityDataLayers(event, extra, eventName, hwnd) {
        if (HasProp(event.Entity, "isWebServiceEntity") && event.Entity.isWebServiceEntity) {
            return
        }

        webServices := this.container["entity_manager.web_service"]
            .EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
            .Condition(IsTrueCondition(), "Enabled")
            .Execute()

        for webServiceId, webService in webServices {
            adapterIds := this.adapterMgr.GetAdapterIds(Map(
                "dataType", "entity_data",
                "entityType", event.EntityTypeId,
                "tags", "defaults"
            ), "", 0, webService)

            for , adapterId in adapterIds {
                adapter := this.adapterMgr.GetAdapter(adapterId)
                layerExists := false
                layerKey := this._getEntityLayerKey(webService, adapterId)

                for , existingLayerKey in event.Layers {
                    if (existingLayerKey == layerKey) {
                        layerExists := true

                        break
                    }
                }

                if (!layerExists) {
                    event.Layers.Push(layerKey)
                }
            }
        }
    }

    EntityLayerSources(event, extra, eventName, hwnd) {
        if (HasProp(event.Entity, "isWebServiceEntity") && event.Entity.isWebServiceEntity) {
            return
        }

        webServices := this.container["entity_manager.web_service"]
            .EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
            .Condition(IsTrueCondition(), "Enabled")
            .Execute()

        for webServiceId, webService in webServices {
            adapters := this.adapterMgr.GetAdapters(Map(
                "dataType", "entity_data",
                "entityType", event.EntityTypeId
            ), "", 0, webService)

            paramsEvent := WebServicesEntityDataParamsEvent(
                WebServicesEvents.ENTITY_DATA_PARAMS,
                event.EntityTypeId,
                event.Entity,
                webService,
                Map("id", event.Entity.Id)
            )
            this.container["manager.event"].DispatchEvent(paramsEvent)

            for key, adapter in adapters {
                layerKey := this._getEntityLayerKey(webService, key)

                if (!event.LayerSources.Has(layerKey)) {
                    event.LayerSources[layerKey] := WebServiceAdapterLayerSource(adapter, paramsEvent.Params)
                }
            }
        }
    }

    GetReleaseInfo(event, extra, eventName, hwnd) {
        if (!event.ReleaseInfo.Count && this.container.GetApp().Version != "{{VERSION}}") {
            releaseInfo := this.adapterMgr.AdapterRequest("", "release_info")

            if (releaseInfo && releaseInfo.Count) {
                event.ReleaseInfo := releaseInfo
            }
        }
    }

    EntityFieldGroups(event, extra, eventName, hwnd) {
        if (HasProp(event.Entity, "isWebServiceEntity") && event.Entity.isWebServiceEntity) {
            return
        }

        if (!event.FieldGroups.Has("web_services")) {
            webServices := this.container["entity_manager.web_service"]
                .EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
                .Condition(IsTrueCondition(), "Enabled")
                .Execute()

            addGroup := false

            for key, webService in webServices {
                filters := Map(
                    "dataType", "entity_data",
                    "entityType", event.EntityTypeId
                )
                operation := "read"

                if (this.adapterMgr.HasAdapters(filters, operation, webService)) {
                    addGroup := true

                    break
                }
            }

            if (addGroup) {
                event.FieldGroups["web_services"] := Map(
                    "name", "Web Services",
                    "weight", 100
                )
            }
        }
    }

    EntityFieldDefinitions(event, extra, eventName, hwnd) {
        if (HasProp(event.Entity, "isWebServiceEntity") && event.Entity.isWebServiceEntity) {
            return
        }

        webServices := this.container["entity_manager.web_service"]
            .EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
            .Condition(IsTrueCondition(), "Enabled")
            .Execute()
        
        for key, webService in webServices {
            filters := Map(
                "dataType", "entity_data",
                "entityType", event.EntityTypeId
            )
            operation := "read"

            if (this.adapterMgr.HasAdapters(filters, operation, webService)) {
                event.FieldDefinitions["web_service_" . webService["id"] . "_ref"] := Map(
                    "title", webService["name"] . " Reference",
                    "description", "The key that is used to look up the entity's data from the " . webService["name"] . " web service.",
                    "help", "It defaults to the entity ID, but it can be overridden by setting this value.`n`nAddtionally, multiple copies of the same entity can exist by giving them different IDs but using the same " . webService["name"] . " reference.",
                    "group", "web_services",
                    "processValue", false,
                    "modes", Map("simple", Map("formField", false))
                )

                break
            }
        }
    }

    EntityDetectValues(event, extra, eventName, hwnd) {
        if (HasProp(event.Entity, "isWebServiceEntity") && event.Entity.isWebServiceEntity) {
            return
        }

        webServices := this.container["entity_manager.web_service"]
            .EntityQuery(EntityQuery.RESULT_TYPE_ENTITIES)
            .Condition(IsTrueCondition(), "Enabled")
            .Execute()

        for key, webService in webServices {
            fieldId := "web_service_" . webService["id"] . "_ref"
            filters := Map(
                "dataType", "entity_data",
                "entityType", event.EntityTypeId
            )
            
            if (
                this.adapterMgr.HasAdapters(filters, "read", webService)
                && (!event.Values.Has(fieldId) || !event.Values[fieldId])
                && event.Entity.HasField(fieldId)
                && (!event.Entity.RawData.Has(fieldId) || !event.Entity.RawData[fieldId])
            ) {
                paramsEvent := WebServicesEntityDataParamsEvent(
                    WebServicesEvents.ENTITY_DATA_PARAMS,
                    event.EntityTypeId,
                    event.Entity,
                    webService,
                    Map("id", event.Entity.Id)
                )
                this.container["manager.event"].DispatchEvent(paramsEvent)

                result := this.adapterMgr.AdapterRequest(
                    paramsEvent.Params,
                    Map(
                        "dataType", "entity_lookup",
                        "entityType", event.EntityTypeId
                    ),
                    "read",
                    false,
                    webService
                )

                if (!result) {
                    result := event.Entity["id"]
                }

                event.Values[fieldId] := result
            }
        }
    }

    ListEntities(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "web_service" || event.EntityTypeId == "web_service_provider") {
            return
        }

        if (event.includeExtended) {
            entityMgr := this.container["entity_manager." . event.EntityTypeId]
            results := this.adapterMgr.AdapterRequest("", Map(
                "dataType", "entity_list",
                "entityType", event.EntityTypeId
            ), "read", true)

            if (results && HasBase(results, Array.Prototype)) {
                managedIds := event.includeManaged 
                    ? [] 
                    : entityMgr.EntityQuery(EntityQuery.RESULT_TYPE_IDS).Execute()

                for index, id in results {
                    exists := false

                    for , existingId in event.EntityList {
                        if (existingId == id) {
                            exists := true
                            break
                        }
                    }

                    if (!exists && !event.includeManaged) {
                        for , managedId in managedIds {
                            if (managedId == id) {
                                exists := true
                                break
                            }
                        }
                    }

                    if (!exists) {
                        event.EntityList.Push(id)
                    }
                }
            }
        }
    }
}
