class BuilderManager extends AppComponentManagerBase {
    launcherMgr := ""

    __New(launcherMgr, container, eventMgr, notifierObj) {
        this.launcherMgr := launcherMgr
        super.__New(container, eventMgr, notifierObj, "builder.", BuilderBase)
    }

    BuildLaunchers(launcherGames := "", updateExisting := false, owner := "", builder := "") {
        if (launcherGames == "") {
            launcherGames := this.launcherMgr.Entities
        }

        builder := this._GetBuilderObject(builder)
        operation := BuildLaunchersOp(this.container.GetApp(), launcherGames, builder, updateExisting, owner)
        return operation.Run()
    }

    CleanLaunchers(launcherGames := "", owner := "", builder := "") {
        if (launcherGames == "") {
            launcherGames := this.launcherMgr.Entities
        }

        builder := this._GetBuilderObject(builder)
        operation := CleanLaunchersOp(this.container.GetApp(), launcherGames, builder, owner)
        return operation.Run()
    }

    _GetBuilderObject(builder) {
        if (builder == "") {
            builder := this.container.Get("Config")["builder_key"]
        }

        if (!IsObject(builder)) {
            if (!this.Has(builder)) {
                throw ComponentException("Builder " . builder . " does not exist")
            }
            
            builder := this[builder]
        }

        return builder
    }
}
