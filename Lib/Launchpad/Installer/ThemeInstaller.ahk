class ThemeInstaller extends InstallerBase {
    name := "Launchpad Theme Installer"
    version := "latest"

    __New(appState, cache, downloadThemes := "", tmpDir := "") {
        assets := []

        asset := GitHubReleaseInstallerAsset.new("VolantisDev/Launchpad", "LaunchpadThemes.zip", true, "Themes", appState, "LaunchpadThemes", cache, "Themes", true, tmpDir, true)
        asset.version := this.version
        assets.Push(asset)

        if (downloadThemes != "") {
            for key, url in downloadThemes {
                path := "Themes\" . key . ".json"
                assets.Push(DownloadableInstallerAsset.new(url, false, path, appState, cache, key . "Theme", "Themes", false, tmpDir, false))
            }
        }

        super.__New(appState, "Themes", cache, assets, tmpDir)
    }
}
