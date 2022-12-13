class WebServicesEventSubscriber extends EventSubscriberBase {
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
}
