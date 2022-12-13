class LaunchpadApiSubscriber extends EventSubscriberBase {
    GetEventSubscribers() {
        return Map(
            Events.APP_GET_RELEASE_INFO, [
                ObjBindMethod(this, "GetReleaseInfo")
            ],
        )
    }

    GetReleaseInfo(event, extra, eventName, hwnd) {
        releaseInfo := event.ReleaseInfo

        if (!event.ReleaseInfo.Count && this.App.Version != "{{VERSION}}") {
            webService := this.App["entity_manager.web_service"]["launchpad_api"]
            
            if (webService["Enabled"]) {
                releaseInfo := webService.AdapterRequest("", "release_info", "read", 1)

                if (releaseInfo && releaseInfo.Has("data")) {
                    for key, val in releaseInfo["data"] {
                        event.ReleaseInfo[key] = val
                    }
                }
            }
        }
    }
}
