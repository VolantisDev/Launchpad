class LaunchpadApiSubscriber extends EventSubscriberBase {
    GetEventSubscribers() {
        return Map(
            Events.APP_GET_RELEASE_INFO, [
                ObjBindMethod(this, "GetReleaseInfo")
            ],
            EntityEvents.ENTITY_DATA_LAYERS, [
                ObjBindMethod(this, "EntityDataLayers")
            ],
            EntityEvents.ENTITY_LAYER_SOURCES, [
                ObjBindMethod(this, "EntityLayerSources")
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
            ],
        )
    }

    GetReleaseInfo(event, extra, eventName, hwnd) {
        releaseInfo := event.ReleaseInfo

        if (!event.ReleaseInfo.Count && this.container.GetApp().Version != "{{VERSION}}") {
            webService := this.container["entity_manager.web_service"]["launchpad_api"]
            
            if (webService["Enabled"]) {
                releaseInfo := webService.AdapterRequest("", "release_info")

                if (releaseInfo) {
                    for key, val in releaseInfo {
                        event.ReleaseInfo[key] = val
                    }
                }
            }
        }
    }

    EntityDataLayers(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "web_service" || event.EntityTypeId == "web_service_provider") {
            return
        }

        webService := this.container["entity_manager.web_service"]["launchpad_api"]

        layers := event.Layers

        if (WebService["Enabled"]) {
            entity := event.Entity

            adapters := webService.GetAdapters([
                "adapterType", "entity_data",
                "entityType", event.EntityTypeId
            ])

            for key, adapter in adapters {
                layerExists := false
                layerKey := webService["id"] . "." . event.EntityTypeId . "." . key

                for index, layerName in layers {
                    if (layerName == layerKey) {
                        layerExists := true
                        break
                    }
                }

                if (!layerExists) {
                    layers.Push(layerKey)
                }
            }
        }
    }

    EntityLayerSources(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "web_service" || event.EntityTypeId == "web_service_provider") {
            return
        }
        
        webService := this.container["entity_manager.web_service"]["launchpad_api"]

        layerData := event.LayerSources

        if (WebService["Enabled"]) {
            adapters := webService.GetAdapters([
                "adapterType", "entity_data",
                "entityType", event.EntityTypeId
            ])

            for key, adapter in adapters {
                layerKey := webService["id"] . "." . event.EntityTypeId . "." . key

                if (!layerData.Has(layerKey)) {
                    layerData[layerKey] := WebServiceAdapterLayerSource(adapter)
                }
            }
        }
    }

    EntityFieldGroups(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "web_service" || event.EntityTypeId == "web_service_provider") {
            return
        }

        webService := this.container["entity_manager.web_service"]["launchpad_api"]

        if (WebService["Enabled"]) {
            fieldGroups := event.FieldGroups

            if (!fieldGroups.Has("api")) {
                adapters := webService.GetAdapters([
                    "adapterType", "entity_data",
                    "entityType", event.EntityTypeId
                ])

                if (adapters.Count) {
                    fieldGroups["api"] := Map(
                        "name", "API",
                        "weight", 150
                    )
                }
            }
        }
    }

    EntityFieldDefinitions(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "web_service" || event.EntityTypeId == "web_service_provider") {
            return
        }

        webService := this.container["entity_manager.web_service"]["launchpad_api"]

        if (WebService["Enabled"]) {
            fieldDefinitions := event.FieldDefinitions

            adapters := webService.GetAdapters([
                "adapterType", "entity_data",
                "entityType", event.EntityTypeId
            ])

            if (adapters.Count) {
                fieldDefinitions["LaunchpadApiRef"] := Map(
                    "description", "The key that is used to look up the entity's data from configured external data sources.",
                    "help", "It defaults to the key which is usually sufficient, but it can be overridden by setting this value.`n`nAddtionally, multiple copies of the same data source entity can exist by giving them different keys but using the same LaunchpadApiRef",
                    "group", "api",
                    "processValue", false,
                    "modes", Map("simple", Map("formField", false))
                )
            }
        }
    }

    EntityDetectValues(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "web_service" || event.EntityTypeId == "web_service_provider") {
            return
        }

        webService := this.container["entity_manager.web_service"]["launchpad_api"]
        values := event.Values
        entity := event.Entity

        if (
            webService["Enabled"]
            && (!values.Has("LaunchpadApiRef") || !values["LaunchpadApiRef"])
            && entity.HasField("LaunchpadApiRef") 
            && (!entity.RawData.Has["LaunchpadApiRef"] || !entity.RawData["LaunchpadApiRef"])
        ) {
            result := ""

            if (event.EntityTypeId == "Launcher") {
                platform := entity["Platform"] ? entity["Platform"]["id"] : ""

                result := webService.AdapterRequest(
                    Map("id", entity["id"], "platform", platform),
                    Map(
                        "adapterType", "entity_list",
                        "entityType", event.EntityTypeId
                    )
                )
            } else if (HasBase(entity, ManagedEntityBase.Prototype)) {
                result := entity["EntityType"]
            } else {
                result := entity["id"]
            }

            if (result) {
                values["LaunchpadApiRef"] := result
            }
        }
    }

    ListEntities(event, extra, eventName, hwnd) {
        if (event.EntityTypeId == "web_service" || event.EntityTypeId == "web_service_provider") {
            return
        }

        if (event.includeExtended) {
            webService := this.container["entity_manager.web_service"]["launchpad_api"]
            entityMgr := this.container["entity_manager." . event.EntityTypeId]

            managedIds := event.includeManaged 
                ? [] 
                : entityMgr.EntityQuery(EntityQuery.RESULT_TYPE_IDS).Execute()

            if (webService["Enabled"]) {
                results := webService.AdapterRequest(
                    "",
                    Map(
                        "adapterType", "entity_list",
                        "entityType", event.EntityTypeId
                    ),
                    "read",
                    true
                )

                if (results && HasBase(results, Array.Prototype)) {
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
}
