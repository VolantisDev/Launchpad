class LauncherManager extends EntityManagerBase {
    _registerEvent := "" ;LaunchpadEvents.LAUNCHERS_REGISTER
    _alterEvent := "" ;LaunchpadEvents.LAUNCHERS_ALTER

    GetLoadOperation() {
        return LoadLaunchersOp(this.app, this.configObj)
    }

    CreateConfigObj(app, configFile) {
        return LauncherConfig(app, configFile, false)
    }

    GetDefaultConfigPath() {
        return this.app.Config.LauncherFile
    }

    RemoveEntityFromConfig(key) {
        this.configObj.Games.Delete(key)
    }

    AddEntityToConfig(key, entityObj) {
        this.configObj.Games[key] := entityObj.UnmergedConfig
    }
}
