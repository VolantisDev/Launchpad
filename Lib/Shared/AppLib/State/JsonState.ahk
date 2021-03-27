class JsonState extends StateBase {
    filePath := ""

    __New(app, filePath, autoLoad := false) {
        InvalidParameterException.CheckTypes("JsonState", "filePath", filePath, "")
        InvalidParameterException.CheckEmpty("JsonState", "filePath", filePath)
        this.filePath := filePath
        super.__New(app, "", autoLoad)
    }

    SaveState(newState := "") {
        if (newState != "") {
            this.stateMap := newState
        }

        stateToSave := Map("State", this.stateMap)
        data := JsonData.new(stateToSave)
        jsonString := data.ToString("", 4)

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
            newState := super.LoadState()

            if (FileExist(this.filePath)) {
                jsonString := Trim(FileRead(this.filePath))

                if (jsonString != "") {
                    data := JsonData.new()
                    jsonObj := data.FromString(jsonString)

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
