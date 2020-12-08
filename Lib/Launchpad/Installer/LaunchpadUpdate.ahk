class LaunchpadUpdate extends InstallerBase {
    name := "Launchpad Update"
    parentComponent := ""
    version := "latest"

    __New(appState, cache, tmpDir := "") {
        components := []

        component := GitHubReleaseInstallerComponent.new("VolantisDev/Launchpad", "Launchpad-{{version}}.exe", false, "LaunchpadSetup.exe", appState, "LaunchpadUpdate", cache, this.appName, true, tmpDir, true)
        component.version := this.version
        components.Push(component)

        super.__New(appState, this.appName, cache, components, tmpDir)
    }
}
