class JsonAppState extends AppStateBase {
    filePath := ""

    __New(filePath, autoLoad := false) {
        this.filePath := filePath
        super.__New("", autoLoad)
    }

    SaveState(newState := "") {
        newState := super.SaveState(newState)

        if (this.filePath == "") {
            return newState
        }

        stateToSave := Map("State", newState)
        jsonString := Jxon_Dump(stateToSave, "", 4)

        if (jsonString != "") {
            if (FileExist(this.filePath)) {
                FileDelete(this.filePath)
            }
            
            FileAppend(jsonString, this.filePath)
        }
        
        return newState
    }

    LoadState() {
        if (this.filePath != "" and FileExist(this.filePath)) {
            jsonString := Trim(FileRead(this.filePath))

            if (jsonString != "") {
                jsonObj := Jxon_Load(jsonString)

                if (jsonObj.Has("State")) {
                    this.State := jsonObj["State"]
                }
            } else {
                this.State := Map()
            }
        }
        
        return super.LoadState()
    }
}
