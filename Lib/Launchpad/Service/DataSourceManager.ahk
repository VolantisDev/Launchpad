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

    GetDataSource(key := "") {
        if (key == "") {
            key := this.primaryDataSourceKey
        }

        return (this.dataSources.Has(key)) ? this.dataSources[key] : ""
    }

    SetDataSource(key, dataSourceObj, makePrimary := false) {
        this.dataSources[key] := dataSourceObj

        if (makePrimary) {
            this.primaryDataSourceKey := key
        }
    }

    ReadListing(path, dataSourceKey := "") {
        dataSource := this.GetDataSource(dataSourceKey)
        return dataSource.ReadListing(path)
    }

    ReadJson(key, path := "", dataSourceKey := "") {
        dataSource := this.GetDataSource(dataSourceKey)
        return dataSource.ReadJson(key, path)
    }
}
