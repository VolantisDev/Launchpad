class StringSanitizer extends DataProcessorBase {
    stripChars := "[^\000-\377]"
    
    __New(stripChars := "") {
        if (stripChars) {
            this.stripChars := stripChars
        }
    }

    ProcessSingleValue(value) {
        return RegExReplace(value, "[^\000-\377]")
    }
}
