class EpicModule extends ModuleBase {
    GetDependencies() {
        return []
    }

    GetSubscribers() {
        subscribers := Map()
        subscribers[Events.PLATFORMS_DEFINE] := [ObjBindMethod(this, "DefinePlatform")]
        return subscribers
    }

    DefinePlatform(event, extra, eventName, hwnd) {
        event.Define("Epic", "EpicPlatform")
    }
}
