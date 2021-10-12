class BlizzardModule extends ModuleBase {
    GetDependencies() {
        return []
    }

    GetEventSubscribers() {
        subscribers := Map()
        subscribers[Events.APP_SERVICE_DEFINITIONS] := [ObjBindMethod(this, "DefineServices")]
        subscribers[LaunchpadEvents.PLATFORMS_DEFINE] := [ObjBindMethod(this, "DefinePlatform")]
        return subscribers
    }

    DefineServices(event, extra, eventName, hwnd) {
        event.DefineService("BlizzardProductDb", Map("class", "BlizzardProductDb"))
    }

    DefinePlatform(event, extra, eventName, hwnd) {
        event.Define("Blizzard", "BlizzardPlatform")
    }
}
