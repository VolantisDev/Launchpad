class GameAhkFile extends ComposableBuildFile {
    __New(launcherEntityObj, destPath := "") {
        if (destPath == "") {
            destPath := launcherEntityObj.AssetsDir . "\" . launcherEntityObj.Key . ".ahk"
        }

        super.__New(launcherEntityObj, destPath)
    }

    ComposeFile() {
        global appVersion

        data := Map(
            "launcherName", this.launcherEntityObj.Key . " - Launchpad",
            "appVersion", appVersion,
            "appDir", this.appDir,
            "gameConfig", this.launcherEntityObj.ManagedLauncher.ManagedGame.Config,
            "launchpadLauncherConfig", this.launcherEntityObj.Config,
            "launcherConfig", this.launcherEntityObj.ManagedLauncher.Config,
            "launcherKey", this.launcherEntityObj.Key,
            "themesDir", this.launcherEntityObj.ThemesDir,
            "resourcesDir", this.launcherEntityObj.ResourcesDir,
            "themeName", this.launcherEntityObj.ThemeName,
            "platforms", this.GetPlatforms()
        )

        templateFile := this.appDir . "\Resources\Templates\Launcher.template.ahk"
        template := AhkTemplate(FileRead(templateFile), data)

        FileAppend(template.Render(), this.FilePath)
        
        return this.FilePath
    }

    GetPlatforms() {
        platforms := Map()

        for key, platform in this.app.Service("PlatformManager").GetActivePlatforms() {
            platforms[key] := platform.Config
        }

        return platforms
    }
}
