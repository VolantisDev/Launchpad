class FileLogger extends LoggerBase {
    path := ""
    autoTruncate := false

    __New(path, loggingLevel := "", autoTruncate := false) {
        this.path := path
        this.autoTruncate := autoTruncate
        super.__New(loggingLevel)
        
        SplitPath(path,, &logDir)

        if (!DirExist(logDir)) {
            DirCreate(logDir)
        }

        if (autoTruncate) {
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
