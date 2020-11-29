class AppException {
    innerException := {Message: "", What: "", Extra: "", File: "", Line: ""}

    Message {
        get => this.innerException.Message
    }

    What {
        get => this.innerException.What
    }

    Extra {
        get => this.innerException.HasProp("Extra") ? this.innerException.Extra : ""
    }

    File {
        get => this.innerException.File
    }

    Line {
        get => this.innerException.Line
    }

    __New(message, what := "", extra := "") {
        this.innerException := Exception(message, what, extra)
    }

    GetException() {
        return this.innerException
    }
}
