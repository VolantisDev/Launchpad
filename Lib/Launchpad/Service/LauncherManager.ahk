class LauncherManager extends EntityManagerBase {
    _registerEvent := LaunchpadEvents.LAUNCHERS_REGISTER
    _alterEvent := LaunchpadEvents.LAUNCHERS_ALTER

    GetLoadOperation() {
        return LoadLaunchersOp(this.app, this.configObj)
    }

    GetDefaultConfigPath() {
        return this.app.Config["launcher_file"]
    }

    RemoveEntityFromConfig(key) {
        this.configObj["games"].Delete(key)
    }

    AddEntityToConfig(key, entityObj) {
        this.configObj["games"][key] := entityObj.UnmergedConfig
        this.app.State.SetLauncherCreated(key)
    }
}
