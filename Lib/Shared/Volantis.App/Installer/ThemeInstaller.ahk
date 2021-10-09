class ThemeInstaller extends InstallerBase {
    name := "Launchpad Theme Installer"
    installerType := InstallerBase.INSTALLER_TYPE_REQUIREMENT

    __New(appVersion, appState, cacheManager, cacheName, downloadThemes := "", tmpDir := "") {
        components := []

        if (downloadThemes != "") {
            for key, url in downloadThemes {
                path := "Resources\Themes\" . key . ".json"
                cache := cacheManager[cacheName]
                components.Push(DownloadableInstallerComponent(this.version, url, false, path, appState, cache, key . "Theme", "Themes", false, tmpDir, false))
            }
        }

        super.__New(appVersion, appState, "Themes", cacheManager, cacheName, components, tmpDir)
    }
}
