class ThemeInstaller extends InstallerBase {
    name := "Launchpad Theme Installer"

    __New(appState, downloadThemes := "", tmpDir := "") {
        assets := []
        assets.Push(CompiledInstallerAsset.new("Themes\Lightpad.json", "Themes\Lightpad.json", appState, "LightpadTheme", "Themes", true, tmpDir))

        if (downloadThemes != "") {
            for key, url in downloadThemes {
                path := "Themes\" . key . ".json"
                assets.Push(DownloadableInstallerAsset.new(url, false, path, appState, key . "Theme", "Themes", false, tmpDir))
            }
        }

        super.__New(appState, "Themes", assets, tmpDir)
    }
}
