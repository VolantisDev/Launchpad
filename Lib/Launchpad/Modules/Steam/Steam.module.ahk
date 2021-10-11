class SteamModule extends ModuleBase {
    GetDependencies() {
        return []
    }

    GetEventSubscribers() {
        subscribers := Map()
        subscribers[LaunchpadEvents.PLATFORMS_DEFINE] := [ObjBindMethod(this, "DefinePlatform")]
        return subscribers
    }

    DefinePlatform(event, extra, eventName, hwnd) {
        event.Define("Steam", "SteamPlatform")
    }
}
