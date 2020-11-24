class DataSourceManager extends ServiceBase {
    dataSources := Map()
    primaryDataSourceKey := ""

    __New(app, primaryKey := "", primaryDataSource := "") {
        if (primaryKey != "" and primaryDataSource != "") {
            this.primaryDataSourceKey := primaryKey
            this.dataSources[primaryKey] := primaryDataSource
        }

        super.__New(app)
    }

    GetDataSource(key) {
        return (this.dataSources.Has(key)) ? this.dataSources[key] : ""
    }

    SetDataSource(key, dataSourceObj, makePrimary := false) {
        this.dataSources[key] := dataSourceObj

        if (makePrimary) {
            this.primaryDataSourceKey := key
        }
    }

    ReadListing(path, dataSourceKey := "") {
        if (dataSourceKey == "") {
            dataSourceKey := this.app.Config.DataSourceKey
        }

        itemListing := ""

        dataSource := this.GetDataSource(dataSourceKey)
        return dataSource.ReadListing(path)
    }

    ReadJson(key, path := "", dataSourceKey := "") {
        if (dataSourceKey == "") {
            dataSourceKey := this.app.Config.DataSourceKey
        }

        jsonData := ""

        dataSource := this.GetDataSource(dataSourceKey)
        return dataSource.ReadJson(key, path)
    }
}
