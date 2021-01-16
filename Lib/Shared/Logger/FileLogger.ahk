class FileLogger extends LoggerBase {
    path := ""
    loggingLevel := ""
    levels := ["None", "Debug", "Info", "Warning", "Error"]

    __New(path, loggingLevel := "", autoTruncate := false) {
        this.path := path

        super.__New(loggingLevel)

        if (autoTruncate) {
            this.autoTruncate := autoTruncate
            this.Truncate(autoTruncate)
        }
    }

    Truncate(truncateSize) {
        if (truncateSize && this.path != "" && FileExist(this.path)) {
            size := FileGetSize(this.path, "M")
            
            if (size >= truncateSize) {
                FileDelete(this.path)
            }
        }
    }

    Log(message, level := "Info") {
        if super.Log(message, level) {
            FileAppend("[" . FormatTime() . "] - [" . level . "] - " . message . "`n", this.path)
        }
    }
}
