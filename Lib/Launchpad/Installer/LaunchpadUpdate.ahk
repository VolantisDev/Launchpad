class LaunchpadUpdate extends InstallerBase {
    name := "Launchpad Update"
    parentComponent := ""

    __New(appVersion, appState, cache, tmpDir := "") {
        components := []
        components.Push(GitHubReleaseInstallerComponent("latest", "VolantisDev/Launchpad", "Launchpad-{{version}}.exe", false, "LaunchpadSetup.exe", appState, "LaunchpadUpdate", cache, this.appName, true, tmpDir, true))
        super.__New(appState, this.appName, cache, components, tmpDir)
    }
}
