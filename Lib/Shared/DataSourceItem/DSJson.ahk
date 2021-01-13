class DSJson extends DSFile {
    itemSuffix := ".json"
    
    Read() {
        content := super.Read()
        obj := Map()

        if (content) {
            data := JsonData.new()
            obj := data.FromString(content)
        }

        return obj
    }
}
