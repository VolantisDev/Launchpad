class BlizzardModule extends ModuleBase {
    GetDependencies() {
        return []
    }

    GetSubscribers() {
        subscribers := Map()
        subscribers[Events.APP_SERVICE_DEFINITIONS] := [ObjBindMethod(this, "DefineServices")]
        subscribers[Events.PLATFORMS_DEFINE] := [ObjBindMethod(this, "DefinePlatform")]
        return subscribers
    }

    DefineServices(event, extra, eventName, hwnd) {
        event.DefineService("BlizzardProductDb", Map(
            "class", "BlizzardProductDb",
            "arguments", this.app
        ))
    }

    DefinePlatform(event, extra, eventName, hwnd) {
        event.Define("Blizzard", "BlizzardPlatform")
    }
}
