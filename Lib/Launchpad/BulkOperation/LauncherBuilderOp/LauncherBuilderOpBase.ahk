class LauncherBuilderOpBase extends LauncherGameOpBase {
    builder := ""
    verb := "building"
    verbProper := "Building"
    verbPast := "built"
    verbPastProper := "Built"

    __New(app, launcherEntities := "", builder := "", owner := "") {
        if (builder == "") {
            builder := app.Config["builder_key"]
        }

        if (Type(builder) == "String" && builder != "") {
            builder := app.Service("BuilderManager")[builder]
        }

        InvalidParameterException.CheckTypes("LauncherBuilderOpBase", "builder", builder, "BuilderBase")
        this.builder := builder
        super.__New(app, launcherEntities, owner)
    }
}
