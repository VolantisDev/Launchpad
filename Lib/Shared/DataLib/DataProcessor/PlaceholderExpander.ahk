class PlaceholderExpander extends DataProcessorBase {
    layeredData := ""
    
    __New(layeredData) {
        this.layeredData := layeredData
    }

    ProcessSingleValue(value) {
        mergedData := this.layeredData.GetMergedData(false)

        for key, varVal in mergedData {
            if (InStr(value, "{{" . key . "}}")) {
                if (InStr(varVal, "{{")) {
                    varVal := this.Process(varVal)
                }

                value := StrReplace(value, "{{" . key . "}}", varVal)
            }
        }

        return value
    }
}
