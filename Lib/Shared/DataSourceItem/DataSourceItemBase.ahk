class DataSourceItemBase {
    endpoint := ""
    basePath := ""
    itemSuffix := ""
    path := ""
    key := ""

    __New(key, path := "", dataSource := "") {
        try {
            InvalidParameterException.CheckTypes("DataSourceItemBase", "key", key, "", "path", path, "")
            InvalidParameterException.CheckEmpty("DataSourceItemBase", "key", key)
            InvalidParameterException.CheckTypes("DataSourceItemBase", "dataSource", dataSource, "DataSourceBase")
        } catch ex {
            MsgBox key
        }
        
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
            if (path) {
                path .= "/"
            }
            
            path .= this.key . this.itemSuffix
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
