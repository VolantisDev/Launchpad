class LaunchpadLauncherState extends StateBase {
    SaveState(newState := "") {
        if (newState) {
            this.State := newState
        }
    }

    LoadState() {

    }
}
