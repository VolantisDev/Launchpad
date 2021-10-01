class AuthModule extends ModuleBase {
    GetDependencies() {
        return []
    }

    GetSubscribers() {
        subscribers := Map()
        subscribers[Events.APP_SERVICE_DEFINITIONS] := [ObjBindMethod(this, "DefineServices")]
        return subscribers
    }

    DefineServices(event, extra, eventName, hwnd) {
        if (!event.Services.Has("auth_provider.launchpad_api") || !event.Services["auth_provider.launchpad_api"]) {
            event.DefineService("auth_provider.launchpad_api", Map(
                "class", "LaunchpadApiAuthProvider",
                "arguments", [AppRef(), this.app.State]
            ))
        }

        if (!event.Services.Has("Auth") || !event.Services["Auth"]) {
            event.DefineService("Auth", Map(
                "class", "AuthService",
                "arguments", [AppRef(), "", this.app.State]
            ))
        }

        if (!event.Services["Auth"].Has("calls")) {
            event.Services["Auth"]["calls"] := []
        }

        event.Services["Auth"]["calls"].Push(Map(
            "method", "SetAuthProvider", 
            "arguments", ServiceRef("auth_provider.launchpad_api")
        ))
    }
}
