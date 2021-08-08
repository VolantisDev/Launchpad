class DSJson extends DSFile {
    itemSuffix := ""
    dataType := "Map"
    
    Read() {
        content := super.Read()
        dataType := this.dataType
        obj := %dataType%()

        if (content) {
            data := JsonData()
            obj := data.FromString(&content)
        }

        return obj
    }
}
