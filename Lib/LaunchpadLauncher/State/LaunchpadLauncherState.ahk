class LaunchpadLauncherState extends AppState {
    __New(app, state := "") {
        if (!HasBase(state, Map.Prototype)) {
            state := ""
        }

        super.__New(app, "", false)
    }
}
