class ThemeInstaller extends InstallerBase {
    name := "Launchpad Theme Installer"
    version := "latest"

    __New(appState, cache, downloadThemes := "", tmpDir := "") {
        components := []

        if (downloadThemes != "") {
            for key, url in downloadThemes {
                path := "Resources\Themes\" . key . ".json"
                components.Push(DownloadableInstallerComponent.new(url, false, path, appState, cache, key . "Theme", "Themes", false, tmpDir, false))
            }
        }

        super.__New(appState, "Themes", cache, components, tmpDir)
    }
}
