class DataSourceManager extends AppComponentServiceBase {
    primaryDataSourceKey := ""

    __New(app, primaryKey := "", primaryDataSource := "") {
        InvalidParameterException.CheckTypes("DataSourceManager", "primaryKey", primaryKey, "", "primaryDataSource", primaryDataSource, "")

        if (primaryKey != "" and primaryDataSource != "") {
            this.primaryDataSourceKey := primaryKey
            this.dataSources[primaryKey] := primaryDataSource
        }

        super.__New(app)
    }

    GetItem(key := "") {
        if (key == "") {
            key := this.primaryDataSourceKey
        }

        return super.GetItem(key)
    }

    SetItem(key, dataSourceObj, makePrimary := false) {
        if (makePrimary) {
            this.primaryDataSourceKey := key
        }

        return super.SetItem(key, dataSourceObj)
    }

    ReadListing(path, dataSourceKey := "") {
        dataSource := this.GetItem(dataSourceKey)
        return dataSource.ReadListing(path)
    }

    ReadJson(key, path := "", dataSourceKey := "") {
        dataSource := this.GetItem(dataSourceKey)
        return dataSource.ReadJson(key, path)
    }
}
