class DataSourceItemBase {
    app := ""
    endpoint := ""
    basePath := ""
    itemSuffix := ""
    path := ""
    key := ""

    __New(app, key, path := "", dataSource := "") {
        InvalidParameterException.CheckTypes("DataSourceItemBase", "app", app, "Launchpad", "key", key, "", "path", path, "")
        InvalidParameterException.CheckEmpty("DataSourceItemBase", "key", key)

        if (Type(dataSource) == "String") {
            dataSource := app.DataSources.GetDataSource(dataSource)
        }

        InvalidParameterException.CheckTypes("DataSourceItemBase", "dataSource", dataSource, "DataSourceBase")
        this.app := app
        this.endpoint := dataSource
        this.key := key
        this.path := path
    }

    GetPath(includeFilename := true) {
        path := this.basePath

        if (path != "" && this.path != "") {
            path .= "/"
        }

        path .= this.path

        if (includeFilename) {
            path .= "/" . this.key . this.itemSuffix
        }

        return path
    }

    GetRemoteLocation() {
        return this.endpoint.GetRemoteLocation(this.GetPath())
    }

    Exists() {
        return this.endpoint.ItemExists(this.GetPath())
    }

    Read() {
        return this.endpoint.ReadItem(this.GetPath())
    }

    Copy(destination) {
        return this.endpoint.CopyItem(this.GetPath(), destination)
    }
}
