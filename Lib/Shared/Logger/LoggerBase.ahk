class LoggerBase {
    loggingLevel := ""

    __New(loggingLevel := "") {
        if (loggingLevel == "") {
            loggingLevel := "Error"
        }

        this.loggingLevel := loggingLevel
    }

    Log(message, level := "info") {
        shouldContinue := false

        minLevel := 1
        reqLevel := 1

        for index, loggingLevel in this.levels {
            if (this.loggingLevel == loggingLevel) {
                minLevel := index
                break
            }
        }

        for index, loggingLevel in this.levels {
            if (loggingLevel == level) {
                reqLevel := index
                break
            }
        }

        return (reqLevel > 1 and minLevel > 1 and reqLevel >= minLevel)
    }
}
