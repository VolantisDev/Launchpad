class LaunchpadInstaller extends InstallerBase {
    name := "Launchpad Installer"
    parentComponent := "LaunchpadExe"
    version := "latest"

    __New(appState, cache, tmpDir := "") {
        components := []

        component := GitHubReleaseInstallerComponent.new("VolantisDev/Launchpad", "LaunchpadUpdater.exe", false, "LaunchpadUpdater.exe", appState, "LaunchpadUpdater", cache, this.appName, true, tmpDir, true)
        component.version := this.version
        components.Push(component)

        component := GitHubReleaseInstallerComponent.new("VolantisDev/Launchpad", "LaunchpadGraphics.zip", true, "Graphics", appState, "LaunchpadGraphics", cache, this.appName, true, tmpDir, true)
        component.version := this.version
        components.Push(component)

        super.__New(appState, this.appName, cache, components, tmpDir)
    }
}
