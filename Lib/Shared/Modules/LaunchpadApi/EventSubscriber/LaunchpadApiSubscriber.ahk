class LaunchpadApiSubscriber extends EventSubscriberBase {
    GetEventSubscribers() {
        return Map(
            WebServicesEvents.ENTITY_DATA_PARAMS, [
                ObjBindMethod(this, "EntityDataParams")
            ]
        )
    }

    EntityDataParams(event, extra, eventName, hwnd) {
        if (HasProp(event.Entity, "isWebServiceEntity") && event.Entity.isWebServiceEntity) {
            return
        }

        ; TODO figure out how to access these values while the data layers are still being loaded
        if (event.WebService["id"] == "launchpad_api") {
            if (HasBase(event.Entity, LauncherEntity.Prototype)) {
                event.Params["platformId"] := "Blizzard" ;event.Entity["Platform"]["id"]
            } else if (HasBase(event.Entity, LaunchProcessEntity.Prototype)) {
                event.Params["platformId"] := "Blizzard" ;event.Entity.ParentEntity["Platform"]["id"]
            }
        }
    }
}
