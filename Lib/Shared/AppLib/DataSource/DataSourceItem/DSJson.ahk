class DSJson extends DSFile {
    itemSuffix := ""
    
    Read() {
        content := super.Read()
        obj := Map()

        if (content) {
            data := JsonData()
            obj := data.FromString(&content)
        }

        return obj
    }
}
