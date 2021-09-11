class FileLogger extends LoggerBase {
    path := ""
    autoTruncate := false

    __New(path, loggingLevel := "", autoTruncate := false) {
        this.path := path
        this.autoTruncate := autoTruncate
        super.__New(loggingLevel)

        this.EnsureDir()

        if (autoTruncate) {
            this.Truncate(autoTruncate)
        }
    }

    EnsureDir() {
        SplitPath(this.path,, &logDir)

        if (!DirExist(logDir)) {
            DirCreate(logDir)
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
            this.EnsureDir()
            FileAppend("[" . FormatTime() . "] - [" . level . "] - " . message . "`n", this.path)
        }
    }
}
