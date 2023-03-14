class BuilderManager extends ComponentManagerBase {
    launcherMgr := ""

    __New(launcherMgr, container, eventMgr, notifierObj) {
        this.launcherMgr := launcherMgr
        super.__New(container, "builder.", eventMgr, notifierObj, BuilderBase)
    }

    BuildLaunchers(launcherGames := "", updateExisting := false, owner := "", builder := "") {
        if (launcherGames == "") {
            launcherGames := this.launcherMgr.All()
        }

        builder := this._GetBuilderObject(builder)
        operation := BuildLaunchersOp(this.container.GetApp(), launcherGames, builder, updateExisting, owner)
        return operation.Run()
    }

    CleanLaunchers(launcherGames := "", owner := "", builder := "") {
        if (launcherGames == "") {
            launcherGames := this.launcherMgr.All()
        }

        builder := this._GetBuilderObject(builder)
        operation := CleanLaunchersOp(this.container.GetApp(), launcherGames, builder, owner)
        return operation.Run()
    }

    GetDefaultComponentId() {
        return this.container.Get("config.app")["builder_key"]
    }

    _GetBuilderObject(builder := "") {
        if (builder == "") {
            builder := this.GetDefaultComponentId()
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
