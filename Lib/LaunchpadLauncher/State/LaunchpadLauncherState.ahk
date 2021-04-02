class LaunchpadLauncherState extends AppState {
    __New(app, state := "") {
        if (Type(state) != "Map") {
            state := ""
        }

        super.__New(app, "", false)
    }
}
