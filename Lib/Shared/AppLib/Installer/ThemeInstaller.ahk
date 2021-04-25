class ThemeInstaller extends InstallerBase {
    name := "Launchpad Theme Installer"

    __New(appVersion, appState, cache, downloadThemes := "", tmpDir := "") {
        components := []

        if (downloadThemes != "") {
            for key, url in downloadThemes {
                path := "Resources\Themes\" . key . ".json"
                components.Push(DownloadableInstallerComponent(this.version, url, false, path, appState, cache, key . "Theme", "Themes", false, tmpDir, false))
            }
        }

        super.__New(appVersion, appState, "Themes", cache, components, tmpDir)
    }
}
