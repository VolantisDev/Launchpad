#Include ApiItem.ahk

class JsonItem extends ApiItem {
    itemSuffix := ".json"
    
    Read() {
        return JSON.Load(super.Read())
    }
}
