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
        event.DefineServices(Map(
            "auth_provider.launchpad_api", Map(
                "class", "LaunchpadApiAuthProvider",
                "arguments", [
                    AppRef(), 
                    this.app.State
                ]
            ),
            "Auth", Map(
                "class", "AuthService",
                "arguments", [
                    AppRef(), 
                    ServiceRef("auth_provider.launchpad_api"), 
                    this.app.State
                ]
            )
        ))
    }
}
