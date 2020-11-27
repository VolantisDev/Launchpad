class BuilderManager extends ServiceBase {
    builders := Map()
    defaultBuilderKey := "ahk"

    GetBuilder(key) {
        return (this.builders.Has(key)) ? this.builders[key] : ""
    }

    SetBuilder(key, builderObj, makeDefault := false) {
        this.builders[key] := builderObj

        if (makeDefault) {
            this.defaultBuilderKey := key
        }
    }

    BuildLaunchers(launcherGames := "", updateExisting := false, owner := "", builder := "") {
        if (launcherGames == "") {
            launcherGames := this.app.Launchers.Launchers
        }

        if (builder == "") {
            builder := this.defaultBuilderKey
        }

        if (!IsObject(builder)) {
            builder := this.GetBuilder(builder)
        }

        operation := BuildLaunchersOp.new(this.app, launcherGames, builder, updateExisting, owner)
        return operation.Run()
    }

    CleanLaunchers(launcherGames := "", owner := "", builder := "") {
        if (launcherGames == "") {
            launcherGames := this.app.Launchers.Launchers
        }

        if (builder == "") {
            builder := this.defaultBuilderKey
        }

        if (!IsObject(builder)) {
            builder := this.GetBuilder(builder)
        }

        operation := CleanLaunchersOp.new(this.app, launcherGames, builder, owner)
        return operation.Run()
    }
}
