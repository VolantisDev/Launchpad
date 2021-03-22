class LoggerBase {
    loggingLevel := ""
    levels := ["none", "debug", "info", "warning", "error"]

    __New(loggingLevel := "") {
        if (loggingLevel == "") {
            loggingLevel := "Error"
        }

        this.loggingLevel := loggingLevel
    }

    Log(message, level := "Info") {
        shouldContinue := false
        level := StrLower(level)

        minLevel := 1
        reqLevel := 1

        for index, loggingLevel in this.levels {
            loggingLevel := StrLower(loggingLevel)
            if (StrLower(this.loggingLevel) == loggingLevel) {
                minLevel := index
            }

            if (loggingLevel == level) {
                reqLevel := index
            }
        }

        return (reqLevel > 1 && minLevel > 1 && reqLevel >= minLevel)
    }
}
