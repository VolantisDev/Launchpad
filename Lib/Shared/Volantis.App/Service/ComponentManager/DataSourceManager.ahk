class DataSourceManager extends AppComponentManagerBase {
    primaryKey := ""

    __New(container, eventMgr, notifierObj, primaryKey := "") {
        if (primaryKey) {
            this.primaryKey := primaryKey
        }

        super.__New(container, eventMgr, notifierObj, "datasource.", DataSourceBase)
    }

    GetDefaultDataSource() {
        if (!this.primaryKey) {
            throw ComponentException("There is no default datasource set")
        }

        if (!this.Has(this.primaryKey)) {
            throw ComponentException("Primary data source key " . this.primaryKey . " does not exist")
        }

        return this[this.primaryKey]
    }

    GetItem(key := "") {
        if (key == "") {
            key := this.primaryKey
        }

        return super.GetItem(key)
    }

    ReadListing(path, dataSourceKey := "") {
        if (dataSourceKey == "") {
            dataSourceKey := this.primaryKey
        }

        if (!this.Has(dataSourceKey)) {
            throw ComponentException("Component " . dataSourceKey . " does not exist in the data source manager")
        }

        dataSource := this[dataSourceKey]
        return dataSource.ReadListing(path)
    }

    ReadJson(key, path := "", dataSourceKey := "") {
        if (dataSourceKey == "") {
            dataSourceKey := this.primaryKey
        }

        if (!this.Has(dataSourceKey)) {
            throw ComponentException("Component " . dataSourceKey . " does not exist in the data source manager")
        }

        dataSource := this[dataSourceKey]
        return dataSource.ReadJson(key, path)
    }
}
