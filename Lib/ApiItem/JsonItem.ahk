class JsonItem extends ApiItem {
    itemSuffix := ".json"
    
    Read() {
        return JSON.Load(base.Read())
    }
}
