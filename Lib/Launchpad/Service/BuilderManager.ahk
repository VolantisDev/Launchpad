class BuilderManager extends AppComponentServiceBase {
    _registerEvent := LaunchpadEvents.BUILDERS_REGISTER
    _alterEvent := LaunchpadEvents.BUILDERS_ALTER

    SetItem(key, builderObj) {
        return super.SetItem(key, builderObj)
    }

    BuildLaunchers(launcherGames := "", updateExisting := false, owner := "", builder := "") {
        if (launcherGames == "") {
            launcherGames := this.app.Service("LauncherManager").Entities
        }

        builder := this._GetBuilderObject(builder)
        operation := BuildLaunchersOp(this.app, launcherGames, builder, updateExisting, owner)
        return operation.Run()
    }

    CleanLaunchers(launcherGames := "", owner := "", builder := "") {
        if (launcherGames == "") {
            launcherGames := this.app.Service("LauncherManager").Entities
        }

        builder := this._GetBuilderObject(builder)
        operation := CleanLaunchersOp(this.app, launcherGames, builder, owner)
        return operation.Run()
    }

    _GetBuilderObject(builder) {
        if (builder == "") {
            builder := this.app.Config["builder_key"]
        }

        if (!IsObject(builder)) {
            builder := this.GetItem(builder)
        }

        return builder
    }
}
