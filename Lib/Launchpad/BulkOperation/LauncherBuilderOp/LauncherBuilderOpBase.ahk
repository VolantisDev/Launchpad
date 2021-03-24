class LauncherBuilderOpBase extends LauncherGameOpBase {
    builder := ""
    verb := "building"
    verbProper := "Building"
    verbPast := "built"
    verbPastProper := "Built"

    __New(app, launcherEntities := "", builder := "", owner := "") {
        if (builder == "") {
            builder := app.Config.BuilderKey
        }

        if (Type(builder) == "String" && builder != "") {
            builder := app.Builders.GetItem(builder)
        }

        InvalidParameterException.CheckTypes("LauncherBuilderOpBase", "builder", builder, "BuilderBase")
        this.builder := builder
        super.__New(app, launcherEntities, owner)
    }
}
