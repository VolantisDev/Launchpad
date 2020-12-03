class ThemeInstaller extends InstallerBase {
    name := "Launchpad Theme Installer"
    version := "latest"

    __New(appState, cache, downloadThemes := "", tmpDir := "") {
        components := []

        component := GitHubReleaseInstallerComponent.new("VolantisDev/Launchpad", "LaunchpadThemes.zip", true, "Themes", appState, "LaunchpadThemes", cache, "Themes", true, tmpDir, true)
        component.version := this.version
        components.Push(component)

        if (downloadThemes != "") {
            for key, url in downloadThemes {
                path := "Themes\" . key . ".json"
                components.Push(DownloadableInstallerComponent.new(url, false, path, appState, cache, key . "Theme", "Themes", false, tmpDir, false))
            }
        }

        super.__New(appState, "Themes", cache, components, tmpDir)
    }
}
