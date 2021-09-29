class ExceptionBase extends Error {
    __New(message, what := "", extra := "") {
        if (!what) {
            what := -1
        }
        
        super.__New(message, what, extra)
    }
}
