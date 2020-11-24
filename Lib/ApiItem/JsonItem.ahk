class JsonItem extends ApiItemBase {
    itemSuffix := ".json"
    
    Read() {
        return Jxon_Load(super.Read())
    }
}
