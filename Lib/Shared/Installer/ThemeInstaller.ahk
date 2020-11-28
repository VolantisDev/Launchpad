class ThemeInstaller extends InstallerBase {
    name := "Launchpad Theme Installer"

    __New(appState, cache, downloadThemes := "", tmpDir := "") {
        assets := []
        assets.Push(LightpadThemeInstallerAsset.new(appState, cache, "LightpadTheme", "Themes", true, tmpDir, true))

        if (downloadThemes != "") {
            for key, url in downloadThemes {
                path := "Themes\" . key . ".json"
                assets.Push(DownloadableInstallerAsset.new(url, false, path, appState, cache, key . "Theme", "Themes", false, tmpDir, false))
            }
        }

        super.__New(appState, "Themes", cache, assets, tmpDir)
    }
}
