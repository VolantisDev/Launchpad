class DataSourceManager extends ComponentServiceBase {
    _registerEvent := "" ;Events.DATASOURCES_REGISTER
    _alterEvent := "" ;Events.DATASOURCES_ALTER
    primaryDataSourceKey := ""

    __New(eventMgr, components := "", primaryKey := "") {
        InvalidParameterException.CheckTypes("DataSourceManager", "primaryKey", primaryKey, "")

        if (primaryKey) {
            this.primaryDataSourceKey := primaryKey
        }

        super.__New(eventMgr, components)
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
