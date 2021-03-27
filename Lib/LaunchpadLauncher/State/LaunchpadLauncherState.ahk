class LaunchpadLauncherState extends StateBase {
    __New(app, state := "") {
        if (Type(state) != "Map") {
            state := ""
        }

        super.__New(app)
    }

    SaveState(newState := "") {
        if (newState && Type(newState) == "Map") {
            this.State := newState
        }
    }

    LoadState() {

    }
}
