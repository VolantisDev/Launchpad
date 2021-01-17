class LoggerService extends ServiceBase {
    logger := ""

    __New(logger) {
        this.logger := logger
    }

    Log(message, level := "info") {
        this.logger.write(message, level)
    }

    Debug(message) {
        this.Log(message, "debug")
    }

    Info(message) {
        this.Log(message, "info")
    }

    Warning(message) {
        this.Log(message, "warning")
    }

    Error(message) {
        this.log(message, "error")
    }
}
