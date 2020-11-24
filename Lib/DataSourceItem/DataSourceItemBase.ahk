class DataSourceItemBase {
    app := ""
    endpoint := ""
    basePath := ""
    itemSuffix := ""
    path := ""
    key := ""

    __New(app, key, path := "", dataSource := "") {
        if (dataSource == "") {
            dataSourceKey := app.Config.DataSourceKey
        }
        
        this.app := app
        this.endpoint := IsObject(dataSource) ? dataSource : app.DataSources.GetDataSource(dataSourceKey)
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
