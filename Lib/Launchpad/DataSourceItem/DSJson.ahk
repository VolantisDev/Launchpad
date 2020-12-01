class DSJson extends DSFile {
    itemSuffix := ".json"
    
    Read() {
        content := super.Read()
        return (content != "") ? Json.FromString(content) : Map()
    }
}
