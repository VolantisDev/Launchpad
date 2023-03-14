class LoggerService {
    logger := ""

    static LOG_LEVEL_NONE := 1
    static LOG_LEVEL_ERROR := 2
    static LOG_LEVEL_WARNING := 3
    static LOG_LEVEL_INFO := 4
    static LOG_LEVEL_DEBUG := 5

    __New(logger) {
        this.logger := logger
    }

    GetLogLevels() {
        return [
            "None",
            "Error",
            "Warning",
            "Info",
            "Debug"
        ]
    }

    Log(message, level := "Info") {
        this.logger.Log(message, level)
    }

    Debug(message) {
        this.Log(message, "Debug")
    }

    Info(message) {
        this.Log(message, "Info")
    }

    Warning(message) {
        this.Log(message, "Warning")
    }

    Error(message) {
        this.log(message, "Error")
    }
}
