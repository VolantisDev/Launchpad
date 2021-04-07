class BlizzardModule extends ModuleBase {
    GetDependencies() {
        return []
    }

    GetSubscribers() {
        subscribers := Map()
        subscribers[Events.APP_PRE_LOAD_SERVICES] := [ObjBindMethod(this, "LoadServices")]
        subscribers[Events.PLATFORMS_DEFINE] := [ObjBindMethod(this, "DefinePlatform")]
        return subscribers
    }

    LoadServices(event, extra, eventName, hwnd) {
        event.App.Services.Set("BlizzardProductDb", BlizzardProductDb.new(this.app))
    }

    DefinePlatform(event, extra, eventName, hwnd) {
        event.Define("Blizzard", "BlizzardPlatform")
    }
}
