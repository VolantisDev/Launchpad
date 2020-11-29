class MethodNotImplementedException extends AppException {
    __New(what := "", extra := "") {
        message := "The called method is required but has not been implemented."
        super.__New(message, what, extra)
    }
}
