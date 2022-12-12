class WebServicesEventSubscriber extends EventSubscriberBase {
    GetEventSubscribers() {
        return Map(
            Events.APP_POST_STARTUP, [
                ObjBindMethod(this, "OnPostStartup")
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
}
