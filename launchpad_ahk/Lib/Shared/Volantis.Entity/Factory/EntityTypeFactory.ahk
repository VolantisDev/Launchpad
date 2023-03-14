class EntityTypeFactory {
    container := ""
    eventMgr := ""
    idSanitizer := ""

    __New(container, eventMgr, idSanitizer) {
        this.container := container
        this.eventMgr := eventMgr
        this.idSanitizer := idSanitizer
    }

    GetDefaults(entityTypeId) {
        return Map(
            "name_singular", "Entity",
            "name_plural", "Entities",
            "entity_type_class", "BasicEntityType",
            "entity_class", this.GetEntityClassFromId(entityTypeId),
            "service_prefix", "entity." . entityTypeId . ".",
            "definition_loader_class", "DiscoveryEntityDefinitionLoader",
            "definition_loader_parameter_key", "",
            "entity_manager_class", "BasicEntityManager",
            "auto_load", false,
            "storage_class", "ConfigEntityStorage",
            "storage_config_service", "config." . entityTypeId,
            "storage_config_storage_class", "JsonConfigStorage",
            "storage_config_storage_parent_key", "entities",
            "storage_config_path_parameter", "",
            "factory_class", "EntityFactory",
            "id_sanitizer", this.idSanitizer,
            "event_manager", "manager.event",
            "notifier", "notifier",
            "parent_entity_type", "",
            "parent_entity_storage", false,
            "default_icon", "cube-outline",
            "icon_field", "IconSrc",
            "allow_view", false,
            "allow_add", false,
            "allow_edit", true,
            "allow_delete", false,
            "manager_view_mode", "Report",
            "manager_view_mode_parameter", "",
            "manager_gui", "ManageEntitiesWindow",
            "manager_link_in_tools_menu", false,
            "manager_menu_link_text", "",
            "storage_type", "persistent"
        )
    }

    MergeWithDefaults(entityTypeId, definition) {
        values := this.GetDefaults(entityTypeId)

        for key, val in definition {
            values[key] := val
        }

        return values
    }

    GetEntityClassFromId(entityTypeId) {
        return StrTitle(entityTypeId)
    }

    CreateServiceDefinitions(id, definition) {
        definition := this.MergeWithDefaults(id, definition)

        storageClass := definition["storage_class"]
        factoryClass := definition["factory_class"]
        loaderClass := definition["definition_loader_class"]
        managerClass := definition["entity_manager_class"]
        entityTypeClass := definition["entity_type_class"]
        parentEntityType := definition["parent_entity_type"]

        services := Map(
            "entity_storage." . id, Map(
                "factory", %storageClass%,
                "method", "Create",
                "arguments", [id, definition, "@{}"]
            ),
            "factory." . id, Map(
                "factory", %factoryClass%,
                "method", "Create",
                "arguments", [id, definition, "@{}"]
            ),
            "definition_loader." . id, Map(
                "factory", %loaderClass%,
                "method", "Create",
                "arguments", [id, definition, "@{}"]
            ),
            "entity_manager." . id, Map(
                "factory", %managerClass%,
                "method", "Create",
                "arguments", [id, definition, "@{}"]
            ),
            "entity_type." . id, Map(
                "factory", %entityTypeClass%,
                "method", "Create",
                "arguments", [id, definition, "@{}"],
                "parent_entity_type", parentEntityType
            ),
        )

        if (definition["storage_type"] == "persistent" && definition["storage_class"] == "ConfigEntityStorage" && definition["storage_config_path_parameter"]) {
            services["config_storage." . id] := Map(
                "class", definition["storage_config_storage_class"],
                "arguments", ["@@" . definition["storage_config_path_parameter"], definition["storage_config_storage_parent_key"]]
            )

            services["config." . id] := Map(
                "class", "PersistentConfig",
                "arguments", ["@config_storage." . id, "@{}", "entity_data." . id]
            )
        } else if (definition["storage_type"] == "runtime") {
            services["config." . id] := Map(
                "class", "RuntimeConfig",
                "arguments", ["@{}", "entity_data." . id]
            )
        }

        entityClass := definition["entity_class"]
        baseClass := "FieldableEntity"

        if (HasBase(%entityClass%, FieldableEntity)) {
            services["entity_field_factory." . id] := Map(
                "class", "EntityFieldFactory",
                "arguments", ["@{}", id]
            )

            services["entity_widget_factory." . id] := Map(
                "class", "EntityFieldWidgetFactory",
                "arguments", ["@{}"]
            )
            
            services["entity_form_factory." . id] := Map(
                "class", "EntityFormFactory",
                "arguments", ["@{}"]
            )
        }

        return services
    }
}
