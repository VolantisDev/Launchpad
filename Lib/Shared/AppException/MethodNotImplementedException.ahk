class MethodNotImplementedException extends AppException {
    __New(className := "", method := "") {
        message := "The called method is required but has not been implemented."
        super.__New(message, className, method)
    }
}
