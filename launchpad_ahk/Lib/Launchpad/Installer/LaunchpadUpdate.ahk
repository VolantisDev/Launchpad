class LaunchpadUpdate extends InstallerBase {
    name := "Launchpad Update"
    parentComponent := ""
    installerType := InstallerBase.INSTALLER_TYPE_SELF_UPDATE

    __New(appVersion, appState, cacheManager, cacheName, tmpDir := "") {
        components := []
        cache := cacheManager[cacheName]
        components.Push(GitHubReleaseInstallerComponent("latest", "VolantisDev/Launchpad", "Launchpad-{{version}}.exe", false, "LaunchpadSetup.exe", appState, "LaunchpadUpdate", cache, this.appName, true, tmpDir, true))
        super.__New(appVersion, appState, this.appName, cacheManager, cacheName, components, tmpDir)
    }
}
