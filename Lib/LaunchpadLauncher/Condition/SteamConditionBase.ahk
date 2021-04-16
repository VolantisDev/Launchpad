class SteamConditionBase extends ConditionBase {
    app := ""
    steamPath := ""

    __New(app, childConditions := "", negate := false) {
        this.app := app
        this.steamPath := GetSteamPath(app)
        super.__New(childConditions, negate)
    }

    GetSteamPath(app) {
        steamPath := ""

        if (app.Services.Exists("Platforms")) {
            platforms := app.Service("Platforms")

            if (platforms.Has("Steam") && platforms["Steam"].Has("InstallDir")) {
                steamPath := platforms["Steam"]["InstallDir"]
            }
        }

        return steamPath
    }
}
