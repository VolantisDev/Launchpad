class NotifierBase {
    config := Map()

    __New(config := "") {
        if (config != "") {
            this.config := config
        }
    }

    Notify(message, title := "", level := "info") {
    }
}
