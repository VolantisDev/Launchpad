class SteamConditionBase extends ConditionBase {
    app := ""
    steamPath := ""

    __New(app, childConditions := "", negate := false) {
        this.app := app
        this.steamPath := this.GetSteamPath(app)
        super.__New(childConditions, negate)
    }

    GetSteamPath(app) {
        steamPath := ""

        platforms := app.Parameter["platforms"]

        if (platforms.Has("Steam") && platforms["Steam"].Has("InstallDir")) {
            steamPath := platforms["Steam"]["InstallDir"]
        }

        return steamPath
    }
}
