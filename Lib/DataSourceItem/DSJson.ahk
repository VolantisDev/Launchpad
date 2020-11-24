class DSJson extends DSFile {
    itemSuffix := ".json"
    
    Read() {
        content := super.Read()
        return (content != "") ? Jxon_Load(content) : Map()
    }
}
