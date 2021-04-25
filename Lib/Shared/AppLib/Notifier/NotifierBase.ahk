class NotifierBase {
    config := Map()

    __New(config := "") {
        if (config != "") {
            this.config := config
        }
    }

    /**
    * ABSTRACT METHODS
    */

    Notify(message, title := "", level := "info") {
        throw MethodNotImplementedException("NotifierBase", "Notify")
    }
}
