#Include ApiItem.ahk

class JsonItem extends ApiItem {
    itemSuffix := ".json"
    
    Read() {
        return Jxon_Load(super.Read())
    }
}
