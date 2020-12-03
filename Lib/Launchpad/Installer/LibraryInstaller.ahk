class LibraryInstaller extends InstallerBase {
    name := "Launchpad Library Installer"
    onlyInstallWhenCompiled := true
    version := "latest"

    __New(appState, cache, tmpDir := "") {
        components := []
        component := GitHubReleaseInstallerComponent.new("VolantisDev/Launchpad", "LaunchpadLib.zip", true, "Lib", appState, "LibDirs", cache, "Libraries", true, tmpDir, true)
        component.version := this.version
        components.Push(component)
        super.__New(appState, "Libraries", cache, components, tmpDir)
    }
}
