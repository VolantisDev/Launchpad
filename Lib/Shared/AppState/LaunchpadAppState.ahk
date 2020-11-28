class LaunchpadAppState extends JsonAppState {
    LaunchpadInstallDir {
        get => this.State.Has("LaunchpadInstallDir") ? this.State["LaunchpadInstallDir"] : ""
        set => this.State["LaunchpadInstallDir"] := value
    }
}
