class JsonAppState extends AppStateBase {
    filePath := ""

    __New(filePath, autoLoad := false) {
        this.filePath := filePath
        super.__New("", autoLoad)
    }

    SaveState() {
        if (this.filePath == "") {
            return false
        }

        if (FileExist(this.filePath)) {
            FileDelete(this.filePath)
        }
        
        FileAppend(Jxon_Dump(this.State, "", 4), this.filePath)
        return super.SaveConfig()
    }

    LoadState() {
        if (this.filePath == "" or !FileExist(this.filePath)) {
            return false
        }

        jsonString := FileRead(this.filePath)
        this.State := (jsonString != "") ? Jxon_Load(jsonString) : Map()
        return super.LoadState()
    }
}
