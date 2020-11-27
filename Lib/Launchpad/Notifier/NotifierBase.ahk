class NotifierBase {
    app := ""
    config := Map()

    __New(app, config := "") {
        this.app := app

        if (config != "") {
            this.config := config
        }
    }

    Notify(message, title := "", level := "info") {
    }
}
