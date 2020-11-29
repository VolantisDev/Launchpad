class JsonAppState extends AppStateBase {
    filePath := ""

    __New(filePath, autoLoad := false) {
        InvalidParameterException.CheckTypes("JsonAppState", "filePath", filePath, "")
        InvalidParameterException.CheckEmpty("JsonAppState", "filePath", filePath)
        this.filePath := filePath
        super.__New("", autoLoad)
    }

    SaveState(newState := "") {
        if (newState != "") {
            this.stateMap := newState
        }

        stateToSave := Map("State", this.stateMap)
        jsonString := Jxon_Dump(stateToSave, "", 4)

        if (jsonString == "") {
            throw(OperationFailedException.new("Converting state map to JSON failed", "AppState", stateToSave))
        }

        if (FileExist(this.filePath)) {
            FileDelete(this.filePath)
        }
            
        FileAppend(jsonString, this.filePath)
        
        return this.stateMap
    }

    LoadState() {
        if (!this.stateLoaded) {
            newState := Map()

            if (FileExist(this.filePath)) {
                jsonString := Trim(FileRead(this.filePath))

                if (jsonString != "") {
                    jsonObj := Jxon_Load(jsonString)

                    if (jsonObj.Has("State")) {
                        newState := jsonObj["State"]
                    }
                }
            }

            this.stateMap := newState
            this.stateLoaded := true
        }
        
        return this.stateMap
    }
}
