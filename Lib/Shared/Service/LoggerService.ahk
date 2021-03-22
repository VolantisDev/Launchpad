class LoggerService extends ServiceBase {
    logger := ""

    __New(logger) {
        this.logger := logger
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
