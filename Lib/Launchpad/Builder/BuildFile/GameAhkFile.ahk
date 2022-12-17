class GameAhkFile extends ComposableBuildFile {
    __New(launcherEntityObj, destPath := "") {
        if (destPath == "") {
            destPath := launcherEntityObj["AssetsDir"] . "\" . launcherEntityObj.Id . ".ahk"
        }

        super.__New(launcherEntityObj, destPath)
    }

    ComposeFile() {
        global appVersion

        data := Map(
            "launcherName", this.launcherEntityObj.Id . " - Launchpad",
            "appVersion", appVersion,
            "appDir", this.appDir,
            "gameConfig", this.launcherEntityObj["GameProcess"].FieldData,
            "launchpadLauncherConfig", this.launcherEntityObj.FieldData,
            "launcherConfig", this.launcherEntityObj["LauncherProcess"].FieldData,
            "launcherId", this.launcherEntityObj.Id,
            "themesDir", this.launcherEntityObj["ThemesDir"],
            "resourcesDir", this.launcherEntityObj["ResourcesDir"],
            "themeName", this.launcherEntityObj["Theme"].name,
            "platforms", this.GetPlatforms()
        )

        templateFile := this.appDir . "\Resources\Templates\Launcher.template.ahk"
        template := AhkTemplate(FileRead(templateFile), data)

        FileAppend(template.Render(), this.FilePath)
        
        return this.FilePath
    }

    GetPlatforms() {
        platforms := Map()

        for key, platform in this.app["entity_manager.platform"].GetActivePlatforms(EntityQuery.RESULT_TYPE_ENTITIES) {
            platforms[key] := platform.FieldData
        }

        return platforms
    }
}
